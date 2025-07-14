package com.example.logindemo.service;

import com.example.logindemo.dto.ClinicDTO;
import java.util.List;
import java.util.Optional;

public interface ClinicService {
    List<ClinicDTO> getAllClinics();
    Optional<ClinicDTO> getClinicById(Long id);
    Optional<ClinicDTO> getClinicByClinicId(String clinicId);
    Optional<ClinicDTO> getClinicByOwnerId(Long ownerId);
    List<ClinicDTO> getClinicsByCityTier(String cityTier);
    ClinicDTO createClinic(ClinicDTO clinicDTO);
    ClinicDTO updateClinic(Long id, ClinicDTO clinicDTO);
    void deleteClinic(Long id);
    long getTotalClinics();
} 