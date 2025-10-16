package com.example.logindemo.service.impl;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.Map;

import com.example.logindemo.dto.UserDTO;
import com.example.logindemo.model.TransactionType;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.context.annotation.Primary;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;

import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.ProcedureStatus;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.service.ToothClinicalExaminationService;
import com.example.logindemo.dto.ProcedurePriceDTO;
import com.example.logindemo.model.ProcedurePrice;
import com.example.logindemo.repository.ProcedurePriceRepository;
import com.example.logindemo.model.User;
import com.example.logindemo.repository.UserRepository;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import com.example.logindemo.model.PaymentMode;
import com.example.logindemo.model.PaymentNotes;
import com.example.logindemo.model.PaymentEntry;
import com.example.logindemo.utils.PeriDeskUtils;
import com.example.logindemo.repository.PaymentEntryRepository;
import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.repository.ProcedurePriceHistoryRepository;
import com.example.logindemo.model.ProcedurePriceHistory;

@Service
@Primary
@Slf4j
public class ToothClinicalExaminationServiceImpl implements ToothClinicalExaminationService {

    @Autowired
    private ToothClinicalExaminationRepository toothClinicalExaminationRepository;

    @Autowired
    private ModelMapper modelMapper;

    @Autowired
    private ProcedurePriceRepository procedurePriceRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PaymentEntryRepository paymentEntryRepository;

    @Autowired
    private ProcedurePriceHistoryRepository priceHistoryRepository;

    @Override
    public ToothClinicalExaminationDTO updateExamination(ToothClinicalExaminationDTO examinationDTO) {
        // Get the existing examination
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationDTO.getId())
            .orElseThrow(() -> new RuntimeException("Examination not found"));
            
        // Update only the examination fields, preserving relationships
        if (examinationDTO.getToothCondition() != null) {
            examination.setToothCondition(examinationDTO.getToothCondition());
        }
        if (examinationDTO.getExistingRestoration() != null) {
            examination.setExistingRestoration(examinationDTO.getExistingRestoration());
        }
        if (examinationDTO.getToothMobility() != null) {
            examination.setToothMobility(examinationDTO.getToothMobility());
        }
        if (examinationDTO.getPocketDepth() != null) {
            examination.setPocketDepth(examinationDTO.getPocketDepth());
        }
        if (examinationDTO.getBleedingOnProbing() != null) {
            examination.setBleedingOnProbing(examinationDTO.getBleedingOnProbing());
        }
        if (examinationDTO.getPlaqueScore() != null) {
            examination.setPlaqueScore(examinationDTO.getPlaqueScore());
        }
        if (examinationDTO.getGingivalRecession() != null) {
            examination.setGingivalRecession(examinationDTO.getGingivalRecession());
        }
        if (examinationDTO.getToothVitality() != null) {
            examination.setToothVitality(examinationDTO.getToothVitality());
        }
        if (examinationDTO.getFurcationInvolvement() != null) {
            examination.setFurcationInvolvement(examinationDTO.getFurcationInvolvement());
        }
        if (examinationDTO.getToothSensitivity() != null) {
            examination.setToothSensitivity(examinationDTO.getToothSensitivity());
        }
        if (examinationDTO.getExaminationNotes() != null) {
            examination.setExaminationNotes(examinationDTO.getExaminationNotes());
        }
        
        // Save the updated entity
        ToothClinicalExamination savedExamination = toothClinicalExaminationRepository.save(examination);
        
