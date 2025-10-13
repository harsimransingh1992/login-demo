package com.example.logindemo.repository;

import com.example.logindemo.model.ProcedureLifecycleTransition;
import com.example.logindemo.model.ToothClinicalExamination;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ProcedureLifecycleTransitionRepository extends JpaRepository<ProcedureLifecycleTransition, Long> {
    List<ProcedureLifecycleTransition> findByExaminationOrderByTransitionTimeAsc(ToothClinicalExamination examination);
    List<ProcedureLifecycleTransition> findByExaminationAndCompletedOrderByTransitionTimeAsc(ToothClinicalExamination examination, boolean completed);
    
    // Purge helpers
    @Modifying(clearAutomatically = true)
    void deleteByExamination(ToothClinicalExamination examination);
    
    @Modifying(clearAutomatically = true)
    void deleteByExamination_Id(Long examinationId);
    
    @Modifying(clearAutomatically = true)
    void deleteByExaminationIn(List<ToothClinicalExamination> examinations);

    // Bulk delete all transitions for all examinations of a patient
    @Modifying(clearAutomatically = true)
    void deleteByExamination_Patient_Id(Long patientId);
}