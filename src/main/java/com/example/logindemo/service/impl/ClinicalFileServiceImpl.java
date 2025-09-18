package com.example.logindemo.service.impl;

import com.example.logindemo.dto.ClinicalFileDTO;
import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.model.ClinicalFile;
import com.example.logindemo.model.ClinicalFileStatus;
import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.model.Patient;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.repository.ClinicalFileRepository;
import com.example.logindemo.repository.ClinicRepository;
import com.example.logindemo.repository.PatientRepository;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.service.ClinicalFileService;
import com.example.logindemo.utils.PeriDeskUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Slf4j
public class ClinicalFileServiceImpl implements ClinicalFileService {

    @Autowired
    private ClinicalFileRepository clinicalFileRepository;

    @Autowired
    private ToothClinicalExaminationRepository toothClinicalExaminationRepository;

    @Autowired
    private ClinicRepository clinicRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Override
    public List<ClinicalFileDTO> getClinicalFilesByPatientId(Long patientId) {
        List<ClinicalFile> files = clinicalFileRepository.findByPatientIdOrderByCreatedAtDesc(patientId);
        return files.stream()
            .map(this::mapToDTO)
            .collect(Collectors.toList());
    }

    @Override
    public List<ClinicalFileDTO> getClinicalFilesByClinicId(String clinicId) {
        List<ClinicalFile> files = clinicalFileRepository.findByClinic_ClinicIdOrderByCreatedAtDesc(clinicId);
        return files.stream()
            .map(this::mapToDTO)
            .collect(Collectors.toList());
    }

    @Override
    public Optional<ClinicalFileDTO> getClinicalFileById(Long id) {
        return clinicalFileRepository.findById(id)
            .map(this::mapToDTO);
    }

    @Override
    public Optional<ClinicalFileDTO> getClinicalFileByFileNumber(String fileNumber) {
        return clinicalFileRepository.findByFileNumber(fileNumber)
            .map(this::mapToDTO);
    }

    @Override
    @Transactional
    public ClinicalFileDTO createClinicalFile(ClinicalFileDTO clinicalFileDTO) {
        ClinicalFile clinicalFile = new ClinicalFile();
        
        // Set basic fields
        clinicalFile.setTitle(clinicalFileDTO.getTitle());
        clinicalFile.setStatus(clinicalFileDTO.getStatus());
        clinicalFile.setNotes(clinicalFileDTO.getNotes());
        
        // Set patient
        if (clinicalFileDTO.getPatientId() != null) {
            Patient patient = patientRepository.findById(clinicalFileDTO.getPatientId())
                .orElseThrow(() -> new RuntimeException("Patient not found with ID: " + clinicalFileDTO.getPatientId()));
            clinicalFile.setPatient(patient);
        }
        
        // Set clinic
        if (clinicalFileDTO.getClinicId() != null) {
            ClinicModel clinic = clinicRepository.findById(clinicalFileDTO.getClinicId())
                .orElseThrow(() -> new RuntimeException("Clinic not found with ID: " + clinicalFileDTO.getClinicId()));
            clinicalFile.setClinic(clinic);
        }
        
        // Generate file number if not provided
        if (clinicalFileDTO.getFileNumber() == null || clinicalFileDTO.getFileNumber().isEmpty()) {
            if (clinicalFile.getClinic() != null) {
                clinicalFile.setFileNumber(generateFileNumber(clinicalFile.getClinic().getClinicId()));
            } else {
                // Fallback to a default clinic ID if clinic is not set
                clinicalFile.setFileNumber(generateFileNumber("CLINIC001"));
            }
        } else {
            clinicalFile.setFileNumber(clinicalFileDTO.getFileNumber());
        }
        
        // Set creation and update timestamps
        clinicalFile.setCreatedAt(LocalDateTime.now());
        clinicalFile.setUpdatedAt(LocalDateTime.now());
        
        ClinicalFile savedFile = clinicalFileRepository.save(clinicalFile);
        log.info("Created clinical file with ID: {} and file number: {}", savedFile.getId(), savedFile.getFileNumber());
        
        return mapToDTO(savedFile);
    }

