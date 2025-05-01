package com.example.logindemo.util;

import com.example.logindemo.dto.PatientDTO;
import com.example.logindemo.dto.OccupationDTO;
import com.example.logindemo.model.Patient;
import com.example.logindemo.model.Occupation;
import org.modelmapper.ModelMapper;
import org.modelmapper.PropertyMap;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

/**
 * Custom mapper for Patient and Occupation entities/DTOs
 */
@Component
public class PatientMapper implements Mapper<Patient, PatientDTO> {

    @Resource(name = "modelMapper")
    private ModelMapper modelMapper;

    @PostConstruct
    public void setupMapper() {
        // Disable the default implicit mapping for occupation
        modelMapper.getConfiguration().setPropertyCondition(context -> 
            !context.getMapping().getLastDestinationProperty().getName().equals("occupation"));

        // Define explicit mapping with custom converters
        modelMapper.addMappings(new PropertyMap<Patient, PatientDTO>() {
            @Override
            protected void configure() {
                // The skip mapping is now handled by the property condition above
                
                // Add custom post converter for occupation
                using(ctx -> {
                    Patient source = (Patient) ctx.getSource();
                    if (source.getOccupation() != null) {
                        return OccupationDTO.fromEntity(source.getOccupation());
                    }
                    return null;
                }).map(source).setOccupation(null);
            }
        });
        
        modelMapper.addMappings(new PropertyMap<PatientDTO, Patient>() {
            @Override
            protected void configure() {
                // The skip mapping is now handled by the property condition above
                
                // Add custom converter for occupation
                using(ctx -> {
                    PatientDTO source = (PatientDTO) ctx.getSource();
                    if (source.getOccupation() != null) {
                        return source.getOccupation().toEntity();
                    }
                    return null;
                }).map(source).setOccupation(null);
            }
        });
    }
    
    @Override
    public PatientDTO toDto(Patient patient) {
        if (patient == null) {
            return null;
        }

        PatientDTO patientDTO = new PatientDTO();
        patientDTO.setId(String.valueOf(patient.getId()));
        patientDTO.setFirstName(patient.getFirstName());
        patientDTO.setLastName(patient.getLastName());
        patientDTO.setDateOfBirth(patient.getDateOfBirth());
        patientDTO.setGender(patient.getGender());
        patientDTO.setPhoneNumber(patient.getPhoneNumber());
        patientDTO.setEmail(patient.getEmail());
        patientDTO.setStreetAddress(patient.getStreetAddress());
        patientDTO.setCity(patient.getCity());
        patientDTO.setState(patient.getState());
        patientDTO.setPincode(patient.getPincode());
        patientDTO.setMedicalHistory(patient.getMedicalHistory());
        patientDTO.setEmergencyContactName(patient.getEmergencyContactName());
        patientDTO.setEmergencyContactPhoneNumber(patient.getEmergencyContactPhoneNumber());
        patientDTO.setRegistrationDate(patient.getRegistrationDate());

        // Convert Occupation enum to OccupationDTO
        if (patient.getOccupation() != null) {
            OccupationDTO occupationDTO = new OccupationDTO();
            occupationDTO.setName(patient.getOccupation().name());
            patientDTO.setOccupation(occupationDTO);
        }

        return patientDTO;
    }
    
    @Override
    public Patient toEntity(PatientDTO patientDTO) {
        if (patientDTO == null) {
            return null;
        }

        Patient patient = new Patient();
        if (patientDTO.getId() != null && !patientDTO.getId().isEmpty()) {
            patient.setId(Long.parseLong(patientDTO.getId()));
        }
        patient.setFirstName(patientDTO.getFirstName());
        patient.setLastName(patientDTO.getLastName());
        patient.setDateOfBirth(patientDTO.getDateOfBirth());
        patient.setGender(patientDTO.getGender());
        patient.setPhoneNumber(patientDTO.getPhoneNumber());
        patient.setEmail(patientDTO.getEmail());
        patient.setStreetAddress(patientDTO.getStreetAddress());
        patient.setCity(patientDTO.getCity());
        patient.setState(patientDTO.getState());
        patient.setPincode(patientDTO.getPincode());
        patient.setMedicalHistory(patientDTO.getMedicalHistory());
        patient.setEmergencyContactName(patientDTO.getEmergencyContactName());
        patient.setEmergencyContactPhoneNumber(patientDTO.getEmergencyContactPhoneNumber());
        patient.setRegistrationDate(patientDTO.getRegistrationDate());

        // Handle occupation conversion - support both OccupationDTO and String
        if (patientDTO.getOccupation() != null) {
            String occupationName;
            if (patientDTO.getOccupation() instanceof OccupationDTO) {
                occupationName = ((OccupationDTO) patientDTO.getOccupation()).getName();
            } else {
                occupationName = patientDTO.getOccupation().toString();
            }
            
            try {
                patient.setOccupation(Occupation.valueOf(occupationName));
            } catch (IllegalArgumentException e) {
                patient.setOccupation(Occupation.OTHER);
            }
        }

        return patient;
    }
} 