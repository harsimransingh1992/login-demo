package com.example.logindemo.service.impl;

import com.example.logindemo.service.SmsService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.client.SimpleClientHttpRequestFactory;

import java.util.*;

@Service
public class SmsServiceImpl implements SmsService {
    private static final Logger log = LoggerFactory.getLogger(SmsServiceImpl.class);

    @Value("${sms.enabled:false}")
    private boolean enabled;

    @Value("${sms.sender-id:PERIDESK}")
    private String senderId;

    // MSG91 configuration
    @Value("${sms.msg91.authkey:}")
    private String msg91AuthKey;

    @Value("${sms.msg91.route:4}")
    private String msg91Route;

    @Value("${sms.country_code:91}")
    private String countryCode;

    @Value("${sms.msg91.api-base:https://api.msg91.com}")
    private String apiBase;

    @Value("${sms.msg91.api-send-path:/api/v2/sendsms}")
    private String apiSendPath;

    @Override
    public String sendSms(String phoneNumber, String message) {
        if (!enabled) {
            log.info("[SMS-DISABLED] Would send to {} from {}: {}", phoneNumber, senderId, message);
            return null;
        }

        if (msg91AuthKey == null || msg91AuthKey.isBlank()) {
            log.warn("[SMS] MSG91 auth key not configured. Set 'sms.msg91.authkey' in application.properties.");
            return null;
        }

        String normalized = normalizePhoneNumber(phoneNumber);
        if (normalized == null || normalized.isBlank()) {
            log.warn("[SMS] Invalid phone number, skipping send: {}", phoneNumber);
            return null;
        }

        try {
            String url = apiBase + apiSendPath;

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("authkey", msg91AuthKey);

            Map<String, Object> payload = new HashMap<>();
            payload.put("sender", senderId);
            payload.put("route", msg91Route);
            payload.put("country", countryCode);

            Map<String, Object> smsObj = new HashMap<>();
            smsObj.put("message", message);
            smsObj.put("to", Collections.singletonList(normalized));
            payload.put("sms", Collections.singletonList(smsObj));

            SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
            factory.setConnectTimeout(5000);
            factory.setReadTimeout(8000);
            RestTemplate restTemplate = new RestTemplate(factory);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(payload, headers);
            ResponseEntity<String> response = restTemplate.postForEntity(url, entity, String.class);

            String body = response.getBody();
            log.info("[SMS] MSG91 response status={} body={}", response.getStatusCodeValue(), body);

            String providerId = extractProviderMessageId(body);
            if (providerId != null) {
                log.info("[SMS] MSG91 request_id={}", providerId);
            }
            return providerId;
        } catch (Exception ex) {
            log.error("[SMS] MSG91 send failed: {}", ex.getMessage(), ex);
            return null;
        }
    }

    private String normalizePhoneNumber(String input) {
        if (input == null) return null;
        String digits = input.replaceAll("[^0-9]", "");
        if (digits.isBlank()) return null;
        if (digits.startsWith(countryCode)) return digits;
        // Handle leading zeros
        while (digits.startsWith("0")) {
            digits = digits.substring(1);
        }
        // If 10-digit Indian mobile, prefix country code
        if (digits.length() == 10) {
            return countryCode + digits;
        }
        return digits;
    }

    private String extractProviderMessageId(String body) {
        if (body == null || body.isBlank()) return null;
        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(body);
            if (root.has("request_id")) {
                return root.get("request_id").asText();
            }
            if (root.has("message")) { // sometimes only message is present
                return root.get("message").asText();
            }
            return null;
        } catch (Exception e) {
            return null;
        }
    }
}