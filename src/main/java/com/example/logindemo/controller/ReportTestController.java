package com.example.logindemo.controller;

import com.example.logindemo.service.report.ReportExecutionService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Test controller for the new bean-based reporting system
 * This controller provides endpoints to test and demonstrate the flexibility
 * of the new reporting architecture
 */
@RestController
@RequestMapping("/api/reports/test")
public class ReportTestController {
    
    private static final Logger log = LoggerFactory.getLogger(ReportTestController.class);
    
    @Autowired
    private ReportExecutionService reportExecutionService;
    
    /**
     * Get all available report generators
     */
    @GetMapping("/generators")
    public ResponseEntity<Map<String, Object>> getAllReportGenerators() {
        try {
            List<String> beanNames = reportExecutionService.getAllReportGeneratorBeanNames();
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("totalGenerators", beanNames.size());
            response.put("generators", beanNames);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error retrieving report generators", e);
            return ResponseEntity.internalServerError()
                .body(Map.of("success", false, "error", e.getMessage()));
        }
    }
    
    /**
     * Get information about a specific report generator
     */
    @GetMapping("/generators/{beanName}/info")
    public ResponseEntity<Map<String, Object>> getReportGeneratorInfo(@PathVariable String beanName) {
        try {
            Map<String, Object> reportInfo = reportExecutionService.getReportInfo(beanName);
            
            if (reportInfo == null) {
                return ResponseEntity.notFound().build();
            }
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("reportInfo", reportInfo);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error retrieving report generator info for: {}", beanName, e);
            return ResponseEntity.internalServerError()
                .body(Map.of("success", false, "error", e.getMessage()));
        }
    }
    
    /**
     * Test report generation with default parameters
     */
    @PostMapping("/generators/{beanName}/test")
    public ResponseEntity<Map<String, Object>> testReportGeneration(@PathVariable String beanName) {
        try {
            log.info("Testing report generation for bean: {}", beanName);
            
            if (!reportExecutionService.reportGeneratorExists(beanName)) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("error", "Report generator not found: " + beanName);
                return ResponseEntity.status(404).body(errorResponse);
            }
            
            String reportContent = reportExecutionService.executeReportWithDefaults(beanName);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("beanName", beanName);
            response.put("reportContent", reportContent);
            response.put("contentLength", reportContent.length());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error testing report generation for: {}", beanName, e);
            return ResponseEntity.internalServerError()
                .body(Map.of("success", false, "error", e.getMessage()));
        }
    }
    
    /**
     * Test report generation with custom parameters
     */
    @PostMapping("/generators/{beanName}/test-with-params")
    public ResponseEntity<Map<String, Object>> testReportGenerationWithParams(
            @PathVariable String beanName,
            @RequestBody Map<String, Object> parameters) {
        try {
            log.info("Testing report generation for bean: {} with parameters: {}", beanName, parameters);
            
            if (!reportExecutionService.reportGeneratorExists(beanName)) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("error", "Report generator not found: " + beanName);
                return ResponseEntity.status(404).body(errorResponse);
            }
            
            String reportContent = reportExecutionService.executeReport(beanName, parameters);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("beanName", beanName);
            response.put("parameters", parameters);
            response.put("reportContent", reportContent);
            response.put("contentLength", reportContent.length());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error testing report generation for: {} with params: {}", beanName, parameters, e);
            return ResponseEntity.internalServerError()
                .body(Map.of("success", false, "error", e.getMessage()));
        }
    }
    
    /**
     * Validate parameters for a specific report generator
     */
    @PostMapping("/generators/{beanName}/validate-params")
    public ResponseEntity<Map<String, Object>> validateReportParameters(
            @PathVariable String beanName,
            @RequestBody Map<String, Object> parameters) {
        try {
            if (!reportExecutionService.reportGeneratorExists(beanName)) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("error", "Report generator not found: " + beanName);
                return ResponseEntity.status(404).body(errorResponse);
            }
            
            var generator = reportExecutionService.getReportGenerator(beanName);
            boolean isValid = generator.validateParameters(parameters);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("beanName", beanName);
            response.put("parameters", parameters);
            response.put("isValid", isValid);
            response.put("defaultParameters", generator.getDefaultParameters());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error validating parameters for: {} with params: {}", beanName, parameters, e);
            return ResponseEntity.internalServerError()
                .body(Map.of("success", false, "error", e.getMessage()));
        }
    }
    
    /**
     * Get system status and available report generators summary
     */
    @GetMapping("/system-status")
    public ResponseEntity<Map<String, Object>> getSystemStatus() {
        try {
            List<String> beanNames = reportExecutionService.getAllReportGeneratorBeanNames();
            
            Map<String, Object> systemInfo = new HashMap<>();
            systemInfo.put("totalReportGenerators", beanNames.size());
            systemInfo.put("availableGenerators", beanNames);
            
            // Test each generator's basic functionality
            Map<String, Object> generatorStatus = new HashMap<>();
            for (String beanName : beanNames) {
                try {
                    Map<String, Object> info = reportExecutionService.getReportInfo(beanName);
                    generatorStatus.put(beanName, Map.of(
                        "status", "available",
                        "name", info.get("name"),
                        "supportsScheduling", info.get("supportsScheduling")
                    ));
                } catch (Exception e) {
                    generatorStatus.put(beanName, Map.of(
                        "status", "error",
                        "error", e.getMessage()
                    ));
                }
            }
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("systemInfo", systemInfo);
            response.put("generatorStatus", generatorStatus);
            response.put("timestamp", System.currentTimeMillis());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error retrieving system status", e);
            return ResponseEntity.internalServerError()
                .body(Map.of("success", false, "error", e.getMessage()));
        }
    }
}