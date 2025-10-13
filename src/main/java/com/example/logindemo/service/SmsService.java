package com.example.logindemo.service;

public interface SmsService {
    /**
     * Send an SMS message to a phone number.
     * @param phoneNumber recipient number (E.164 preferred)
     * @param message plain text message
     * @return provider message id or null if unavailable
     */
    String sendSms(String phoneNumber, String message);
}