    @Override
    @Transactional
    public ClinicalFileDTO updateClinicalFile(Long id, ClinicalFileDTO clinicalFileDTO) {
        ClinicalFile existingFile = clinicalFileRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Clinical file not found with ID: " + id));
        
        // Update fields
        if (clinicalFileDTO.getTitle() != null) {
            existingFile.setTitle(clinicalFileDTO.getTitle());
        }
        if (clinicalFileDTO.getStatus() != null) {
            existingFile.setStatus(clinicalFileDTO.getStatus());
        }
        if (clinicalFileDTO.getNotes() != null) {
            existingFile.setNotes(clinicalFileDTO.getNotes());
        }
        
        existingFile.setUpdatedAt(LocalDateTime.now());
        
        ClinicalFile updatedFile = clinicalFileRepository.save(existingFile);
        log.info("Updated clinical file with ID: {}", updatedFile.getId());
        
        return mapToDTO(updatedFile);
    }

    @Override
    @Transactional
    public void deleteClinicalFile(Long id) {
        ClinicalFile clinicalFile = clinicalFileRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Clinical file not found with ID: " + id));
        
        // Remove all examinations from this file
        clinicalFile.getExaminations().forEach(exam -> exam.setClinicalFile(null));
        
        clinicalFileRepository.delete(clinicalFile);
        log.info("Deleted clinical file with ID: {}", id);
    }

    @Override
    @Transactional
    public ClinicalFileDTO closeClinicalFile(Long id) {
        ClinicalFile clinicalFile = clinicalFileRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Clinical file not found with ID: " + id));
        
        if (!clinicalFile.canBeClosed()) {
            throw new RuntimeException("Clinical file cannot be closed. All examinations must be completed first.");
        }
        
        clinicalFile.close();
        ClinicalFile savedFile = clinicalFileRepository.save(clinicalFile);
        log.info("Closed clinical file with ID: {}", savedFile.getId());
        
        return mapToDTO(savedFile);
    }

    @Override
    @Transactional
    public ClinicalFileDTO reopenClinicalFile(Long id) {
        ClinicalFile clinicalFile = clinicalFileRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Clinical file not found with ID: " + id));
        
        clinicalFile.reopen();
        ClinicalFile savedFile = clinicalFileRepository.save(clinicalFile);
        log.info("Reopened clinical file with ID: {}", savedFile.getId());
        
        return mapToDTO(savedFile);
    }

    @Override
    public List<ClinicalFileDTO> getClinicalFilesByStatus(ClinicalFileStatus status) {
        List<ClinicalFile> files = clinicalFileRepository.findByStatusOrderByCreatedAtDesc(status);
        return files.stream()
            .map(this::mapToDTO)
            .collect(Collectors.toList());
    }

    @Override
    public List<ClinicalFileDTO> getClinicalFilesByStatusAndClinic(ClinicalFileStatus status, String clinicId) {
        List<ClinicalFile> files = clinicalFileRepository.findByStatusAndClinic_ClinicIdOrderByCreatedAtDesc(status, clinicId);
        return files.stream()
            .map(this::mapToDTO)
            .collect(Collectors.toList());
    }

