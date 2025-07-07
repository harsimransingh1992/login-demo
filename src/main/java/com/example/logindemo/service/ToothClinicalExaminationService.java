package com.example.logindemo.service;

import com.example.logindemo.dto.ProcedurePriceDTO;
import com.example.logindemo.dto.ToothClinicalExaminationDTO;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.ProcedureStatus;
import com.example.logindemo.model.PaymentMode;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface ToothClinicalExaminationService {
    List<ToothClinicalExaminationDTO> getExaminationsByPatientId(Long patientId);
    Optional<ToothClinicalExaminationDTO> getExaminationById(Long id);
    ToothClinicalExaminationDTO saveExamination(ToothClinicalExaminationDTO examinationDTO);
    ToothClinicalExamination saveExamination(ToothClinicalExamination examination);
    void deleteExamination(Long id);
    List<ProcedurePriceDTO> getProceduresByExaminationId(Long examinationId);
    void updateProcedureStatus(Long examinationId, ProcedureStatus status);
    ToothClinicalExaminationDTO updateTreatmentDate(Long examinationId, String treatmentStartDate);
    ToothClinicalExaminationDTO assignDoctor(Long examinationId, Long doctorId);

    List<ToothClinicalExaminationDTO> getToothClinicalExaminationForPatientId(Long patientId);
    
    /**
     * Get tooth clinical examination by ID
     * @param id the examination ID
     * @return the ToothClinicalExaminationDTO or null if not found
     */
    ToothClinicalExaminationDTO getToothClinicalExaminationById(Long id);

    List<ToothClinicalExaminationDTO> getTodayAppointments();
    
    /**
     * Associate procedures with an examination
     * @param examinationId the examination ID
     * @param procedureIds list of procedure IDs to associate
     */
    void associateProceduresWithExamination(Long examinationId, List<Long> procedureIds);
    
    /**
     * Get procedures associated with an examination
     * @param examinationId the examination ID
     * @return list of procedures associated with the examination
     */
    List<ProcedurePriceDTO> getProceduresForExamination(Long examinationId);
    
    /**
     * Check if a procedure is already associated with an examination
     * @param examinationId the examination ID
     * @param procedureId the procedure ID to check
     * @return true if the procedure is already associated with the examination, false otherwise
     */
    boolean isProcedureAlreadyAssociated(Long examinationId, Long procedureId);
    
    /**
     * Check which procedures from a list are already associated with an examination
     * @param examinationId the examination ID
     * @param procedureIds list of procedure IDs to check
     * @return list of procedure IDs that are already associated with the examination
     */
    List<Long> findAlreadyAssociatedProcedures(Long examinationId, List<Long> procedureIds);
    
    /**
     * Remove a procedure from an examination
     * @param examinationId the examination ID
     * @param procedureId the procedure ID to remove
     */
    void removeProcedureFromExamination(Long examinationId, Long procedureId);

    ToothClinicalExaminationDTO updateExamination(ToothClinicalExaminationDTO examinationDTO);

    List<ToothClinicalExamination> findByProcedureStatus(ProcedureStatus status);
    
    /**
     * Find examinations by procedure status and examination clinic ID
     * @param status the procedure status to filter by
     * @param clinicId the examination clinic ID to filter by
     * @return list of examinations matching the criteria
     */
    List<ToothClinicalExamination> findByProcedureStatusAndExaminationClinic_ClinicId(ProcedureStatus status, String clinicId);

    /**
     * Find examinations by patient and examination clinic ID
     * @param patientId the patient ID to filter by
     * @param clinicId the examination clinic ID to filter by
     * @return list of examinations matching the criteria
     */
    List<ToothClinicalExamination> findByPatient_IdAndExaminationClinic_ClinicId(Long patientId, String clinicId);

    Optional<ToothClinicalExamination> findExaminationByProcedureId(Long procedureId);

    Double getHistoricalPrice(Long procedureId, LocalDateTime date);

    ToothClinicalExaminationDTO getExaminationDetails(Long id);

    @Transactional
    void collectPayment(Long examinationId, PaymentMode paymentMode, String notes, Map<String, String> paymentDetails);

    List<ToothClinicalExaminationDTO> getAllToothClinicalExaminations();

    /**
     * Find today's pending examinations for a specific clinic
     * @param clinicId the examination clinic ID to filter by
     * @return list of examinations with examinationDate today and procedureStatus PAYMENT_PENDING
     */
    List<ToothClinicalExamination> findTodayPendingExaminations(String clinicId);

    /**
     * Find examinations by assigned doctor, date range, and with at least one payment entry
     */
    List<ToothClinicalExamination> findByDoctorAndDateWithPayments(com.example.logindemo.model.User doctor, java.time.LocalDateTime from, java.time.LocalDateTime to);
}
