package com.example.logindemo.config;

import com.example.logindemo.model.IndianCity;
import com.example.logindemo.model.IndianState;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.module.SimpleModule;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateTimeDeserializer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Configuration
public class JacksonConfig {

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

    @Bean
    @Primary
    public ObjectMapper objectMapper() {
        ObjectMapper objectMapper = new ObjectMapper();
        SimpleModule module = new SimpleModule();
        
        // Add serializer for IndianCity enum
        module.addSerializer(IndianCity.class, new JsonSerializer<IndianCity>() {
            @Override
            public void serialize(IndianCity value, JsonGenerator gen, SerializerProvider serializers) throws IOException {
                gen.writeStartObject();
                gen.writeStringField("displayName", value.getDisplayName());
                gen.writeStringField("state", value.getState().getDisplayName());
                gen.writeEndObject();
            }
        });
        
        // Add serializer for IndianState enum
        module.addSerializer(IndianState.class, new JsonSerializer<IndianState>() {
            @Override
            public void serialize(IndianState value, JsonGenerator gen, SerializerProvider serializers) throws IOException {
                gen.writeStartObject();
                gen.writeStringField("displayName", value.getDisplayName());
                gen.writeEndObject();
            }
        });
        
        // Configure JavaTimeModule with custom formatter
        JavaTimeModule javaTimeModule = new JavaTimeModule();
        javaTimeModule.addSerializer(LocalDateTime.class, new LocalDateTimeSerializer(DATE_TIME_FORMATTER));
        javaTimeModule.addDeserializer(LocalDateTime.class, new LocalDateTimeDeserializer(DATE_TIME_FORMATTER));
        
        objectMapper.registerModule(module);
        objectMapper.registerModule(javaTimeModule);
        return objectMapper;
    }
} 