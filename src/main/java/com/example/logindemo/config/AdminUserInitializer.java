package com.example.logindemo.config;

import com.example.logindemo.model.User;
import com.example.logindemo.model.UserRole;
import com.example.logindemo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

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
            // Create admin user
            User adminUser = new User();
            adminUser.setUsername("admin");
            adminUser.setPassword(passwordEncoder.encode("Dexter@26081992"));
            adminUser.setFirstName("Admin");
            adminUser.setLastName("User");
            adminUser.setRole(UserRole.ADMIN);
            adminUser.setIsActive(true);
            
            userRepository.save(adminUser);
            System.out.println("Admin user created successfully with username 'admin' and password 'admin'");
        } else {
            // Update existing admin user if needed
            User adminUser = existingAdmin.get();
            if (!adminUser.getRole().equals(UserRole.ADMIN)) {
                adminUser.setRole(UserRole.ADMIN);
                userRepository.save(adminUser);
                System.out.println("Updated existing admin user role to ADMIN");
            }
            if (!adminUser.getIsActive()) {
                adminUser.setIsActive(true);
                userRepository.save(adminUser);
                System.out.println("Activated existing admin user");
            }
        }
    }
} 