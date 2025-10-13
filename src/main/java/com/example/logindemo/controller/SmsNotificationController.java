package com.example.logindemo.controller;

import com.example.logindemo.dto.SmsAppointmentNotificationRequest;
import com.example.logindemo.service.SmsNotificationService;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/notifications/appointments")
public class SmsNotificationController {
    private final SmsNotificationService notificationService;

    public SmsNotificationController(SmsNotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @PostMapping("/scheduled")
    public ResponseEntity<?> sendScheduled(@Validated @RequestBody SmsAppointmentNotificationRequest request) {
        String messageId = notificationService.sendScheduled(request);
        return ResponseEntity.ok().body(new ApiResponse("SENT", messageId));
    }

    @PostMapping("/rescheduled")
    public ResponseEntity<?> sendRescheduled(@Validated @RequestBody SmsAppointmentNotificationRequest request) {
        String messageId = notificationService.sendRescheduled(request);
        return ResponseEntity.ok().body(new ApiResponse("SENT", messageId));
    }

    static class ApiResponse {
        public String status;
        public String messageId;
        public ApiResponse(String status, String messageId) {
            this.status = status;
            this.messageId = messageId;
        }
    }
}