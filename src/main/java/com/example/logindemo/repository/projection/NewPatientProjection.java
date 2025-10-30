package com.example.logindemo.repository.projection;

import java.time.LocalDateTime;

public interface NewPatientProjection {
    Long getPatientId();
    String getRegistrationCode();
    LocalDateTime getFirstExamTime();
}