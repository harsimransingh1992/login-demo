package com.example.logindemo.service;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

/**
 * Service for handling file storage operations
 */
public interface FileStorageService {
    
    /**
     * Store a file in the configured storage location
     * 
     * @param file The file to store
     * @param directory Optional subdirectory to store the file in (e.g., "profiles")
     * @return The path where the file was stored, relative to the application context
     * @throws IOException If an I/O error occurs
     */
    String storeFile(MultipartFile file, String directory) throws IOException;
    
    /**
     * Delete a file from storage
     * 
     * @param filePath The path of the file to delete
     * @return true if the file was successfully deleted, false otherwise
     */
    boolean deleteFile(String filePath);
    
    /**
     * Get the absolute file path for a given relative path
     * 
     * @param relativePath The relative path of the file
     * @return The absolute file path
     */
    String getAbsoluteFilePath(String relativePath);
} 