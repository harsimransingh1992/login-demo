package com.example.logindemo.service;

import lombok.Getter;

/**
 * Result class for password reset operations
 */
@Getter
public class PasswordResetResult {
    private final boolean success;
    private final String errorCode;
    private final String message;
    private final String maskedEmail;
    
    public PasswordResetResult(boolean success, String errorCode, String message, String maskedEmail) {
        this.success = success;
        this.errorCode = errorCode;
        this.message = message;
        this.maskedEmail = maskedEmail;
    }
    
    public static PasswordResetResult success(String maskedEmail) {
        return new PasswordResetResult(true, null, "Password reset instructions sent successfully", maskedEmail);
    }
    
    public static PasswordResetResult userNotFound() {
        return new PasswordResetResult(false, "USER_NOT_FOUND", "User not found. Please check your username.", null);
    }
    
    public static PasswordResetResult noEmail() {
        return new PasswordResetResult(false, "NO_EMAIL", "No email address associated with this account. Please contact support.", null);
    }
    
    public static PasswordResetResult emailError() {
        return new PasswordResetResult(false, "EMAIL_ERROR", "Unable to send reset email due to system issues. Please try again later or contact support.", null);
    }

}