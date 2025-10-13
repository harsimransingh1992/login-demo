package com.example.logindemo.dto;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

public class SmsAppointmentNotificationRequest {
    @NotNull
    private Long appointmentId;

    @NotNull
    private Long patientId;

    @NotBlank
    private String patientName;

    @NotBlank
    private String phoneNumber; // E.164 or local, service will normalize

    @NotBlank
    private String clinicName;

    @NotBlank
    private String scheduledAt; // ISO-8601 date-time string in clinic TZ

    private String previousScheduledAt; // for rescheduled notifications

    private String reason; // optional reschedule reason

    public Long getAppointmentId() { return appointmentId; }
    public void setAppointmentId(Long appointmentId) { this.appointmentId = appointmentId; }

    public Long getPatientId() { return patientId; }
    public void setPatientId(Long patientId) { this.patientId = patientId; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getClinicName() { return clinicName; }
    public void setClinicName(String clinicName) { this.clinicName = clinicName; }

    public String getScheduledAt() { return scheduledAt; }
    public void setScheduledAt(String scheduledAt) { this.scheduledAt = scheduledAt; }

    public String getPreviousScheduledAt() { return previousScheduledAt; }
    public void setPreviousScheduledAt(String previousScheduledAt) { this.previousScheduledAt = previousScheduledAt; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
}