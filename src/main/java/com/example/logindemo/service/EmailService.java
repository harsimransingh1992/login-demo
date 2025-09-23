package com.example.logindemo.service;

/**
 * Service interface for sending emails
 */
public interface EmailService {
    
    /**
     * Send daily report via email
     * @param recipient email address of the recipient
     * @param subject email subject
     * @param content email content/body
     */
    void sendDailyReport(String recipient, String subject, String content);
    
    /**
     * Send a simple text email
     * @param to recipient email address
     * @param subject email subject
     * @param text email body text
     */
    void sendSimpleMessage(String to, String subject, String text);
}