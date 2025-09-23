package com.example.logindemo.controller;

import com.example.logindemo.dto.ClinicDTO;
import com.example.logindemo.dto.ProcedurePriceDTO;
import com.example.logindemo.dto.UserDTO;
import com.example.logindemo.model.*;
import com.example.logindemo.repository.*;
import com.example.logindemo.service.ClinicService;
import com.example.logindemo.service.UserService;
import com.example.logindemo.service.ProcedurePriceService;
import com.example.logindemo.service.DoctorTargetService;
import com.example.logindemo.service.MotivationQuoteService;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import java.beans.PropertyEditorSupport;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
@Slf4j
public class AdminController {

    @Resource(name = "userRepository")
    private UserRepository userRepository;

    @Resource(name = "procedurePriceRepository")
    private ProcedurePriceRepository procedurePriceRepository;
    
    @Resource(name = "modelMapper")
    private ModelMapper modelMapper;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Resource(name = "patientRepository")
    private PatientRepository patientRepository;
    
    @Resource(name = "checkInRecordRepository")
    private CheckInRecordRepository checkInRecordRepository;
    
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private UserService userService;
    
    @Autowired
    private ClinicService clinicService;

    @Resource(name = "clinicRepository")
    private ClinicRepository clinicRepository;

    @Resource(name = "procedurePriceService")
    private ProcedurePriceService procedurePriceService;

    @Resource(name = "procedurePriceHistoryRepository")
    private ProcedurePriceHistoryRepository procedurePriceHistoryRepository;
    
    @Autowired
    private DoctorTargetService doctorTargetService;

