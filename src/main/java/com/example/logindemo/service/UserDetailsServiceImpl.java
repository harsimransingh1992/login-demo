package com.example.logindemo.service;

import com.example.logindemo.model.User;
import com.example.logindemo.repository.UserRepository;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {

    @Resource(name="userRepository")
    private UserRepository userRepository;

    private static final Logger log = LoggerFactory.getLogger(UserDetailsServiceImpl.class);

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with username: " + username));

        List<SimpleGrantedAuthority> authorities = new ArrayList<>();
        
        // Add role based on the user's role enum - map UserRole to Spring Security roles
        if (user.getRole() != null) {
            authorities.add(new SimpleGrantedAuthority("ROLE_" + user.getRole().name()));
        } else {
            // Fallback to basic user role if no role is set
            authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
        }
        
        // Special case: ensure admin usernames always get admin role
        if ("adminperidesk".equals(user.getUsername()) || "admin".equals(user.getUsername())) {
            boolean hasAdminRole = authorities.stream()
                .anyMatch(auth -> auth.getAuthority().equals("ROLE_ADMIN"));
            if (!hasAdminRole) {
                authorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
            }
        }

        // Add cross-clinic access authority if enabled for the user
        if (Boolean.TRUE.equals(user.getHasCrossClinicApptAccess())) {
            authorities.add(new SimpleGrantedAuthority("CROSS_CLINIC_ACCESS"));
            log.info("Granted CROSS_CLINIC_ACCESS to user {}", username);
        } else {
            log.debug("User {} does not have cross-clinic access flag", username);
        }

        // Create and return the Spring Security User object
        org.springframework.security.core.userdetails.User securityUser = 
            new org.springframework.security.core.userdetails.User(
                user.getUsername(),
                user.getPassword(),
                authorities
            );
        return securityUser;
    }
}