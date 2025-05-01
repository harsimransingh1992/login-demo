package com.example.logindemo.repository;

import com.example.logindemo.model.DoctorDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Component;

import java.util.List;

@Component("doctorDetailRepository")
public interface DoctorDetailRepository extends JpaRepository<DoctorDetail, Long> {
    List<DoctorDetail> findDoctorsByOnboardClinic_Username(String onboardClinicUsername);
}
