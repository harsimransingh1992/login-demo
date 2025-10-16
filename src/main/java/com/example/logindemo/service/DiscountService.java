package com.example.logindemo.service;

import com.example.logindemo.model.DiscountReason;
import com.example.logindemo.model.ToothClinicalExamination;
import com.example.logindemo.model.User;

public interface DiscountService {

    /**
     * Check if a user can apply a discount to the given examination.
     */
    boolean canUserApplyDiscount(User user, ToothClinicalExamination examination);

    /**
     * Apply a discount to an examination using either a percentage or a standardized reason.
     * If a standardized reason is provided (other than OTHER), configured percentages are used.
     * If OTHER or no reason is provided, the explicit percentage is applied.
     */
    ToothClinicalExamination applyDiscount(Long examinationId,
                                           Double percentage,
                                           DiscountReason reason,
                                           String note,
                                           User appliedBy);

    /**
     * Remove any discount from an examination.
     */
    ToothClinicalExamination removeDiscount(Long examinationId, User appliedBy);
}