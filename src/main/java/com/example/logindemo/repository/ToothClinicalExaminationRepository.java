package com.example.logindemo.repository;

import com.example.logindemo.model.DoctorDetail;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.service.DoctorDetailService;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
@Component("toothClinicalExaminationRepository")
public interface ToothClinicalExaminationRepository extends JpaRepository<ToothClinicalExamination,Long> {

    List<ToothClinicalExamination> findByPatientIdOrderByExaminationDateDescToothNumberAsc(Long patientId);

    ToothClinicalExamination getToothClinicalExaminationById(Long id);

    List<ToothClinicalExamination> findByPatientId(Long patientId);

    List<ToothClinicalExamination> findByTreatmentStartingDateBetween(LocalDateTime startDate, LocalDateTime endDate);

    List<ToothClinicalExamination> findToothClinicalExaminationsByTreatmentStartingDateBetweenAndAssignedDoctor(LocalDateTime startDate, LocalDateTime endDate, DoctorDetail doctorDetail);
}
