package com.example.logindemo.service.report;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Service for executing reports using Spring bean references
 * This replaces the hardcoded report type approach with a flexible bean-based system
 */
@Service
public class ReportExecutionService {
    
    private static final Logger log = LoggerFactory.getLogger(ReportExecutionService.class);
    
    @Autowired
    private ApplicationContext applicationContext;
    
    /**
     * Execute a report by Spring bean name
     * @param beanName The Spring bean name of the report generator
     * @param parameters Optional parameters for report generation
     * @return Generated report content
     */
    public String executeReport(String beanName, Map<String, Object> parameters) {
        try {
            log.info("Executing report with bean name: {}", beanName);
            
            // Get the report generator bean
            ReportGenerator reportGenerator = getReportGenerator(beanName);
            if (reportGenerator == null) {
                throw new IllegalArgumentException("Report generator bean not found: " + beanName);
            }
            
            // Validate parameters
            if (!reportGenerator.validateParameters(parameters)) {
                throw new IllegalArgumentException("Invalid parameters for report: " + beanName);
            }
            
            // Generate the report
            String reportContent = reportGenerator.generateReport(parameters);
            
            log.info("Successfully executed report: {} ({})", reportGenerator.getReportName(), beanName);
            return reportContent;
            
        } catch (Exception e) {
            log.error("Error executing report with bean name {}: {}", beanName, e.getMessage(), e);
            throw new RuntimeException("Failed to execute report: " + e.getMessage(), e);
        }
    }
    
    /**
     * Get a report generator by bean name
     * @param beanName The Spring bean name
     * @return ReportGenerator instance or null if not found
     */
    public ReportGenerator getReportGenerator(String beanName) {
        try {
            Object bean = applicationContext.getBean(beanName);
            if (bean instanceof ReportGenerator) {
                return (ReportGenerator) bean;
            } else {
                log.warn("Bean {} is not a ReportGenerator instance", beanName);
                return null;
            }
        } catch (Exception e) {
            log.warn("Bean {} not found or error retrieving: {}", beanName, e.getMessage());
            return null;
        }
    }
    
    /**
     * Get all available report generators
     * @return List of all ReportGenerator beans
     */
    public List<ReportGenerator> getAllReportGenerators() {
        Map<String, ReportGenerator> reportBeans = applicationContext.getBeansOfType(ReportGenerator.class);
        return reportBeans.values().stream().collect(Collectors.toList());
    }
    
    /**
     * Get all available report generator bean names
     * @return List of bean names that implement ReportGenerator
     */
    public List<String> getAllReportGeneratorBeanNames() {
        Map<String, ReportGenerator> reportBeans = applicationContext.getBeansOfType(ReportGenerator.class);
        return reportBeans.keySet().stream().sorted().collect(Collectors.toList());
    }
    
    /**
     * Get report information by bean name
     * @param beanName The Spring bean name
     * @return Map containing report information (name, description, formats, etc.)
     */
    public Map<String, Object> getReportInfo(String beanName) {
        ReportGenerator generator = getReportGenerator(beanName);
        if (generator == null) {
            return null;
        }
        
        return Map.of(
            "beanName", beanName,
            "name", generator.getReportName(),
            "description", generator.getReportDescription(),
            "supportedFormats", generator.getSupportedFormats(),
            "supportsScheduling", generator.supportsScheduling(),
            "defaultParameters", generator.getDefaultParameters()
        );
    }
    
    /**
     * Check if a report generator bean exists
     * @param beanName The Spring bean name to check
     * @return true if the bean exists and implements ReportGenerator
     */
    public boolean reportGeneratorExists(String beanName) {
        return getReportGenerator(beanName) != null;
    }
    
    /**
     * Execute report with default parameters
     * @param beanName The Spring bean name of the report generator
     * @return Generated report content
     */
    public String executeReportWithDefaults(String beanName) {
        ReportGenerator generator = getReportGenerator(beanName);
        if (generator == null) {
            throw new IllegalArgumentException("Report generator bean not found: " + beanName);
        }
        
        return executeReport(beanName, generator.getDefaultParameters());
    }
}