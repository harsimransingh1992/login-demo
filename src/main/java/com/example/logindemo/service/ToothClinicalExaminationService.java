package com.example.logindemo.service;

import com.example.logindemo.dto.ProcedurePriceDTO;
import com.example.logindemo.dto.ToothClinicalExaminationDTO;

import java.util.List;

public interface ToothClinicalExaminationService {
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
}
