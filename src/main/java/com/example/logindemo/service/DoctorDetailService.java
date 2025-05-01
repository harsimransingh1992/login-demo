package com.example.logindemo.service;

import com.example.logindemo.dto.DoctorDetailDTO;
import com.example.logindemo.model.DoctorDetail;
import com.example.logindemo.model.ToothClinicalExamination;

import java.util.List;

public interface DoctorDetailService {
     List<DoctorDetailDTO> findDoctorsByOnboardClinicUsername(String clinicUserName);
}
