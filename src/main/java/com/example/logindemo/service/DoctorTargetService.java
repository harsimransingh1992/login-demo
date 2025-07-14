package com.example.logindemo.service;

import com.example.logindemo.dto.DoctorTargetProgressDTO;
import com.example.logindemo.model.DoctorTarget;
import com.example.logindemo.model.User;

import java.time.LocalDate;
import java.util.List;

public interface DoctorTargetService {
    DoctorTargetProgressDTO calculateTargetProgress(User doctor, LocalDate from, LocalDate to);
    
    // CRUD operations for target management
    List<DoctorTarget> getAllTargets();
    DoctorTarget getTargetById(Long id);
    DoctorTarget getTargetByCityTier(String cityTier);
    DoctorTarget createTarget(DoctorTarget target);
    DoctorTarget updateTarget(Long id, DoctorTarget target);
    void deleteTarget(Long id);
    void activateTarget(Long id);
    void deactivateTarget(Long id);
} 