        // Map back to DTO and return
        return modelMapper.map(savedExamination, ToothClinicalExaminationDTO.class);
    }

    @Override
    public boolean isProcedureAlreadyAssociated(Long examinationId, Long procedureId) {
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId).orElse(null);
        if (examination == null || examination.getProcedure() == null) {
            return false;
        }
        return examination.getProcedure().getId().equals(procedureId);
    }

    @Override
    public Optional<ToothClinicalExamination> findExaminationByProcedureId(Long procedureId) {
        return toothClinicalExaminationRepository.findFirstByProcedureIdOrderByCreatedAtDesc(procedureId);
    }

    @Override
    public List<ProcedurePriceDTO> getProceduresForExamination(Long examinationId) {
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
            .orElseThrow(() -> new RuntimeException("Examination not found"));
            
        if (examination.getProcedure() == null) {
            return new ArrayList<>();
        }
        
        return Collections.singletonList(modelMapper.map(examination.getProcedure(), ProcedurePriceDTO.class));
    }

    @Override
    public Double getHistoricalPrice(Long procedureId, LocalDateTime date) {
        Optional<ProcedurePrice> procedureOpt = procedurePriceRepository.findById(procedureId);
        if (!procedureOpt.isPresent()) {
            throw new RuntimeException("Procedure not found");
        }

        ProcedurePrice procedure = procedureOpt.get();

        // If no date is provided, return current price
        if (date == null) {
            return procedure.getPrice();
        }

        Optional<ProcedurePriceHistory> history = priceHistoryRepository
            .findFirstByProcedureAndEffectiveFromLessThanEqualOrderByEffectiveFromDesc(
                procedure, date);

        return history.map(ProcedurePriceHistory::getPrice)
            .orElse(procedure.getPrice());
    }

    @Override
    public List<ToothClinicalExamination> findByProcedureStatus(ProcedureStatus status) {
        return toothClinicalExaminationRepository.findByProcedureStatus(status);
    }

    @Override
    public List<ToothClinicalExamination> findByProcedureStatusAndExaminationClinic_ClinicId(
            ProcedureStatus status, String clinicId) {
        return toothClinicalExaminationRepository.findByProcedureStatusAndExaminationClinic_ClinicId(status, clinicId);
    }

    @Override
    public List<ToothClinicalExamination> findByPatient_IdAndExaminationClinic_ClinicId(Long patientId, String clinicId) {
        return toothClinicalExaminationRepository.findByPatient_IdAndExaminationClinic_ClinicId(patientId, clinicId);
    }

    @Override
    public List<ToothClinicalExamination> findTodayPendingExaminations(String clinicId) {
        LocalDateTime startOfDay = LocalDateTime.now().with(LocalTime.MIN);
        LocalDateTime endOfDay = LocalDateTime.now().with(LocalTime.MAX);
        
        return toothClinicalExaminationRepository.findTodayPendingExaminationsByCreatedOrExamDate(
            startOfDay, endOfDay, ProcedureStatus.PAYMENT_PENDING, clinicId);
    }

    @Override
    public Optional<ToothClinicalExaminationDTO> getExaminationById(Long id) {
        return toothClinicalExaminationRepository.findById(id)
            .map(exam -> modelMapper.map(exam, ToothClinicalExaminationDTO.class));
    }

    @Override
    public List<ToothClinicalExaminationDTO> getToothClinicalExaminationForPatientId(Long patientId) {
        return toothClinicalExaminationRepository.findByPatientId(patientId)
            .stream()
            .map(this::convertToDTO)
            .toList();
    }

    @Override
    public Page<ToothClinicalExaminationDTO> getToothClinicalExaminationForPatientIdPaginated(Long patientId, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("examinationDate").descending().and(Sort.by("toothNumber").ascending()));
        Page<ToothClinicalExamination> examinationPage = toothClinicalExaminationRepository.findByPatientId(patientId, pageable);
        
        return examinationPage.map(this::convertToDTO);
    }
    
    private ToothClinicalExaminationDTO convertToDTO(ToothClinicalExamination exam) {
        ToothClinicalExaminationDTO dto = new ToothClinicalExaminationDTO();
        dto.setId(exam.getId());
        dto.setPatientId(exam.getPatient() != null ? exam.getPatient().getId() : null);
        dto.setToothNumber(exam.getToothNumber());
        dto.setToothCondition(exam.getToothCondition());
        dto.setToothMobility(exam.getToothMobility());
        dto.setPocketDepth(exam.getPocketDepth());
        dto.setBleedingOnProbing(exam.getBleedingOnProbing());
        dto.setPlaqueScore(exam.getPlaqueScore());
        dto.setGingivalRecession(exam.getGingivalRecession());
        dto.setToothVitality(exam.getToothVitality());
        dto.setFurcationInvolvement(exam.getFurcationInvolvement());
        dto.setPeriapicalCondition(exam.getPeriapicalCondition());
        dto.setToothSensitivity(exam.getToothSensitivity());
        dto.setExistingRestoration(exam.getExistingRestoration());
        dto.setExaminationNotes(exam.getExaminationNotes());
        dto.setExaminationDate(exam.getExaminationDate());
        dto.setTreatmentStartingDate(exam.getTreatmentStartingDate());
        dto.setProcedureStatus(exam.getProcedureStatus());
        dto.setFollowUpDate(exam.getFollowUpDate());
        
        // Set procedure if available
        if (exam.getProcedure() != null) {
            dto.setProcedure(modelMapper.map(exam.getProcedure(), ProcedurePriceDTO.class));
        }
        
        // Set doctor IDs
        if (exam.getAssignedDoctor() != null) {
            dto.setAssignedDoctorId(exam.getAssignedDoctor().getId());
        }
        if (exam.getOpdDoctor() != null) {
            dto.setOpdDoctorId(exam.getOpdDoctor().getId());
        }
        
        return dto;
    }

    @Override
    public List<ToothClinicalExaminationDTO> getTodayAppointments() {
        LocalDateTime startOfDay = LocalDateTime.now().with(LocalTime.MIN);
        LocalDateTime endOfDay = LocalDateTime.now().with(LocalTime.MAX);
        return toothClinicalExaminationRepository.findByTreatmentStartingDateBetween(startOfDay, endOfDay)
            .stream()
            .map(this::convertToDTO)
            .toList();
    }

    @Override
    public List<ToothClinicalExaminationDTO> getExaminationsByPatientId(Long patientId) {
        return toothClinicalExaminationRepository.findByPatientId(patientId)
            .stream()
            .map(this::convertToDTO)
            .toList();
    }

    @Override
    public void associateProceduresWithExamination(Long examinationId, List<Long> procedureIds) {
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
            .orElseThrow(() -> new RuntimeException("Examination not found"));
            
        if (procedureIds == null || procedureIds.isEmpty()) {
            throw new IllegalArgumentException("No procedure IDs provided");
        }
        
        // Since we only support one procedure per examination, take the first ID
        Long procedureId = procedureIds.get(0);
        ProcedurePrice procedure = procedurePriceRepository.findById(procedureId)
            .orElseThrow(() -> new RuntimeException("Procedure not found"));
            
        // Snapshot the price effective at association time and store as base total
        Double basePrice = getHistoricalPrice(procedure.getId(), LocalDateTime.now());
        if (basePrice == null) {
            basePrice = procedure.getPrice();
        }

        examination.setProcedure(procedure);
        examination.setBasePriceAtAssociation(basePrice);
        examination.setPaymentAmount(basePrice); // updates totalProcedureAmount internally
        toothClinicalExaminationRepository.save(examination);
    }

    @Override
    public ToothClinicalExamination saveExamination(ToothClinicalExamination examination) {
        return toothClinicalExaminationRepository.save(examination);
    }

    @Override
    public ToothClinicalExaminationDTO saveExamination(ToothClinicalExaminationDTO examinationDTO) {
        ToothClinicalExamination examination = modelMapper.map(examinationDTO, ToothClinicalExamination.class);
        ToothClinicalExamination savedExamination = toothClinicalExaminationRepository.save(examination);
        return modelMapper.map(savedExamination, ToothClinicalExaminationDTO.class);
    }

    @Override
    public void deleteExamination(Long id) {
        toothClinicalExaminationRepository.deleteById(id);
    }

    @Override
    public ToothClinicalExaminationDTO assignDoctor(Long examinationId, Long doctorId) {
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
            .orElseThrow(() -> new RuntimeException("Examination not found"));
            
        User doctor = userRepository.findById(doctorId)
            .orElseThrow(() -> new RuntimeException("Doctor not found"));
            
        examination.setAssignedDoctor(doctor);
        ToothClinicalExamination savedExamination = toothClinicalExaminationRepository.save(examination);
        return modelMapper.map(savedExamination, ToothClinicalExaminationDTO.class);
    }

    @Override
    public void updateProcedureStatus(Long examinationId, ProcedureStatus status) {
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
            .orElseThrow(() -> new RuntimeException("Examination not found"));
        examination.setProcedureStatus(status);
        toothClinicalExaminationRepository.save(examination);
    }

    @Override
    public List<ProcedurePriceDTO> getProceduresByExaminationId(Long examinationId) {
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
            .orElseThrow(() -> new RuntimeException("Examination not found"));
            
        if (examination.getProcedure() == null) {
            return Collections.emptyList();
        }
        
        return Collections.singletonList(modelMapper.map(examination.getProcedure(), ProcedurePriceDTO.class));
    }

    @Override
    public ToothClinicalExaminationDTO updateTreatmentDate(Long examinationId, String treatmentDate) {
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
            .orElseThrow(() -> new RuntimeException("Examination not found"));
        examination.setTreatmentStartingDate(LocalDateTime.parse(treatmentDate));
        ToothClinicalExamination savedExamination = toothClinicalExaminationRepository.save(examination);
        return modelMapper.map(savedExamination, ToothClinicalExaminationDTO.class);
    }

    @Override
    public void removeProcedureFromExamination(Long examinationId, Long procedureId) {
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
            .orElseThrow(() -> new RuntimeException("Examination not found"));
            
        if (examination.getProcedure() != null && examination.getProcedure().getId().equals(procedureId)) {
            examination.setProcedure(null);
            toothClinicalExaminationRepository.save(examination);
        }
    }

    @Override
    public List<Long> findAlreadyAssociatedProcedures(Long examinationId, List<Long> procedureIds) {
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
            .orElseThrow(() -> new RuntimeException("Examination not found"));
            
        if (examination.getProcedure() == null) {
            return Collections.emptyList();
        }
        
        return procedureIds.stream()
            .filter(id -> id.equals(examination.getProcedure().getId()))
            .toList();
    }

    @Override
    public ToothClinicalExaminationDTO getToothClinicalExaminationById(Long id) {
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Examination not found"));
            
        ToothClinicalExaminationDTO dto = modelMapper.map(examination, ToothClinicalExaminationDTO.class);
        
        // Set doctor IDs with null checks
        if (examination.getAssignedDoctor() != null) {
            dto.setAssignedDoctorId(examination.getAssignedDoctor().getId());
            log.info("Set assignedDoctorId to: {} for examination: {}", examination.getAssignedDoctor().getId(), id);
        } else {
            log.info("No assigned doctor found for examination: {}", id);
        }
        if (examination.getOpdDoctor() != null) {
            dto.setOpdDoctorId(examination.getOpdDoctor().getId());
        }
        
        log.info("Final DTO assignedDoctorId: {} for examination: {}", dto.getAssignedDoctorId(), id);
        return dto;
    }

    @Override
    public List<ToothClinicalExaminationDTO> getAllToothClinicalExaminations() {
        return toothClinicalExaminationRepository.findAll().stream()
            .map(examination -> {
                ToothClinicalExaminationDTO dto = modelMapper.map(examination, ToothClinicalExaminationDTO.class);
                // Set doctor IDs with null checks
                if (examination.getAssignedDoctor() != null) {
                    dto.setAssignedDoctorId(examination.getAssignedDoctor().getId());
                }
                if (examination.getOpdDoctor() != null) {
                    dto.setOpdDoctorId(examination.getOpdDoctor().getId());
                }
                return dto;
            })
            .collect(Collectors.toList());
    }

    @Override
    public ToothClinicalExaminationDTO getExaminationDetails(Long id) {
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Examination not found"));
        return modelMapper.map(examination, ToothClinicalExaminationDTO.class);
    }

    @Override
    @Transactional
    public void collectPayment(Long examinationId, PaymentMode paymentMode, String notes, Map<String, String> paymentDetails) {
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
            .orElseThrow(() -> new RuntimeException("Examination not found"));

        // Parse amount from paymentDetails
        Double amount = null;
        if (paymentDetails != null && paymentDetails.containsKey("amount")) {
            try {
                amount = Double.parseDouble(paymentDetails.get("amount"));
            } catch (NumberFormatException e) {
                throw new RuntimeException("Invalid payment amount");
            }
        }
        if (amount == null) {
            throw new RuntimeException("Payment amount is required");
        }

        // Optionally parse transaction reference
        String transactionReference = paymentDetails.getOrDefault("transactionReference", null);

        // Optionally parse payment notes
        PaymentNotes paymentNotes = PaymentNotes.fromString(notes);

        // Get the current user (recorder)
        User recordedBy = PeriDeskUtils.getCurrentUser();

        // Create new PaymentEntry
        PaymentEntry entry = PaymentEntry.createPaymentEntry(
            amount,
            paymentMode,
            paymentNotes,
            TransactionType.CAPTURE, // Default to CAPTURE for regular payments
            examination,
            recordedBy,
            notes,
            transactionReference
        );
        entry.setPaymentDate(java.time.LocalDateTime.now());
        entry.setCreatedAt(java.time.LocalDateTime.now());
        entry.setUpdatedAt(java.time.LocalDateTime.now());

        // Save the PaymentEntry first to get an ID
        PaymentEntry savedEntry = paymentEntryRepository.save(entry);

        // Add to examination's paymentEntries
        if (examination.getPaymentEntries() == null) {
            examination.setPaymentEntries(new java.util.ArrayList<>());
        }
        examination.getPaymentEntries().add(savedEntry);

        // Set treatmentStartingDate when first payment is received
        if (examination.getTreatmentStartingDate() == null) {
            examination.setTreatmentStartingDate(java.time.LocalDateTime.now());
            log.info("Set treatmentStartingDate to current time for examination: {} (first payment received)", examinationId);
        }

        // Calculate total paid amount after adding the new payment
        double totalPaid = examination.getTotalPaidAmount();
        double totalProcedureAmount = examination.getTotalProcedureAmount() != null ? examination.getTotalProcedureAmount() : 0.0;
        
        // Only change status to PAYMENT_COMPLETED if the previous status was PAYMENT_PENDING
        // This prevents changing status from COMPLETED to PAYMENT_COMPLETED
        if (examination.getProcedureStatus() == ProcedureStatus.PAYMENT_PENDING) {
            examination.setProcedureStatus(ProcedureStatus.PAYMENT_COMPLETED);
            log.info("Changed status from PAYMENT_PENDING to PAYMENT_COMPLETED for examination: {}", examinationId);
        } else {
            log.info("Payment collected but status remains {} for examination: {}", examination.getProcedureStatus(), examinationId);
        }

        toothClinicalExaminationRepository.save(examination);
    }

    @Override
    public List<ToothClinicalExamination> findByDoctorAndDateWithPayments(User doctor, LocalDateTime from, LocalDateTime to) {
        List<ToothClinicalExamination> all = toothClinicalExaminationRepository.findByAssignedDoctorAndExaminationDateBetween(doctor, from, to);
        return all.stream()
            .filter(exam -> exam.getPaymentEntries() != null && !exam.getPaymentEntries().isEmpty())
            .collect(Collectors.toList());
    }
}