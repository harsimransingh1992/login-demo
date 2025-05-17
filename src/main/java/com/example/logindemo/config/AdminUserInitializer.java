package com.example.logindemo.config;

import com.example.logindemo.model.User;
import com.example.logindemo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Optional;

@Component
public class AdminUserInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        // Check if admin user exists, if not, create one
        Optional<User> existingAdmin = userRepository.findByUsername("admin");
        
        if (existingAdmin.isEmpty()) {
            // Create a very simple admin user
            User adminUser = new User();
            adminUser.setUsername("admin");
            adminUser.setPassword("admin"); // Plain text password
            adminUser.setOnboardDoctors(new ArrayList<>());
            
            userRepository.save(adminUser);
            System.out.println("Admin user created successfully with username 'admin' and password 'admin'");
        } else {
            System.out.println("Admin user already exists, skipping creation");
        }
    }
} 