package com.example.logindemo.service.report;

import java.time.LocalDateTime;
import java.util.Map;

/**
 * Base interface for all report generators.
 * Each report implementation should be a Spring bean that implements this interface.
 */
public interface ReportGenerator {
    
    /**
     * Generate the report content
     * @param parameters Optional parameters for report generation
     * @return Generated report content (HTML, CSV, etc.)
     */
    String generateReport(Map<String, Object> parameters);
    
    /**
     * Get the report name/title
     * @return Human-readable report name
     */
    String getReportName();
    
    /**
     * Get the report description
     * @return Description of what this report contains
     */
    String getReportDescription();
    
    /**
     * Get supported output formats
     * @return Array of supported formats (HTML, PDF, CSV, etc.)
     */
    String[] getSupportedFormats();
    
    /**
     * Validate parameters before report generation
     * @param parameters Parameters to validate
     * @return true if parameters are valid, false otherwise
     */
    default boolean validateParameters(Map<String, Object> parameters) {
        return true;
    }
    
    /**
     * Get default parameters for this report
     * @return Map of default parameter values
     */
    default Map<String, Object> getDefaultParameters() {
        return Map.of();
    }
    
    /**
     * Check if this report supports scheduled execution
     * @return true if can be scheduled, false otherwise
     */
    default boolean supportsScheduling() {
        return true;
    }
}