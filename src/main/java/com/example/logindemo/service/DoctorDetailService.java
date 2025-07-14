package com.example.logindemo.service;

import com.example.logindemo.dto.UserDTO;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.UserRole;

import java.util.List;

public interface DoctorDetailService {
     List<UserDTO> findDoctorsByOnboardClinicUsername(String clinicUserName);
     
     /**
      * Get all users with DOCTOR role
      */
     List<UserDTO> getAllDoctors();
}
