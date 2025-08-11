<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- Color Code Strip -->
<div class="color-code-strip ${patient.colorCode.name().toLowerCase().replace('_', '-')} clickable-code" 
     data-patient-id="${patient.id}" data-color-code="${patient.colorCode.name()}"></div>

<!-- Color Code Badge (for use in patient meta section) -->
<span class="patient-code-badge ${patient.colorCode.name().toLowerCase().replace('_', '-')} clickable-code" 
      data-patient-id="${patient.id}" data-color-code="${patient.colorCode.name()}">
    ${patient.colorCode.displayName}
    <i class="fas fa-edit" style="margin-left: 5px; font-size: 0.8em;"></i>
</span>

<!-- Color Code Dropdown -->
<div id="colorCodeDropdown" class="color-code-dropdown">
    <div class="color-code-option" data-value="CODE_BLUE">
        <div class="color-code-preview" style="background-color: #0066CC;"></div>
        <span>Code Blue</span>
    </div>
    <div class="color-code-option" data-value="CODE_YELLOW">
        <div class="color-code-preview" style="background-color: #FFD700;"></div>
        <span>Code Yellow</span>
    </div>
    <div class="color-code-option" data-value="NO_CODE">
        <div class="color-code-preview" style="background-color: #E0E0E0;"></div>
        <span>No Code</span>
    </div>
</div> 