package com.example.logindemo.service.impl;

import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.service.ToothClinicalExaminationService;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ToothClinicalExaminationServiceImpl implements ToothClinicalExaminationService {

    @Autowired
    private ToothClinicalExaminationRepository examinationRepository;

    @Autowired
    private ModelMapper modelMapper;

    @Override
    public List<ToothClinicalExaminationDTO> getToothClinicalExaminationForPatientId(Long patientId) {
        List<ToothClinicalExamination> examinations = examinationRepository.findByPatientId(patientId);
        return examinations.stream()
                .map(exam -> modelMapper.map(exam, ToothClinicalExaminationDTO.class))
                .collect(Collectors.toList());
    }

    @Override
    public ToothClinicalExaminationDTO getToothClinicalExaminationById(Long id) {
        ToothClinicalExamination examination = examinationRepository.findById(id).orElse(null);
        return examination != null ? modelMapper.map(examination, ToothClinicalExaminationDTO.class) : null;
    }

    @Override
    public List<ToothClinicalExaminationDTO> getTodayAppointments() {
        LocalDateTime startOfDay = LocalDateTime.now().with(LocalTime.MIN);
        LocalDateTime endOfDay = LocalDateTime.now().with(LocalTime.MAX);
        List<ToothClinicalExamination> appointments = examinationRepository.findByTreatmentStartingDateBetween(startOfDay, endOfDay);
        return appointments.stream()
                .map(appointment -> modelMapper.map(appointment, ToothClinicalExaminationDTO.class))
                .collect(Collectors.toList());
    }
} 