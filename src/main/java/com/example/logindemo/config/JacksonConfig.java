package com.example.logindemo.config;

import com.example.logindemo.model.IndianCity;
import com.example.logindemo.model.IndianState;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.module.SimpleModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import java.io.IOException;

@Configuration
public class JacksonConfig {

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
        
        objectMapper.registerModule(module);
        return objectMapper;
    }
} 