package com.example.logindemo.service.impl;

import com.example.logindemo.model.DiscountEntry;
import com.example.logindemo.model.DiscountReason;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.ProcedureStatus;
import com.example.logindemo.model.User;
import com.example.logindemo.model.UserRole;
import com.example.logindemo.repository.DiscountEntryRepository;
import com.example.logindemo.repository.ToothClinicalExaminationRepository;
import com.example.logindemo.service.DiscountService;
import com.example.logindemo.repository.ProcedurePriceHistoryRepository;
import com.example.logindemo.model.ProcedurePriceHistory;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import javax.annotation.Resource;

@Service
@Slf4j
public class DiscountServiceImpl implements DiscountService {

    @Resource(name = "toothClinicalExaminationRepository")
    private ToothClinicalExaminationRepository examinationRepository;

    @Autowired
    private DiscountEntryRepository discountEntryRepository;

    @Autowired
    private ProcedurePriceHistoryRepository priceHistoryRepository;

    @Override
    public boolean canUserApplyDiscount(User user, ToothClinicalExamination examination) {
        if (user == null || examination == null) return false;

        // First check if user has canApplyDiscount permission
        if (user.getCanApplyDiscount() == null || !user.getCanApplyDiscount()) {
            return false;
        }

        UserRole role = user.getRole();

        // Admin and Clinic Owner can apply discount to any examination
        if (role == UserRole.ADMIN || role == UserRole.CLINIC_OWNER) {
            return true;
        }

        // Doctors can apply discount to any examination when permission is enabled
        if (role == UserRole.DOCTOR || role == UserRole.OPD_DOCTOR) {
            return true;
        }

        // Staff cannot apply discounts, even if permission is set
        return false;
    }

    /**
     * Returns a human-readable reason why a user cannot apply a discount.
     * If null is returned, the user is allowed.
     */
    private String getPermissionIssue(User user, ToothClinicalExamination examination) {
        if (user == null) {
            return "User is not authenticated";
        }
        if (examination == null) {
            return "Examination not found";
        }
        if (user.getCanApplyDiscount() == null || !user.getCanApplyDiscount()) {
            return "Missing permission: enable 'canApplyDiscount' for your account";
        }

        UserRole role = user.getRole();
        if (role == UserRole.ADMIN || role == UserRole.CLINIC_OWNER) {
            return null; // allowed
        }

        if (role == UserRole.DOCTOR || role == UserRole.OPD_DOCTOR) {
            // Relaxed: allow doctors to apply discounts regardless of assignment when permission is enabled
            return null; // allowed
        }

        return String.format("Role '%s' not permitted to apply discounts", role);
    }

