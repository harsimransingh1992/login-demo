package com.example.logindemo.controller;

import com.example.logindemo.service.UserJourneyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/journeys")
public class JourneyController {

    @Autowired
    private UserJourneyService journeyService;

    @GetMapping("/tracking")
    public String trackingPage(@RequestParam(value = "patientId", required = false) Long patientId,
                               Model model) {
        model.addAttribute("patientId", patientId);
        return "journeys/tracking";
    }

    @GetMapping("/api/events")
    @ResponseBody
    public Map<String, Object> getEvents(@RequestParam(value = "patientId", required = false) Long patientId,
                                         @RequestParam(value = "eventType", required = false) String eventType,
                                         @RequestParam(value = "eventTypes", required = false) String eventTypesCsv,
                                         @RequestParam(value = "searchText", required = false) String searchText,
                                         @RequestParam(value = "from", required = false)
                                         @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime from,
                                         @RequestParam(value = "to", required = false)
                                         @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime to) {
        List<String> eventTypes = null;
        if (eventTypesCsv != null && !eventTypesCsv.isEmpty()) {
            eventTypes = Arrays.stream(eventTypesCsv.split(","))
                    .map(String::trim)
                    .filter(s -> !s.isEmpty())
                    .collect(Collectors.toList());
        } else if (eventType != null && !eventType.isEmpty()) {
            eventTypes = List.of(eventType);
        }
        List<Map<String, Object>> events = journeyService.getEventsAdvanced(patientId, eventTypes, from, to, searchText);
        Map<String, Object> resp = new HashMap<>();
        resp.put("success", true);
        resp.put("events", events);
        return resp;
    }

    @PostMapping("/api/events")
    @ResponseBody
    public ResponseEntity<?> logEvent(@RequestBody Map<String, Object> payload) {
        journeyService.logEvent(payload);
        Map<String, Object> resp = new HashMap<>();
        resp.put("success", true);
        resp.put("message", "Event logged");
        return ResponseEntity.ok(resp);
    }
}