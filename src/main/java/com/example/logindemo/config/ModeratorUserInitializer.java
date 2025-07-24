package com.example.logindemo.config;

import com.example.logindemo.model.User;
import com.example.logindemo.model.UserRole;
import com.example.logindemo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
@Order(2) // Run after AdminUserInitializer
public class ModeratorUserInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        // Check if moderator user exists, if not, create one
        Optional<User> existingModerator = userRepository.findByUsername("moderator");
        
        if (existingModerator.isEmpty()) {
            // Create moderator user
            User moderatorUser = new User();
            moderatorUser.setUsername("moderator");
            moderatorUser.setPassword(passwordEncoder.encode("moderator123"));
            moderatorUser.setFirstName("System");
            moderatorUser.setLastName("Moderator");
            moderatorUser.setEmail("moderator@peridesk.com");
            moderatorUser.setRole(UserRole.MODERATOR);
            moderatorUser.setIsActive(true);
            // Moderators don't have a specific clinic assigned
            moderatorUser.setClinic(null);
            
            userRepository.save(moderatorUser);
            System.out.println("Moderator user created successfully with username 'moderator' and password 'moderator123'");
        } else {
            // Update existing moderator user if needed
            User moderatorUser = existingModerator.get();
            if (!moderatorUser.getRole().equals(UserRole.MODERATOR)) {
                moderatorUser.setRole(UserRole.MODERATOR);
                userRepository.save(moderatorUser);
                System.out.println("Updated existing moderator user role to MODERATOR");
            }
            if (!moderatorUser.getIsActive()) {
                moderatorUser.setIsActive(true);
                userRepository.save(moderatorUser);
                System.out.println("Activated existing moderator user");
            }
            // Ensure moderator doesn't have a clinic assigned
            if (moderatorUser.getClinic() != null) {
                moderatorUser.setClinic(null);
                userRepository.save(moderatorUser);
                System.out.println("Removed clinic assignment from moderator user");
            }
        }
    }
} 