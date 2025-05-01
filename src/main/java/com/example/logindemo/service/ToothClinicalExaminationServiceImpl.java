package com.example.logindemo.service;


import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
@Component("toothClinicalExaminationService")
public class ToothClinicalExaminationServiceImpl implements ToothClinicalExaminationService {

    @Resource(name="toothClinicalExaminationRepository")
    private ToothClinicalExaminationRepository toothClinicalExaminationRepository;

    @Resource(name = "modelMapper")
    private ModelMapper modelMapper;


    @Override
    public List<ToothClinicalExaminationDTO> getToothClinicalExaminationForPatientId(Long patientId) {
        final List<ToothClinicalExamination> patientClinicalExamination = toothClinicalExaminationRepository.findByPatientIdOrderByExaminationDateDescToothNumberAsc(patientId);
        List<ToothClinicalExaminationDTO> toothClinicalExaminationDTOList = new ArrayList<>();
        patientClinicalExamination.forEach(examination -> {
            toothClinicalExaminationDTOList.add(modelMapper.map(examination, ToothClinicalExaminationDTO.class));
        });
        return toothClinicalExaminationDTOList;
    }

    @Override
    public ToothClinicalExaminationDTO getToothClinicalExaminationById(Long id) {
        ToothClinicalExamination toothExamination=toothClinicalExaminationRepository.getToothClinicalExaminationById(id);
        return modelMapper.map(toothExamination, ToothClinicalExaminationDTO.class);
    }

    @Override
    public List<ToothClinicalExaminationDTO> getTodayAppointments() {
        final LocalDateTime startOfDay = LocalDateTime.now().with(LocalTime.MIN);
        final LocalDateTime endOfDay = LocalDateTime.now().with(LocalTime.MAX);
        List<ToothClinicalExamination> appointments = toothClinicalExaminationRepository.findByTreatmentStartingDateBetween(startOfDay, endOfDay);
        return appointments.stream()
                .map(appointment -> modelMapper.map(appointment, ToothClinicalExaminationDTO.class))
                .collect(Collectors.toList());
    }
}
