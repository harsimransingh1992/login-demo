package com.example.logindemo.service.impl;

import com.example.logindemo.model.*;
import com.example.logindemo.repository.FollowUpRecordRepository;
import com.example.logindemo.repository.UserRepository;
import com.example.logindemo.repository.AppointmentRepository;
import com.example.logindemo.service.FollowUpService;
import com.example.logindemo.service.ToothClinicalExaminationService;
import com.example.logindemo.service.AppointmentService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.core.context.SecurityContextHolder;
import java.text.SimpleDateFormat;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Slf4j
public class FollowUpServiceImpl implements FollowUpService {
    
    @Autowired
    private FollowUpRecordRepository followUpRecordRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private ToothClinicalExaminationService toothClinicalExaminationService;
    
    @Autowired
    private AppointmentService appointmentService;
    
    @Autowired
    private AppointmentRepository appointmentRepository;
    
    @Override
    @Transactional
    public FollowUpRecord createFollowUp(ToothClinicalExamination examination, LocalDateTime scheduledDate, 
                                       String followUpNotes, Long doctorId) {
        try {
            // Get the doctor
            User doctor = null;
            if (doctorId != null) {
                doctor = userRepository.findById(doctorId).orElse(examination.getAssignedDoctor());
            } else {
                doctor = examination.getAssignedDoctor();
            }
            
            // Get next sequence number
            Integer sequenceNumber = getNextSequenceNumber(examination);
            
            // Create new follow-up record
            FollowUpRecord followUpRecord = new FollowUpRecord();
            followUpRecord.setExamination(examination);
            followUpRecord.setScheduledDate(scheduledDate);
            followUpRecord.setFollowUpNotes(followUpNotes);
            followUpRecord.setAssignedDoctor(doctor);
            followUpRecord.setSequenceNumber(sequenceNumber);
            followUpRecord.setStatus(FollowUpStatus.SCHEDULED);
            followUpRecord.setIsLatest(true);
            
            // Mark all existing follow-ups as not latest
            List<FollowUpRecord> existingFollowUps = followUpRecordRepository.findByExaminationOrderBySequenceNumberAsc(examination);
            existingFollowUps.forEach(followUp -> followUp.setIsLatest(false));
            followUpRecordRepository.saveAll(existingFollowUps);
            
            // Save the new follow-up record
            FollowUpRecord savedFollowUp = followUpRecordRepository.save(followUpRecord);
            
            // Add to examination's follow-up records
            examination.addFollowUpRecord(savedFollowUp);
            
            log.info("Created follow-up record ID: {} for examination ID: {}, sequence: {}", 
                    savedFollowUp.getId(), examination.getId(), sequenceNumber);
            
            return savedFollowUp;
            
        } catch (Exception e) {
            log.error("Error creating follow-up record for examination ID: {}", examination.getId(), e);
            throw new RuntimeException("Failed to create follow-up record", e);
        }
    }
    
    @Override
    public List<FollowUpRecord> getFollowUpsForExamination(ToothClinicalExamination examination) {
        List<FollowUpRecord> records = followUpRecordRepository.findByExaminationOrderBySequenceNumberAsc(examination);
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy 'at' hh:mm a");
        for (FollowUpRecord followUp : records) {
            if (followUp.getScheduledDate() != null) {
                followUp.setFormattedScheduledDate(followUp.getScheduledDate().format(formatter));
            }
            if (followUp.getCompletedDate() != null) {
                followUp.setFormattedCompletedDate(followUp.getCompletedDate().format(formatter));
            }
        }
        return records;
    }
    
    @Override
    public FollowUpRecord getLatestFollowUp(ToothClinicalExamination examination) {
        return followUpRecordRepository.findByExaminationAndIsLatestTrue(examination).orElse(null);
    }
    
    @Override
    @Transactional
    public FollowUpRecord completeFollowUp(Long followUpId, String clinicalNotes) {
        Optional<FollowUpRecord> optionalFollowUp = followUpRecordRepository.findById(followUpId);
        if (optionalFollowUp.isEmpty()) {
            throw new RuntimeException("Follow-up record not found with ID: " + followUpId);
        }
        
        FollowUpRecord followUp = optionalFollowUp.get();
        followUp.markAsCompleted();
        followUp.setClinicalNotes(clinicalNotes);
        
        FollowUpRecord savedFollowUp = followUpRecordRepository.save(followUp);
        log.info("Marked follow-up ID: {} as completed", followUpId);

        // Check if all follow-ups for the examination are completed
        ToothClinicalExamination examination = followUp.getExamination();
        List<FollowUpRecord> allFollowUps = followUpRecordRepository.findByExaminationOrderBySequenceNumberAsc(examination);
        boolean allCompleted = allFollowUps.stream().allMatch(fu -> fu.getStatus() == FollowUpStatus.COMPLETED);
        if (allCompleted) {
            examination.setProcedureStatus(ProcedureStatus.FOLLOW_UP_COMPLETED);
            toothClinicalExaminationService.saveExamination(examination);
            log.info("All next sittings completed. Updated procedure status to Next-Sitting Completed for examination ID: {}", examination.getId());
        }
        
        return savedFollowUp;
    }
    
