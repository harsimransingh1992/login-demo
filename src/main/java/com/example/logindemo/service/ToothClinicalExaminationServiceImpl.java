package com.example.logindemo.service;


import com.example.logindemo.dto.ProcedurePriceDTO;
import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.model.ProcedurePrice;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.repository.ProcedurePriceRepository;
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
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Slf4j
@Component("toothClinicalExaminationService")
public class ToothClinicalExaminationServiceImpl implements ToothClinicalExaminationService {

    @Resource(name="toothClinicalExaminationRepository")
    private ToothClinicalExaminationRepository toothClinicalExaminationRepository;

    @Resource(name="procedurePriceRepository")
    private ProcedurePriceRepository procedurePriceRepository;

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

    @Override
    public void associateProceduresWithExamination(Long examinationId, List<Long> procedureIds) {
        // Find the examination
        ToothClinicalExamination examination = toothClinicalExaminationRepository.getToothClinicalExaminationById(examinationId);
        if (examination == null) {
            log.error("Examination with ID {} not found", examinationId);
            throw new IllegalArgumentException("Examination not found");
        }

        // Find all selected procedures by IDs
        List<ProcedurePrice> procedures = procedurePriceRepository.findAllById(procedureIds);
        if (procedures.size() != procedureIds.size()) {
            log.warn("Not all procedure IDs were found in the database");
        }

        // Associate the procedures with the examination
        if (examination.getProcedures() == null) {
            examination.setProcedures(new ArrayList<>());
        }
        
        // Update the examination's procedure list
        examination.getProcedures().addAll(procedures);
        toothClinicalExaminationRepository.save(examination);
        
        log.info("Associated {} procedures with examination {}", procedures.size(), examinationId);
    }

    @Override
    public List<ProcedurePriceDTO> getProceduresForExamination(Long examinationId) {
        // Find the examination
        ToothClinicalExamination examination = toothClinicalExaminationRepository.getToothClinicalExaminationById(examinationId);
        if (examination == null) {
            log.error("Examination with ID {} not found", examinationId);
            throw new IllegalArgumentException("Examination not found");
        }

        // Get associated procedures
        List<ProcedurePrice> procedures = examination.getProcedures();
        if (procedures == null || procedures.isEmpty()) {
            log.info("No procedures found for examination {}", examinationId);
            return new ArrayList<>();
        }

        // Map to DTOs
        return procedures.stream()
                .map(procedure -> modelMapper.map(procedure, ProcedurePriceDTO.class))
                .collect(Collectors.toList());
    }

    @Override
    public boolean isProcedureAlreadyAssociated(Long examinationId, Long procedureId) {
        ToothClinicalExamination examination = toothClinicalExaminationRepository.getToothClinicalExaminationById(examinationId);
        if (examination == null || examination.getProcedures() == null) {
            return false;
        }
        
        return examination.getProcedures().stream()
                .anyMatch(procedure -> procedure.getId().equals(procedureId));
    }
    
    @Override
    public List<Long> findAlreadyAssociatedProcedures(Long examinationId, List<Long> procedureIds) {
        ToothClinicalExamination examination = toothClinicalExaminationRepository.getToothClinicalExaminationById(examinationId);
        if (examination == null || examination.getProcedures() == null || examination.getProcedures().isEmpty()) {
            return new ArrayList<>();
        }
        
        // Get all existing procedure IDs
        List<Long> existingProcedureIds = examination.getProcedures().stream()
                .map(ProcedurePrice::getId)
                .collect(Collectors.toList());
        
        // Find which of the requested procedures are already associated
        return procedureIds.stream()
                .filter(existingProcedureIds::contains)
                .collect(Collectors.toList());
    }

    @Override
    public void removeProcedureFromExamination(Long examinationId, Long procedureId) {
        log.info("Removing procedure {} from examination {}", procedureId, examinationId);
        
        // Find the examination
        ToothClinicalExamination examination = toothClinicalExaminationRepository.getToothClinicalExaminationById(examinationId);
        if (examination == null) {
            log.error("Examination with ID {} not found", examinationId);
            throw new IllegalArgumentException("Examination not found");
        }
        
        // Find the procedure by ID
        Optional<ProcedurePrice> procedureOptional = procedurePriceRepository.findById(procedureId);
        if (!procedureOptional.isPresent()) {
            log.error("Procedure with ID {} not found", procedureId);
            throw new IllegalArgumentException("Procedure not found");
        }
        
        ProcedurePrice procedureToRemove = procedureOptional.get();
        
        // Check if the procedure is associated with the examination
        if (examination.getProcedures() == null || 
            !examination.getProcedures().stream().anyMatch(p -> p.getId().equals(procedureId))) {
            log.error("Procedure {} is not associated with examination {}", procedureId, examinationId);
            throw new IllegalArgumentException("Procedure is not associated with this examination");
        }
        
        // Remove the procedure from the examination
        examination.getProcedures().removeIf(p -> p.getId().equals(procedureId));
        
        // Save the updated examination
        toothClinicalExaminationRepository.save(examination);
        
        log.info("Successfully removed procedure {} from examination {}", procedureId, examinationId);
    }
}
