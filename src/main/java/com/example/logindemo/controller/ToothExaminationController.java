package com.example.logindemo.controller;

import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.service.ToothExaminationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.Map;

@RestController
@RequestMapping("/patients/tooth-examination")
public class ToothExaminationController {

    @Autowired
    private ToothExaminationService toothExaminationService;

    @PostMapping("/update-treatment-date")
    @ResponseBody
    public ResponseEntity<?> updateTreatmentDate(@RequestBody Map<String, Object> request) {
        try {
            Long examinationId = Long.parseLong(request.get("examinationId").toString());
            String treatmentStartDate = (String) request.get("treatmentStartDate");
            
            toothExaminationService.updateTreatmentDate(examinationId, treatmentStartDate);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Treatment start date updated successfully"
            ));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Failed to update treatment date: " + e.getMessage()
            ));
        }
    }
} 