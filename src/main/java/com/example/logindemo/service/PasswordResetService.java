package com.example.logindemo.service;

import com.example.logindemo.model.PasswordResetToken;
import com.example.logindemo.model.User;
import com.example.logindemo.repository.PasswordResetTokenRepository;
import com.example.logindemo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class PasswordResetService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordResetTokenRepository tokenRepository;

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Value("${app.base-url:http://localhost:8080}")
    private String baseUrl;

    @Value("${spring.mail.from:noreply@peridesk.com}")
    private String fromEmail;
    
    /**
     * Initiate password reset process by creating a token and sending email
     */
    @Transactional
    public PasswordResetResult initiatePasswordReset(String username) {
        try {
            Optional<User> userOptional = userRepository.findByUsername(username);
            if (userOptional.isEmpty()) {
                System.out.println("Password reset requested for non-existent username: " + username);
                return PasswordResetResult.userNotFound();
            }
            
            User user = userOptional.get();
            
            // Check if user has an email
            if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
                System.out.println("Password reset requested for user without email: " + username);
                return PasswordResetResult.noEmail();
            }
            
            // Delete any existing tokens for this user
            tokenRepository.deleteByUser(user);
            
            // Generate new token
            String token = UUID.randomUUID().toString();
            PasswordResetToken resetToken = new PasswordResetToken(token, user);
            tokenRepository.save(resetToken);
            
            // Send email
            try {
                sendPasswordResetEmail(user, token);
                System.out.println("Password reset token generated and email sent for user: " + username);
                return PasswordResetResult.success(maskEmail(user.getEmail()));
            } catch (Exception emailException) {
                System.err.println("Error sending password reset email for user: " + username + " - " + emailException.getMessage());
                // Clean up the token since email failed
                tokenRepository.deleteByUser(user);
                return PasswordResetResult.emailError();
            }
            
        } catch (Exception e) {
            System.err.println("Error initiating password reset for user: " + username + " - " + e.getMessage());
            return PasswordResetResult.emailError();
        }
    }
    
    /**
     * Validate a password reset token
     */
    public boolean isValidToken(String token) {
        Optional<PasswordResetToken> tokenOptional = tokenRepository.findValidToken(token, LocalDateTime.now());
        return tokenOptional.isPresent();
    }
    
    /**
     * Get user associated with a valid token
     */
    public Optional<User> getUserByToken(String token) {
        Optional<PasswordResetToken> tokenOptional = tokenRepository.findValidToken(token, LocalDateTime.now());
        return tokenOptional.map(PasswordResetToken::getUser);
    }
    
    /**
     * Reset password using a valid token
     */
    @Transactional
    public boolean resetPassword(String token, String newPassword) {
        try {
            Optional<PasswordResetToken> tokenOptional = tokenRepository.findValidToken(token, LocalDateTime.now());
            if (tokenOptional.isEmpty()) {
                System.out.println("Invalid or expired token used for password reset: " + token);
                return false;
            }
            
            PasswordResetToken resetToken = tokenOptional.get();
            User user = resetToken.getUser();
            
            // Update user password
            user.setPassword(passwordEncoder.encode(newPassword));
            user.setForcePasswordChange(false); // Clear force password change flag if set
            userRepository.save(user);
            
            // Mark token as used
            tokenRepository.markTokenAsUsed(token);
            
            System.out.println("Password successfully reset for user: " + user.getUsername());
            return true;
            
        } catch (Exception e) {
            System.err.println("Error resetting password with token: " + token + " - " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Get masked email for display purposes
     */
    public String getMaskedEmail(String username) {
        Optional<User> userOptional = userRepository.findByUsername(username);
        if (userOptional.isEmpty() || userOptional.get().getEmail() == null) {
            return null;
        }
        
        String email = userOptional.get().getEmail();
        return maskEmail(email);
    }
    
    /**
     * Clean up expired tokens
     */
    @Transactional
    public void cleanupExpiredTokens() {
        try {
            tokenRepository.deleteExpiredTokens(LocalDateTime.now());
            System.out.println("Cleaned up expired password reset tokens");
        } catch (Exception e) {
            System.err.println("Error cleaning up expired tokens: " + e.getMessage());
        }
    }
    
    /**
     * Send password reset email
     */
    private void sendPasswordResetEmail(User user, String token) {
        try {
            String resetUrl = baseUrl + "/password-reset/reset?token=" + token;
            
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(user.getEmail());
            message.setSubject("PeriDesk - Password Reset Request");
            message.setText(buildEmailContent(user.getFirstName(), user.getUsername(), resetUrl));
            
            mailSender.send(message);
            System.out.println("Password reset email sent to: " + maskEmail(user.getEmail()));
            
        } catch (Exception e) {
            System.err.println("Error sending password reset email to user: " + user.getUsername() + " - " + e.getMessage());
            throw new RuntimeException("Failed to send password reset email", e);
        }
    }
    
    /**
     * Build email content
     */
    private String buildEmailContent(String firstName, String username, String resetUrl) {
        return "Dear " + (firstName != null ? firstName : "User") + ",\n\n" +
               "You have requested to reset your password for your PeriDesk account.\n" +
               "Username: " + username + "\n\n" +
               "Please click the following link to reset your password:\n" +
               resetUrl + "\n\n" +
               "This link will expire in 30 minutes for security reasons.\n\n" +
               "If you did not request this password reset, please ignore this email.\n\n" +
               "Best regards,\n" +
               "PeriDesk Team";
    }
    
    /**
     * Mask email for display purposes
     * Shows first and last character of local part, and masks only one word in domain
     */
    private String maskEmail(String email) {
        if (email == null || !email.contains("@")) {
            return "***@***.com";
        }
        
        String[] parts = email.split("@");
        String localPart = parts[0];
        String domain = parts[1];
        
        // Mask local part (username)
        String maskedLocal;
        if (localPart.length() <= 2) {
            maskedLocal = "***";
        } else {
            maskedLocal = localPart.charAt(0) + "***" + localPart.charAt(localPart.length() - 1);
        }
        
        // Improved domain masking - only mask one word, keep others original
        String maskedDomain;
        if (domain.contains(".")) {
            String[] domainParts = domain.split("\\.");
            if (domainParts.length == 2) {
                // For domains like "gmail.com" -> "*****.com"
                maskedDomain = "*****." + domainParts[1];
            } else if (domainParts.length >= 3) {
                // For domains like "mail.google.com" -> "mail.***.com"
                // Mask the middle part, keep first and last
                StringBuilder sb = new StringBuilder();
                sb.append(domainParts[0]).append(".");
                for (int i = 1; i < domainParts.length - 1; i++) {
                    if (i > 1) sb.append(".");
                    sb.append("***");
                }
                sb.append(".").append(domainParts[domainParts.length - 1]);
                maskedDomain = sb.toString();
            } else {
                // Single part domain (unusual case)
                maskedDomain = "***";
            }
        } else {
            // Domain without dots (unusual case)
            maskedDomain = "***";
        }
        
        return maskedLocal + "@" + maskedDomain;
    }

    /**
     * Scheduled task to clean up expired tokens
     * Runs every hour
     */
    @Scheduled(fixedRate = 3600000) // 1 hour = 3600000 milliseconds
    public void cleanupExpiredTokensScheduled() {
        cleanupExpiredTokens();
    }
}