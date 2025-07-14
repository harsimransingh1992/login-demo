package com.example.logindemo.service;

import com.example.logindemo.dto.ClinicDTO;
import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.model.CityTier;
import com.example.logindemo.repository.ClinicRepository;
import com.example.logindemo.repository.UserRepository;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class ClinicServiceImpl implements ClinicService {

    @Autowired
    private ClinicRepository clinicRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private ModelMapper modelMapper;

    @Override
    public List<ClinicDTO> getAllClinics() {
        return clinicRepository.findAll().stream()
            .map(clinic -> modelMapper.map(clinic, ClinicDTO.class))
            .collect(Collectors.toList());
    }

    @Override
    public Optional<ClinicDTO> getClinicById(Long id) {
        return clinicRepository.findById(id)
            .map(clinic -> modelMapper.map(clinic, ClinicDTO.class));
    }

    @Override
    public Optional<ClinicDTO> getClinicByClinicId(String clinicId) {
        return clinicRepository.findByClinicId(clinicId)
            .map(clinic -> modelMapper.map(clinic, ClinicDTO.class));
    }

    @Override
    public Optional<ClinicDTO> getClinicByOwnerId(Long ownerId) {
        return clinicRepository.findByOwnerId(ownerId)
            .map(clinic -> modelMapper.map(clinic, ClinicDTO.class));
    }

    @Override
    public List<ClinicDTO> getClinicsByCityTier(String cityTier) {
        CityTier tier = CityTier.valueOf(cityTier);
        return clinicRepository.findAll().stream()
            .filter(clinic -> clinic.getCityTier() == tier)
            .map(clinic -> modelMapper.map(clinic, ClinicDTO.class))
            .collect(Collectors.toList());
    }

    @Override
    public ClinicDTO createClinic(ClinicDTO clinicDTO) {
        // Check if clinicId is unique
        if (clinicRepository.findByClinicId(clinicDTO.getClinicId()).isPresent()) {
            throw new RuntimeException("Clinic ID already exists: " + clinicDTO.getClinicId());
        }

        ClinicModel clinic = modelMapper.map(clinicDTO, ClinicModel.class);
        
        // Set the owner if provided
        if (clinicDTO.getOwner() != null && clinicDTO.getOwner().getId() != null) {
            userRepository.findById(clinicDTO.getOwner().getId())
                .ifPresent(clinic::setOwner);
        }
        
        ClinicModel savedClinic = clinicRepository.save(clinic);
        return modelMapper.map(savedClinic, ClinicDTO.class);
    }

    @Override
    public ClinicDTO updateClinic(Long id, ClinicDTO clinicDTO) {
        return clinicRepository.findById(id)
            .map(clinic -> {
                // Update fields but preserve relationships
                if (clinicDTO.getClinicName() != null) {
                    clinic.setClinicName(clinicDTO.getClinicName());
                }
                if (clinicDTO.getClinicId() != null) {
                    clinic.setClinicId(clinicDTO.getClinicId());
                }
                if (clinicDTO.getCityTier() != null) {
                    clinic.setCityTier(clinicDTO.getCityTier());
                }
                
                // Update owner if provided
                if (clinicDTO.getOwner() != null && clinicDTO.getOwner().getId() != null) {
                    userRepository.findById(clinicDTO.getOwner().getId())
                        .ifPresent(clinic::setOwner);
                }
                
                ClinicModel updatedClinic = clinicRepository.save(clinic);
                return modelMapper.map(updatedClinic, ClinicDTO.class);
            })
            .orElseThrow(() -> new RuntimeException("Clinic not found with id: " + id));
    }

    @Override
    public void deleteClinic(Long id) {
        if (!clinicRepository.existsById(id)) {
            throw new RuntimeException("Clinic not found with id: " + id);
        }
        clinicRepository.deleteById(id);
    }

    @Override
    public long getTotalClinics() {
        return clinicRepository.count();
    }
} 