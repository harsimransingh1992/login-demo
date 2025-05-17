package com.example.logindemo.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.lang.NonNull;
import lombok.extern.slf4j.Slf4j;

import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
@Slf4j
public class WebConfig implements WebMvcConfigurer {

    @Value("${file.upload-dir:uploads}")
    private String uploadDir;

    @Override
    public void configureViewResolvers(@NonNull ViewResolverRegistry registry) {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        registry.viewResolver(resolver);
    }
    
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Add handler for images directory
        registry.addResourceHandler("/images/**")
                .addResourceLocations("/images/", "classpath:/static/images/", "/WEB-INF/images/", "/webapp/images/");
                
        // Add handler for CSS, JS, and other static resources if needed
        registry.addResourceHandler("/css/**")
                .addResourceLocations("/css/", "classpath:/static/css/");
                
        registry.addResourceHandler("/js/**")
                .addResourceLocations("/js/", "classpath:/static/js/");

        // Register resource handler for uploaded files
        Path uploadPath = Paths.get(uploadDir);
        String uploadAbsolutePath = uploadPath.toFile().getAbsolutePath();
        
        // Add trailing slash if not present
        if (!uploadAbsolutePath.endsWith("/")) {
            uploadAbsolutePath += "/";
        }
        
        log.info("Configuring uploads directory resource handler at: {}", uploadAbsolutePath);
        
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + uploadAbsolutePath);
    }
} 