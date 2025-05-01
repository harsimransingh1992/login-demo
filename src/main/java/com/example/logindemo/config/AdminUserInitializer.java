package com.example.logindemo.config;

import com.example.logindemo.model.User;
import com.example.logindemo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.ArrayList;

@Component
public class AdminUserInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        // Check if admin user exists
        if (!userRepository.findByUsername("adminperidesk").isPresent()) {
            // Create admin user
            User adminUser = new User();
            adminUser.setUsername("adminperidesk");
            adminUser.setPassword(passwordEncoder.encode("PeriDesk@2024")); // Set default password
            adminUser.setOnboardDoctors(new ArrayList<>());
            
            userRepository.save(adminUser);
            System.out.println("Admin user created successfully");
        }
    }
} 