    @Override
    @Transactional
    public FollowUpRecord cancelFollowUp(Long followUpId, String reason) {
        Optional<FollowUpRecord> optionalFollowUp = followUpRecordRepository.findById(followUpId);
        if (optionalFollowUp.isEmpty()) {
            throw new RuntimeException("Follow-up record not found with ID: " + followUpId);
        }
        
        FollowUpRecord followUp = optionalFollowUp.get();
        followUp.markAsCancelled();
        if (reason != null && !reason.trim().isEmpty()) {
            followUp.setClinicalNotes("Cancelled: " + reason);
        }
        
        FollowUpRecord savedFollowUp = followUpRecordRepository.save(followUp);
        log.info("Cancelled follow-up ID: {} with reason: {}", followUpId, reason);
        
        return savedFollowUp;
    }
    
    @Override
    @Transactional
    public FollowUpRecord markFollowUpAsNoShow(Long followUpId) {
        Optional<FollowUpRecord> optionalFollowUp = followUpRecordRepository.findById(followUpId);
        if (optionalFollowUp.isEmpty()) {
            throw new RuntimeException("Follow-up record not found with ID: " + followUpId);
        }
        
        FollowUpRecord followUp = optionalFollowUp.get();
        followUp.setStatus(FollowUpStatus.NO_SHOW);
        followUp.setUpdatedAt(LocalDateTime.now());
        
        FollowUpRecord savedFollowUp = followUpRecordRepository.save(followUp);
        log.info("Marked follow-up ID: {} as no-show", followUpId);
        
        return savedFollowUp;
    }
    
    @Override
    @Transactional
    public FollowUpRecord rescheduleFollowUp(Long followUpId, LocalDateTime newScheduledDate, String rescheduleNotes, Long doctorId) {
        Optional<FollowUpRecord> optionalFollowUp = followUpRecordRepository.findById(followUpId);
        if (optionalFollowUp.isEmpty()) {
            throw new RuntimeException("Follow-up record not found with ID: " + followUpId);
        }
        FollowUpRecord oldFollowUp = optionalFollowUp.get();
        // Cancel the old follow-up as RESCHEDULED
        oldFollowUp.setStatus(FollowUpStatus.RESCHEDULED);
        oldFollowUp.setUpdatedAt(LocalDateTime.now());
        StringBuilder notesBuilder = new StringBuilder();
        if (oldFollowUp.getClinicalNotes() != null && !oldFollowUp.getClinicalNotes().isEmpty()) {
            notesBuilder.append(oldFollowUp.getClinicalNotes()).append("\n");
        }
        // Get timestamp
        String timestamp = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(java.sql.Timestamp.valueOf(LocalDateTime.now()));
        // Get username
        String username = "System";
        try {
            username = SecurityContextHolder.getContext().getAuthentication().getName();
        } catch (Exception e) {
            // fallback to 'System'
        }
        // Format new scheduled date/time
        String newDateTime = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(java.sql.Timestamp.valueOf(newScheduledDate));
        notesBuilder.append("System cancelled due to rescheduling on ")
            .append(timestamp)
            .append(" by ")
            .append(username != null ? username : "System")
            .append(".");
        if (rescheduleNotes != null && !rescheduleNotes.trim().isEmpty()) {
            notesBuilder.append(" Reason: ").append(rescheduleNotes.trim());
        }
        notesBuilder.append(" New follow-up scheduled for: ").append(newDateTime);
        oldFollowUp.setClinicalNotes(notesBuilder.toString());
        followUpRecordRepository.save(oldFollowUp);
        // Cancel the associated appointment if present
        if (oldFollowUp.getAppointment() != null) {
            appointmentService.updateAppointmentStatus(oldFollowUp.getAppointment().getId(), AppointmentStatus.CANCELLED, null);
        }
        // Create a new follow-up record
        ToothClinicalExamination examination = oldFollowUp.getExamination();
        User doctor = doctorId != null ? userRepository.findById(doctorId).orElse(oldFollowUp.getAssignedDoctor()) : oldFollowUp.getAssignedDoctor();
        Integer sequenceNumber = getNextSequenceNumber(examination);
        // --- Create new appointment for the rescheduled follow-up ---
        Appointment appointment = new Appointment();
        appointment.setPatient(examination.getPatient());
        appointment.setPatientName(examination.getPatient().getFirstName() + " " + examination.getPatient().getLastName());
        appointment.setPatientMobile(examination.getPatient().getPhoneNumber());
        appointment.setAppointmentDateTime(newScheduledDate);
        appointment.setStatus(AppointmentStatus.SCHEDULED);
        appointment.setClinic(examination.getExaminationClinic());
        appointment.setDoctor(doctor);
        appointment.setNotes("Follow-up appointment for examination ID: " + examination.getId() +
            "\nTooth: " + examination.getToothNumber() +
            "\nProcedure: " + (examination.getProcedure() != null ? examination.getProcedure().getProcedureName() : "N/A") +
            "\nFollow-up Instructions: " + (rescheduleNotes != null ? rescheduleNotes : ""));
        // Set the booking user as the same as the previous appointment, or null if not available
        if (oldFollowUp.getAppointment() != null && oldFollowUp.getAppointment().getAppointmentBookedBy() != null) {
            appointment.setAppointmentBookedBy(oldFollowUp.getAppointment().getAppointmentBookedBy());
        }
        // Save the new appointment directly using repository
        Appointment savedAppointment = appointmentRepository.save(appointment);
        // --- End appointment creation ---
        FollowUpRecord newFollowUp = new FollowUpRecord();
        newFollowUp.setExamination(examination);
        newFollowUp.setScheduledDate(newScheduledDate);
        newFollowUp.setFollowUpNotes(rescheduleNotes);
        newFollowUp.setAssignedDoctor(doctor);
        newFollowUp.setSequenceNumber(sequenceNumber);
        newFollowUp.setStatus(FollowUpStatus.SCHEDULED);
        newFollowUp.setIsLatest(true);
        newFollowUp.setAppointment(savedAppointment);
        // Mark all existing follow-ups as not latest
        List<FollowUpRecord> existingFollowUps = followUpRecordRepository.findByExaminationOrderBySequenceNumberAsc(examination);
        existingFollowUps.forEach(fu -> fu.setIsLatest(false));
        followUpRecordRepository.saveAll(existingFollowUps);
        FollowUpRecord savedFollowUp = followUpRecordRepository.save(newFollowUp);
        examination.addFollowUpRecord(savedFollowUp);
        log.info("Rescheduled follow-up. Old ID: {}, New ID: {}, Examination ID: {}. New appointment ID: {}", oldFollowUp.getId(), savedFollowUp.getId(), examination.getId(), savedAppointment != null ? savedAppointment.getId() : null);
        return savedFollowUp;
    }
    