    @Override
    @Transactional
    public ToothClinicalExamination applyDiscount(Long examinationId,
                                                  Double percentage,
                                                  DiscountReason reason,
                                                  String note,
                                                  String membershipNumber,
                                                  User appliedBy) {
        ToothClinicalExamination examination = examinationRepository.findById(examinationId)
                .orElseThrow(() -> new RuntimeException("Examination not found"));

        String issue = getPermissionIssue(appliedBy, examination);
        if (issue != null) {
            log.warn("Discount permission denied (examId={}, userId={}, role={}, canApplyDiscount={}): {}",
                    examinationId,
                    appliedBy != null ? appliedBy.getId() : null,
                    appliedBy != null ? appliedBy.getRole() : null,
                    appliedBy != null ? appliedBy.getCanApplyDiscount() : null,
                    issue);
            throw new AccessDeniedException(issue);
        }

        // Enforce: discount can be applied only one time
        List<DiscountEntry> activeEntries = examination.getActiveDiscountEntries();
        boolean hasActiveDiscount = activeEntries != null && !activeEntries.isEmpty();
        boolean hasLegacyDiscount = examination.getDiscountPercentage() != null && examination.getDiscountPercentage() > 0.0;
        if (hasActiveDiscount || hasLegacyDiscount) {
            throw new RuntimeException("A discount has already been applied to this examination");
        }

        // For simplicity and consistency: do not allow changing discount after payments have started
        Double totalPaid = examination.getTotalPaidAmount();
        if (totalPaid != null && totalPaid > 0.0) {
            throw new RuntimeException("Cannot apply discount after payments have been recorded");
        }

        // Business rule: Discount should not be applicable if procedure is not assigned.
        // We now enforce strictly on procedure presence regardless of base price snapshot.
        if (examination.getProcedure() == null) {
            throw new RuntimeException("Cannot apply discount: no procedure assigned to examination");
        }

        // If MEMBERSHIP_PLAN_SERVICE is selected, verify membership number matches patient's record
        if (reason == DiscountReason.MEMBERSHIP_PLAN_SERVICE) {
            String patientMembership = examination.getPatient() != null ? examination.getPatient().getMembershipNumber() : null;
            String provided = membershipNumber != null ? membershipNumber.trim() : null;
            if (provided == null || provided.isEmpty()) {
                throw new RuntimeException("Membership number is required for Membership Plan Service discount");
            }
            if (patientMembership == null || !patientMembership.equals(provided)) {
                throw new RuntimeException("Membership number does not match the patient's membership record");
            }
        }

        // Determine applied percentage based on reason or explicit percentage
        double appliedPct;
        DiscountReason appliedReason = reason;
        if (reason != null && reason != DiscountReason.OTHER) {
            appliedPct = reason.resolvePercentage();
        } else {
            appliedReason = (reason != null ? reason : DiscountReason.OTHER);
            appliedPct = percentage != null ? Math.max(0.0, Math.min(percentage, 100.0)) : 0.0;
        }

        // Create and save DiscountEntry
        DiscountEntry entry = new DiscountEntry();
        entry.setExamination(examination);
        entry.setReasonEnum(appliedReason);
        entry.setPercentage(appliedPct);
        entry.setNote(note);
        entry.setAppliedBy(appliedBy);
        entry.setAppliedAt(LocalDateTime.now());
        entry.setActive(true);
        discountEntryRepository.save(entry);

        // Ensure examination has the entry in its collection
        if (examination.getDiscountEntries() == null) {
            examination.setDiscountEntries(new java.util.ArrayList<>());
        }
        examination.getDiscountEntries().add(entry);

        // Update legacy fields for UI compatibility
        examination.updateLegacyDiscountFieldsFromEntries();

        // Update total_procedure_amount to reflect the discounted net amount
        // Prefer the base snapshot captured at association for consistent calculations
        double base = 0.0;
        if (examination.getBasePriceAtAssociation() != null) {
            base = examination.getBasePriceAtAssociation();
        } else if (examination.getProcedure() != null && examination.getProcedure().getPrice() != null) {
            base = examination.getProcedure().getPrice();
        } else if (examination.getTotalProcedureAmount() != null) {
            base = examination.getTotalProcedureAmount();
        }
        double aggregated = examination.getAggregatedDiscountPercentage();
        double net = base * (1 - (aggregated / 100.0));
        examination.setTotalProcedureAmount(net < 0 ? 0.0 : net);

        // If effective net payable is zero after discount, mark payment as completed
        if ((net <= 0.0) || examination.isFullyWaived()) {
            examination.setProcedureStatus(ProcedureStatus.PAYMENT_COMPLETED);
        }

        return examinationRepository.save(examination);
    }

    @Override
    @Transactional
    public ToothClinicalExamination removeDiscount(Long examinationId, User appliedBy) {
        ToothClinicalExamination examination = examinationRepository.findById(examinationId)
                .orElseThrow(() -> new RuntimeException("Examination not found"));

        String issue = getPermissionIssue(appliedBy, examination);
        if (issue != null) {
            log.warn("Discount removal permission denied (examId={}, userId={}, role={}, canApplyDiscount={}): {}",
                    examinationId,
                    appliedBy != null ? appliedBy.getId() : null,
                    appliedBy != null ? appliedBy.getRole() : null,
                    appliedBy != null ? appliedBy.getCanApplyDiscount() : null,
                    issue);
            throw new AccessDeniedException(issue);
        }

        // Do not allow changing discount after payments have started
        Double totalPaid = examination.getTotalPaidAmount();
        if (totalPaid != null && totalPaid > 0.0) {
            throw new RuntimeException("Cannot remove discount after payments have been recorded");
        }

        // Soft-remove all active discount entries to preserve history
        List<DiscountEntry> activeEntries = examination.getActiveDiscountEntries();
        LocalDateTime now = LocalDateTime.now();
        for (DiscountEntry e : activeEntries) {
            e.setActive(false);
            e.setRemovedBy(appliedBy);
            e.setRemovedAt(now);
            discountEntryRepository.save(e);
        }

        // Update legacy fields for UI compatibility
        examination.updateLegacyDiscountFieldsFromEntries();

        // Restore total_procedure_amount to base (no active discounts)
        // Prefer the base snapshot; fallback to historical/current price when missing
        double base = 0.0;
        if (examination.getBasePriceAtAssociation() != null) {
            base = examination.getBasePriceAtAssociation();
        } else if (examination.getProcedure() != null) {
            ProcedurePriceHistory history = null;
            if (examination.getCreatedAt() != null) {
                history = priceHistoryRepository
                        .findFirstByProcedureAndEffectiveFromLessThanEqualOrderByEffectiveFromDesc(
                                examination.getProcedure(), examination.getCreatedAt())
                        .orElse(null);
            }
            base = history != null && history.getPrice() != null
                    ? history.getPrice()
                    : (examination.getProcedure().getPrice() != null ? examination.getProcedure().getPrice() : 0.0);
        } else if (examination.getTotalProcedureAmount() != null) {
            base = examination.getTotalProcedureAmount();
        }
        examination.setTotalProcedureAmount(base);

        return examinationRepository.save(examination);
    }
}
