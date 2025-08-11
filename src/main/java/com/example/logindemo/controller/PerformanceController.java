package com.example.logindemo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.cache.CacheManager;
// Spring Boot Actuator endpoints not available in this project
import org.springframework.http.MediaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.databind.node.ArrayNode;

import javax.sql.DataSource;
import java.lang.management.ManagementFactory;
import java.lang.management.MemoryMXBean;
import java.lang.management.OperatingSystemMXBean;
import java.lang.management.ThreadMXBean;
import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.TimeUnit;

@RestController
@RequestMapping("/api/performance")
@CrossOrigin(origins = "*")
public class PerformanceController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private DataSource dataSource;

    @Autowired(required = false)
    private CacheManager cacheManager;

    // Spring Boot Actuator endpoints not available in this project

    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * Get comprehensive performance metrics
     */
    @GetMapping("/metrics")
    public ResponseEntity<Map<String, Object>> getPerformanceMetrics() {
        Map<String, Object> metrics = new HashMap<>();
        
        try {
            // JVM Metrics
            metrics.put("jvm", getJVMMetrics());
            
            // Database Metrics
            metrics.put("database", getDatabaseMetrics());
            
            // Cache Metrics
            metrics.put("cache", getCacheMetrics());
            
            // System Metrics
            metrics.put("system", getSystemMetrics());
            
            // Application Metrics
            metrics.put("application", getApplicationMetrics());
            
            return ResponseEntity.ok(metrics);
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Failed to collect metrics: " + e.getMessage());
            return ResponseEntity.internalServerError().body(error);
        }
    }

    /**
     * Get JVM performance metrics
     */
    private Map<String, Object> getJVMMetrics() {
        Map<String, Object> jvmMetrics = new HashMap<>();
        
        MemoryMXBean memoryBean = ManagementFactory.getMemoryMXBean();
        OperatingSystemMXBean osBean = ManagementFactory.getOperatingSystemMXBean();
        ThreadMXBean threadBean = ManagementFactory.getThreadMXBean();
        
        // Memory metrics
        long heapUsed = memoryBean.getHeapMemoryUsage().getUsed();
        long heapMax = memoryBean.getHeapMemoryUsage().getMax();
        long nonHeapUsed = memoryBean.getNonHeapMemoryUsage().getUsed();
        
        jvmMetrics.put("heapUsedMB", heapUsed / (1024 * 1024));
        jvmMetrics.put("heapMaxMB", heapMax / (1024 * 1024));
        jvmMetrics.put("heapUsagePercent", (double) heapUsed / heapMax * 100);
        jvmMetrics.put("nonHeapUsedMB", nonHeapUsed / (1024 * 1024));
        
        // Thread metrics
        jvmMetrics.put("threadCount", threadBean.getThreadCount());
        jvmMetrics.put("peakThreadCount", threadBean.getPeakThreadCount());
        jvmMetrics.put("daemonThreadCount", threadBean.getDaemonThreadCount());
        
        // System metrics
        jvmMetrics.put("systemLoadAverage", osBean.getSystemLoadAverage());
        jvmMetrics.put("availableProcessors", osBean.getAvailableProcessors());
        
        // Uptime
        long uptime = ManagementFactory.getRuntimeMXBean().getUptime();
        jvmMetrics.put("uptimeHours", TimeUnit.MILLISECONDS.toHours(uptime));
        jvmMetrics.put("uptimeMinutes", TimeUnit.MILLISECONDS.toMinutes(uptime));
        
        return jvmMetrics;
    }

    /**
     * Get database performance metrics
     */
    private Map<String, Object> getDatabaseMetrics() {
        Map<String, Object> dbMetrics = new HashMap<>();
        
        try {
            // Connection pool metrics
            if (dataSource instanceof com.zaxxer.hikari.HikariDataSource) {
                com.zaxxer.hikari.HikariDataSource hikariDS = (com.zaxxer.hikari.HikariDataSource) dataSource;
                com.zaxxer.hikari.HikariPoolMXBean poolMXBean = hikariDS.getHikariPoolMXBean();
                
                dbMetrics.put("activeConnections", poolMXBean.getActiveConnections());
                dbMetrics.put("idleConnections", poolMXBean.getIdleConnections());
                dbMetrics.put("totalConnections", poolMXBean.getTotalConnections());
                dbMetrics.put("threadsAwaitingConnection", poolMXBean.getThreadsAwaitingConnection());
            }
            
            // Query performance metrics
            String slowQueryCount = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM information_schema.processlist WHERE time > 5", String.class);
            dbMetrics.put("slowQueries", slowQueryCount != null ? Integer.parseInt(slowQueryCount) : 0);
            
            // Connection test
            long startTime = System.currentTimeMillis();
            jdbcTemplate.queryForObject("SELECT 1", Integer.class);
            long responseTime = System.currentTimeMillis() - startTime;
            dbMetrics.put("connectionResponseTimeMs", responseTime);
            
        } catch (Exception e) {
            dbMetrics.put("error", "Database metrics unavailable: " + e.getMessage());
        }
        
        return dbMetrics;
    }

    /**
     * Get cache performance metrics
     */
    private Map<String, Object> getCacheMetrics() {
        Map<String, Object> cacheMetrics = new HashMap<>();
        
        try {
            if (cacheManager != null) {
                cacheManager.getCacheNames().forEach(cacheName -> {
                Map<String, Object> cacheInfo = new HashMap<>();
                org.springframework.cache.Cache cache = cacheManager.getCache(cacheName);
                
                if (cache != null) {
                    cacheInfo.put("name", cacheName);
                    cacheInfo.put("nativeCache", cache.getNativeCache().getClass().getSimpleName());
                    
                    // Try to get cache statistics if available
                    try {
                        // Generic cache information
                        cacheInfo.put("name", cacheName);
                        cacheInfo.put("nativeCache", cache.getNativeCache().getClass().getSimpleName());
                        
                        // Try to get EhCache statistics if available
                        if (cache.getNativeCache() instanceof net.sf.ehcache.Ehcache) {
                            net.sf.ehcache.Ehcache ehcache = (net.sf.ehcache.Ehcache) cache.getNativeCache();
                            cacheInfo.put("size", ehcache.getSize());
                            cacheInfo.put("memoryStoreSize", ehcache.getMemoryStoreSize());
                            cacheInfo.put("diskStoreSize", ehcache.getDiskStoreSize());
                            
                            // Get cache statistics using the correct API
                            try {
                                net.sf.ehcache.statistics.StatisticsGateway stats = ehcache.getStatistics();
                                long hits = stats.cacheHitCount();
                                long misses = stats.cacheMissCount();
                                
                                cacheInfo.put("hitCount", hits);
                                cacheInfo.put("missCount", misses);
                                
                                double hitRate = (hits + misses) > 0 ? (double) hits / (hits + misses) * 100 : 0;
                                cacheInfo.put("hitRate", Math.round(hitRate * 100.0) / 100.0);
                            } catch (Exception e) {
                                cacheInfo.put("statisticsError", "Unable to get cache statistics: " + e.getMessage());
                            }
                        } else {
                            // Try to get size if available for other cache types
                            try {
                                if (cache.getNativeCache() instanceof java.util.Map) {
                                    java.util.Map<?, ?> mapCache = (java.util.Map<?, ?>) cache.getNativeCache();
                                    cacheInfo.put("size", mapCache.size());
                                }
                            } catch (Exception e) {
                                cacheInfo.put("size", "Unknown");
                            }
                        }
                        
                    } catch (Exception e) {
                        cacheInfo.put("statisticsError", "Cache statistics unavailable: " + e.getMessage());
                    }
                }
                
                cacheMetrics.put(cacheName, cacheInfo);
            });
            } else {
                cacheMetrics.put("status", "Cache manager not available");
            }
        } catch (Exception e) {
            cacheMetrics.put("error", "Cache metrics unavailable: " + e.getMessage());
        }
        
        return cacheMetrics;
    }

    /**
     * Get system performance metrics
     */
    private Map<String, Object> getSystemMetrics() {
        Map<String, Object> systemMetrics = new HashMap<>();
        
        try {
            OperatingSystemMXBean osBean = ManagementFactory.getOperatingSystemMXBean();
            
            systemMetrics.put("systemLoadAverage", osBean.getSystemLoadAverage());
            systemMetrics.put("availableProcessors", osBean.getAvailableProcessors());
            systemMetrics.put("totalPhysicalMemoryMB", getTotalPhysicalMemory() / (1024 * 1024));
            systemMetrics.put("freePhysicalMemoryMB", getFreePhysicalMemory() / (1024 * 1024));
            
            // Calculate memory usage percentage
            long totalMemory = getTotalPhysicalMemory();
            long freeMemory = getFreePhysicalMemory();
            double memoryUsagePercent = totalMemory > 0 ? (double) (totalMemory - freeMemory) / totalMemory * 100 : 0;
            systemMetrics.put("memoryUsagePercent", Math.round(memoryUsagePercent * 100.0) / 100.0);
            
        } catch (Exception e) {
            systemMetrics.put("error", "System metrics unavailable: " + e.getMessage());
        }
        
        return systemMetrics;
    }

    /**
     * Get application-specific metrics
     */
    private Map<String, Object> getApplicationMetrics() {
        Map<String, Object> appMetrics = new HashMap<>();
        
        try {
            // Custom application metrics
            appMetrics.put("timestamp", System.currentTimeMillis());
            appMetrics.put("startTime", ManagementFactory.getRuntimeMXBean().getStartTime());
            appMetrics.put("version", "1.0.0");
            appMetrics.put("environment", "production");
            
        } catch (Exception e) {
            appMetrics.put("error", "Application metrics unavailable: " + e.getMessage());
        }
        
        return appMetrics;
    }

    /**
     * Get total physical memory
     */
    private long getTotalPhysicalMemory() {
        try {
            return Runtime.getRuntime().totalMemory();
        } catch (Exception e) {
            return 0;
        }
    }

    /**
     * Get free physical memory
     */
    private long getFreePhysicalMemory() {
        try {
            return Runtime.getRuntime().freeMemory();
        } catch (Exception e) {
            return 0;
        }
    }

    /**
     * Get specific metric by name
     */
    @GetMapping("/metrics/{metricName}")
    public ResponseEntity<Object> getSpecificMetric(@PathVariable String metricName) {
        try {
            switch (metricName.toLowerCase()) {
                case "jvm":
                    return ResponseEntity.ok(getJVMMetrics());
                case "database":
                    return ResponseEntity.ok(getDatabaseMetrics());
                case "cache":
                    return ResponseEntity.ok(getCacheMetrics());
                case "system":
                    return ResponseEntity.ok(getSystemMetrics());
                case "application":
                    return ResponseEntity.ok(getApplicationMetrics());
                default:
                    return ResponseEntity.badRequest().body("Unknown metric: " + metricName);
            }
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Error retrieving metric: " + e.getMessage());
        }
    }

    /**
     * Health check endpoint
     */
    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> healthCheck() {
        Map<String, Object> health = new HashMap<>();
        
        try {
            // Basic health checks
            health.put("status", "UP");
            health.put("timestamp", System.currentTimeMillis());
            health.put("uptime", ManagementFactory.getRuntimeMXBean().getUptime());
            
            // Database connectivity
            try {
                jdbcTemplate.queryForObject("SELECT 1", Integer.class);
                health.put("database", "UP");
            } catch (Exception e) {
                health.put("database", "DOWN");
                health.put("databaseError", e.getMessage());
            }
            
            // Memory check
            MemoryMXBean memoryBean = ManagementFactory.getMemoryMXBean();
            long heapUsage = memoryBean.getHeapMemoryUsage().getUsed();
            long heapMax = memoryBean.getHeapMemoryUsage().getMax();
            double heapUsagePercent = (double) heapUsage / heapMax * 100;
            
            health.put("memoryUsage", heapUsagePercent);
            health.put("memoryStatus", heapUsagePercent > 90 ? "WARNING" : "OK");
            
            return ResponseEntity.ok(health);
        } catch (Exception e) {
            health.put("status", "DOWN");
            health.put("error", e.getMessage());
            return ResponseEntity.status(503).body(health);
        }
    }
} 