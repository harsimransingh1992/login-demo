package com.example.logindemo.repository;

import com.example.logindemo.model.MediaFile;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface MediaFileRepository extends JpaRepository<MediaFile, Long> {
    List<MediaFile> findByExaminationIdAndFileType(Long examinationId, String fileType);
    List<MediaFile> findByExamination_Id(Long examinationId);
} 