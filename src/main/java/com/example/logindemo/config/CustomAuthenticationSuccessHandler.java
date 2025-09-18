package com.example.logindemo.config;

import com.example.logindemo.model.User;
import com.example.logindemo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collection;

@Component
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    @Autowired
    private UserRepository userRepository;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, 
                                      Authentication authentication) throws IOException, ServletException {
        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        String contextPath = request.getContextPath();
        
        // Get the current user
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        User user = userRepository.findByUsername(userDetails.getUsername())
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        // Check if password change is required
        if (user.getForcePasswordChange()) {
            response.sendRedirect(contextPath + "/change-password?force=true");
            return;
        }
        
        // Route to appropriate dashboard based on role
        if (authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            response.sendRedirect(contextPath + "/welcome");
        } else if (authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_MODERATOR"))) {
            response.sendRedirect(contextPath + "/moderator/dashboard"); // Moderators go to moderator dashboard
        } else if (authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_CLINIC_OWNER"))) {
            response.sendRedirect(contextPath + "/clinic/dashboard");
        } else if (authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_DOCTOR"))) {
            response.sendRedirect(contextPath + "/welcome"); // Changed from "/doctor/dashboard"
        } else if (authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_OPD_DOCTOR"))) {
            response.sendRedirect(contextPath + "/welcome");
        } else {
            response.sendRedirect(contextPath + "/welcome");
        }
    }
} 