    @Override
    public List<FollowUpRecord> getTodayScheduledFollowUps() {
        return followUpRecordRepository.findTodayScheduledFollowUps();
    }
    
    @Override
    public List<FollowUpRecord> getOverdueFollowUps() {
        return followUpRecordRepository.findOverdueFollowUps();
    }
    
    @Override
    public List<FollowUpRecord> getFollowUpsForDoctor(Long doctorId) {
        return followUpRecordRepository.findByAssignedDoctorIdOrderByScheduledDateAsc(doctorId);
    }
    
    @Override
    public FollowUpStatistics getFollowUpStatistics(ToothClinicalExamination examination) {
        int totalFollowUps = (int) followUpRecordRepository.countByExamination(examination);
        int completedFollowUps = (int) followUpRecordRepository.countByExaminationAndStatus(examination, FollowUpStatus.COMPLETED);
        int scheduledFollowUps = (int) followUpRecordRepository.countByExaminationAndStatus(examination, FollowUpStatus.SCHEDULED);
        int cancelledFollowUps = (int) followUpRecordRepository.countByExaminationAndStatus(examination, FollowUpStatus.CANCELLED);
        int noShowFollowUps = (int) followUpRecordRepository.countByExaminationAndStatus(examination, FollowUpStatus.NO_SHOW);
        
        return new FollowUpStatistics(totalFollowUps, completedFollowUps, scheduledFollowUps, cancelledFollowUps, noShowFollowUps);
    }
    
    @Override
    public boolean hasPendingFollowUps(ToothClinicalExamination examination) {
        List<FollowUpRecord> followUps = getFollowUpsForExamination(examination);
        return followUps.stream()
                .anyMatch(followUp -> followUp.getStatus() == FollowUpStatus.SCHEDULED);
    }
    
    @Override
    public Integer getNextSequenceNumber(ToothClinicalExamination examination) {
        Integer nextNumber = followUpRecordRepository.getNextSequenceNumber(examination);
        return nextNumber != null ? nextNumber : 1;
    }
    
    @Override
    @Transactional
    public FollowUpRecord updateFollowUpRecord(FollowUpRecord followUpRecord) {
        followUpRecord.setUpdatedAt(LocalDateTime.now());
        return followUpRecordRepository.save(followUpRecord);
    }
}