    @Autowired
    private MotivationQuoteService motivationQuoteService;

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        // Register custom editor for LocalDate fields
        binder.registerCustomEditor(LocalDate.class, new PropertyEditorSupport() {
            @Override
            public void setAsText(String text) throws IllegalArgumentException {
                if (text != null && !text.trim().isEmpty()) {
                    try {
                        setValue(LocalDate.parse(text, DateTimeFormatter.ofPattern("yyyy-MM-dd")));
                    } catch (Exception e) {
                        log.warn("Invalid date format: {}", text);
                        setValue(null);
                    }
                } else {
                    setValue(null);
                }
            }
        });
    }

    @GetMapping
    public String adminDashboard(Model model) {
        model.addAttribute("userCount", userService.countUsers());
        model.addAttribute("clinicCount", clinicService.getAllClinics().size());
        return "admin/dashboard";
    }
    
    @GetMapping("/users")
    public String listUsers(Model model) {
        List<UserDTO> users = userService.getAllUsers();
        model.addAttribute("users", users);
        return "admin/userList";
    }
    
    @GetMapping("/users/new")
    public String showCreateUserForm(Model model) {
        UserDTO userDTO = new UserDTO();
        model.addAttribute("user", userDTO);
        model.addAttribute("clinics", clinicService.getAllClinics());
        model.addAttribute("roles", UserRole.values());
        model.addAttribute("specializations", DentalSpecialization.values());
        return "admin/createUser";
    }
    
    @PostMapping("/users")
    public String createUser(@ModelAttribute UserDTO userDTO, 
                            @RequestParam(required = false) String specialization,
                            RedirectAttributes redirectAttributes) {
        try {
            // If the created user is a doctor, set the specialization
            if (userDTO.getRole() == UserRole.DOCTOR || userDTO.getRole() == UserRole.OPD_DOCTOR) {
                if (specialization != null && !specialization.isEmpty()) {
                    userDTO.setSpecialization(specialization);
                }
            }

            userService.createUser(userDTO);
            redirectAttributes.addFlashAttribute("successMessage", "User created successfully");
            return "redirect:/admin/users";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error creating user: " + e.getMessage());
            return "redirect:/admin/users/new";
        }
    }
    
    @GetMapping("/users/{id}")
    public String getUserDetails(@PathVariable Long id, Model model) {
        return userService.getUserById(id)
            .map(user -> {
                model.addAttribute("user", user);
                return "admin/userDetails";
            })
            .orElse("redirect:/admin/users?error=User+not+found");
    }
    
    @GetMapping("/users/{id}/edit")
    public String showEditUserForm(@PathVariable Long id, Model model) {
        return userService.getUserById(id)
            .map(user -> {
                model.addAttribute("user", user);
                model.addAttribute("clinics", clinicService.getAllClinics());
                model.addAttribute("roles", UserRole.values());
                model.addAttribute("specializations", DentalSpecialization.values());
                
                // If the user is a doctor, get the existing specialization from the user directly
                if (user.getRole() == UserRole.DOCTOR || user.getRole() == UserRole.OPD_DOCTOR) {
                    if (user.getSpecialization() != null) {
                        model.addAttribute("specialization", user.getSpecialization());
                    }
                }
                
                return "admin/editUser";
            })
            .orElse("redirect:/admin/users?error=User+not+found");
    }
    
    @PostMapping("/users/{id}")
    public String updateUser(@PathVariable Long id, 
                            @ModelAttribute UserDTO userDTO, 
                            @RequestParam(required = false) String specialization,
                            RedirectAttributes redirectAttributes) {
        try {
            // If the updated user is a doctor, set the specialization
            if (userDTO.getRole() == UserRole.DOCTOR || userDTO.getRole() == UserRole.OPD_DOCTOR) {
                if (specialization != null && !specialization.isEmpty()) {
                    userDTO.setSpecialization(specialization);
                }
            }
            
            UserDTO updatedUser = userService.updateUser(id, userDTO);
            
            redirectAttributes.addFlashAttribute("successMessage", "User updated successfully");
            return "redirect:/admin/users/" + id;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating user: " + e.getMessage());
            return "redirect:/admin/users/" + id + "/edit";
        }
    }
    
    @PostMapping("/users/{id}/delete")
    public String deleteUser(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            userService.deleteUser(id);
            redirectAttributes.addFlashAttribute("successMessage", "User deleted successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error deleting user: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }
    
    @PostMapping("/users/{id}/reset-password")
    public String resetUserPassword(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
            
            // Generate a random password
            String newPassword = generateRandomPassword();
            
            // Set the new password and force change flag
            user.setPassword(passwordEncoder.encode(newPassword));
            user.setForcePasswordChange(true);
            userRepository.save(user);
            
            // Add success message with the new password
            redirectAttributes.addFlashAttribute("successMessage", 
                "Password reset successful. New password: " + newPassword);
            
            return "redirect:/admin/users/" + id;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", 
                "Error resetting password: " + e.getMessage());
            return "redirect:/admin/users/" + id;
        }
    }
    
    private String generateRandomPassword() {
        // Generate a random 8-character password
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        StringBuilder password = new StringBuilder();
        Random random = new Random();
        
        for (int i = 0; i < 8; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }
        
        return password.toString();
    }
    
    // Doctor Management
    @GetMapping("/doctors")
    public String listDoctors(Model model) {
        // Since UserRepository doesn't have findByRole yet, use a filter on findAll
        List<User> allUsers = userRepository.findAll();
        List<User> doctors = allUsers.stream()
            .filter(user -> user.getRole() == UserRole.DOCTOR || user.getRole() == UserRole.OPD_DOCTOR)
            .collect(Collectors.toList());
        
        List<ClinicModel> clinics = clinicRepository.findAll();
        
        model.addAttribute("doctors", doctors);
        model.addAttribute("clinics", clinics);
        return "admin/doctors";
    }
    
    @GetMapping("/doctors/create")
    public String showCreateDoctorForm(Model model) {
        // Redirect to the regular user creation form
        return "redirect:/admin/users/new";
    }
    
    @PostMapping("/doctors/create")
    public String createDoctor(@ModelAttribute UserDTO doctorDTO, 
                         @RequestParam Long clinicId,
                         @RequestParam(required = false) String specialization,
                         @RequestParam String doctorMobileNumber,
                         @RequestParam String doctorBirthday,
                         Model model) {
        // No longer needed as we're using User entity with DOCTOR role
        return "redirect:/admin/users/new";
    }
    
    @PostMapping("/doctors/{id}/delete")
    @ResponseBody
    public ResponseEntity<?> deleteDoctor(@PathVariable Long id) {
        try {
            // Simply update the user's role instead of deleting a doctor record
            Optional<User> user = userRepository.findById(id);
            if (!user.isPresent()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("success", false, "message", "Doctor not found"));
            }
            
            // Update the user to a different role or delete the user entirely
            user.get().setRole(UserRole.STAFF); // Change to staff, or use userService.deleteUser(id)
            userRepository.save(user.get());
            
            return ResponseEntity.ok(Map.of("success", true));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("success", false, "message", e.getMessage()));
        }
    }
    
    @GetMapping("/doctors/{id}/edit")
    public String showEditDoctorForm(@PathVariable Long id, Model model) {
        return "redirect:/admin/users/" + id + "/edit";
    }
    
    @PostMapping("/doctors/{id}/edit")
    public String updateDoctor(@PathVariable Long id, 
                              @ModelAttribute UserDTO doctorDTO, 
                              @RequestParam Long clinicId,
                              @RequestParam(required = false) String specialization,
                              @RequestParam String doctorMobileNumber,
                              @RequestParam String doctorBirthday,
                              Model model) {
        // Redirect to the user edit path instead
        return "redirect:/admin/users/" + id + "/edit";
    }
    
    // Clinic Management
    @GetMapping("/clinics")
    public String listClinics(Model model) {
        List<ClinicDTO> clinics = clinicService.getAllClinics();
        model.addAttribute("clinics", clinics);
        return "admin/clinics/list";
    }

    @GetMapping("/clinics/new")
    public String showCreateClinicForm(Model model) {
        model.addAttribute("clinic", new ClinicDTO());
        model.addAttribute("users", userService.getAllUsers());
        model.addAttribute("cityTiers", CityTier.values());
        return "admin/clinics/form";
    }

    @PostMapping("/clinics/save")
    public String saveClinic(@ModelAttribute ClinicDTO clinicDTO, 
                           @RequestParam(required = false) Long ownerId,
                           RedirectAttributes redirectAttributes) {
        try {
            // Validate mandatory fields
            if (clinicDTO.getClinicId() == null || clinicDTO.getClinicId().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Clinic ID is required");
                return "redirect:/admin/clinics/new";
            }
            
            if (clinicDTO.getClinicName() == null || clinicDTO.getClinicName().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Clinic Name is required");
                return "redirect:/admin/clinics/new";
            }
            
            if (clinicDTO.getCityTier() == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "City Tier is required");
                return "redirect:/admin/clinics/new";
            }
            
            // Set owner if provided
            if (ownerId != null) {
                UserDTO owner = userService.getUserById(ownerId)
                    .orElseThrow(() -> new RuntimeException("Owner not found"));
                clinicDTO.setOwner(owner);
            }
            
            // Save the clinic using service
            ClinicDTO savedClinic = clinicService.createClinic(clinicDTO);
            
            redirectAttributes.addFlashAttribute("successMessage", "Clinic created successfully");
            return "redirect:/admin/clinics";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error creating clinic: " + e.getMessage());
            return "redirect:/admin/clinics/new";
        }
    }

    @GetMapping("/clinics/edit/{id}")
    public String showEditClinicForm(@PathVariable Long id, Model model) {
        try {
            ClinicDTO clinic = clinicService.getClinicById(id)
                    .orElseThrow(() -> new RuntimeException("Clinic not found"));

            model.addAttribute("clinic", clinic);
            return "admin/clinics/form";
        } catch (Exception e) {
            return "redirect:/admin/clinics?error=not-found";
        }
    }

    @PostMapping("/clinics/edit/{id}")
    public String updateClinic(@PathVariable Long id,
                               @ModelAttribute ClinicDTO clinicDTO,
                               RedirectAttributes redirectAttributes) {
        try {
            // Validate clinic name
            if (clinicDTO.getClinicName() == null || clinicDTO.getClinicName().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Clinic Name is required");
                return "redirect:/admin/clinics/edit/" + id;
            }

            // Get existing clinic to preserve other fields
            ClinicDTO existingClinic = clinicService.getClinicById(id)
                    .orElseThrow(() -> new RuntimeException("Clinic not found"));

            // Only update the clinic name
            existingClinic.setClinicName(clinicDTO.getClinicName());

            // Update the clinic using service
            ClinicDTO updatedClinic = clinicService.updateClinic(id, existingClinic);

            redirectAttributes.addFlashAttribute("successMessage", "Clinic name updated successfully");
            return "redirect:/admin/clinics";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating clinic: " + e.getMessage());
            return "redirect:/admin/clinics/edit/" + id;
        }
    }

    @PostMapping("/clinics/{id}/delete")
    @ResponseBody
    public ResponseEntity<?> deleteClinic(@PathVariable Long id) {
        try {
            clinicService.deleteClinic(id);
            return ResponseEntity.ok(Map.of("success", true));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }
    
    // Procedure Price Management
    @GetMapping("/prices")
    public String listProcedurePrices(Model model, @RequestParam(required = false) String query) {
        List<ProcedurePrice> prices;
        
        if (query != null && !query.trim().isEmpty()) {
            // Search functionality
            prices = procedurePriceRepository.findByProcedureNameContainingIgnoreCase(query);
            model.addAttribute("searchQuery", query);
        } else {
            prices = procedurePriceRepository.findAll();
        }
        
        model.addAttribute("procedures", prices);
        return "admin/procedure-prices";
    }
    
    @GetMapping("/prices/create")
    public String showCreateProcedurePriceForm(Model model) {
        model.addAttribute("procedure", new ProcedurePriceDTO());
        model.addAttribute("cityTiers", CityTier.values());
        model.addAttribute("dentalDepartments", DentalDepartment.values());
        return "admin/create-procedure";
    }
    
    @PostMapping("/prices/create")
    public String createProcedurePrice(@ModelAttribute ProcedurePriceDTO procedureDTO, 
                                     @RequestParam(required = false) String changeReason,
                                     @RequestParam(required = false) String effectiveFrom,
                                     Model model) {
        try {
            // Validate all required fields
            if (procedureDTO.getProcedureName() == null || procedureDTO.getProcedureName().trim().isEmpty()) {
                model.addAttribute("error", "Procedure name is required");
                model.addAttribute("cityTiers", CityTier.values());
                model.addAttribute("dentalDepartments", DentalDepartment.values());
                return "admin/create-procedure";
            }
            
            if (procedureDTO.getCityTier() == null) {
                model.addAttribute("error", "City tier is required");
                model.addAttribute("cityTiers", CityTier.values());
                model.addAttribute("dentalDepartments", DentalDepartment.values());
                return "admin/create-procedure";
            }
            
            if (procedureDTO.getDentalDepartment() == null) {
                model.addAttribute("error", "Department is required");
                model.addAttribute("cityTiers", CityTier.values());
                model.addAttribute("dentalDepartments", DentalDepartment.values());
                return "admin/create-procedure";
            }
            
            if (procedureDTO.getPrice() == null || procedureDTO.getPrice() <= 0) {
                model.addAttribute("error", "Valid price is required (must be greater than zero)");
                model.addAttribute("cityTiers", CityTier.values());
                model.addAttribute("dentalDepartments", DentalDepartment.values());
                return "admin/create-procedure";
            }
            
            // Create the procedure price
            ProcedurePrice procedurePrice = new ProcedurePrice();
            procedurePrice.setProcedureName(procedureDTO.getProcedureName());
            procedurePrice.setCityTier(procedureDTO.getCityTier());
            procedurePrice.setPrice(procedureDTO.getPrice());
            procedurePrice.setDentalDepartment(procedureDTO.getDentalDepartment());
            
            // Save the procedure first to get its ID
            procedurePrice = procedurePriceRepository.save(procedurePrice);
            
            // Create the initial price history record
            ProcedurePriceHistory history = new ProcedurePriceHistory();
            history.setProcedure(procedurePrice);
            history.setPrice(procedureDTO.getPrice());
            history.setChangeReason(changeReason != null ? changeReason : "Initial price");
            
            // Set effective from date if provided, otherwise use current time
            if (effectiveFrom != null && !effectiveFrom.trim().isEmpty()) {
                history.setEffectiveFrom(LocalDateTime.parse(effectiveFrom.replace(" ", "T")));
            } else {
                history.setEffectiveFrom(LocalDateTime.now());
            }
            
            // Save the history record
            procedurePriceHistoryRepository.save(history);
            
            return "redirect:/admin/prices?success";
        } catch (Exception e) {
            model.addAttribute("error", "Error creating procedure price: " + e.getMessage());
            model.addAttribute("cityTiers", CityTier.values());
            model.addAttribute("dentalDepartments", DentalDepartment.values());
            return "admin/create-procedure";
        }
    }
    
    @GetMapping("/prices/{id}/edit")
    public String showEditProcedurePriceForm(@PathVariable Long id, Model model) {
        Optional<ProcedurePrice> procedure = procedurePriceRepository.findById(id);
        if (!procedure.isPresent()) {
            return "redirect:/admin/prices?error=not-found";
        }
        
        model.addAttribute("procedure", procedure.get());
        model.addAttribute("cityTiers", CityTier.values());
        model.addAttribute("dentalDepartments", DentalDepartment.values());
        return "admin/edit-procedure";
    }
    
    @PostMapping("/prices/{id}/edit")
    public String updateProcedurePrice(@PathVariable Long id, @ModelAttribute ProcedurePriceDTO procedureDTO, 
                                     @RequestParam(required = false) String changeReason, Model model) {
        try {
            Optional<ProcedurePrice> existingProcedure = procedurePriceRepository.findById(id);
            if (!existingProcedure.isPresent()) {
                return "redirect:/admin/prices?error=not-found";
            }
            
            // Validate all required fields
            if (procedureDTO.getProcedureName() == null || procedureDTO.getProcedureName().trim().isEmpty()) {
                model.addAttribute("error", "Procedure name is required");
                model.addAttribute("cityTiers", CityTier.values());
                model.addAttribute("dentalDepartments", DentalDepartment.values());
                model.addAttribute("procedure", procedureDTO);
                return "admin/edit-procedure";
            }
            
            if (procedureDTO.getCityTier() == null) {
                model.addAttribute("error", "City tier is required");
                model.addAttribute("cityTiers", CityTier.values());
                model.addAttribute("dentalDepartments", DentalDepartment.values());
                model.addAttribute("procedure", procedureDTO);
                return "admin/edit-procedure";
            }
            
            if (procedureDTO.getDentalDepartment() == null) {
                model.addAttribute("error", "Department is required");
                model.addAttribute("cityTiers", CityTier.values());
                model.addAttribute("dentalDepartments", DentalDepartment.values());
                model.addAttribute("procedure", procedureDTO);
                return "admin/edit-procedure";
            }
            
            if (procedureDTO.getPrice() == null || procedureDTO.getPrice() <= 0) {
                model.addAttribute("error", "Valid price is required (must be greater than zero)");
                model.addAttribute("cityTiers", CityTier.values());
                model.addAttribute("dentalDepartments", DentalDepartment.values());
                model.addAttribute("procedure", procedureDTO);
                return "admin/edit-procedure";
            }
            
            // Update the procedure price with history
            procedurePriceService.updateProcedurePrice(id, procedureDTO, changeReason);
            return "redirect:/admin/prices?success=updated";
        } catch (Exception e) {
            model.addAttribute("error", "Error updating procedure price: " + e.getMessage());
            model.addAttribute("cityTiers", CityTier.values());
            model.addAttribute("dentalDepartments", DentalDepartment.values());
            model.addAttribute("procedure", procedureDTO);
            return "admin/edit-procedure";
        }
    }
    
    @PostMapping("/prices/{id}/delete")
    @ResponseBody
    public ResponseEntity<?> deleteProcedurePrice(@PathVariable Long id) {
        try {
            Optional<ProcedurePrice> procedure = procedurePriceRepository.findById(id);
            if (!procedure.isPresent()) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Procedure price not found"));
            }
            
            procedurePriceRepository.delete(procedure.get());
            return ResponseEntity.ok(Map.of("success", true));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }
    
    
    @PostMapping("/fix-duplicate-ids")
    @ResponseBody
    public ResponseEntity<?> fixDuplicateIds() {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // This SQL gets duplicate IDs
            String findDuplicatesSql = "SELECT id, COUNT(*) as count FROM check_in_records GROUP BY id HAVING COUNT(*) > 1";
            List<Map<String, Object>> duplicates = jdbcTemplate.queryForList(findDuplicatesSql);
            
            int fixedIds = 0;
            
            for (Map<String, Object> duplicate : duplicates) {
                Long id = ((Number) duplicate.get("id")).longValue();
                log.info("Found duplicate records for ID: {}", id);
                
                // Get duplicate rows
                String getDuplicatesSql = "SELECT * FROM check_in_records WHERE id = ? ORDER BY check_in_time DESC";
                List<Map<String, Object>> records = jdbcTemplate.queryForList(getDuplicatesSql, id);
                
                if (records.size() > 1) {
                    // Keep first record and delete others
                    for (int i = 1; i < records.size(); i++) {
                        Long recordId = ((Number) records.get(i).get("id")).longValue();
                        
                        // Delete the duplicate directly with SQL
                        String deleteSql = "DELETE FROM check_in_records WHERE id = ? LIMIT 1";
                        int result = jdbcTemplate.update(deleteSql, recordId);
                        
                        if (result > 0) {
                            fixedIds++;
                            log.info("Deleted duplicate check-in record with ID: {}", recordId);
                        }
                    }
                }
            }
            
            response.put("success", true);
            response.put("message", "Fixed " + fixedIds + " duplicate check-in records across " + duplicates.size() + " IDs");
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("Error fixing duplicate record IDs: {}", e.getMessage());
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }
    
    @GetMapping("/fix-database")
    public String fixDatabaseManually() {
        try {
            // Get all duplicates as a set of IDs 
            String findDuplicateIds = "SELECT id FROM check_in_records GROUP BY id HAVING COUNT(*) > 1";
            List<Long> duplicateIds = jdbcTemplate.query(findDuplicateIds, (rs, rowNum) -> rs.getLong("id"));
            
            // For each duplicate ID
            for (Long id : duplicateIds) {
                // Get a reference row ID (one we'll keep)
                String getFirstRowQuery = "SELECT id FROM check_in_records WHERE id = ? LIMIT 1";
                Long referenceId = jdbcTemplate.queryForObject(getFirstRowQuery, Long.class, id);
                
                if (referenceId != null) {
                    // Fix this by assigning new IDs to duplicates
                    String getMaxId = "SELECT MAX(id) FROM check_in_records";
                    Long maxId = jdbcTemplate.queryForObject(getMaxId, Long.class);
                    
                    if (maxId != null) {
                        // Get the number of duplicates
                        String countDuplicatesQuery = "SELECT COUNT(*) FROM check_in_records WHERE id = ?";
                        Integer duplicateCount = jdbcTemplate.queryForObject(countDuplicatesQuery, Integer.class, id);
                        
                        if (duplicateCount != null && duplicateCount > 1) {
                            // Update all but the first row with new sequential IDs
                            int updated = 0;
                            for (int i = 1; i < duplicateCount; i++) {
                                maxId++;
                                String updateQuery = "UPDATE check_in_records " + 
                                                    "SET id = ? " + 
                                                    "WHERE id = ? " + 
                                                    "LIMIT 1";
                                updated += jdbcTemplate.update(updateQuery, maxId, id);
                            }
                            log.info("Updated {} duplicate records for ID {}", updated, id);
                        }
                    }
                }
            }
            
            return "redirect:/admin/database-status?fixed=true";
        } catch (Exception e) {
            log.error("Error fixing database manually: {}", e.getMessage());
            return "redirect:/admin/database-status?error=" + e.getMessage();
        }
    }
    
    // Target Management Methods
    @GetMapping("/targets")
    public String listTargets(Model model) {
        List<DoctorTarget> targets = doctorTargetService.getAllTargets();
        model.addAttribute("targets", targets);
        model.addAttribute("cityTiers", CityTier.values());
        return "admin/targets";
    }
    
    @GetMapping("/targets/new")
    public String showCreateTargetForm(Model model) {
        DoctorTarget target = new DoctorTarget();
        model.addAttribute("target", target);
        model.addAttribute("cityTiers", CityTier.values());
        return "admin/create-target";
    }
    
    @PostMapping("/targets/create")
    public String createTarget(@ModelAttribute DoctorTarget target, RedirectAttributes redirectAttributes) {
        try {
            doctorTargetService.createTarget(target);
            redirectAttributes.addFlashAttribute("successMessage", "Target created successfully");
            return "redirect:/admin/targets";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error creating target: " + e.getMessage());
            return "redirect:/admin/targets/new";
        }
    }
    
    @GetMapping("/targets/{id}/edit")
    public String showEditTargetForm(@PathVariable Long id, Model model) {
        try {
            DoctorTarget target = doctorTargetService.getTargetById(id);
            model.addAttribute("target", target);
            model.addAttribute("cityTiers", CityTier.values());
            return "admin/edit-target";
        } catch (Exception e) {
            return "redirect:/admin/targets?error=Target+not+found";
        }
    }
    
    @PostMapping("/targets/{id}/edit")
    public String updateTarget(@PathVariable Long id, @ModelAttribute DoctorTarget target, RedirectAttributes redirectAttributes) {
        try {
            doctorTargetService.updateTarget(id, target);
            redirectAttributes.addFlashAttribute("successMessage", "Target updated successfully");
            return "redirect:/admin/targets";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating target: " + e.getMessage());
            return "redirect:/admin/targets/" + id + "/edit";
        }
    }
    
    @PostMapping("/targets/{id}/delete")
    @ResponseBody
    public ResponseEntity<?> deleteTarget(@PathVariable Long id) {
        try {
            doctorTargetService.deleteTarget(id);
            return ResponseEntity.ok(Map.of("success", true, "message", "Target deleted successfully"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }
    
    @PostMapping("/targets/{id}/activate")
    @ResponseBody
    public ResponseEntity<?> activateTarget(@PathVariable Long id) {
        try {
            doctorTargetService.activateTarget(id);
            return ResponseEntity.ok(Map.of("success", true, "message", "Target activated successfully"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }
    
    @PostMapping("/targets/{id}/deactivate")
    @ResponseBody
    public ResponseEntity<?> deactivateTarget(@PathVariable Long id) {
        try {
            doctorTargetService.deactivateTarget(id);
            return ResponseEntity.ok(Map.of("success", true, "message", "Target deactivated successfully"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    @GetMapping("/reports")
    public String reports(Model model) {
        return "admin/reports";
    }
    
    @GetMapping("/report-dashboard")
    public String reportDashboard(Model model) {
        // Redirect to the AdminReportDashboardController
        return "redirect:/admin/reports/dashboard";
    }
    
    // Motivation Quote Management
    
    @GetMapping("/motivation-quotes")
    public String listMotivationQuotes(Model model) {
        List<MotivationQuote> quotes = motivationQuoteService.getAllActiveQuotes();
        model.addAttribute("quotes", quotes);
        return "admin/motivationQuotes";
    }
    
    @GetMapping("/motivation-quotes/new")
    public String showCreateMotivationQuoteForm(Model model) {
        model.addAttribute("quote", new MotivationQuote());
        return "admin/motivationQuoteForm";
    }
    
    @PostMapping("/motivation-quotes")
    public String createMotivationQuote(@ModelAttribute MotivationQuote quote, RedirectAttributes redirectAttributes) {
        try {
            motivationQuoteService.saveQuote(quote);
            redirectAttributes.addFlashAttribute("success", "Motivation quote created successfully!");
        } catch (Exception e) {
            log.error("Error creating motivation quote", e);
            redirectAttributes.addFlashAttribute("error", "Error creating motivation quote: " + e.getMessage());
        }
        return "redirect:/admin/motivation-quotes";
    }
    
    @GetMapping("/motivation-quotes/{id}/edit")
    public String showEditMotivationQuoteForm(@PathVariable Long id, Model model) {
        Optional<MotivationQuote> quote = motivationQuoteService.getQuoteById(id);
        if (quote.isPresent()) {
            model.addAttribute("quote", quote.get());
            return "admin/motivationQuoteForm";
        } else {
            return "redirect:/admin/motivation-quotes?error=Quote not found";
        }
    }
    
    @PostMapping("/motivation-quotes/{id}")
    public String updateMotivationQuote(@PathVariable Long id, @ModelAttribute MotivationQuote quote, RedirectAttributes redirectAttributes) {
        try {
            motivationQuoteService.updateQuote(id, quote);
            redirectAttributes.addFlashAttribute("success", "Motivation quote updated successfully!");
        } catch (Exception e) {
            log.error("Error updating motivation quote", e);
            redirectAttributes.addFlashAttribute("error", "Error updating motivation quote: " + e.getMessage());
        }
        return "redirect:/admin/motivation-quotes";
    }
    
    @PostMapping("/motivation-quotes/{id}/delete")
    public String deleteMotivationQuote(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            motivationQuoteService.deleteQuote(id);
            redirectAttributes.addFlashAttribute("success", "Motivation quote deleted successfully!");
        } catch (Exception e) {
            log.error("Error deleting motivation quote", e);
            redirectAttributes.addFlashAttribute("error", "Error deleting motivation quote: " + e.getMessage());
        }
        return "redirect:/admin/motivation-quotes";
    }
}