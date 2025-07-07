package com.example.logindemo.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.lang.NonNull;
import org.springframework.web.servlet.config.annotation.ContentNegotiationConfigurer;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.io.File;

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
        log.info("Upload directory exists: {}", new File(uploadAbsolutePath).exists());
        log.info("Upload directory is readable: {}", new File(uploadAbsolutePath).canRead());
        
        // List contents of upload directory for debugging
        File uploadDir = new File(uploadAbsolutePath);
        if (uploadDir.exists() && uploadDir.isDirectory()) {
            log.info("Contents of upload directory:");
            File[] files = uploadDir.listFiles();
            if (files != null) {
                for (File file : files) {
                    log.info("  - {} ({} bytes)", file.getName(), file.length());
                }
            }
        }
        
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + uploadAbsolutePath)
                .setCachePeriod(3600) // Cache for 1 hour
                .resourceChain(true);
    }

    @Override
    public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {
        configurer
            .defaultContentType(MediaType.APPLICATION_JSON)
            .mediaType("json", MediaType.APPLICATION_JSON);
    }

    @Override
    public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
        MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter();
        converter.setSupportedMediaTypes(List.of(
            MediaType.APPLICATION_JSON,
            MediaType.APPLICATION_JSON_UTF8,
            new MediaType("application", "json", java.nio.charset.StandardCharsets.UTF_8)
        ));
        converters.add(converter);
    }
} 