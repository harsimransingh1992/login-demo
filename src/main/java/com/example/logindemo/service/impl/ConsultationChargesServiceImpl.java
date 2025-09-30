package com.example.logindemo.service.impl;

import com.example.logindemo.dto.UserDTO;
import com.example.logindemo.model.*;
import com.example.logindemo.repository.*;
import com.example.logindemo.service.ConsultationChargesService;
import com.example.logindemo.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@Slf4j
public class ConsultationChargesServiceImpl implements ConsultationChargesService {

    @Autowired
    private ProcedurePriceRepository procedurePriceRepository;
    
    @Autowired
    private ToothClinicalExaminationRepository toothClinicalExaminationRepository;
    
    @Autowired
    private PaymentEntryRepository paymentEntryRepository;
    
    @Autowired
    private PatientRepository patientRepository;
    
    @Autowired
    private ClinicRepository clinicRepository;
    
    @Autowired
    private UserService userService;

    @Override
    public Double getConsultationFee(String clinicId) {
        try {
            // Get clinic to determine tier
            Optional<ClinicModel> clinicOpt = clinicRepository.findByClinicId(clinicId);
            if (!clinicOpt.isPresent()) {
                log.error("Clinic not found with ID: {}", clinicId);
                return 0.0;
            }
            
            ClinicModel clinic = clinicOpt.get();
            CityTier cityTier = clinic.getCityTier();
            
            // Find consultation fee procedure price by searching all procedures
            List<ProcedurePrice> allProcedures = procedurePriceRepository.findByCityTier(cityTier);
            Optional<ProcedurePrice> procedurePriceOpt = allProcedures.stream()
                .filter(p -> "Consultation Fees".equals(p.getProcedureName()) && 
                           DentalDepartment.DIAGNOSIS_ORAL_MEDICINE_RADIOLOGY.equals(p.getDentalDepartment()))
                .findFirst();
            
            if (procedurePriceOpt.isPresent()) {
                return procedurePriceOpt.get().getPrice();
            } else {
                log.warn("Consultation fee not found for clinic tier: {}", cityTier);
                return 0.0;
            }
        } catch (Exception e) {
            log.error("Error getting consultation fee for clinic: {}", clinicId, e);
            return 0.0;
        }
    }

    @Override
    @Transactional
    public ToothClinicalExamination collectConsultationCharges(Long patientId, Double consultationFee, 
                                                              PaymentMode paymentMode, String paymentNotes, Long treatingDoctorId) {
        try {
            // Get current user
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            Optional<User> currentUserOpt = userService.findByUsername(auth.getName());
            if (!currentUserOpt.isPresent()) {
                throw new RuntimeException("Current user not found");
            }
            User currentUser = currentUserOpt.get();
            
            // Get patient
            Optional<Patient> patientOpt = patientRepository.findById(patientId);
            if (!patientOpt.isPresent()) {
                throw new RuntimeException("Patient not found with ID: " + patientId);
            }
            Patient patient = patientOpt.get();
            
            // Get clinic
            ClinicModel clinic = currentUser.getClinic();
            if (clinic == null) {
                throw new RuntimeException("Current user has no associated clinic");
            }
            
            // Get treating doctor if provided
            User treatingDoctor = null;
            if (treatingDoctorId != null) {
                Optional<UserDTO> treatingDoctorOpt = userService.getUserById(treatingDoctorId);
                if (treatingDoctorOpt.isPresent()) {
                    // Convert UserDTO back to User entity - we need to get the actual User entity
                    Optional<User> treatingDoctorEntityOpt = userService.findByUsername(treatingDoctorOpt.get().getUsername());
                    if (treatingDoctorEntityOpt.isPresent()) {
                        treatingDoctor = treatingDoctorEntityOpt.get();
                    }
                }
            }
            
            // Find consultation fee procedure price by searching all procedures
            List<ProcedurePrice> allProcedures = procedurePriceRepository.findByCityTier(clinic.getCityTier());
            Optional<ProcedurePrice> procedurePriceOpt = allProcedures.stream()
                .filter(p -> "Consultation Fees".equals(p.getProcedureName()) && 
                           DentalDepartment.DIAGNOSIS_ORAL_MEDICINE_RADIOLOGY.equals(p.getDentalDepartment()))
                .findFirst();
            
            if (procedurePriceOpt.isEmpty()) {
                throw new RuntimeException("Consultation fee procedure price not found");
            }
            ProcedurePrice procedurePrice = procedurePriceOpt.get();
            
            // Create ToothClinicalExamination
            ToothClinicalExamination examination = new ToothClinicalExamination();
            examination.setPatient(patient);
            examination.setExaminationClinic(clinic);
            examination.setToothNumber(ToothNumber.GENERAL_CONSULTATION);
            examination.setProcedure(procedurePrice);
            examination.setTotalProcedureAmount(consultationFee);
            examination.setProcedureStatus(ProcedureStatus.PAYMENT_COMPLETED);
            examination.setExaminationDate(LocalDateTime.now());
            examination.setTreatmentStartingDate(LocalDateTime.now());
            examination.setCreatedAt(LocalDateTime.now());
            examination.setUpdatedAt(LocalDateTime.now());
            examination.setExaminationNotes("General consultation - payment collected");
            
            // Set treating doctor fields if provided
            if (treatingDoctor != null) {
                examination.setOpdDoctor(treatingDoctor);
                examination.setAssignedDoctor(treatingDoctor);
            }
            
            // Save examination first to get ID
            ToothClinicalExamination savedExamination = toothClinicalExaminationRepository.save(examination);
            
            // Create PaymentEntry
            PaymentEntry paymentEntry = new PaymentEntry();
            paymentEntry.setExamination(savedExamination);
            paymentEntry.setAmount(consultationFee);
            paymentEntry.setPaymentMode(paymentMode);
            paymentEntry.setPaymentNotes(PaymentNotes.FULL_PAYMENT);
            paymentEntry.setRemarks(paymentNotes != null ? paymentNotes : "Consultation charges collected");
            paymentEntry.setTransactionType(TransactionType.CAPTURE);
            paymentEntry.setPaymentDate(LocalDateTime.now());
            paymentEntry.setCreatedAt(LocalDateTime.now());
            paymentEntry.setUpdatedAt(LocalDateTime.now());
            paymentEntry.setRecordedBy(currentUser);
            
            // Save payment entry
            PaymentEntry savedPaymentEntry = paymentEntryRepository.save(paymentEntry);
            
            // Add payment entry to examination
            if (savedExamination.getPaymentEntries() == null) {
                savedExamination.setPaymentEntries(new ArrayList<>());
            }
            savedExamination.getPaymentEntries().add(savedPaymentEntry);
            
            // Update and save examination
            savedExamination.setUpdatedAt(LocalDateTime.now());
            ToothClinicalExamination finalExamination = toothClinicalExaminationRepository.save(savedExamination);
            
            log.info("Consultation charges collected successfully for patient: {} by user: {} with treating doctor: {}", 
                    patientId, currentUser.getUsername(), treatingDoctor != null ? treatingDoctor.getUsername() : "none");
            
            return finalExamination;
            
        } catch (Exception e) {
            log.error("Error collecting consultation charges for patient: {}", patientId, e);
            throw new RuntimeException("Failed to collect consultation charges: " + e.getMessage());
        }
    }
}