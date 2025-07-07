package com.example.logindemo.service.impl;

import com.example.logindemo.model.ProcedureLifecycleTransition;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.User;
import com.example.logindemo.model.ProcedureStatus;
import com.example.logindemo.repository.ProcedureLifecycleTransitionRepository;
import com.example.logindemo.repository.UserRepository;
import com.example.logindemo.service.ProcedureLifecycleService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProcedureLifecycleServiceImpl implements ProcedureLifecycleService {

    private final ProcedureLifecycleTransitionRepository transitionRepository;
    private final UserRepository userRepository;
    private final ObjectMapper objectMapper;
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm");

    @Override
    @Transactional
    public ProcedureLifecycleTransition recordTransition(
            ToothClinicalExamination examination,
            String stageName,
            String stageDescription,
            boolean completed,
            Map<String, String> stageDetails) {
        
        ProcedureLifecycleTransition transition = new ProcedureLifecycleTransition();
        transition.setExamination(examination);
        transition.setStageName(stageName);
        transition.setStageDescription(stageDescription);
        transition.setCompleted(completed);
        transition.setTransitionTime(LocalDateTime.now());
        
        // Get current user from security context
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User currentUser = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found: " + username));
        transition.setTransitionedBy(currentUser);
        
        try {
            transition.setStageDetails(objectMapper.writeValueAsString(stageDetails));
        } catch (JsonProcessingException e) {
            log.error("Error serializing stage details", e);
        }
        
        return transitionRepository.save(transition);
    }

    @Override
    public List<ProcedureLifecycleTransition> getExaminationLifecycle(ToothClinicalExamination examination) {
        return transitionRepository.findByExaminationOrderByTransitionTimeAsc(examination);
    }

    @Override
    public List<Map<String, Object>> getFormattedLifecycleStages(ToothClinicalExamination examination) {
        log.info("Getting formatted lifecycle stages for examination ID: {}", examination.getId());
        
        List<Map<String, Object>> stages = new ArrayList<>();
        List<ProcedureLifecycleTransition> transitions = getExaminationLifecycle(examination);
        
        log.info("Found {} existing transitions for examination ID: {}", transitions.size(), examination.getId());
        
        // If no transitions exist, create initial stages
        if (transitions.isEmpty()) {
            log.info("No transitions found, creating initial stages for examination ID: {}", examination.getId());
            try {
                stages.add(createExaminationCreatedStage(examination));
                stages.add(createProcedureOpenedStage(examination));
                stages.add(createPaymentVerificationStage(examination));
                stages.add(createProcedureStartedStage(examination));
                stages.add(createProcedureCompletedStage(examination));
                stages.add(createFollowUpStage(examination));
                log.info("Successfully created {} initial stages for examination ID: {}", stages.size(), examination.getId());
            } catch (Exception e) {
                log.error("Error creating initial stages for examination ID: {}", examination.getId(), e);
                throw e;
            }
        } else {
            // Convert transitions to formatted stages
            log.info("Converting {} transitions to formatted stages for examination ID: {}", transitions.size(), examination.getId());
            for (ProcedureLifecycleTransition transition : transitions) {
                try {
                    Map<String, Object> stage = new HashMap<>();
                    stage.put("name", transition.getStageName());
                    stage.put("description", transition.getStageDescription());
                    stage.put("completed", transition.isCompleted());
                    stage.put("timestamp", transition.getTransitionTime().format(formatter));
                    
                    // Add who performed the transition
                    if (transition.getTransitionedBy() != null) {
                        stage.put("transitionedBy", transition.getTransitionedBy().getFirstName() + " " + transition.getTransitionedBy().getLastName());
                        stage.put("transitionedByRole", transition.getTransitionedBy().getRole().toString());
                    }
                    
                    if (transition.getStageDetails() != null) {
                        Map<String, String> details = objectMapper.readValue(
                            transition.getStageDetails(), 
                            Map.class
                        );
                        stage.put("details", details);
                    }
                    
                    stages.add(stage);
                } catch (Exception e) {
                    log.error("Error processing transition for examination ID: {}", examination.getId(), e);
                    // Continue with other transitions instead of failing completely
                }
            }
        }
        
        log.info("Returning {} formatted stages for examination ID: {}", stages.size(), examination.getId());
        return stages;
    }

    private Map<String, Object> createExaminationCreatedStage(ToothClinicalExamination examination) {
        Map<String, Object> stage = new HashMap<>();
        stage.put("name", ProcedureLifecycleTransition.STAGE_EXAMINATION_CREATED);
        stage.put("completed", true);
        stage.put("timestamp", examination.getCreatedAt() != null ? 
                   examination.getCreatedAt().format(formatter) : null);
        stage.put("description", "Tooth examination created");
        
        // Add OPD doctor information if available
        if (examination.getOpdDoctor() != null) {
            stage.put("transitionedBy", examination.getOpdDoctor().getFirstName() + " " + examination.getOpdDoctor().getLastName());
            stage.put("transitionedByRole", examination.getOpdDoctor().getRole().toString());
        }
        
        Map<String, String> details = new HashMap<>();
        details.put("Tooth Number", examination.getToothNumber() != null ? 
                   examination.getToothNumber().toString() : "Not specified");
        details.put("Initial Condition", examination.getToothCondition() != null ? 
                   examination.getToothCondition().toString() : "Not recorded");
        details.put("Surface", examination.getToothSurface() != null ? 
                   examination.getToothSurface().toString() : "Not specified");
        stage.put("details", details);
        
        return stage;
    }

    private Map<String, Object> createProcedureOpenedStage(ToothClinicalExamination examination) {
        Map<String, Object> stage = new HashMap<>();
        stage.put("name", ProcedureLifecycleTransition.STAGE_PROCEDURE_OPENED);
        stage.put("completed", examination.getProcedureStatus() != null);
        stage.put("timestamp", examination.getUpdatedAt() != null ? 
                   examination.getUpdatedAt().format(formatter) : null);
        stage.put("description", "Procedure opened and ready for payment verification");
        
        if (examination.getProcedureStatus() != null) {
            Map<String, String> details = new HashMap<>();
            details.put("Status", examination.getProcedureStatus().getLabel());
            stage.put("details", details);
        }
        
        return stage;
    }

    private Map<String, Object> createPaymentVerificationStage(ToothClinicalExamination examination) {
        Map<String, Object> stage = new HashMap<>();
        stage.put("name", ProcedureLifecycleTransition.STAGE_PAYMENT_VERIFICATION);
        
        boolean paymentVerified = false;
        if (examination.getProcedureStatus() != null) {
            String statusLabel = examination.getProcedureStatus().getLabel();
            paymentVerified = "Payment Completed".equals(statusLabel) ||
                             "In Progress".equals(statusLabel) ||
                             "Completed".equals(statusLabel) ||
                             "Follow-Up Scheduled".equals(statusLabel) ||
                             "Closed".equals(statusLabel);
        }
        
        stage.put("completed", paymentVerified);
        stage.put("timestamp", paymentVerified && examination.getUpdatedAt() != null ? 
                   examination.getUpdatedAt().format(formatter) : null);
        stage.put("description", paymentVerified ? 
            "Payment verified and procedure can proceed" : 
            "Waiting for payment verification");
        
        if (paymentVerified && examination.getProcedure() != null) {
            Map<String, String> details = new HashMap<>();
            
            // Find who processed the payment by looking at payment entries
            if (examination.getPaymentEntries() != null && !examination.getPaymentEntries().isEmpty()) {
                // Get the first payment entry (most recent or first one)
                var firstPayment = examination.getPaymentEntries().get(0);
                if (firstPayment.getRecordedBy() != null) {
                    details.put("Verified By", firstPayment.getRecordedBy().getFirstName() + " " + firstPayment.getRecordedBy().getLastName());
                    stage.put("transitionedBy", firstPayment.getRecordedBy().getFirstName() + " " + firstPayment.getRecordedBy().getLastName());
                    stage.put("transitionedByRole", firstPayment.getRecordedBy().getRole().toString());
                } else {
                    details.put("Verified By", "Receptionist");
                }
            } else {
            details.put("Verified By", "Receptionist");
            }
            
            details.put("Amount", "₹" + examination.getProcedure().getPrice());
            stage.put("details", details);
        }
        
        return stage;
    }

    private Map<String, Object> createProcedureStartedStage(ToothClinicalExamination examination) {
        Map<String, Object> stage = new HashMap<>();
        stage.put("name", ProcedureLifecycleTransition.STAGE_PROCEDURE_STARTED);
        
        boolean procedureStarted = false;
        if (examination.getProcedureStatus() != null) {
            String statusLabel = examination.getProcedureStatus().getLabel();
            procedureStarted = "In Progress".equals(statusLabel) ||
                              "Completed".equals(statusLabel) ||
                              "Follow-Up Scheduled".equals(statusLabel) ||
                              "Closed".equals(statusLabel);
        }
        
        stage.put("completed", procedureStarted);
        stage.put("timestamp", examination.getProcedureStartTime() != null ? 
                   examination.getProcedureStartTime().format(formatter) : null);
        stage.put("description", procedureStarted ? 
            "Procedure started at " + (examination.getProcedureStartTime() != null ? 
                                     examination.getProcedureStartTime().format(formatter) : "") : 
            "Waiting for procedure to start");
        
        if (procedureStarted && examination.getProcedureStartTime() != null) {
            Map<String, String> details = new HashMap<>();
            if (examination.getDoctor() != null) {
                details.put("Started By", "Dr. " + examination.getDoctor().getFirstName() + " " + 
                           examination.getDoctor().getLastName());
                stage.put("transitionedBy", examination.getDoctor().getFirstName() + " " + examination.getDoctor().getLastName());
                stage.put("transitionedByRole", examination.getDoctor().getRole().toString());
            } else {
                details.put("Started By", "Not recorded");
            }
            details.put("Notes", examination.getExaminationNotes() != null && 
                       !examination.getExaminationNotes().isEmpty() ? 
                       "Available" : "None");
            stage.put("details", details);
        }
        
        return stage;
    }

    private Map<String, Object> createProcedureCompletedStage(ToothClinicalExamination examination) {
        Map<String, Object> stage = new HashMap<>();
        stage.put("name", ProcedureLifecycleTransition.STAGE_PROCEDURE_COMPLETED);
        
        boolean procedureCompleted = false;
        if (examination.getProcedureStatus() != null) {
            String statusLabel = examination.getProcedureStatus().getLabel();
            procedureCompleted = "Completed".equals(statusLabel) ||
                                "Follow-Up Scheduled".equals(statusLabel) ||
                                "Closed".equals(statusLabel);
        }
        
        stage.put("completed", procedureCompleted);
        stage.put("timestamp", examination.getProcedureEndTime() != null ? 
                   examination.getProcedureEndTime().format(formatter) : null);
        stage.put("description", procedureCompleted ? 
            "Procedure completed at " + (examination.getProcedureEndTime() != null ? 
                                       examination.getProcedureEndTime().format(formatter) : "") : 
            "Procedure in progress");
        
        if (procedureCompleted && examination.getProcedureEndTime() != null) {
            Map<String, String> details = new HashMap<>();
            if (examination.getProcedureStartTime() != null) {
                long minutes = java.time.Duration.between(
                    examination.getProcedureStartTime(), 
                    examination.getProcedureEndTime()
                ).toMinutes();
                details.put("Duration", minutes + " minutes");
            }
            details.put("Result", "Successful");
            stage.put("details", details);
        }
        
        return stage;
    }

    private Map<String, Object> createFollowUpStage(ToothClinicalExamination examination) {
        Map<String, Object> stage = new HashMap<>();
        stage.put("name", ProcedureLifecycleTransition.STAGE_FOLLOW_UP);
        
        boolean followUpScheduled = false;
        if (examination.getProcedureStatus() != null) {
            String statusLabel = examination.getProcedureStatus().getLabel();
            followUpScheduled = "Follow-Up Scheduled".equals(statusLabel);
        }
        
        stage.put("completed", followUpScheduled);
        stage.put("timestamp", examination.getFollowUpDate() != null ? 
                   examination.getFollowUpDate().format(formatter) : null);
        stage.put("description", followUpScheduled ? 
            "Follow-up scheduled for " + (examination.getFollowUpDate() != null ? 
                                        examination.getFollowUpDate().format(formatter) : "") : 
            "No follow-up scheduled");
        
        if (followUpScheduled && examination.getFollowUpDate() != null) {
            Map<String, String> details = new HashMap<>();
            long daysUntil = java.time.Duration.between(
                LocalDateTime.now(), 
                examination.getFollowUpDate()
            ).toDays();
            
            details.put("Days Until Follow-up", daysUntil + " days");
            details.put("With Doctor", examination.getDoctor() != null ? 
                       "Dr. " + examination.getDoctor().getFirstName() + " " + 
                       examination.getDoctor().getLastName() : "Same doctor");
            details.put("Instructions", "Available");
            stage.put("details", details);
        }
        
        return stage;
    }
} 