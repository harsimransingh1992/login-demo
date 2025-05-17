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

@Service
public class UserDetailsServiceImpl implements UserDetailsService {

    @Resource(name="userRepository")
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with username: " + username));

        List<SimpleGrantedAuthority> authorities = new ArrayList<>();
        
        // Add basic user role
        authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
        
        // Check if user is admin (both adminperidesk and admin usernames get admin role)
        if ("adminperidesk".equals(user.getUsername()) || "admin".equals(user.getUsername())) {
            authorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
            System.out.println("Assigned ROLE_ADMIN to user: " + username);
        }

        // Create and return the Spring Security User object
        org.springframework.security.core.userdetails.User securityUser = 
            new org.springframework.security.core.userdetails.User(
                user.getUsername(),
                user.getPassword(),
                authorities
            );
            
        System.out.println("Loaded user: " + username + " with password starting with: " + 
                          (user.getPassword().length() > 10 ? user.getPassword().substring(0, 10) + "..." : "INVALID"));
        
        return securityUser;
    }
} 