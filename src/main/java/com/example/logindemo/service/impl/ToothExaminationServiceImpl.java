package com.example.logindemo.service.impl;

import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.repository.DoctorDetailRepository;
import com.example.logindemo.service.ToothExaminationService;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ToothExaminationServiceImpl implements ToothExaminationService {

    private final ToothClinicalExaminationRepository examinationRepository;
    private final DoctorDetailRepository doctorRepository;
    private final ModelMapper modelMapper;

    @Autowired
    public ToothExaminationServiceImpl(
            ToothClinicalExaminationRepository examinationRepository,
            DoctorDetailRepository doctorRepository,
            ModelMapper modelMapper) {
        this.examinationRepository = examinationRepository;
        this.doctorRepository = doctorRepository;
        this.modelMapper = modelMapper;
    }

    @Override
    public List<ToothClinicalExaminationDTO> getExaminationsByPatientId(Long patientId) {
        List<ToothClinicalExamination> examinations = examinationRepository.findByPatientId(patientId);
        return examinations.stream()
                .map(exam -> modelMapper.map(exam, ToothClinicalExaminationDTO.class))
                .collect(Collectors.toList());
    }

    @Override
    public Optional<ToothClinicalExaminationDTO> getExaminationById(Long id) {
        return examinationRepository.findById(id)
                .map(exam -> modelMapper.map(exam, ToothClinicalExaminationDTO.class));
    }

    @Override
    @Transactional
    public ToothClinicalExaminationDTO saveExamination(ToothClinicalExaminationDTO examinationDTO) {
        ToothClinicalExamination examination = modelMapper.map(examinationDTO, ToothClinicalExamination.class);
        examination.setExaminationDate(LocalDateTime.now());
        ToothClinicalExamination savedExamination = examinationRepository.save(examination);
        return modelMapper.map(savedExamination, ToothClinicalExaminationDTO.class);
    }

    @Override
    @Transactional
    public ToothClinicalExaminationDTO updateTreatmentDate(Long examinationId, String treatmentStartDate) {
        ToothClinicalExamination examination = examinationRepository.findById(examinationId)
                .orElseThrow(() -> new RuntimeException("Examination not found with id: " + examinationId));

        if (treatmentStartDate != null && !treatmentStartDate.isEmpty()) {
            try {
                // Parse the date string which is in format "YYYY-MM-DD HH:mm"
                String[] dateTimeParts = treatmentStartDate.split(" ");
                String datePart = dateTimeParts[0];
                String timePart = dateTimeParts[1];
                
                // Create the final date string in ISO format
                String formattedDate = datePart + "T" + timePart + ":00";
                
                // Parse the formatted date string to LocalDateTime
                examination.setTreatmentStartingDate(LocalDateTime.parse(formattedDate));
            } catch (Exception e) {
                throw new RuntimeException("Failed to parse treatment start date: " + e.getMessage());
            }
        } else {
            examination.setTreatmentStartingDate(null);
        }

        ToothClinicalExamination updatedExamination = examinationRepository.save(examination);
        return modelMapper.map(updatedExamination, ToothClinicalExaminationDTO.class);
    }

    @Override
    @Transactional
    public ToothClinicalExaminationDTO assignDoctor(Long examinationId, Long doctorId) {
        ToothClinicalExamination examination = examinationRepository.findById(examinationId)
                .orElseThrow(() -> new RuntimeException("Examination not found with id: " + examinationId));

        if (doctorId != null) {
            examination.setAssignedDoctor(doctorRepository.findById(doctorId)
                    .orElseThrow(() -> new RuntimeException("Doctor not found with id: " + doctorId)));
        } else {
            examination.setAssignedDoctor(null);
        }

        ToothClinicalExamination updatedExamination = examinationRepository.save(examination);
        return modelMapper.map(updatedExamination, ToothClinicalExaminationDTO.class);
    }
} 