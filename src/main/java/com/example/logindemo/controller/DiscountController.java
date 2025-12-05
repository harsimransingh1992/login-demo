package com.example.logindemo.controller;

import com.example.logindemo.model.DiscountReason;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.User;
import com.example.logindemo.service.DiscountService;
import com.example.logindemo.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/discounts")
@Slf4j
public class DiscountController {

    @Autowired
    private DiscountService discountService;

    @Autowired
    private UserService userService;

    @PostMapping("/apply/{examinationId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('CLINIC_OWNER') or hasRole('DOCTOR') or hasRole('OPD_DOCTOR')")
    @ResponseBody
    public ResponseEntity<?> applyDiscount(@PathVariable Long examinationId,
                                           @RequestParam(required = false) String reason,
                                           @RequestParam(required = false) Double percentage,
                                           @RequestParam(required = false) String note,
                                           @RequestParam(required = false) String membershipNumber,
                                           Authentication authentication) {
        try {
            User currentUser = userService.findByUsername(authentication.getName())
                    .orElseThrow(() -> new RuntimeException("User not found"));

            // Parse reason if provided
            DiscountReason discountReason = null;
            if (reason != null && !reason.trim().isEmpty()) {
                try {
                    discountReason = DiscountReason.valueOf(reason.trim().toUpperCase());
                } catch (IllegalArgumentException e) {
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                            .body(Map.of("success", false, "message", "Invalid discount reason"));
                }
            }

            // Validate: either a standardized reason (non-OTHER) or a percentage must be provided
            if ((discountReason == null || discountReason == DiscountReason.OTHER) && (percentage == null || percentage <= 0.0)) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(Map.of("success", false, "message", "Provide a valid percentage for OTHER or no reason"));
            }

            ToothClinicalExamination updated = discountService.applyDiscount(examinationId, percentage, discountReason, note, membershipNumber, currentUser);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Discount applied successfully");
            response.put("effectiveTotal", updated.getEffectiveTotalProcedureAmount());
            response.put("discountPercentage", updated.getDiscountPercentage());
            response.put("aggregatedDiscountPercentage", updated.getAggregatedDiscountPercentage());
            response.put("discountReason", updated.getDiscountReason());
            response.put("discountReasonEnum", updated.getDiscountReasonEnum() != null ? updated.getDiscountReasonEnum().name() : null);

            return ResponseEntity.ok(response);
        } catch (AccessDeniedException ade) {
            log.warn("Permission denied applying discount (examId={}, user={}, role={}, reason={}, percentage={}): {}",
                    examinationId,
                    authentication != null ? authentication.getName() : null,
                    authentication != null ? authentication.getAuthorities() : null,
                    reason,
                    percentage,
                    ade.getMessage());
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(Map.of("success", false, "message", ade.getMessage()));
        } catch (Exception e) {
            log.error("Error applying discount for examination {}: {}", examinationId, e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    @PostMapping("/remove/{examinationId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('CLINIC_OWNER') or hasRole('DOCTOR') or hasRole('OPD_DOCTOR')")
    @ResponseBody
    public ResponseEntity<?> removeDiscount(@PathVariable Long examinationId, Authentication authentication) {
        try {
            User currentUser = userService.findByUsername(authentication.getName())
                    .orElseThrow(() -> new RuntimeException("User not found"));

            ToothClinicalExamination updated = discountService.removeDiscount(examinationId, currentUser);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Discount removed successfully");
            response.put("effectiveTotal", updated.getEffectiveTotalProcedureAmount());
            response.put("discountPercentage", updated.getDiscountPercentage());
            response.put("aggregatedDiscountPercentage", updated.getAggregatedDiscountPercentage());
            response.put("discountReason", updated.getDiscountReason());
            response.put("discountReasonEnum", updated.getDiscountReasonEnum() != null ? updated.getDiscountReasonEnum().name() : null);

            return ResponseEntity.ok(response);
        } catch (AccessDeniedException ade) {
            log.warn("Permission denied removing discount (examId={}, user={}, role={}): {}",
                    examinationId,
                    authentication != null ? authentication.getName() : null,
                    authentication != null ? authentication.getAuthorities() : null,
                    ade.getMessage());
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(Map.of("success", false, "message", ade.getMessage()));
        } catch (Exception e) {
            log.error("Error removing discount for examination {}: {}", examinationId, e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    /**
     * Returns the configured discount percentages for each standardized reason.
     */
    @GetMapping("/reasons")
    @PreAuthorize("hasRole('ADMIN') or hasRole('CLINIC_OWNER') or hasRole('DOCTOR') or hasRole('OPD_DOCTOR')")
    @ResponseBody
    public ResponseEntity<?> getDiscountReasons() {
        List<Map<String, Object>> reasons = Arrays.stream(DiscountReason.values())
                .map(r -> {
                    Map<String, Object> m = new HashMap<>();
                    m.put("name", r.name());
                    m.put("label", r.getLabel());
                    m.put("percentage", r.resolvePercentage());
                    return m;
                })
                .collect(Collectors.toList());

        return ResponseEntity.ok(Map.of("success", true, "reasons", reasons));
    }
}
