package com.example.logindemo.config;

import com.example.logindemo.model.User;
import com.example.logindemo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
public class ForcePasswordChangeFilter extends OncePerRequestFilter {

    @Autowired
    private UserRepository userRepository;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        
        if (authentication != null && authentication.isAuthenticated() && 
            !authentication.getName().equals("anonymousUser")) {
            
            User user = userRepository.findByUsername(authentication.getName())
                .orElse(null);
                
            if (user != null && user.getForcePasswordChange() && 
                !request.getRequestURI().equals("/change-password") &&
                !request.getRequestURI().startsWith("/css/") &&
                !request.getRequestURI().startsWith("/js/") &&
                !request.getRequestURI().startsWith("/images/") &&
                !request.getRequestURI().startsWith("/api/mobile/")) {
                
                response.sendRedirect("/change-password?force=true");
                return;
            }
        }
        
        filterChain.doFilter(request, response);
    }
} 