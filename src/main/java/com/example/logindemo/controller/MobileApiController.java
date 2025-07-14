package com.example.logindemo.controller;

import com.example.logindemo.model.User;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.repository.UserRepository;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@RestController
@RequestMapping("/api/mobile")
@CrossOrigin(origins = "*") // Allow all origins for mobile app
@Slf4j
public class MobileApiController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private ToothClinicalExaminationRepository toothClinicalExaminationRepository;

    @Value("${api.key}")
    private String apiKey;

    @Value("${api.secret:default-secret-key-change-in-production}")
    private String apiSecret;

    @Value("${api.rate.limit.requests:100}")
    private int rateLimitRequests;

    @Value("${api.rate.limit.window.minutes:15}")
    private int rateLimitWindowMinutes;

    // Rate limiting storage
    private final Map<String, RateLimitInfo> rateLimitMap = new ConcurrentHashMap<>();
    private final Map<String, Integer> failedLoginAttempts = new ConcurrentHashMap<>();

    // Security configuration
    private static final String HMAC_ALGORITHM = "HmacSHA256";
    private static final String API_KEY_HEADER = "X-API-Key";
    private static final String SIGNATURE_HEADER = "X-Signature";
    private static final String TIMESTAMP_HEADER = "X-Timestamp";
    private static final int MAX_FAILED_LOGIN_ATTEMPTS = 5;
    private static final int LOGIN_LOCKOUT_MINUTES = 30;

    /**
     * Test endpoint to verify mobile API is accessible
     * GET /api/mobile/test
     */
    @GetMapping("/test")
    public ResponseEntity<Map<String, Object>> test() {
        log.info("Mobile API test endpoint called");
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Mobile API is working!");
        response.put("timestamp", LocalDateTime.now().toString());
        return ResponseEntity.ok(response);
    }

    /**
     * Simple login test endpoint (for debugging - no security headers required)
     * POST /api/mobile/login-test
     */
    @PostMapping("/login-test")
    public ResponseEntity<Map<String, Object>> loginTest(@RequestBody LoginRequest loginRequest) {
        try {
            log.info("Mobile login test attempt for username: {}", loginRequest.getUsername());

            // Validate input
            if (loginRequest.getUsername() == null || loginRequest.getUsername().trim().isEmpty()) {
                return createErrorResponse("Username is required", HttpStatus.BAD_REQUEST);
            }

            if (loginRequest.getPassword() == null || loginRequest.getPassword().trim().isEmpty()) {
                return createErrorResponse("Password is required", HttpStatus.BAD_REQUEST);
            }

            // Find user by username
            Optional<User> userOptional = userRepository.findByUsername(loginRequest.getUsername());
            if (userOptional.isEmpty()) {
                log.warn("Mobile login test failed: User not found for username: {}", loginRequest.getUsername());
                return createErrorResponse("Invalid username or password", HttpStatus.UNAUTHORIZED);
            }

            User user = userOptional.get();

            // Check if user is active
            if (!user.getIsActive()) {
                log.warn("Mobile login test failed: Inactive user attempt for username: {}", loginRequest.getUsername());
                return createErrorResponse("Account is deactivated", HttpStatus.UNAUTHORIZED);
            }

            // Verify password
            if (!passwordEncoder.matches(loginRequest.getPassword(), user.getPassword())) {
                log.warn("Mobile login test failed: Invalid password for username: {}", loginRequest.getUsername());
                return createErrorResponse("Invalid username or password", HttpStatus.UNAUTHORIZED);
            }

            // Create success response
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Login test successful");
            response.put("user", createUserResponse(user));
            response.put("timestamp", LocalDateTime.now().toString());

            log.info("Mobile login test successful for user: {} (ID: {})", user.getUsername(), user.getId());
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("Mobile login test error: ", e);
            return createErrorResponse("Internal server error", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Mobile app login API
     * POST /api/mobile/login
     */
    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody LoginRequest loginRequest, HttpServletRequest request) {
        try {
            log.info("Mobile login attempt for username: {}", loginRequest.getUsername());
            log.info("Request URI: {}", request.getRequestURI());
            log.info("Request method: {}", request.getMethod());
            log.info("Content-Type: {}", request.getContentType());

            // Security validation
            String requestBody = loginRequest.getUsername() + loginRequest.getPassword();
            ResponseEntity<Map<String, Object>> securityValidation = validateSecurityHeaders(request, requestBody);
            if (securityValidation != null) {
                return securityValidation;
            }

            // Rate limiting check
            ResponseEntity<Map<String, Object>> rateLimitCheck = checkRateLimit("login:" + request.getRemoteAddr());
            if (rateLimitCheck != null) {
                return rateLimitCheck;
            }

            // Validate input
            if (loginRequest.getUsername() == null || loginRequest.getUsername().trim().isEmpty()) {
                return createErrorResponse("Username is required", HttpStatus.BAD_REQUEST);
            }

            if (loginRequest.getPassword() == null || loginRequest.getPassword().trim().isEmpty()) {
                return createErrorResponse("Password is required", HttpStatus.BAD_REQUEST);
            }

            // Check for account lockout
            ResponseEntity<Map<String, Object>> lockoutCheck = checkLoginLockout(loginRequest.getUsername());
            if (lockoutCheck != null) {
                return lockoutCheck;
            }

            // Find user by username
            Optional<User> userOptional = userRepository.findByUsername(loginRequest.getUsername());
            if (userOptional.isEmpty()) {
                recordFailedLoginAttempt(loginRequest.getUsername());
                log.warn("Mobile login failed: User not found for username: {}", loginRequest.getUsername());
                return createErrorResponse("Invalid username or password", HttpStatus.UNAUTHORIZED);
            }

            User user = userOptional.get();

            // Check if user is active
            if (!user.getIsActive()) {
                recordFailedLoginAttempt(loginRequest.getUsername());
                log.warn("Mobile login failed: Inactive user attempt for username: {}", loginRequest.getUsername());
                return createErrorResponse("Account is deactivated", HttpStatus.UNAUTHORIZED);
            }

            // Verify password
            if (!passwordEncoder.matches(loginRequest.getPassword(), user.getPassword())) {
                recordFailedLoginAttempt(loginRequest.getUsername());
                log.warn("Mobile login failed: Invalid password for username: {}", loginRequest.getUsername());
                return createErrorResponse("Invalid username or password", HttpStatus.UNAUTHORIZED);
            }

            // Clear failed login attempts on successful login
            clearFailedLoginAttempts(loginRequest.getUsername());

            // Create success response
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Login successful");
            response.put("user", createUserResponse(user));
            response.put("timestamp", LocalDateTime.now().toString());

            log.info("Mobile login successful for user: {} (ID: {})", user.getUsername(), user.getId());
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("Mobile login error: ", e);
            return createErrorResponse("Internal server error", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Health check API for mobile app
     * GET /api/mobile/health
     */
    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> healthCheck() {
        try {
            Map<String, Object> response = new HashMap<>();
            response.put("status", "healthy");
            response.put("timestamp", LocalDateTime.now().toString());
            response.put("service", "PeriDesk Mobile API");
            response.put("version", "1.0.0");
            response.put("environment", "production");
            response.put("uptime", System.currentTimeMillis());
            
            // Add basic system info
            Map<String, Object> systemInfo = new HashMap<>();
            systemInfo.put("javaVersion", System.getProperty("java.version"));
            systemInfo.put("osName", System.getProperty("os.name"));
            systemInfo.put("availableMemory", Runtime.getRuntime().freeMemory());
            systemInfo.put("totalMemory", Runtime.getRuntime().totalMemory());
            response.put("system", systemInfo);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Health check error: ", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("status", "unhealthy");
            errorResponse.put("timestamp", LocalDateTime.now().toString());
            errorResponse.put("error", "Health check failed");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * Get examination details by ID with access control
     * POST /api/mobile/examination
     */
    @PostMapping("/examination")
    public ResponseEntity<Map<String, Object>> getExamination(@RequestBody ExaminationRequest request, HttpServletRequest httpRequest) {
        try {
            log.info("Mobile examination request for examination ID: {} by user: {}", 
                    request.getExaminationId(), request.getUsername());

            // Security validation
            String requestBody = request.getExaminationId() + request.getUsername();
            ResponseEntity<Map<String, Object>> securityValidation = validateSecurityHeaders(httpRequest, requestBody);
            if (securityValidation != null) {
                return securityValidation;
            }

            // Rate limiting check
            ResponseEntity<Map<String, Object>> rateLimitCheck = checkRateLimit("examination:" + httpRequest.getRemoteAddr());
            if (rateLimitCheck != null) {
                return rateLimitCheck;
            }

            // Validate input
            if (request.getExaminationId() == null) {
                return createErrorResponse("Examination ID is required", HttpStatus.BAD_REQUEST);
            }

            if (request.getUsername() == null || request.getUsername().trim().isEmpty()) {
                return createErrorResponse("Username is required", HttpStatus.BAD_REQUEST);
            }

            // Find user by username
            Optional<User> userOptional = userRepository.findByUsername(request.getUsername());
            if (userOptional.isEmpty()) {
                return createErrorResponse("User not found", HttpStatus.NOT_FOUND);
            }

            User user = userOptional.get();

            // Find examination by ID
            Optional<ToothClinicalExamination> examinationOptional = toothClinicalExaminationRepository.findById(request.getExaminationId());
            if (examinationOptional.isEmpty()) {
                return createErrorResponse("Examination not found", HttpStatus.NOT_FOUND);
            }

            ToothClinicalExamination examination = examinationOptional.get();

            // Check if examination date is today
            LocalDateTime today = LocalDateTime.now().toLocalDate().atStartOfDay();
            LocalDateTime examinationDate = examination.getExaminationDate().toLocalDate().atStartOfDay();
            
            if (!examinationDate.equals(today)) {
                return createErrorResponse("Examination is not from today", HttpStatus.FORBIDDEN);
            }

            // Check if user is authorized (OPD doctor or assigned doctor)
            boolean isAuthorized = false;
            if (examination.getOpdDoctor() != null && examination.getOpdDoctor().getId().equals(user.getId())) {
                isAuthorized = true;
            }
            if (examination.getAssignedDoctor() != null && examination.getAssignedDoctor().getId().equals(user.getId())) {
                isAuthorized = true;
            }

            if (!isAuthorized) {
                log.warn("Mobile examination access denied: User {} not authorized for examination {}", 
                        user.getUsername(), request.getExaminationId());
                return createErrorResponse("Access denied: You are not authorized to view this examination", HttpStatus.FORBIDDEN);
            }

            // Create success response with basic patient information
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Examination found");
            response.put("examination", createExaminationResponse(examination));
            response.put("timestamp", LocalDateTime.now().toString());

            log.info("Mobile examination access granted for user: {} (ID: {}) to examination: {}", 
                    user.getUsername(), user.getId(), request.getExaminationId());
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("Mobile examination request error: ", e);
            return createErrorResponse("Internal server error", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Upload images for examination
     * POST /api/mobile/upload-images
     */
    @PostMapping("/upload-images")
    public ResponseEntity<Map<String, Object>> uploadImages(
            @RequestParam("examinationId") Long examinationId,
            @RequestParam("username") String username,
            @RequestParam(value = "upperDentureImage", required = false) MultipartFile upperDentureImage,
            @RequestParam(value = "lowerDentureImage", required = false) MultipartFile lowerDentureImage,
            @RequestParam(value = "xrayImage", required = false) MultipartFile xrayImage,
            HttpServletRequest request) {
        
        try {
            log.info("Mobile image upload request for examination ID: {} by user: {}", examinationId, username);

            // Security validation (for multipart requests, we'll validate based on parameters)
            String requestBody = examinationId + username;
            ResponseEntity<Map<String, Object>> securityValidation = validateSecurityHeaders(request, requestBody);
            if (securityValidation != null) {
                return securityValidation;
            }

            // Rate limiting check
            ResponseEntity<Map<String, Object>> rateLimitCheck = checkRateLimit("upload:" + request.getRemoteAddr());
            if (rateLimitCheck != null) {
                return rateLimitCheck;
            }

            // Validate input
            if (examinationId == null) {
                return createErrorResponse("Examination ID is required", HttpStatus.BAD_REQUEST);
            }

            if (username == null || username.trim().isEmpty()) {
                return createErrorResponse("Username is required", HttpStatus.BAD_REQUEST);
            }

            // Check if at least one image is provided
            if ((upperDentureImage == null || upperDentureImage.isEmpty()) &&
                (lowerDentureImage == null || lowerDentureImage.isEmpty()) &&
                (xrayImage == null || xrayImage.isEmpty())) {
                return createErrorResponse("At least one image is required", HttpStatus.BAD_REQUEST);
            }

            // Validate file types and sizes
            ResponseEntity<Map<String, Object>> fileValidation = validateUploadedFiles(upperDentureImage, lowerDentureImage, xrayImage);
            if (fileValidation != null) {
                return fileValidation;
            }

            // Find user by username
            Optional<User> userOptional = userRepository.findByUsername(username);
            if (userOptional.isEmpty()) {
                return createErrorResponse("User not found", HttpStatus.NOT_FOUND);
            }

            User user = userOptional.get();

            // Find examination by ID
            Optional<ToothClinicalExamination> examinationOptional = toothClinicalExaminationRepository.findById(examinationId);
            if (examinationOptional.isEmpty()) {
                return createErrorResponse("Examination not found", HttpStatus.NOT_FOUND);
            }

            ToothClinicalExamination examination = examinationOptional.get();

            // Check if examination date is today
            LocalDateTime today = LocalDateTime.now().toLocalDate().atStartOfDay();
            LocalDateTime examinationDate = examination.getExaminationDate().toLocalDate().atStartOfDay();
            
            if (!examinationDate.equals(today)) {
                return createErrorResponse("Examination is not from today", HttpStatus.FORBIDDEN);
            }

            // Check if user is authorized (OPD doctor or assigned doctor)
            boolean isAuthorized = false;
            if (examination.getOpdDoctor() != null && examination.getOpdDoctor().getId().equals(user.getId())) {
                isAuthorized = true;
            }
            if (examination.getAssignedDoctor() != null && examination.getAssignedDoctor().getId().equals(user.getId())) {
                isAuthorized = true;
            }

            if (!isAuthorized) {
                log.warn("Mobile image upload access denied: User {} not authorized for examination {}", 
                        user.getUsername(), examinationId);
                return createErrorResponse("Access denied: You are not authorized to upload images for this examination", HttpStatus.FORBIDDEN);
            }

            // Create uploads directory if it doesn't exist
            String uploadsDir = "uploads";
            String denturePicturesDir = uploadsDir + "/denture-pictures";
            String xrayPicturesDir = uploadsDir + "/xray-pictures";
            
            createDirectoryIfNotExists(denturePicturesDir);
            createDirectoryIfNotExists(xrayPicturesDir);

            Map<String, String> uploadedFiles = new HashMap<>();

            // Upload upper denture image
            if (upperDentureImage != null && !upperDentureImage.isEmpty()) {
                String fileName = saveImage(upperDentureImage, denturePicturesDir, "upper-denture");
                examination.setUpperDenturePicturePath(fileName);
                uploadedFiles.put("upperDentureImage", fileName);
            }

            // Upload lower denture image
            if (lowerDentureImage != null && !lowerDentureImage.isEmpty()) {
                String fileName = saveImage(lowerDentureImage, denturePicturesDir, "lower-denture");
                examination.setLowerDenturePicturePath(fileName);
                uploadedFiles.put("lowerDentureImage", fileName);
            }

            // Upload X-ray image
            if (xrayImage != null && !xrayImage.isEmpty()) {
                String fileName = saveImage(xrayImage, xrayPicturesDir, "xray");
                examination.setXrayPicturePath(fileName);
                uploadedFiles.put("xrayImage", fileName);
            }

            // Save the examination with updated image paths
            toothClinicalExaminationRepository.save(examination);

            // Create success response
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Images uploaded successfully");
            response.put("uploadedFiles", uploadedFiles);
            response.put("timestamp", LocalDateTime.now().toString());

            log.info("Mobile image upload successful for user: {} (ID: {}) to examination: {}", 
                    user.getUsername(), user.getId(), examinationId);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("Mobile image upload error: ", e);
            return createErrorResponse("Internal server error", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Debug endpoint to check API configuration
     * GET /api/mobile/debug
     */
    @GetMapping("/debug")
    public ResponseEntity<Map<String, Object>> debug() {
        log.info("Mobile API debug endpoint called");
        Map<String, Object> response = new HashMap<>();
        response.put("apiKeySet", apiKey != null && !apiKey.isEmpty());
        response.put("apiSecretSet", apiSecret != null && !apiSecret.isEmpty());
        response.put("rateLimitRequests", rateLimitRequests);
        response.put("rateLimitWindowMinutes", rateLimitWindowMinutes);
        response.put("timestamp", LocalDateTime.now().toString());
        return ResponseEntity.ok(response);
    }

    /**
     * Debug signature generation
     * POST /api/mobile/debug-signature
     */
    @PostMapping("/debug-signature")
    public ResponseEntity<Map<String, Object>> debugSignature(@RequestBody Map<String, String> request) {
        try {
            String payload = request.get("payload");
            String timestamp = request.get("timestamp");
            
            if (payload == null || timestamp == null) {
                return createErrorResponse("Payload and timestamp are required", HttpStatus.BAD_REQUEST);
            }
            
            String expectedSignature = generateSignature(payload, timestamp);
            
            Map<String, Object> response = new HashMap<>();
            response.put("payload", payload);
            response.put("timestamp", timestamp);
            response.put("apiSecret", apiSecret != null ? "SET" : "NULL");
            response.put("dataToSign", payload + timestamp + apiSecret);
            response.put("expectedSignature", expectedSignature);
            response.put("timestamp", LocalDateTime.now().toString());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Debug signature error: ", e);
            return createErrorResponse("Signature generation failed", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // Helper methods

    /**
     * Creates a directory if it doesn't exist
     */
    private void createDirectoryIfNotExists(String directoryPath) throws IOException {
        Path path = Paths.get(directoryPath);
        if (!Files.exists(path)) {
            Files.createDirectories(path);
        }
    }

    /**
     * Saves an uploaded image file
     */
    private String saveImage(MultipartFile file, String directory, String prefix) throws IOException {
        // Generate unique filename
        String originalFilename = file.getOriginalFilename();
        String fileExtension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }
        
        String uniqueFilename = prefix + "-" + UUID.randomUUID().toString() + fileExtension;
        Path filePath = Paths.get(directory, uniqueFilename);
        
        // Save the file
        Files.copy(file.getInputStream(), filePath);
        
        return uniqueFilename;
    }

    private ResponseEntity<Map<String, Object>> createErrorResponse(String message, HttpStatus status) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", message);
        response.put("timestamp", LocalDateTime.now().toString());
        return ResponseEntity.status(status).body(response);
    }

    private Map<String, Object> createUserResponse(User user) {
        Map<String, Object> userResponse = new HashMap<>();
        userResponse.put("id", user.getId());
        userResponse.put("username", user.getUsername());
        userResponse.put("firstName", user.getFirstName());
        userResponse.put("lastName", user.getLastName());
        userResponse.put("email", user.getEmail());
        userResponse.put("phoneNumber", user.getPhoneNumber());
        userResponse.put("role", user.getRole().name());
        userResponse.put("isActive", user.getIsActive());
        userResponse.put("forcePasswordChange", user.getForcePasswordChange());
        
        // Professional details for dental staff
        if (user.getClinic() != null) {
            Map<String, Object> clinicInfo = new HashMap<>();
            clinicInfo.put("id", user.getClinic().getId());
            clinicInfo.put("name", user.getClinic().getClinicName());
            clinicInfo.put("clinicId", user.getClinic().getClinicId());
            clinicInfo.put("cityTier", user.getClinic().getCityTier());
            userResponse.put("clinic", clinicInfo);
        }
        
        userResponse.put("specialization", user.getSpecialization());
        userResponse.put("licenseNumber", user.getLicenseNumber());
        userResponse.put("qualification", user.getQualification());
        userResponse.put("designation", user.getDesignation());
        userResponse.put("joiningDate", user.getJoiningDate());
        
        return userResponse;
    }

    private Map<String, Object> createExaminationResponse(ToothClinicalExamination examination) {
        Map<String, Object> examinationResponse = new HashMap<>();
        examinationResponse.put("id", examination.getId());
        examinationResponse.put("examinationDate", examination.getExaminationDate().toString());
        examinationResponse.put("toothNumber", examination.getToothNumber());
        examinationResponse.put("procedureStatus", examination.getProcedureStatus());
        
        // Basic patient information
        if (examination.getPatient() != null) {
            Map<String, Object> patientInfo = new HashMap<>();
            patientInfo.put("name", examination.getPatient().getFirstName() + " " + examination.getPatient().getLastName());
            patientInfo.put("registrationId", examination.getPatient().getRegistrationCode());
            patientInfo.put("phoneNumber", examination.getPatient().getPhoneNumber());
            examinationResponse.put("patient", patientInfo);
        }
        
        // Doctor information
        if (examination.getAssignedDoctor() != null) {
            Map<String, Object> doctorInfo = new HashMap<>();
            doctorInfo.put("name", "Dr. " + examination.getAssignedDoctor().getFirstName() + " " + examination.getAssignedDoctor().getLastName());
            doctorInfo.put("role", "Assigned Doctor");
            examinationResponse.put("assignedDoctor", doctorInfo);
        }
        
        if (examination.getOpdDoctor() != null) {
            Map<String, Object> opdDoctorInfo = new HashMap<>();
            opdDoctorInfo.put("name", "Dr. " + examination.getOpdDoctor().getFirstName() + " " + examination.getOpdDoctor().getLastName());
            opdDoctorInfo.put("role", "OPD Doctor");
            examinationResponse.put("opdDoctor", opdDoctorInfo);
        }
        
        return examinationResponse;
    }

    // Security validation methods

    /**
     * Validates API key and request signature
     */
    private ResponseEntity<Map<String, Object>> validateSecurityHeaders(HttpServletRequest request, String requestBody) {
        try {
            log.info("Validating security headers for request: {}", request.getRequestURI());
            log.info("API Key from config: {}", apiKey != null ? "SET" : "NULL");
            log.info("API Secret from config: {}", apiSecret != null ? "SET" : "NULL");
            
            // Validate API Key
            String providedApiKey = request.getHeader(API_KEY_HEADER);
            log.info("Provided API Key: {}", providedApiKey);
            if (providedApiKey == null || !apiKey.equals(providedApiKey)) {
                log.warn("Invalid API key provided: {}", providedApiKey);
                return createErrorResponse("Invalid API key", HttpStatus.UNAUTHORIZED);
            }

            // Validate timestamp (prevent replay attacks)
            String timestamp = request.getHeader(TIMESTAMP_HEADER);
            log.info("Provided timestamp: {}", timestamp);
            if (timestamp == null) {
                return createErrorResponse("Timestamp header is required", HttpStatus.BAD_REQUEST);
            }

            ZonedDateTime requestTime = ZonedDateTime.parse(timestamp, DateTimeFormatter.ISO_OFFSET_DATE_TIME);
            ZonedDateTime now = ZonedDateTime.now();
            if (requestTime.isBefore(now.minusMinutes(5)) || requestTime.isAfter(now.plusMinutes(5))) {
                log.warn("Request timestamp is too old or in the future: {}", timestamp);
                return createErrorResponse("Invalid timestamp", HttpStatus.BAD_REQUEST);
            }

            // Validate signature
            String signature = request.getHeader(SIGNATURE_HEADER);
            log.info("Provided signature: {}", signature);
            if (signature == null) {
                return createErrorResponse("Signature header is required", HttpStatus.BAD_REQUEST);
            }

            String expectedSignature = generateSignature(requestBody, timestamp);
            log.info("Expected signature: {}", expectedSignature);
            log.info("Request body: {}", requestBody);
            if (!signature.equals(expectedSignature)) {
                log.warn("Invalid signature provided. Expected: {}, Got: {}", expectedSignature, signature);
                return createErrorResponse("Invalid signature", HttpStatus.UNAUTHORIZED);
            }

            log.info("Security validation passed");
            return null; // Validation passed
        } catch (Exception e) {
            log.error("Security validation error: ", e);
            return createErrorResponse("Security validation failed", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Generates HMAC signature for request validation
     */
    private String generateSignature(String payload, String timestamp) throws NoSuchAlgorithmException, InvalidKeyException {
        String dataToSign = payload + timestamp + apiSecret;
        Mac mac = Mac.getInstance(HMAC_ALGORITHM);
        SecretKeySpec secretKeySpec = new SecretKeySpec(apiSecret.getBytes(StandardCharsets.UTF_8), HMAC_ALGORITHM);
        mac.init(secretKeySpec);
        byte[] signatureBytes = mac.doFinal(dataToSign.getBytes(StandardCharsets.UTF_8));
        return bytesToHex(signatureBytes);
    }

    /**
     * Converts byte array to hex string
     */
    private String bytesToHex(byte[] bytes) {
        StringBuilder result = new StringBuilder();
        for (byte b : bytes) {
            result.append(String.format("%02x", b));
        }
        return result.toString();
    }

    /**
     * Rate limiting check
     */
    private ResponseEntity<Map<String, Object>> checkRateLimit(String identifier) {
        ZonedDateTime now = ZonedDateTime.now();
        RateLimitInfo rateLimitInfo = rateLimitMap.get(identifier);
        
        if (rateLimitInfo == null) {
            rateLimitInfo = new RateLimitInfo();
            rateLimitMap.put(identifier, rateLimitInfo);
        }

        // Reset if window has passed
        if (rateLimitInfo.getWindowStart().isBefore(now.minusMinutes(rateLimitWindowMinutes))) {
            rateLimitInfo.reset(now);
        }

        // Check if limit exceeded
        if (rateLimitInfo.getRequestCount() >= rateLimitRequests) {
            log.warn("Rate limit exceeded for identifier: {}", identifier);
            return createErrorResponse("Rate limit exceeded. Please try again later.", HttpStatus.TOO_MANY_REQUESTS);
        }

        rateLimitInfo.incrementRequestCount();
        return null; // Rate limit check passed
    }

    /**
     * Check for account lockout due to failed login attempts
     */
    private ResponseEntity<Map<String, Object>> checkLoginLockout(String username) {
        Integer failedAttempts = failedLoginAttempts.get(username);
        if (failedAttempts != null && failedAttempts >= MAX_FAILED_LOGIN_ATTEMPTS) {
            log.warn("Account locked due to too many failed login attempts: {}", username);
            return createErrorResponse("Account temporarily locked due to too many failed attempts. Please try again later.", 
                    HttpStatus.TOO_MANY_REQUESTS);
        }
        return null; // No lockout
    }

    /**
     * Record failed login attempt
     */
    private void recordFailedLoginAttempt(String username) {
        failedLoginAttempts.compute(username, (key, attempts) -> {
            if (attempts == null) return 1;
            return attempts + 1;
        });
    }

    /**
     * Clear failed login attempts on successful login
     */
    private void clearFailedLoginAttempts(String username) {
        failedLoginAttempts.remove(username);
    }

    /**
     * Validates uploaded files for type and size
     */
    private ResponseEntity<Map<String, Object>> validateUploadedFiles(MultipartFile upperDentureImage, 
                                                                      MultipartFile lowerDentureImage, 
                                                                      MultipartFile xrayImage) {
        MultipartFile[] files = {upperDentureImage, lowerDentureImage, xrayImage};
        
        for (MultipartFile file : files) {
            if (file != null && !file.isEmpty()) {
                // Check file size (max 10MB)
                if (file.getSize() > 10 * 1024 * 1024) {
                    return createErrorResponse("File size too large. Maximum size is 10MB.", HttpStatus.BAD_REQUEST);
                }
                
                // Check file type
                String contentType = file.getContentType();
                if (contentType == null || !contentType.startsWith("image/")) {
                    return createErrorResponse("Invalid file type. Only image files are allowed.", HttpStatus.BAD_REQUEST);
                }
                
                // Check file extension
                String originalFilename = file.getOriginalFilename();
                if (originalFilename != null) {
                    String extension = originalFilename.toLowerCase();
                    if (!extension.endsWith(".jpg") && !extension.endsWith(".jpeg") && 
                        !extension.endsWith(".png") && !extension.endsWith(".gif")) {
                        return createErrorResponse("Invalid file format. Only JPG, PNG, and GIF files are allowed.", HttpStatus.BAD_REQUEST);
                    }
                }
            }
        }
        
        return null; // Validation passed
    }

    // Rate limiting data class
    private static class RateLimitInfo {
        private int requestCount;
        private ZonedDateTime windowStart;

        public RateLimitInfo() {
            this.requestCount = 0;
            this.windowStart = ZonedDateTime.now();
        }

        public void reset(ZonedDateTime newStart) {
            this.requestCount = 0;
            this.windowStart = newStart;
        }

        public void incrementRequestCount() {
            this.requestCount++;
        }

        public int getRequestCount() { return requestCount; }
        public ZonedDateTime getWindowStart() { return windowStart; }
    }

    // Request/Response DTOs

    public static class LoginRequest {
        private String username;
        private String password;

        // Getters and setters
        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }
        public String getPassword() { return password; }
        public void setPassword(String password) { this.password = password; }
    }

    public static class ExaminationRequest {
        private Long examinationId;
        private String username;

        // Getters and setters
        public Long getExaminationId() { return examinationId; }
        public void setExaminationId(Long examinationId) { this.examinationId = examinationId; }
        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }
    }
} 