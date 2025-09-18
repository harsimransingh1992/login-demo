package com.example.logindemo.controller;

import com.example.logindemo.dto.ClinicalFileDTO;
import com.example.logindemo.model.ClinicalFileStatus;
import com.example.logindemo.service.ClinicalFileService;
import com.example.logindemo.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/clinical-files")
@Slf4j
@PreAuthorize("hasRole('OPD_DOCTOR')")
public class ClinicalFileController {

    @Autowired
    private ClinicalFileService clinicalFileService;
    
    @Autowired
    private UserService userService;

    /**
     * Show list of clinical files for the current clinic.
     */
    @GetMapping
    public String listClinicalFiles(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String status,
            Model model) {
        
        try {
            List<ClinicalFileDTO> files;
            
            if (status != null && !status.isEmpty()) {
                ClinicalFileStatus fileStatus = ClinicalFileStatus.valueOf(status.toUpperCase());
                files = clinicalFileService.getClinicalFilesByStatus(fileStatus);
            } else {
                            // Get files for current clinic
            String currentClinicId = getCurrentUserClinicIdString();
            files = clinicalFileService.getClinicalFilesByClinicId(currentClinicId);
            }
            
            model.addAttribute("clinicalFiles", files);
            model.addAttribute("statuses", ClinicalFileStatus.values());
            model.addAttribute("currentStatus", status);
            
            return "clinical-files/list";
        } catch (Exception e) {
            log.error("Error loading clinical files", e);
            model.addAttribute("error", "Error loading clinical files: " + e.getMessage());
            return "clinical-files/list";
        }
    }

    /**
     * Show clinical file details.
     */
    @GetMapping("/{id}")
    public String showClinicalFile(@PathVariable Long id, Model model) {
        try {
            ClinicalFileDTO clinicalFile = clinicalFileService.getClinicalFileById(id)
                .orElseThrow(() -> new RuntimeException("Clinical file not found"));
            
            model.addAttribute("clinicalFile", clinicalFile);
            return "clinical-files/details";
        } catch (Exception e) {
            log.error("Error loading clinical file", e);
            model.addAttribute("error", "Error loading clinical file: " + e.getMessage());
            return "redirect:/clinical-files";
        }
    }

    /**
     * Show form to create new clinical file.
     */
    @GetMapping("/create")
    public String showCreateForm(@RequestParam(required = false) Long patientId, Model model) {
        try {
            ClinicalFileDTO clinicalFile = new ClinicalFileDTO();
            if (patientId != null) {
                clinicalFile.setPatientId(patientId);
            }
            
            model.addAttribute("clinicalFile", clinicalFile);
            model.addAttribute("statuses", ClinicalFileStatus.values());
            
            return "clinical-files/create";
        } catch (Exception e) {
            log.error("Error loading create form", e);
            model.addAttribute("error", "Error loading create form: " + e.getMessage());
            return "redirect:/clinical-files";
        }
    }

    /**
     * Create new clinical file.
     */
    @PostMapping("/create")
    public String createClinicalFile(@ModelAttribute ClinicalFileDTO clinicalFileDTO, Model model) {
        try {
            ClinicalFileDTO createdFile = clinicalFileService.createClinicalFile(clinicalFileDTO);
            return "redirect:/clinical-files/" + createdFile.getId();
        } catch (Exception e) {
            log.error("Error creating clinical file", e);
            model.addAttribute("error", "Error creating clinical file: " + e.getMessage());
            model.addAttribute("clinicalFile", clinicalFileDTO);
            model.addAttribute("statuses", ClinicalFileStatus.values());
            return "clinical-files/create";
        }
    }

    /**
     * Show form to edit clinical file.
     */
    @GetMapping("/{id}/edit")
    public String showEditForm(@PathVariable Long id, Model model) {
        try {
            ClinicalFileDTO clinicalFile = clinicalFileService.getClinicalFileById(id)
                .orElseThrow(() -> new RuntimeException("Clinical file not found"));
            
            model.addAttribute("clinicalFile", clinicalFile);
            model.addAttribute("statuses", ClinicalFileStatus.values());
            
            return "clinical-files/edit";
        } catch (Exception e) {
            log.error("Error loading edit form", e);
            model.addAttribute("error", "Error loading edit form: " + e.getMessage());
            return "redirect:/clinical-files/" + id;
        }
    }

    /**
     * Update clinical file.
     */
    @PostMapping("/{id}/edit")
    public String updateClinicalFile(@PathVariable Long id, @ModelAttribute ClinicalFileDTO clinicalFileDTO, Model model) {
        try {
            ClinicalFileDTO updatedFile = clinicalFileService.updateClinicalFile(id, clinicalFileDTO);
            return "redirect:/clinical-files/" + updatedFile.getId();
        } catch (Exception e) {
            log.error("Error updating clinical file", e);
            model.addAttribute("error", "Error updating clinical file: " + e.getMessage());
            model.addAttribute("clinicalFile", clinicalFileDTO);
            model.addAttribute("statuses", ClinicalFileStatus.values());
            return "clinical-files/edit";
        }
    }

