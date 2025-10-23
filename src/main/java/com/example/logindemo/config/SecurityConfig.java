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
import org.springframework.security.web.header.HeaderWriterFilter;
import org.springframework.security.web.header.writers.ReferrerPolicyHeaderWriter;
import org.springframework.security.web.header.writers.ContentSecurityPolicyHeaderWriter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;

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

    @Value("${cors.allowed-origins:http://localhost:8080,http://localhost:8081,http://localhost:8083}")
    private String corsAllowedOrigins;

    @Value("${cors.allowed-methods:GET,POST,PUT,DELETE,OPTIONS}")
    private String corsAllowedMethods;

    @Value("${cors.allowed-headers:Authorization,Content-Type,X-Requested-With}")
    private String corsAllowedHeaders;

    @Value("${cors.allow-credentials:false}")
    private boolean corsAllowCredentials;

    @Value("${cors.max-age:86400}")
    private long corsMaxAge;

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
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(Arrays.asList(corsAllowedOrigins.split(",")));
        configuration.setAllowedMethods(Arrays.asList(corsAllowedMethods.split(",")));
        configuration.setAllowedHeaders(Arrays.asList(corsAllowedHeaders.split(",")));
        configuration.setAllowCredentials(corsAllowCredentials);
        configuration.setMaxAge(corsMaxAge);
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    @Bean
    public OncePerRequestFilter permissionsPolicyHeaderFilter() {
        return new OncePerRequestFilter() {
            @Override
            protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
                // Conservative Permissions-Policy to reduce risk and improve performance by disabling unnecessary features
                response.setHeader("Permissions-Policy", "geolocation=(), microphone=(), camera=(), accelerometer=(), gyroscope=(), magnetometer=()");
                filterChain.doFilter(request, response);
            }
        };
    }

    @Bean
    public ContentSecurityPolicyHeaderWriter contentSecurityPolicyHeaderWriter() {
        ContentSecurityPolicyHeaderWriter writer = new ContentSecurityPolicyHeaderWriter(
                "default-src 'self'; script-src 'self' https://ajax.googleapis.com https://cdnjs.cloudflare.com; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://cdnjs.cloudflare.com; img-src 'self' data: blob:; font-src 'self' https://fonts.gstatic.com; connect-src 'self'; frame-ancestors 'self'"
        );
        writer.setReportOnly(true);
        return writer;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf()
                .ignoringAntMatchers("/css/**", "/js/**", "/images/**", "/api/mobile/**", "/api/consultation-charges/**", "/api/consultation-fee/**", "/patients/update-procedure-status", "/patients/test-simple-update", "/patients/uncheck/**", "/password-reset/**")
            .and()
            .addFilterBefore(forcePasswordChangeFilter, UsernamePasswordAuthenticationFilter.class)
            .authorizeRequests()
                // Static resources accessible to all
                .antMatchers("/css/**", "/js/**", "/images/**", "/uploads/**").permitAll()
                
                // Mobile API endpoints - handle their own security
                .antMatchers("/api/mobile/**").permitAll()
                
                // Consultation charges API endpoints
                .antMatchers("/api/consultation-charges/**").hasAnyRole("RECEPTIONIST", "ADMIN", "DOCTOR")
                
                // Consultation fee API endpoints
                .antMatchers("/api/consultation-fee/**").hasAnyRole("RECEPTIONIST", "ADMIN", "DOCTOR")
                
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
                .antMatchers("/payments/**").hasAnyRole("RECEPTIONIST", "ADMIN", "MODERATOR","OPD_DOCTOR","DOCTOR")
                
                // Cross-clinic schedules - accessible to admins and moderators
                .antMatchers("/schedules/**").hasAnyRole("RECEPTIONIST", "ADMIN", "MODERATOR","OPD_DOCTOR","DOCTOR")
                
                // Welcome page and basic features - accessible to all authenticated users
                .antMatchers("/welcome", "/profile/**").authenticated()
                
                // Catch all other requests
                .anyRequest().authenticated()
            .and()
            .httpBasic() // Enable HTTP Basic authentication for API endpoints
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
            .cors()
            .and()
            .headers()
                .frameOptions().deny()
                .xssProtection().block(true);
        
        http.addFilterAfter(permissionsPolicyHeaderFilter(), HeaderWriterFilter.class);
        return http.build();
    }
}