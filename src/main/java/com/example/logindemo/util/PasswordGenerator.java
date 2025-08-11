package com.example.logindemo.util;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class PasswordGenerator {
    
    @Bean
    public CommandLineRunner generatePassword() {
        return args -> {
            PasswordEncoder encoder = new BCryptPasswordEncoder();
            
            String rawPassword = "admin";
            String encodedPassword = encoder.encode(rawPassword);

            
            // Verify against our actual hardcoded password in data.sql
            String dataScriptPassword = "$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG";
            boolean matches = encoder.matches(rawPassword, dataScriptPassword);
        };
    }
} 