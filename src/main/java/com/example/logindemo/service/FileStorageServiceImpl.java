package com.example.logindemo.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service("fileStorageService")
@Slf4j
public class FileStorageServiceImpl implements FileStorageService {

    @Value("${file.upload-dir:uploads}")
    private String uploadDir;
    
    @PostConstruct
    public void init() {
        try {
            Files.createDirectories(Paths.get(uploadDir));
            log.info("Created upload directory: {}", uploadDir);
            
            // Create subdirectories
            Files.createDirectories(Paths.get(uploadDir, "profiles"));
            log.info("Created profiles directory: {}", Paths.get(uploadDir, "profiles"));
            
            Files.createDirectories(Paths.get(uploadDir, "denture-pictures"));
            log.info("Created denture-pictures directory: {}", Paths.get(uploadDir, "denture-pictures"));
            
            Files.createDirectories(Paths.get(uploadDir, "xray-pictures"));
            log.info("Created xray-pictures directory: {}", Paths.get(uploadDir, "xray-pictures"));
        } catch (IOException e) {
            log.error("Could not create upload directories", e);
            throw new RuntimeException("Could not create upload directories", e);
        }
    }
    
    @Override
    public String storeFile(MultipartFile file, String directory) throws IOException {
        if (file.isEmpty()) {
            throw new IOException("Failed to store empty file");
        }
        
        // Create directory path
        String targetDir = directory != null ? uploadDir + File.separator + directory : uploadDir;
        Files.createDirectories(Paths.get(targetDir));
        
        // Generate a unique file name to avoid collisions
        String originalFileName = file.getOriginalFilename();
        String extension = "";
        if (originalFileName != null && originalFileName.contains(".")) {
            extension = originalFileName.substring(originalFileName.lastIndexOf("."));
        }
        String fileName = UUID.randomUUID().toString() + extension;
        
        // Store the file
        Path targetPath = Paths.get(targetDir, fileName);
        Files.copy(file.getInputStream(), targetPath, StandardCopyOption.REPLACE_EXISTING);
        
        // Return the relative path
        String relativePath = directory != null ? 
            directory + File.separator + fileName : fileName;
        
        log.info("Stored file at: {}", targetPath);
        return relativePath;
    }
    
    @Override
    public boolean deleteFile(String filePath) {
        try {
            Path path = Paths.get(uploadDir, filePath);
            return Files.deleteIfExists(path);
        } catch (IOException e) {
            log.error("Error deleting file: {}", filePath, e);
            return false;
        }
    }
    
    @Override
    public String getAbsoluteFilePath(String relativePath) {
        return Paths.get(uploadDir, relativePath).toString();
    }
} 