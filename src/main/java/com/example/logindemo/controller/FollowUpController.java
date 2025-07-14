package com.example.logindemo.controller;

import com.example.logindemo.model.FollowUpRecord;
import com.example.logindemo.service.FollowUpService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Dedicated controller for follow-up actions to avoid regression issues
 */
@Controller
@RequestMapping("/follow-up")
@Slf4j
public class FollowUpController {

    @Autowired
    private FollowUpService followUpService;

    /**
     * Mark a follow-up as completed
     */
    @PostMapping("/complete")
    public String completeFollowUp(
            @RequestParam Long followUpId,
            @RequestParam Long examinationId,
            @RequestParam(required = false) String clinicalNotes,
            RedirectAttributes redirectAttributes) {
        
        try {
            log.info("Completing follow-up ID: {} for examination ID: {}", followUpId, examinationId);
            
            // Validate clinical notes
            if (clinicalNotes == null || clinicalNotes.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Clinical notes are required to complete a follow-up.");
                return "redirect:/patients/examination/" + examinationId + "/lifecycle";
            }
            
            // Complete the follow-up
            FollowUpRecord followUpRecord = followUpService.completeFollowUp(followUpId, clinicalNotes);
            
            redirectAttributes.addFlashAttribute("success", "Follow-up marked as completed successfully!");
            log.info("Successfully completed follow-up ID: {}", followUpId);
            
        } catch (Exception e) {
            log.error("Error completing follow-up ID {}: {}", followUpId, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error", "Error completing follow-up: " + e.getMessage());
        }
        
        return "redirect:/patients/examination/" + examinationId + "/lifecycle";
    }

    /**
     * Reschedule a follow-up
     */
    @PostMapping("/reschedule")
    public String rescheduleFollowUp(
            @RequestParam Long followUpId,
            @RequestParam Long examinationId,
            @RequestParam String newDate,
            @RequestParam String newTime,
            @RequestParam(required = false) String rescheduleNotes,
            @RequestParam(required = false) Long doctorId,
            RedirectAttributes redirectAttributes) {
        
        try {
            log.info("Rescheduling follow-up ID: {} for examination ID: {} to {} {}", 
                    followUpId, examinationId, newDate, newTime);
            
            // Parse date and time
            LocalDate date = LocalDate.parse(newDate);
            LocalDateTime newScheduledDate = date.atTime(
                Integer.parseInt(newTime.split(":")[0]), 
                Integer.parseInt(newTime.split(":")[1])
            );
            
            // Reschedule the follow-up
            followUpService.rescheduleFollowUp(followUpId, newScheduledDate, rescheduleNotes, doctorId);
            
            redirectAttributes.addFlashAttribute("success", "Follow-up rescheduled successfully!");
            log.info("Successfully rescheduled follow-up ID: {} to {}", followUpId, newScheduledDate);
            
        } catch (Exception e) {
            log.error("Error rescheduling follow-up ID {}: {}", followUpId, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error", "Error rescheduling follow-up: " + e.getMessage());
        }
        
        return "redirect:/patients/examination/" + examinationId + "/lifecycle";
    }

    /**
     * Cancel a follow-up
     */
    @PostMapping("/cancel")
    public String cancelFollowUp(
            @RequestParam Long followUpId,
            @RequestParam Long examinationId,
            @RequestParam(required = false) String reason,
            RedirectAttributes redirectAttributes) {
        
        try {
            log.info("Cancelling follow-up ID: {} for examination ID: {}", followUpId, examinationId);
            
            // Validate reason
            if (reason == null || reason.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Reason is required to cancel a follow-up.");
                return "redirect:/patients/examination/" + examinationId + "/lifecycle";
            }
            
            // Cancel the follow-up
            FollowUpRecord followUpRecord = followUpService.cancelFollowUp(followUpId, reason);
            
            redirectAttributes.addFlashAttribute("success", "Follow-up cancelled successfully!");
            log.info("Successfully cancelled follow-up ID: {}", followUpId);
            
        } catch (Exception e) {
            log.error("Error cancelling follow-up ID {}: {}", followUpId, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error", "Error cancelling follow-up: " + e.getMessage());
        }
        
        return "redirect:/patients/examination/" + examinationId + "/lifecycle";
    }
} 