package com.example.logindemo.service;

import com.example.logindemo.dto.CheckInRecordDTO;
import com.example.logindemo.dto.ProcedurePriceDTO;
import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.dto.UserDTO;
import com.example.logindemo.model.*;
import com.example.logindemo.repository.ProcedurePriceRepository;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.repository.UserRepository;
import com.example.logindemo.repository.PatientRepository;
import com.example.logindemo.repository.ProcedurePriceHistoryRepository;
import com.example.logindemo.utils.PeriDeskUtils;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
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

    @Resource(name = "userRepository")
    private UserRepository userRepository;

    @Resource(name = "patientRepository")
    private PatientRepository patientRepository;

    @Resource(name = "procedurePriceService")
    private ProcedurePriceService procedurePriceService;

    @Resource(name = "procedurePriceHistoryRepository")
    private ProcedurePriceHistoryRepository priceHistoryRepository;

    @Override
    public List<ToothClinicalExaminationDTO> getToothClinicalExaminationForPatientId(Long patientId) {
        final List<ToothClinicalExamination> patientClinicalExamination = toothClinicalExaminationRepository.findByPatientIdOrderByExaminationDateDescToothNumberAsc(patientId);
        List<ToothClinicalExaminationDTO> toothClinicalExaminationDTOList = new ArrayList<>();
        patientClinicalExamination.forEach(examination -> {
            ToothClinicalExaminationDTO dto = convertToDTO(examination);
            
            // If there's a procedure and payment has been collected, get its historical price at the time of payment
            LocalDateTime lastPaymentDate = (examination.getPaymentEntries() != null && !examination.getPaymentEntries().isEmpty())
                ? examination.getPaymentEntries().get(examination.getPaymentEntries().size() - 1).getPaymentDate()
                : null;
            if (examination.getProcedure() != null && lastPaymentDate != null && dto.getProcedure() != null) {
                Double historicalPrice = procedurePriceService.getHistoricalPrice(
                    examination.getProcedure().getId(),
                    lastPaymentDate
                );
                if (historicalPrice != null) {
                    dto.getProcedure().setPrice(historicalPrice);
                }
            }
            
            toothClinicalExaminationDTOList.add(dto);
        });
        return toothClinicalExaminationDTOList;
    }
    
    private ToothClinicalExaminationDTO convertToDTO(ToothClinicalExamination exam) {
        ToothClinicalExaminationDTO dto = modelMapper.map(exam, ToothClinicalExaminationDTO.class);
        
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
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId).orElse(null);
        if (examination == null) {
            log.error("Examination with ID {} not found", examinationId);
            throw new IllegalArgumentException("Examination not found");
        }

        // Since we now only support one procedure per examination, take the first ID from the list
        if (procedureIds == null || procedureIds.isEmpty()) {
            log.warn("No procedure IDs provided for examination {}", examinationId);
            return;
        }

        Long procedureId = procedureIds.get(0);
        
        // Find the procedure by ID
        Optional<ProcedurePrice> procedureOptional = procedurePriceRepository.findById(procedureId);
        if (!procedureOptional.isPresent()) {
            log.error("Procedure with ID {} not found", procedureId);
            throw new IllegalArgumentException("Procedure not found");
        }
        
        // Associate the procedure with the examination
        examination.setProcedure(procedureOptional.get());
        examination.setPaymentAmount(procedureOptional.get().getPrice());
        examination.setTotalProcedureAmount(procedureOptional.get().getPrice());
        toothClinicalExaminationRepository.save(examination);
        
        log.info("Associated procedure {} with examination {}", procedureId, examinationId);
    }

    @Override
    public List<ProcedurePriceDTO> getProceduresForExamination(Long examinationId) {
        // Find the examination
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId).orElse(null);
        if (examination == null) {
            log.error("Examination with ID {} not found", examinationId);
            throw new IllegalArgumentException("Examination not found");
        }

        // Get associated procedure
        ProcedurePrice procedure = examination.getProcedure();
        if (procedure == null) {
            log.info("No procedure found for examination {}", examinationId);
            return new ArrayList<>();
        }

        // Map to DTO and return as a single item list for backwards compatibility
        ProcedurePriceDTO procedureDTO = modelMapper.map(procedure, ProcedurePriceDTO.class);
        return Collections.singletonList(procedureDTO);
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
    public List<Long> findAlreadyAssociatedProcedures(Long examinationId, List<Long> procedureIds) {
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId).orElse(null);
        if (examination == null || examination.getProcedure() == null) {
            return new ArrayList<>();
        }
        
        // Get the existing procedure ID
        Long existingProcedureId = examination.getProcedure().getId();
        
        // Find if any of the requested procedures are already associated
        return procedureIds.stream()
                .filter(id -> id.equals(existingProcedureId))
                .collect(Collectors.toList());
    }

    @Override
    public void removeProcedureFromExamination(Long examinationId, Long procedureId) {
        log.info("Removing procedure {} from examination {}", procedureId, examinationId);
        
        // Find the examination
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId).orElse(null);
        if (examination == null) {
            log.error("Examination with ID {} not found", examinationId);
            throw new IllegalArgumentException("Examination not found");
        }
        
        // Check if the procedure is associated with the examination
        if (examination.getProcedure() == null || !examination.getProcedure().getId().equals(procedureId)) {
            log.error("Procedure {} is not associated with examination {}", procedureId, examinationId);
            throw new IllegalArgumentException("Procedure is not associated with this examination");
        }
        
        // Remove the procedure from the examination
        examination.setProcedure(null);
        
        // Save the updated examination
        toothClinicalExaminationRepository.save(examination);
        
        log.info("Successfully removed procedure {} from examination {}", procedureId, examinationId);
    }

    @Override
    public Optional<ToothClinicalExaminationDTO> getExaminationById(Long id) {
        return toothClinicalExaminationRepository.findById(id)
                .map(exam -> modelMapper.map(exam, ToothClinicalExaminationDTO.class));
    }
    
    @Override
    public ToothClinicalExaminationDTO updateExamination(ToothClinicalExaminationDTO examinationDTO) {
        // Validate required fields
        if (examinationDTO.getToothSurface() == null) {
            throw new IllegalArgumentException("Tooth surface is required");
        }
        if (examinationDTO.getToothCondition() == null) {
            throw new IllegalArgumentException("Tooth condition is required");
        }
        if (examinationDTO.getExistingRestoration() == null) {
            throw new IllegalArgumentException("Existing restoration is required");
        }
        
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationDTO.getId())
            .orElseThrow(() -> new RuntimeException("Examination not found"));
            
        // Update only the fields that can be changed
        examination.setToothSurface(examinationDTO.getToothSurface());
        examination.setToothCondition(examinationDTO.getToothCondition());
        examination.setExistingRestoration(examinationDTO.getExistingRestoration());
        examination.setToothMobility(examinationDTO.getToothMobility());
        examination.setPocketDepth(examinationDTO.getPocketDepth());
        examination.setBleedingOnProbing(examinationDTO.getBleedingOnProbing());
        examination.setPlaqueScore(examinationDTO.getPlaqueScore());
        examination.setGingivalRecession(examinationDTO.getGingivalRecession());
        examination.setToothVitality(examinationDTO.getToothVitality());
        examination.setFurcationInvolvement(examinationDTO.getFurcationInvolvement());
        examination.setToothSensitivity(examinationDTO.getToothSensitivity());
        examination.setExaminationNotes(examinationDTO.getExaminationNotes());
        examination.setChiefComplaints(examinationDTO.getChiefComplaints());
        examination.setAdvised(examinationDTO.getAdvised());
        
        // Save the updated entity
        ToothClinicalExamination savedExamination = toothClinicalExaminationRepository.save(examination);
        
        // Map back to DTO and return
        return modelMapper.map(savedExamination, ToothClinicalExaminationDTO.class);
    }
    
    @Override
    public void deleteExamination(Long id) {
        toothClinicalExaminationRepository.deleteById(id);
    }
    
    @Override
    @Transactional
    public ToothClinicalExaminationDTO saveExamination(ToothClinicalExaminationDTO examinationDTO) {
        ToothClinicalExamination examination = modelMapper.map(examinationDTO, ToothClinicalExamination.class);
        ToothClinicalExamination savedExamination = toothClinicalExaminationRepository.save(examination);
        return modelMapper.map(savedExamination, ToothClinicalExaminationDTO.class);
    }

    @Override
    public ToothClinicalExamination saveExamination(ToothClinicalExamination examination) {
        return toothClinicalExaminationRepository.save(examination);
    }

    @Override
    public List<ToothClinicalExaminationDTO> getExaminationsByPatientId(Long patientId) {
        List<ToothClinicalExamination> examinations = toothClinicalExaminationRepository.findByPatientId(patientId);
        return examinations.stream()
                .map(exam -> modelMapper.map(exam, ToothClinicalExaminationDTO.class))
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public ToothClinicalExaminationDTO updateTreatmentDate(Long examinationId, String treatmentStartDate) {
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
                .orElseThrow(() -> new RuntimeException("Examination not found with id: " + examinationId));

        if (treatmentStartDate != null && !treatmentStartDate.isEmpty()) {
            try {
                String[] dateTimeParts = treatmentStartDate.split(" ");
                String datePart = dateTimeParts[0];
                String timePart = dateTimeParts.length > 1 ? dateTimeParts[1] : "00:00";
                String formattedDate = datePart + "T" + timePart + ":00";
                
                LocalDateTime parsedDate = LocalDateTime.parse(formattedDate);
                examination.setTreatmentStartingDate(parsedDate);
            } catch (Exception e) {
                log.error("Error processing date string: {}", e.getMessage());
                throw new RuntimeException("Failed to process treatment start date: " + e.getMessage());
            }
        } else {
            examination.setTreatmentStartingDate(null);
        }

        ToothClinicalExamination updatedExamination = toothClinicalExaminationRepository.save(examination);
        return modelMapper.map(updatedExamination, ToothClinicalExaminationDTO.class);
    }

    @Override
    @Transactional
    public ToothClinicalExaminationDTO assignDoctor(Long examinationId, Long doctorId) {
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
                .orElseThrow(() -> new RuntimeException("Examination not found with id: " + examinationId));

        if (doctorId != null) {
            examination.setAssignedDoctor(userRepository.findById(doctorId)
                    .orElseThrow(() -> new RuntimeException("Doctor not found with id: " + doctorId)));
        } else {
            examination.setAssignedDoctor(null);
        }

        ToothClinicalExamination updatedExamination = toothClinicalExaminationRepository.save(examination);
        return modelMapper.map(updatedExamination, ToothClinicalExaminationDTO.class);
    }

    @Override
    public List<ToothClinicalExamination> findByProcedureStatus(ProcedureStatus status) {
        return toothClinicalExaminationRepository.findByProcedureStatus(status);
    }

    @Override
    public List<ToothClinicalExamination> findByProcedureStatusAndExaminationClinic_ClinicId(ProcedureStatus status, String clinicId) {
        return toothClinicalExaminationRepository.findByProcedureStatusAndExaminationClinic_ClinicId(status, clinicId);
    }

    @Override
    public List<ToothClinicalExamination> findByPatient_IdAndExaminationClinic_ClinicId(Long patientId, String clinicId) {
        return toothClinicalExaminationRepository.findByPatient_IdAndExaminationClinic_ClinicId(patientId, clinicId);
    }

    @Override
    public void updateProcedureStatus(Long examinationId, ProcedureStatus newStatus) {
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
            .orElseThrow(() -> new RuntimeException("Examination not found"));
        examination.setProcedureStatus(newStatus);
        toothClinicalExaminationRepository.save(examination);
    }

    @Override
    public List<ProcedurePriceDTO> getProceduresByExaminationId(Long examinationId) {
        ToothClinicalExamination examination = toothClinicalExaminationRepository.findById(examinationId)
            .orElseThrow(() -> new RuntimeException("Examination not found with id: " + examinationId));
        
        if (examination.getProcedure() == null) {
            return new ArrayList<>();
        }
        
        return Collections.singletonList(modelMapper.map(examination.getProcedure(), ProcedurePriceDTO.class));
    }

    @Override
    public Optional<ToothClinicalExamination> findExaminationByProcedureId(Long procedureId) {
        return toothClinicalExaminationRepository.findFirstByProcedureIdOrderByCreatedAtDesc(procedureId);
    }

    @Override
    public Double getHistoricalPrice(Long procedureId, LocalDateTime date) {
        Optional<ProcedurePrice> procedure = procedurePriceRepository.findById(procedureId);
        if (!procedure.isPresent()) {
            throw new RuntimeException("Procedure not found");
        }
        
        // If no date is provided, return current price
        if (date == null) {
            return procedure.get().getPrice();
        }
        
        Optional<ProcedurePriceHistory> history = priceHistoryRepository
            .findFirstByProcedureAndEffectiveFromLessThanEqualOrderByEffectiveFromDesc(
                procedure.get(), date);
        
        return history.map(ProcedurePriceHistory::getPrice)
            .orElse(procedure.get().getPrice());
    }

    @Transactional
    @Override
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

        // Optionally get the current user (recorder) - for now, set to null or fetch from context if available
        User recordedBy = PeriDeskUtils.getCurrentUser();

        // Create new PaymentEntry
        PaymentEntry entry = PaymentEntry.createPaymentEntry(
            amount,
            paymentMode,
            paymentNotes,
            examination,
            recordedBy,
            notes,
            transactionReference
        );
        entry.setPaymentDate(java.time.LocalDateTime.now());
        entry.setCreatedAt(java.time.LocalDateTime.now());
        entry.setUpdatedAt(java.time.LocalDateTime.now());

        // Add to examination's paymentEntries
        if (examination.getPaymentEntries() == null) {
            examination.setPaymentEntries(new java.util.ArrayList<>());
        }
        examination.getPaymentEntries().add(entry);

        // Set treatmentStartingDate when first payment is received
        if (examination.getTreatmentStartingDate() == null) {
            examination.setTreatmentStartingDate(java.time.LocalDateTime.now());
            log.info("Set treatmentStartingDate to current time for examination: {} (first payment received)", examinationId);
        }

        // Optionally update procedure status if needed
        examination.setProcedureStatus(ProcedureStatus.PAYMENT_COMPLETED);

        toothClinicalExaminationRepository.save(examination);
    }

    @Override
    public List<ToothClinicalExaminationDTO> getAllToothClinicalExaminations() {
        return toothClinicalExaminationRepository.findAll().stream()
            .map(examination -> {
                ToothClinicalExaminationDTO dto = modelMapper.map(examination, ToothClinicalExaminationDTO.class);
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
    public List<ToothClinicalExamination> findTodayPendingExaminations(String clinicId) {
        LocalDateTime startOfDay = LocalDateTime.now().with(LocalTime.MIN);
        LocalDateTime endOfDay = LocalDateTime.now().with(LocalTime.MAX);
        return toothClinicalExaminationRepository.findTodayPendingExaminationsByCreatedOrExamDate(
                startOfDay, endOfDay, ProcedureStatus.PAYMENT_PENDING, clinicId);
    }

    @Override
    public ToothClinicalExaminationDTO getExaminationDetails(Long id) {
        Optional<ToothClinicalExamination> examinationOpt = toothClinicalExaminationRepository.findById(id);
        if (examinationOpt.isEmpty()) {
            return null;
        }
        
        ToothClinicalExamination examination = examinationOpt.get();
        return convertToDTO(examination);
    }
    
    @Override
    public List<ToothClinicalExamination> findByDoctorAndDateWithPayments(User doctor, LocalDateTime from, LocalDateTime to) {
        return toothClinicalExaminationRepository.findByAssignedDoctorAndExaminationDateBetween(doctor, from, to);
    }

}
