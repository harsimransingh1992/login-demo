package com.example.logindemo.config;

import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.concurrent.ConcurrentMapCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.cache.interceptor.KeyGenerator;
import org.springframework.cache.interceptor.SimpleKeyGenerator;

@Configuration
@EnableCaching
public class CacheConfig {

    @Bean
    public CacheManager cacheManager() {
        // Use simple in-memory cache manager for now
        ConcurrentMapCacheManager cacheManager = new ConcurrentMapCacheManager(
            "clinicDoctors", 
            "checkedInPatients",
            "userByUsername"
        );
        // Set to allow null values
        cacheManager.setAllowNullValues(false);
        return cacheManager;
    }

    @Bean
    public KeyGenerator keyGenerator() {
        return new SimpleKeyGenerator();
    }
}