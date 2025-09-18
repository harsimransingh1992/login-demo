package com.example.logindemo.config;

import com.example.logindemo.service.UserDetailsServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true, securedEnabled = true)
public class SecurityConfig {

    @Autowired
    private UserDetailsServiceImpl userDetailsService;

    @Autowired
    private CustomAuthenticationSuccessHandler authenticationSuccessHandler;

    @Autowired
    private ForcePasswordChangeFilter forcePasswordChangeFilter;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder());
        return authProvider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf()
                .ignoringAntMatchers("/css/**", "/js/**", "/images/**", "/api/mobile/**", "/patients/update-procedure-status", "/patients/test-simple-update", "/patients/uncheck/**", "/password-reset/**")
            .and()
            .addFilterBefore(forcePasswordChangeFilter, UsernamePasswordAuthenticationFilter.class)
            .authorizeRequests()
                // Static resources accessible to all
                .antMatchers("/css/**", "/js/**", "/images/**", "/uploads/**").permitAll()
                
                // Mobile API endpoints - handle their own security
                .antMatchers("/api/mobile/**").permitAll()
                
                // Public pages
                .antMatchers("/login", "/register", "/forgot-password", "/reset-password", "/password-reset/**").permitAll()
                
                // Admin section - system maintenance and database management
                .antMatchers("/admin/**").hasRole("ADMIN")
                
                // Moderator section - business insights and clinic monitoring
                .antMatchers("/moderator/**").hasRole("MODERATOR")
                
                // Clinic owner section
                .antMatchers("/clinic/dashboard/**", "/clinic/manage/**").hasAnyRole("CLINIC_OWNER", "MODERATOR")
                
                // Doctor specific pages
                .antMatchers("/doctor/dashboard/**", "/patients/examination/*/procedures/**", "/examination/*/procedures/**").hasAnyRole("DOCTOR", "OPD_DOCTOR", "MODERATOR")
                
                // Receptionist specific pages
                .antMatchers("/appointments/management/**").hasAnyRole("RECEPTIONIST", "ADMIN", "DOCTOR", "OPD_DOCTOR", "MODERATOR")
                .antMatchers("/receptionist/**").hasAnyRole("RECEPTIONIST", "ADMIN", "MODERATOR")
                
                // Patient management - accessible to all staff
                .antMatchers("/patients/**").hasAnyRole("DOCTOR", "OPD_DOCTOR", "STAFF", "RECEPTIONIST", "ADMIN", "CLINIC_OWNER", "MODERATOR")
                
                // Follow-up management - accessible to all staff
                .antMatchers("/follow-up/**").hasAnyRole("DOCTOR", "OPD_DOCTOR", "STAFF", "RECEPTIONIST", "ADMIN", "CLINIC_OWNER", "MODERATOR")
                
                // Payments - accessible to receptionists and moderators (read-only for moderators)
                .antMatchers("/payments/**").hasAnyRole("RECEPTIONIST", "ADMIN", "MODERATOR")
                
                // Welcome page and basic features - accessible to all authenticated users
                .antMatchers("/welcome", "/profile/**").authenticated()
                
                // Catch all other requests
                .anyRequest().authenticated()
            .and()
            .formLogin()
                .loginPage("/login")
                .loginProcessingUrl("/login")
                .successHandler(authenticationSuccessHandler)
                .failureUrl("/login?error=true")
                .permitAll()
            .and()
            .logout()
                .logoutUrl("/logout")
                .logoutSuccessUrl("/logout-success")
                .invalidateHttpSession(true)
                .clearAuthentication(true)
                .deleteCookies("JSESSIONID")
                .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                .permitAll()
            .and()
            .exceptionHandling()
                .accessDeniedPage("/access-denied")
            .and()
            .sessionManagement()
                .maximumSessions(1)
                .expiredUrl("/login?expired")
            .and()
            .and()
            .headers()
                .frameOptions().deny()
                .xssProtection().block(true);
        
        return http.build();
    }
}