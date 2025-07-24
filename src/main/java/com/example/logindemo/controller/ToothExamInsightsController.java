package com.example.logindemo.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.*;

@Controller
public class ToothExamInsightsController {

    @GetMapping("/moderator/tooth-exam-dashboard")
    public String showToothExamInsights(Model model) throws Exception {
        // Dummy data for demonstration. Replace with real data fetching logic.
        List<Map<String, Object>> mostCommonToothConditions = new ArrayList<>();
        mostCommonToothConditions.add(Map.of("key", "Caries", "value", 12));
        mostCommonToothConditions.add(Map.of("key", "Fracture", "value", 8));
        mostCommonToothConditions.add(Map.of("key", "Attrition", "value", 5));

        ObjectMapper mapper = new ObjectMapper();
        String mostCommonToothConditionsJson = mapper.writeValueAsString(mostCommonToothConditions);

        model.addAttribute("mostCommonToothConditionsJson", mostCommonToothConditionsJson);

        return "moderator/tooth-exam-insights";
    }
} 