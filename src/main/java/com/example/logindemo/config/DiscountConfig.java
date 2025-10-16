package com.example.logindemo.config;

import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;

/**
 * Provides access to discount-related configuration values from application properties.
 * Uses a static accessor to allow models and utilities to resolve percentages without injection.
 */
@Component
public class DiscountConfig {

    private static Environment ENV;

    public DiscountConfig(Environment environment) {
        ENV = environment;
    }

    public static double getPercentageOrDefault(String propertyKey, double defaultValue) {
        if (ENV == null || propertyKey == null) return defaultValue;
        try {
            String val = ENV.getProperty(propertyKey);
            if (val != null && !val.trim().isEmpty()) {
                return Double.parseDouble(val.trim());
            }
        } catch (Exception ignored) {}
        return defaultValue;
    }
}