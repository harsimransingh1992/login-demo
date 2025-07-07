package com.example.logindemo.service;

import com.example.logindemo.model.ProcedureLifecycleTransition;
import com.example.logindemo.model.ToothClinicalExamination;
import java.util.List;
import java.util.Map;

public interface ProcedureLifecycleService {
    ProcedureLifecycleTransition recordTransition(
        ToothClinicalExamination examination,
        String stageName,
        String stageDescription,
        boolean completed,
        Map<String, String> stageDetails
    );
    
    List<ProcedureLifecycleTransition> getExaminationLifecycle(ToothClinicalExamination examination);
    
    List<Map<String, Object>> getFormattedLifecycleStages(ToothClinicalExamination examination);
} 