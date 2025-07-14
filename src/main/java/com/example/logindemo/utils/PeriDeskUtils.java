package com.example.logindemo.utils;

import com.example.logindemo.model.ClinicModel;
import com.example.logindemo.model.User;
import com.example.logindemo.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class PeriDeskUtils {
    private static final Logger logger = LoggerFactory.getLogger(PeriDeskUtils.class);
    
    private static UserRepository userRepository;
    
    @Autowired
    public void setUserRepository(UserRepository userRepository) {
        PeriDeskUtils.userRepository = userRepository;
    }

    public static String getCurrentClinicUserName(){
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication.getName();
    }

    public static ClinicModel getCurrentClinicModel(){
        try {
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null) {
                logger.error("No authentication found in SecurityContext");
                throw new IllegalStateException("No authentication found");
            }
            
            if (userRepository == null) {
                logger.error("UserRepository is not initialized");
                throw new IllegalStateException("UserRepository is not initialized");
            }
            
            Optional<User> currentUser = userRepository.findByUsername(authentication.getName());
            if(currentUser.isPresent()){
                return currentUser.get().getClinic();
            } else {
                logger.error("No user found for username: {}", authentication.getName());
                throw new IllegalStateException("No user found for current authentication");
            }
        } catch (Exception e) {
            logger.error("Error getting current clinic model", e);
            throw new IllegalStateException("Failed to get current clinic model", e);
        }
    }

    /**
     * Gets the currently authenticated user with their clinic information
     * @return the current User object
     * @throws IllegalStateException if no user is authenticated or user is not of type User
     */
    public static User getCurrentUser() {
        try {
            final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null || !authentication.isAuthenticated()) {
                logger.error("No authenticated user found");
                throw new IllegalStateException("No authenticated user found");
    }

            if (userRepository == null) {
                logger.error("UserRepository is not initialized");
                throw new IllegalStateException("UserRepository is not initialized");
            }
            
            Optional<User> currentUser = userRepository.findByUsername(authentication.getName());
            if (!currentUser.isPresent()) {
                logger.error("No user found for username: {}", authentication.getName());
                throw new IllegalStateException("No user found for current authentication");
            }
            
            User user = currentUser.get();
            if (user.getClinic() == null) {
                logger.error("User {} has no clinic associated", authentication.getName());
                throw new IllegalStateException("User does not have a clinic associated");
            }
            
            return user;
        } catch (Exception e) {
            logger.error("Error getting current user", e);
            throw new IllegalStateException("Failed to get current user", e);
        }
    }
}
