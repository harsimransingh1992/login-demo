package com.example.logindemo.service;

import com.example.logindemo.dto.SmsAppointmentNotificationRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class SmsNotificationService {
    private final SmsService smsService;

    @Value("${sms.template.appointmentScheduled:Dear {name}, your appointment is scheduled for {datetime} at {clinic}.}")
    private String scheduledTemplate;

    @Value("${sms.template.appointmentRescheduled:Dear {name}, your appointment has been rescheduled to {datetime} at {clinic}. Reason: {reason}.}")
    private String rescheduledTemplate;

    public SmsNotificationService(SmsService smsService) {
        this.smsService = smsService;
    }

    public String sendScheduled(SmsAppointmentNotificationRequest req) {
        String message = scheduledTemplate
                .replace("{name}", safe(req.getPatientName()))
                .replace("{datetime}", safe(req.getScheduledAt()))
                .replace("{clinic}", safe(req.getClinicName()));
        return smsService.sendSms(req.getPhoneNumber(), message);
    }

    public String sendRescheduled(SmsAppointmentNotificationRequest req) {
        String reason = req.getReason() == null ? "N/A" : req.getReason();
        String message = rescheduledTemplate
                .replace("{name}", safe(req.getPatientName()))
                .replace("{datetime}", safe(req.getScheduledAt()))
                .replace("{clinic}", safe(req.getClinicName()))
                .replace("{reason}", safe(reason));
        return smsService.sendSms(req.getPhoneNumber(), message);
    }

    private String safe(String s) { return s == null ? "" : s; }
}