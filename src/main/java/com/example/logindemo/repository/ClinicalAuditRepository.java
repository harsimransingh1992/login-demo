package com.example.logindemo.repository;

import com.example.logindemo.model.ClinicalAudit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository for ClinicalAudit entity
 */
@Repository
public interface ClinicalAuditRepository extends JpaRepository<ClinicalAudit, Long> {
    
    /**
     * Find all audits for a specific clinical file
     */
    List<ClinicalAudit> findByClinicalFileIdOrderByAuditDateDesc(Long clinicalFileId);
    
    /**
     * Find all audits for a specific examination
     */
    List<ClinicalAudit> findByExaminationIdOrderByAuditDateDesc(Long examinationId);
    
    /**
     * Find all audits by a specific auditor
     */
    List<ClinicalAudit> findByAuditorIdOrderByAuditDateDesc(Long auditorId);
    
    /**
     * Find audits by status
     */
    List<ClinicalAudit> findByAuditStatusOrderByAuditDateDesc(ClinicalAudit.AuditStatus status);
    
    /**
     * Find the latest audit for a clinical file
     */
    @Query("SELECT ca FROM ClinicalAudit ca WHERE ca.clinicalFile.id = :clinicalFileId ORDER BY ca.auditDate DESC")
    List<ClinicalAudit> findLatestAuditByClinicalFileId(@Param("clinicalFileId") Long clinicalFileId);
    
    /**
     * Find audits by audit type
     */
    List<ClinicalAudit> findByAuditTypeOrderByAuditDateDesc(ClinicalAudit.AuditType auditType);
    
    /**
     * Find audits by quality rating
     */
    List<ClinicalAudit> findByQualityRatingOrderByAuditDateDesc(ClinicalAudit.QualityRating qualityRating);
}
