package com.example.logindemo.repository;

import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.User;
import com.example.logindemo.model.ProcedureStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
@Component("toothClinicalExaminationRepository")
public interface ToothClinicalExaminationRepository extends JpaRepository<ToothClinicalExamination, Long> {

    List<ToothClinicalExamination> findByPatientIdOrderByExaminationDateDescToothNumberAsc(Long patientId);

    List<ToothClinicalExamination> findByPatientId(Long patientId);

    Page<ToothClinicalExamination> findByPatientId(Long patientId, Pageable pageable);

    List<ToothClinicalExamination> findByTreatmentStartingDateBetween(LocalDateTime startDate, LocalDateTime endDate);

    List<ToothClinicalExamination> findToothClinicalExaminationsByTreatmentStartingDateBetweenAndAssignedDoctor(LocalDateTime startDate, LocalDateTime endDate, User assignedDoctor);

    Optional<ToothClinicalExamination> findFirstByProcedureIdOrderByCreatedAtDesc(Long procedureId);

    List<ToothClinicalExamination> findByProcedureStatus(ProcedureStatus status);
    
    List<ToothClinicalExamination> findByProcedureStatusAndExaminationClinic_ClinicId(ProcedureStatus status, String clinicId);

    List<ToothClinicalExamination> findByPatient_IdAndExaminationClinic_ClinicId(Long patientId, String clinicId);

    Optional<ToothClinicalExamination> findById(Long id);

    List<ToothClinicalExamination> findByExaminationDateBetween(LocalDateTime startDate, LocalDateTime endDate);

    Long countByExaminationDateBetween(LocalDateTime startDate, LocalDateTime endDate);

    List<ToothClinicalExamination> findTop10ByOrderByExaminationDateDesc();

    List<ToothClinicalExamination> findByExaminationDateBetweenAndProcedureStatusAndExaminationClinic_ClinicId(
        LocalDateTime startDate, LocalDateTime endDate, ProcedureStatus status, String clinicId);

    // Find examinations created today with PAYMENT_PENDING status for a specific clinic
    List<ToothClinicalExamination> findByCreatedAtBetweenAndProcedureStatusAndExaminationClinic_ClinicId(
        LocalDateTime startDate, LocalDateTime endDate, ProcedureStatus status, String clinicId);

    // Find examinations with either createdAt or examinationDate today, with PAYMENT_PENDING status for a specific clinic
    @Query("SELECT DISTINCT t FROM ToothClinicalExamination t WHERE t.procedureStatus = :status " +
           "AND t.examinationClinic.clinicId = :clinicId " +
           "AND ((t.createdAt BETWEEN :startDate AND :endDate) OR (t.examinationDate BETWEEN :startDate AND :endDate) OR (t.updatedAt BETWEEN :startDate AND :endDate))")
    List<ToothClinicalExamination> findTodayPendingExaminationsByCreatedOrExamDate(
        LocalDateTime startDate, LocalDateTime endDate, ProcedureStatus status, String clinicId);

    // Find by assigned doctor, date range, and at least one payment entry
    List<ToothClinicalExamination> findByAssignedDoctorAndExaminationDateBetween(User assignedDoctor, LocalDateTime from, LocalDateTime to);

    // Find patient by examination ID
    Optional<ToothClinicalExamination> findByIdAndPatientIsNotNull(Long id);

    // Pageable queries for assigned cases
    Page<ToothClinicalExamination> findByAssignedDoctor(User assignedDoctor, Pageable pageable);
    Page<ToothClinicalExamination> findByAssignedDoctorAndProcedureStatus(User assignedDoctor, ProcedureStatus status, Pageable pageable);
    Page<ToothClinicalExamination> findByAssignedDoctorAndExaminationDateBetween(User assignedDoctor, LocalDateTime from, LocalDateTime to, Pageable pageable);
    Page<ToothClinicalExamination> findByAssignedDoctorAndProcedureStatusAndExaminationDateBetween(User assignedDoctor, ProcedureStatus status, LocalDateTime from, LocalDateTime to, Pageable pageable);

    // Pageable queries using treatmentStartingDate for scheduled filters
    Page<ToothClinicalExamination> findByAssignedDoctorAndTreatmentStartingDateBetween(User assignedDoctor, LocalDateTime from, LocalDateTime to, Pageable pageable);
    Page<ToothClinicalExamination> findByAssignedDoctorAndProcedureStatusAndTreatmentStartingDateBetween(User assignedDoctor, ProcedureStatus status, LocalDateTime from, LocalDateTime to, Pageable pageable);
}
