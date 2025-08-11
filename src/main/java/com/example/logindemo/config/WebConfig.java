package com.example.logindemo.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.resource.PathResourceResolver;
import org.springframework.web.servlet.resource.ResourceUrlEncodingFilter;
import org.springframework.web.servlet.resource.VersionResourceResolver;
import com.example.logindemo.filter.ImageCacheFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.web.filter.OncePerRequestFilter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Value("${file.upload-dir:uploads}")
    private String uploadDir;

    @Value("${image.cache.duration:86400}")
    private int imageCacheDuration;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Get absolute path for uploads
        Path uploadAbsolutePath = Paths.get(uploadDir).toAbsolutePath().normalize();
        
        // Enhanced static resource handling with versioning and caching
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/")
                .setCachePeriod(86400) // Cache for 24 hours
                .resourceChain(true)
                .addResolver(new VersionResourceResolver().addContentVersionStrategy("/**"))
                .addResolver(new PathResourceResolver());

        // Enhanced CSS and JS handling
        registry.addResourceHandler("/css/**", "/js/**")
                .addResourceLocations("classpath:/static/css/", "classpath:/static/js/", "classpath:/webapp/css/", "classpath:/webapp/js/", "classpath:/META-INF/resources/webapp/css/", "classpath:/META-INF/resources/webapp/js/", "classpath:/META-INF/resources/", "classpath:/resources/")
                .setCachePeriod(86400) // Cache for 24 hours
                .resourceChain(true)
                .addResolver(new VersionResourceResolver().addContentVersionStrategy("/**"))
                .addResolver(new PathResourceResolver());

        // Enhanced image handling with longer cache
        registry.addResourceHandler("/images/**")
                .addResourceLocations("classpath:/static/images/", "classpath:/webapp/images/", "classpath:/META-INF/resources/webapp/images/")
                .setCachePeriod(31536000) // Cache for 1 year
                .resourceChain(true)
                .addResolver(new PathResourceResolver());

        // Enhanced uploads handling with Cloudflare optimization
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + uploadAbsolutePath + "/", "file:uploads/")
                .setCachePeriod(imageCacheDuration) // Cache for configured duration
                .resourceChain(true)
                .addResolver(new PathResourceResolver());

        // Font files with long cache
        registry.addResourceHandler("/fonts/**")
                .addResourceLocations("classpath:/static/fonts/")
                .setCachePeriod(31536000) // Cache for 1 year
                .resourceChain(true)
                .addResolver(new PathResourceResolver());

        // Service worker with no cache
        registry.addResourceHandler("/sw.js")
                .addResourceLocations("classpath:/static/")
                .setCachePeriod(0) // No cache for service worker
                .resourceChain(false);

        // Webapp resources (for files in src/main/webapp)
        registry.addResourceHandler("/webapp/**")
                .addResourceLocations("classpath:/webapp/", "classpath:/META-INF/resources/webapp/")
                .setCachePeriod(86400) // Cache for 24 hours
                .resourceChain(true)
                .addResolver(new PathResourceResolver());

        // Direct access to webapp resources
        registry.addResourceHandler("/**")
                .addResourceLocations("classpath:/META-INF/resources/", "classpath:/resources/", "classpath:/static/", "classpath:/webapp/")
                .setCachePeriod(86400) // Cache for 24 hours
                .resourceChain(true)
                .addResolver(new PathResourceResolver());
    }

    @Bean
    public ResourceUrlEncodingFilter resourceUrlEncodingFilter() {
        return new ResourceUrlEncodingFilter();
    }

    @Bean
    public FilterRegistrationBean<ImageCacheFilter> imageCacheFilter() {
        FilterRegistrationBean<ImageCacheFilter> registrationBean = new FilterRegistrationBean<>();
        registrationBean.setFilter(new ImageCacheFilter());
        registrationBean.addUrlPatterns("/uploads/*", "/images/*", "/static/*");
        registrationBean.setOrder(1);
        return registrationBean;
    }

    // Compression is handled by Spring Boot's built-in compression
    // No custom compression filter needed

    @Bean
    public FilterRegistrationBean<SecurityHeadersFilter> securityHeadersFilter() {
        FilterRegistrationBean<SecurityHeadersFilter> registrationBean = new FilterRegistrationBean<>();
        registrationBean.setFilter(new SecurityHeadersFilter());
        registrationBean.addUrlPatterns("/*");
        registrationBean.setOrder(3);
        return registrationBean;
    }

    // Compression filter removed - using Spring Boot's built-in compression

    /**
     * Security headers filter for better security and performance
     */
    public static class SecurityHeadersFilter extends OncePerRequestFilter {
        @Override
        protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
                throws ServletException, IOException {
            
            // Security headers
            response.setHeader("X-Content-Type-Options", "nosniff");
            response.setHeader("X-Frame-Options", "SAMEORIGIN");
            response.setHeader("X-XSS-Protection", "1; mode=block");
            response.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
            
            // Performance headers
            response.setHeader("X-DNS-Prefetch-Control", "on");
            
            // Cache control for static assets
            String requestURI = request.getRequestURI();
            if (requestURI.contains("/css/") || requestURI.contains("/js/") || 
                requestURI.contains("/images/") || requestURI.contains("/fonts/")) {
                response.setHeader("Cache-Control", "public, max-age=31536000, immutable");
            } else if (requestURI.contains("/uploads/")) {
                response.setHeader("Cache-Control", "public, max-age=86400");
            }
            
            filterChain.doFilter(request, response);
        }
    }
} 