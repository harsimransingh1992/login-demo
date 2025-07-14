package com.example.logindemo.repository;

import com.example.logindemo.model.ProcedureLifecycleTransition;
import com.example.logindemo.model.ToothClinicalExamination;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ProcedureLifecycleTransitionRepository extends JpaRepository<ProcedureLifecycleTransition, Long> {
    List<ProcedureLifecycleTransition> findByExaminationOrderByTransitionTimeAsc(ToothClinicalExamination examination);
    List<ProcedureLifecycleTransition> findByExaminationAndCompletedOrderByTransitionTimeAsc(ToothClinicalExamination examination, boolean completed);
} 