    /**
     * Close clinical file.
     */
    @PostMapping("/{id}/close")
    @ResponseBody
    public ResponseEntity<?> closeClinicalFile(@PathVariable Long id) {
        try {
            ClinicalFileDTO closedFile = clinicalFileService.closeClinicalFile(id);
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Clinical file closed successfully",
                "file", closedFile
            ));
        } catch (Exception e) {
            log.error("Error closing clinical file", e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }

    /**
     * Reopen clinical file.
     */
    @PostMapping("/{id}/reopen")
    @ResponseBody
    public ResponseEntity<?> reopenClinicalFile(@PathVariable Long id) {
        try {
            ClinicalFileDTO reopenedFile = clinicalFileService.reopenClinicalFile(id);
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Clinical file reopened successfully",
                "file", reopenedFile
            ));
        } catch (Exception e) {
            log.error("Error reopening clinical file", e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }

    /**
     * Add examination to clinical file.
     */
    @PostMapping("/{fileId}/examinations/{examinationId}/add")
    @ResponseBody
    public ResponseEntity<?> addExaminationToFile(@PathVariable Long fileId, @PathVariable Long examinationId) {
        try {
            ClinicalFileDTO updatedFile = clinicalFileService.addExaminationToFile(fileId, examinationId);
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Examination added to clinical file successfully",
                "file", updatedFile
            ));
        } catch (Exception e) {
            log.error("Error adding examination to clinical file", e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }

    /**
     * Remove examination from clinical file.
     */
    @PostMapping("/{fileId}/examinations/{examinationId}/remove")
    @ResponseBody
    public ResponseEntity<?> removeExaminationFromFile(@PathVariable Long fileId, @PathVariable Long examinationId) {
        try {
            ClinicalFileDTO updatedFile = clinicalFileService.removeExaminationFromFile(fileId, examinationId);
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Examination removed from clinical file successfully",
                "file", updatedFile
            ));
        } catch (Exception e) {
            log.error("Error removing examination from clinical file", e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }

    /**
     * Get clinical files by patient ID (API endpoint).
     */
    @GetMapping("/patient/{patientId}")
    @ResponseBody
    public ResponseEntity<?> getClinicalFilesByPatient(@PathVariable Long patientId) {
        try {
            List<ClinicalFileDTO> files = clinicalFileService.getClinicalFilesByPatientId(patientId);
            return ResponseEntity.ok(Map.of(
                "success", true,
                "files", files
            ));
        } catch (Exception e) {
            log.error("Error getting clinical files for patient", e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }

    /**
     * Get clinical files with pending payments.
     */
    @GetMapping("/pending-payments")
    @ResponseBody
    public ResponseEntity<?> getFilesWithPendingPayments() {
        try {
            String currentClinicId = getCurrentUserClinicIdString();
            List<ClinicalFileDTO> files = clinicalFileService.getActiveFilesWithPendingPayments(currentClinicId);
            return ResponseEntity.ok(Map.of(
                "success", true,
                "files", files
            ));
        } catch (Exception e) {
            log.error("Error getting files with pending payments", e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }

    /**
     * Get clinical files ready to close.
     */
    @GetMapping("/ready-to-close")
    @ResponseBody
    public ResponseEntity<?> getFilesReadyToClose() {
        try {
            String currentClinicId = getCurrentUserClinicIdString();
            List<ClinicalFileDTO> files = clinicalFileService.getFilesReadyToClose(currentClinicId);
            return ResponseEntity.ok(Map.of(
                "success", true,
                "files", files
            ));
        } catch (Exception e) {
            log.error("Error getting files ready to close", e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }

    /**
     * Create clinical file with selected examinations.
     */
    @PostMapping("/create-with-examinations")
    @ResponseBody
    public ResponseEntity<?> createClinicalFileWithExaminations(@RequestBody Map<String, Object> request) {
        try {
            String title = (String) request.get("title");
            String status = (String) request.get("status");
            String notes = (String) request.get("notes");
            Long patientId = Long.valueOf(request.get("patientId").toString());
            @SuppressWarnings("unchecked")
            List<String> examinationIds = (List<String>) request.get("examinationIds");
            
            // Create the clinical file
            ClinicalFileDTO clinicalFileDTO = new ClinicalFileDTO();
            clinicalFileDTO.setTitle(title);
            clinicalFileDTO.setStatus(ClinicalFileStatus.valueOf(status));
            clinicalFileDTO.setNotes(notes);
            clinicalFileDTO.setPatientId(patientId);
            clinicalFileDTO.setClinicId(getCurrentUserClinicId());
            
            ClinicalFileDTO createdFile = clinicalFileService.createClinicalFile(clinicalFileDTO);
            
            // Add selected examinations to the file
            for (String examId : examinationIds) {
                clinicalFileService.addExaminationToFile(createdFile.getId(), Long.valueOf(examId));
            }
            
            // Get the updated file with examinations
            ClinicalFileDTO updatedFile = clinicalFileService.getClinicalFileById(createdFile.getId())
                .orElse(createdFile);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Clinical file created successfully with " + examinationIds.size() + " examinations",
                "file", updatedFile
            ));
        } catch (Exception e) {
            log.error("Error creating clinical file with examinations", e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }
    
    /**
     * Helper method to get current user's clinic ID as Long (for ClinicalFileDTO)
     */
    private Long getCurrentUserClinicId() {
        try {
            String currentUsername = org.springframework.security.core.context.SecurityContextHolder.getContext()
                .getAuthentication().getName();
            return userService.getUserByUsername(currentUsername)
                .map(user -> user.getClinic() != null ? user.getClinic().getId() : 1L)
                .orElse(1L);
        } catch (Exception e) {
            log.warn("Could not get current user's clinic, using default: {}", e.getMessage());
            return 1L;
        }
    }

    /**
     * Helper method to get current user's clinic ID as String (for service methods)
     */
    private String getCurrentUserClinicIdString() {
        try {
            String currentUsername = org.springframework.security.core.context.SecurityContextHolder.getContext()
                .getAuthentication().getName();
            return userService.getUserByUsername(currentUsername)
                .map(user -> user.getClinic() != null ? user.getClinic().getClinicId() : "CLINIC001")
                .orElse("CLINIC001");
        } catch (Exception e) {
            log.warn("Could not get current user's clinic, using default: {}", e.getMessage());
            return "CLINIC001";
        }
    }
}