    @Override
    public List<ClinicalFileDTO> getClinicalFilesByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        List<ClinicalFile> files = clinicalFileRepository.findByCreatedAtBetweenOrderByCreatedAtDesc(startDate, endDate);
        return files.stream()
            .map(this::mapToDTO)
            .collect(Collectors.toList());
    }

    @Override
    public List<ClinicalFileDTO> getClinicalFilesByDateRangeAndClinic(LocalDateTime startDate, LocalDateTime endDate, String clinicId) {
        List<ClinicalFile> files = clinicalFileRepository.findByCreatedAtBetweenAndClinic_ClinicIdOrderByCreatedAtDesc(startDate, endDate, clinicId);
        return files.stream()
            .map(this::mapToDTO)
            .collect(Collectors.toList());
    }

    @Override
    public List<ClinicalFileDTO> getActiveFilesWithPendingPayments(String clinicId) {
        List<ClinicalFile> files = clinicalFileRepository.findActiveFilesWithPendingPayments(clinicId);
        return files.stream()
            .map(this::mapToDTO)
            .collect(Collectors.toList());
    }

    @Override
    public List<ClinicalFileDTO> getFilesReadyToClose(String clinicId) {
        List<ClinicalFile> files = clinicalFileRepository.findFilesReadyToClose(clinicId);
        return files.stream()
            .map(this::mapToDTO)
            .collect(Collectors.toList());
    }

    @Override
    public String generateFileNumber(String clinicId) {
        // Get the total count of clinical files for this clinic
        long count = 0;
        try {
            count = clinicalFileRepository.findByClinic_ClinicIdOrderByCreatedAtDesc(clinicId).size();
        } catch (Exception e) {
            // If there's an error, default to 0
            log.warn("Error counting files for clinic {}: {}", clinicId, e.getMessage());
        }
        
        // Return simple sequential number starting from 1
        return String.valueOf(count + 1);
    }

    @Override
    @Transactional
    public ClinicalFileDTO addExaminationToFile(Long fileId, Long examinationId) {
        ClinicalFile clinicalFile = clinicalFileRepository.findById(fileId)
            .orElseThrow(() -> new RuntimeException("Clinical file not found with ID: " + fileId));
        
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
            .orElseThrow(() -> new RuntimeException("Examination not found with ID: " + examinationId));
        
        // Check if examination is already in another file
        if (examination.getClinicalFile() != null && !examination.getClinicalFile().getId().equals(fileId)) {
            throw new RuntimeException("Examination is already assigned to another clinical file");
        }
        
        clinicalFile.addExamination(examination);
        ClinicalFile savedFile = clinicalFileRepository.save(clinicalFile);
        log.info("Added examination {} to clinical file {}", examinationId, fileId);
        
        return mapToDTO(savedFile);
    }

    @Override
    @Transactional
    public ClinicalFileDTO removeExaminationFromFile(Long fileId, Long examinationId) {
        ClinicalFile clinicalFile = clinicalFileRepository.findById(fileId)
            .orElseThrow(() -> new RuntimeException("Clinical file not found with ID: " + fileId));
        
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
            .orElseThrow(() -> new RuntimeException("Examination not found with ID: " + examinationId));
        
        clinicalFile.removeExamination(examination);
        ClinicalFile savedFile = clinicalFileRepository.save(clinicalFile);
        log.info("Removed examination {} from clinical file {}", examinationId, fileId);
        
        return mapToDTO(savedFile);
    }

    /**
     * Map ClinicalFile entity to DTO with computed fields.
     */
    private ClinicalFileDTO mapToDTO(ClinicalFile clinicalFile) {
        ClinicalFileDTO dto = new ClinicalFileDTO();
        
        // Set basic fields
        dto.setId(clinicalFile.getId());
        dto.setTitle(clinicalFile.getTitle());
        dto.setStatus(clinicalFile.getStatus());
        dto.setNotes(clinicalFile.getNotes());
        dto.setFileNumber(clinicalFile.getFileNumber());
        dto.setCreatedAt(clinicalFile.getCreatedAt());
        dto.setUpdatedAt(clinicalFile.getUpdatedAt());
        dto.setClosedAt(clinicalFile.getClosedAt());
        
        // Set formatted date strings
        if (clinicalFile.getCreatedAt() != null) {
            dto.setCreatedAtFormatted(clinicalFile.getCreatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        }
        if (clinicalFile.getUpdatedAt() != null) {
            dto.setUpdatedAtFormatted(clinicalFile.getUpdatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        }
        if (clinicalFile.getClosedAt() != null) {
            dto.setClosedAtFormatted(clinicalFile.getClosedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        }
        
        // Set IDs and patient information
        if (clinicalFile.getPatient() != null) {
            dto.setPatientId(clinicalFile.getPatient().getId());
            dto.setPatientFirstName(clinicalFile.getPatient().getFirstName());
            dto.setPatientLastName(clinicalFile.getPatient().getLastName());
            dto.setPatientFullName(clinicalFile.getPatient().getFirstName() + " " + clinicalFile.getPatient().getLastName());
        }
        if (clinicalFile.getClinic() != null) {
            dto.setClinicId(clinicalFile.getClinic().getId());
        }
        
        // Set computed fields
        dto.setExaminationCount(clinicalFile.getExaminationCount());
        dto.setTotalAmount(clinicalFile.getTotalAmount());
        dto.setTotalPaidAmount(clinicalFile.getTotalPaidAmount());
        dto.setRemainingAmount(clinicalFile.getRemainingAmount());
        dto.setHasPendingPayments(clinicalFile.hasPendingPayments());
        dto.setOverallStatus(clinicalFile.getOverallStatus());
        
        // Map examinations if needed
        if (clinicalFile.getExaminations() != null && !clinicalFile.getExaminations().isEmpty()) {
            List<ToothClinicalExaminationDTO> examinationDTOs = clinicalFile.getExaminations().stream()
                .map(this::mapExaminationToDTO)
                .collect(Collectors.toList());
            dto.setExaminations(examinationDTOs);
        }
        
        return dto;
    }
    
    /**
     * Map ToothClinicalExamination entity to DTO.
     */
    private ToothClinicalExaminationDTO mapExaminationToDTO(ToothClinicalExamination examination) {
        ToothClinicalExaminationDTO dto = new ToothClinicalExaminationDTO();
        
        // Set basic fields
        dto.setId(examination.getId());
        dto.setToothNumber(examination.getToothNumber());
        dto.setToothCondition(examination.getToothCondition());
        dto.setToothMobility(examination.getToothMobility());
        dto.setPocketDepth(examination.getPocketDepth());
        dto.setBleedingOnProbing(examination.getBleedingOnProbing());
        dto.setPlaqueScore(examination.getPlaqueScore());
        dto.setGingivalRecession(examination.getGingivalRecession());
        dto.setToothVitality(examination.getToothVitality());
        dto.setFurcationInvolvement(examination.getFurcationInvolvement());
        dto.setPeriapicalCondition(examination.getPeriapicalCondition());
        dto.setToothSensitivity(examination.getToothSensitivity());
        dto.setExistingRestoration(examination.getExistingRestoration());
        dto.setExaminationNotes(examination.getExaminationNotes());
        dto.setChiefComplaints(examination.getChiefComplaints());
        dto.setAdvised(examination.getAdvised());
        dto.setUpperDenturePicturePath(examination.getUpperDenturePicturePath());
        dto.setLowerDenturePicturePath(examination.getLowerDenturePicturePath());
        dto.setXrayPicturePath(examination.getXrayPicturePath());
        dto.setExaminationDate(examination.getExaminationDate());
        dto.setTreatmentStartingDate(examination.getTreatmentStartingDate());
        dto.setProcedureStatus(examination.getProcedureStatus());
        dto.setFollowUpDate(examination.getFollowUpDate());
        
        // Set formatted date
        if (examination.getExaminationDate() != null) {
            dto.setExaminationDateFormatted(examination.getExaminationDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        }
        
        // Set IDs
        if (examination.getPatient() != null) {
            dto.setPatientId(examination.getPatient().getId());
        }
        if (examination.getAssignedDoctor() != null) {
            dto.setAssignedDoctorId(examination.getAssignedDoctor().getId());
        }
        if (examination.getOpdDoctor() != null) {
            dto.setOpdDoctorId(examination.getOpdDoctor().getId());
        }
        
        return dto;
    }
}
