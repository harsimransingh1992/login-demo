package com.example.logindemo.controller;

import com.example.logindemo.model.User;
import com.example.logindemo.service.PasswordResetService;
import com.example.logindemo.service.PasswordResetResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/password-reset")
public class PasswordResetController {

    @Autowired
    private PasswordResetService passwordResetService;

    /**
     * Show password reset request page
     */
    @GetMapping("/request")
    public String showResetRequestPage() {
        return "password-reset-request";
    }

    /**
     * Handle password reset request
     */
    @PostMapping("/request")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> requestPasswordReset(@RequestParam String username) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            PasswordResetResult result = passwordResetService.initiatePasswordReset(username);
            
            if (result.isSuccess()) {
                response.put("success", true);
                response.put("message", result.getMessage());
                response.put("maskedEmail", result.getMaskedEmail());
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", result.getMessage());
                response.put("errorCode", result.getErrorCode());
                
                // Return different HTTP status codes based on error type
                switch (result.getErrorCode()) {
                    case "USER_NOT_FOUND":
                        return ResponseEntity.badRequest().body(response);
                    case "NO_EMAIL":
                        return ResponseEntity.badRequest().body(response);
                    case "EMAIL_ERROR":
                        return ResponseEntity.status(503).body(response); // Service Unavailable
                    default:
                        return ResponseEntity.badRequest().body(response);
                }
            }
        } catch (Exception e) {
            System.err.println("Error processing password reset request: " + e.getMessage());
            response.put("success", false);
            response.put("message", "An unexpected error occurred while processing your request. Please try again.");
            response.put("errorCode", "SYSTEM_ERROR");
            return ResponseEntity.internalServerError().body(response);
        }
    }
    
    /**
     * Validate password strength according to security requirements
     */
    private String validatePasswordStrength(String password) {
        if (password == null || password.length() < 8) {
            return "Password must be at least 8 characters long.";
        }
        
        if (!password.matches(".*[a-z].*")) {
            return "Password must contain at least one lowercase letter.";
        }
        
        if (!password.matches(".*[A-Z].*")) {
            return "Password must contain at least one uppercase letter.";
        }
        
        if (!password.matches(".*[0-9].*")) {
            return "Password must contain at least one number.";
        }
        
        if (!password.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*")) {
            return "Password must contain at least one special character.";
        }
        
        return null; // Password is valid
    }

    /**
     * Show password reset form page
     */
    @GetMapping("/reset")
    public String showResetPasswordPage(@RequestParam String token, Model model) {
        if (!passwordResetService.isValidToken(token)) {
            model.addAttribute("error", "Invalid or expired reset token. Please request a new password reset.");
            return "password-reset-error";
        }
        
        Optional<User> userOpt = passwordResetService.getUserByToken(token);
        if (userOpt.isPresent()) {
            model.addAttribute("token", token);
            model.addAttribute("username", userOpt.get().getUsername());
            return "password-reset-form";
        } else {
            model.addAttribute("error", "Invalid reset token. Please request a new password reset.");
            return "password-reset-error";
        }
    }

    /**
     * Handle password reset form submission
     */
    @PostMapping("/reset")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> resetPassword(
            @RequestParam String token,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Validate passwords match
            if (!newPassword.equals(confirmPassword)) {
                response.put("success", false);
                response.put("message", "Passwords do not match.");
                return ResponseEntity.badRequest().body(response);
            }
            
            // Validate password strength
            String passwordValidationError = validatePasswordStrength(newPassword);
            if (passwordValidationError != null) {
                response.put("success", false);
                response.put("message", passwordValidationError);
                return ResponseEntity.badRequest().body(response);
            }
            
            // Validate token and reset password
            if (!passwordResetService.isValidToken(token)) {
                response.put("success", false);
                response.put("message", "Invalid or expired reset token. Please request a new password reset.");
                return ResponseEntity.badRequest().body(response);
            }
            
            boolean success = passwordResetService.resetPassword(token, newPassword);
            
            if (success) {
                response.put("success", true);
                response.put("message", "Your password has been successfully reset. You can now log in with your new password.");
                response.put("redirectUrl", "/login?reset=success");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "Failed to reset password. The token may have expired or been used already.");
                return ResponseEntity.badRequest().body(response);
            }
        } catch (Exception e) {
            System.err.println("Error resetting password: " + e.getMessage());
            response.put("success", false);
            response.put("message", "An error occurred while resetting your password. Please try again.");
            return ResponseEntity.internalServerError().body(response);
        }
    }

    /**
     * Validate token endpoint (for AJAX calls)
     */
    @GetMapping("/validate-token")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> validateToken(@RequestParam String token) {
        Map<String, Object> response = new HashMap<>();
        
        boolean isValid = passwordResetService.isValidToken(token);
        response.put("valid", isValid);
        
        if (isValid) {
            Optional<User> userOpt = passwordResetService.getUserByToken(token);
            if (userOpt.isPresent()) {
                response.put("username", userOpt.get().getUsername());
            }
        }
        
        return ResponseEntity.ok(response);
    }

    /**
     * Check if username exists endpoint (for AJAX calls)
     */
    @GetMapping("/check-username")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkUsername(@RequestParam String username) {
        Map<String, Object> response = new HashMap<>();
        
        String maskedEmail = passwordResetService.getMaskedEmail(username);
        boolean exists = maskedEmail != null && !maskedEmail.equals("***@***.com");
        
        response.put("exists", exists);
        if (exists) {
            response.put("maskedEmail", maskedEmail);
        }
        
        return ResponseEntity.ok(response);
    }
}