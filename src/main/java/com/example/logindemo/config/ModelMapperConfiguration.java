package com.example.logindemo.config;

import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ModelMapperConfiguration {
    @Bean
    public ModelMapper modelMapper() {
        ModelMapper modelMapper = new ModelMapper();
        
        // Configure ModelMapper
        modelMapper.getConfiguration()
            .setMatchingStrategy(MatchingStrategies.STRICT)
            .setAmbiguityIgnored(true)
            .setSkipNullEnabled(true);
        
        // Configure circular reference handling
        modelMapper.getConfiguration()
            .setPropertyCondition(context -> {
                // Skip mapping if the source and destination are the same object
                return context.getSource() != context.getDestination();
            });
        
        return modelMapper;
    }
}
