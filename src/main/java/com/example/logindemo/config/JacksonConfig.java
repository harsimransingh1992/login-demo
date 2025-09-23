package com.example.logindemo.config;

import com.example.logindemo.model.IndianCity;
import com.example.logindemo.model.IndianState;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.module.SimpleModule;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;

@Configuration
public class JacksonConfig {

    private static final ZoneId IST_ZONE = ZoneId.of("Asia/Kolkata");
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSXXX");

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
        
        // Custom LocalDateTime serializer that treats LocalDateTime as IST and returns timestamp
        module.addSerializer(LocalDateTime.class, new JsonSerializer<LocalDateTime>() {
            @Override
            public void serialize(LocalDateTime value, JsonGenerator gen, SerializerProvider serializers) throws IOException {
                ZonedDateTime zonedDateTime = value.atZone(IST_ZONE);
                // Return timestamp in milliseconds for JavaScript compatibility
                gen.writeNumber(zonedDateTime.toInstant().toEpochMilli());
            }
        });
        
        // Custom LocalDateTime deserializer
        module.addDeserializer(LocalDateTime.class, new JsonDeserializer<LocalDateTime>() {
            @Override
            public LocalDateTime deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
                long timestamp = p.getValueAsLong();
                return LocalDateTime.ofInstant(java.time.Instant.ofEpochMilli(timestamp), IST_ZONE);
            }
        });
        
        objectMapper.registerModule(module);
        objectMapper.registerModule(new JavaTimeModule());
        return objectMapper;
    }
}