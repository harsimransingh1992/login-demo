package com.example.logindemo.model;

import com.example.logindemo.config.DiscountConfig;

/**
 * Enum representing standardized discount reasons with configurable percentages.
 * Percentages can be overridden via application properties.
 */
public enum DiscountReason {
    GENERAL_DISCOUNT("General Discount", "discount.general.percentage", 5.0),
    EMPLOYEE_FAMILY_DISCOUNT("Employee Discount", "discount.employee_family.percentage", 30.0),
    EMPLOYEE_RELATION_DISCOUNT("Employee Relation Discount", "discount.employee_relation.percentage", 20.0),
    FULL_WAIVE_OFF("Full Waive-Off", "discount.full_waive_off.percentage", 100.0),
    MEMBERSHIP_PLAN_SERVICE("Membership Plan Service", "discount.membership_plan_service.percentage", 100.0),
    OTHER("Other", null, 0.0);

    private final String label;
    private final String propertyKey;
    private final double defaultPercentage;

    DiscountReason(String label, String propertyKey, double defaultPercentage) {
        this.label = label;
        this.propertyKey = propertyKey;
        this.defaultPercentage = defaultPercentage;
    }

    public String getLabel() {
        return label;
    }

    /**
     * Resolves the percentage for this reason, using application properties if available,
     * otherwise falling back to the enum's default percentage. Returns 0 for OTHER.
     */
    public double resolvePercentage() {
        if (propertyKey == null) return 0.0;
        return DiscountConfig.getPercentageOrDefault(propertyKey, defaultPercentage);
    }
}
