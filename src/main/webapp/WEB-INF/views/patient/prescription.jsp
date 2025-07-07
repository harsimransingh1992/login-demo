<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
    <title>Dental Prescription - PeriDesk</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        @media print {
            body { margin: 0; padding: 0; }
            .no-print { display: none !important; }
            .prescription-container { 
                margin-top: 120px; /* Space for pre-printed header */
                margin-bottom: 80px; /* Space for pre-printed footer */
                padding: 0 20px;
            }
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: #f5f5f5;
            color: #333;
            line-height: 1.6;
        }
        
        .prescription-container {
            max-width: 800px;
            margin: 0 auto;
            border: 1px solid #ddd;
            padding: 20px;
            background: white;
        }
        
        .prescription-header {
            text-align: center;
            margin-bottom: 20px;
            border-bottom: 2px solid #333;
            padding-bottom: 10px;
        }
        
        .clinic-name {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .clinic-info {
            font-size: 11px;
            color: #666;
        }
        
        .prescription-title {
            font-size: 16px;
            font-weight: bold;
            text-align: center;
            margin: 15px 0;
            text-decoration: underline;
        }
        
        .section-title {
            font-size: 13px;
            font-weight: bold;
            margin: 10px 0 5px 0;
            border-bottom: 1px solid #ccc;
            padding-bottom: 2px;
        }
        
        .patient-grid, .examination-grid, .findings-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
            margin-bottom: 15px;
        }
        
        .patient-item, .examination-item, .findings-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 3px 0;
        }
        
        .patient-label, .examination-label, .findings-label {
            font-weight: bold;
            font-size: 11px;
            min-width: 80px;
        }
        
        .patient-value, .examination-value, .findings-value {
            font-size: 11px;
            text-align: right;
            flex: 1;
        }
        
        .notes-section {
            margin: 15px 0;
        }
        
        .notes-content {
            font-size: 11px;
            padding: 8px;
            border: 1px solid #ddd;
            background: #f9f9f9;
            margin-top: 5px;
        }
        
        .doctor-section {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-top: 30px;
            padding-top: 15px;
            border-top: 1px solid #333;
        }
        
        .doctor-info {
            text-align: left;
        }
        
        .doctor-name {
            font-weight: bold;
            font-size: 12px;
            margin-bottom: 2px;
        }
        
        .doctor-credentials {
            font-size: 10px;
            color: #666;
        }
        
        .signature-area {
            width: 150px;
            height: 60px;
            border-bottom: 1px solid #333;
            text-align: center;
            font-size: 10px;
            color: #666;
            display: flex;
            align-items: flex-end;
            justify-content: center;
        }
        
        .date-section {
            text-align: right;
            font-size: 11px;
            margin-top: 10px;
        }
        
        .print-button {
            position: fixed;
            top: 20px;
            right: 20px;
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
            transition: all 0.3s ease;
        }
        
        .print-button:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(52, 152, 219, 0.4);
        }
        
        .watermark {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-45deg);
            font-size: 4rem;
            color: rgba(52, 152, 219, 0.1);
            font-weight: 700;
            pointer-events: none;
            z-index: -1;
        }
        
        @media (max-width: 768px) {
            .prescription-container {
                margin: 10px;
                border-radius: 8px;
            }
            
            .patient-grid,
            .examination-grid,
            .findings-grid {
                grid-template-columns: 1fr;
            }
            
            .doctor-section {
                flex-direction: column;
                align-items: flex-start;
                gap: 20px;
            }
            
            .print-button {
                position: static;
                margin: 20px auto;
                display: block;
            }
        }
    </style>
</head>
<body>
    <div class="watermark">PRESCRIPTION</div>
    
    <button class="print-button no-print" onclick="window.print()">
        <i class="fas fa-print"></i> Print Prescription
    </button>
    
    <div class="prescription-container">
        <div class="prescription-header">
            <div class="clinic-name">
                <c:choose>
                    <c:when test="${not empty clinic}">${clinic.clinicName}</c:when>
                    <c:otherwise>Dental Clinic</c:otherwise>
                </c:choose>
            </div>
            <div class="clinic-info">
                <c:if test="${not empty clinic}">
                    <c:if test="${not empty clinic.clinicName}">${clinic.clinicName}</c:if>
                    <c:if test="${not empty clinic.owner}">
                        <c:if test="${not empty clinic.owner.address}"> | Address: ${clinic.owner.address}</c:if>
                        <c:if test="${not empty clinic.owner.phoneNumber}"> | Phone: ${clinic.owner.phoneNumber}</c:if>
                        <c:if test="${not empty clinic.owner.email}"> | Email: ${clinic.owner.email}</c:if>
                    </c:if>
                </c:if>
            </div>
        </div>
        
        <div class="prescription-title">DENTAL PRESCRIPTION</div>
        
        <!-- Patient Information - Compact -->
        <div class="section-title">Patient Information</div>
        <div class="patient-grid">
            <div class="patient-item">
                <span class="patient-label">Name:</span>
                <span class="patient-value">
                    <c:choose>
                        <c:when test="${not empty patient.firstName or not empty patient.lastName}">
                            <c:if test="${not empty patient.firstName}">${patient.firstName}</c:if>
                            <c:if test="${not empty patient.lastName}"><c:if test="${not empty patient.firstName}"> </c:if>${patient.lastName}</c:if>
                        </c:when>
                        <c:otherwise>Not available</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="patient-item">
                <span class="patient-label">Reg. Code:</span>
                <span class="patient-value">
                    <c:choose>
                        <c:when test="${not empty patient.registrationCode}">${patient.registrationCode}</c:when>
                        <c:otherwise>Not available</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="patient-item">
                <span class="patient-label">Age/Gender:</span>
                <span class="patient-value">
                    <c:choose>
                        <c:when test="${not empty patient.age}">${patient.age} years</c:when>
                        <c:otherwise>Not available</c:otherwise>
                    </c:choose>
                    /
                    <c:choose>
                        <c:when test="${not empty patient.gender}">${patient.gender}</c:when>
                        <c:otherwise>Not available</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="patient-item">
                <span class="patient-label">Phone:</span>
                <span class="patient-value">
                    <c:choose>
                        <c:when test="${not empty patient.phoneNumber}">${patient.phoneNumber}</c:when>
                        <c:otherwise>Not available</c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>
        
        <!-- Examination Information - Compact -->
        <div class="section-title">Examination Details</div>
        <div class="examination-grid">
            <div class="examination-item">
                <span class="examination-label">Tooth:</span>
                <span class="examination-value">
                    <c:if test="${not empty examination.toothNumber}">${examination.toothNumber}</c:if>
                </span>
            </div>
            <div class="examination-item">
                <span class="examination-label">Date:</span>
                <span class="examination-value">
                    <c:if test="${not empty examination.examinationDate}">
                        <c:set var="dateStr" value="${examination.examinationDate.toString()}" />
                        <c:set var="datePart" value="${fn:substringBefore(dateStr, 'T')}" />
                        <c:set var="year" value="${fn:substring(datePart, 0, 4)}" />
                        <c:set var="month" value="${fn:substring(datePart, 5, 7)}" />
                        <c:set var="day" value="${fn:substring(datePart, 8, 10)}" />
                        ${day}/${month}/${year}
                    </c:if>
                </span>
            </div>
        </div>
        
        <!-- Clinical Findings - Expanded -->
        <div class="section-title">Clinical Findings</div>
        <div class="findings-grid">
            <c:if test="${not empty examination.toothSurface}">
                <div class="findings-item">
                    <span class="findings-label">Surface:</span>
                    <span class="findings-value">${examination.toothSurface}</span>
                </div>
            </c:if>
            <c:if test="${not empty examination.toothCondition}">
                <div class="findings-item">
                    <span class="findings-label">Condition:</span>
                    <span class="findings-value">${examination.toothCondition}</span>
                </div>
            </c:if>
            <c:if test="${not empty examination.existingRestoration}">
                <div class="findings-item">
                    <span class="findings-label">Restoration:</span>
                    <span class="findings-value">${examination.existingRestoration}</span>
                </div>
            </c:if>
            <c:if test="${not empty examination.toothMobility}">
                <div class="findings-item">
                    <span class="findings-label">Mobility:</span>
                    <span class="findings-value">${examination.toothMobility}</span>
                </div>
            </c:if>
            <c:if test="${not empty examination.pocketDepth}">
                <div class="findings-item">
                    <span class="findings-label">Pocket Depth:</span>
                    <span class="findings-value">${examination.pocketDepth}</span>
                </div>
            </c:if>
            <c:if test="${not empty examination.bleedingOnProbing}">
                <div class="findings-item">
                    <span class="findings-label">Bleeding:</span>
                    <span class="findings-value">${examination.bleedingOnProbing}</span>
                </div>
            </c:if>
            <c:if test="${not empty examination.plaqueScore}">
                <div class="findings-item">
                    <span class="findings-label">Plaque Score:</span>
                    <span class="findings-value">${examination.plaqueScore}</span>
                </div>
            </c:if>
            <c:if test="${not empty examination.gingivalRecession}">
                <div class="findings-item">
                    <span class="findings-label">Gingival Recession:</span>
                    <span class="findings-value">${examination.gingivalRecession}</span>
                </div>
            </c:if>
            <c:if test="${not empty examination.toothVitality}">
                <div class="findings-item">
                    <span class="findings-label">Vitality:</span>
                    <span class="findings-value">${examination.toothVitality}</span>
                </div>
            </c:if>
            <c:if test="${not empty examination.furcationInvolvement}">
                <div class="findings-item">
                    <span class="findings-label">Furcation:</span>
                    <span class="findings-value">${examination.furcationInvolvement}</span>
                </div>
            </c:if>
            <c:if test="${not empty examination.toothSensitivity}">
                <div class="findings-item">
                    <span class="findings-label">Sensitivity:</span>
                    <span class="findings-value">${examination.toothSensitivity}</span>
                </div>
            </c:if>
            <c:if test="${not empty examination.periapicalCondition}">
                <div class="findings-item">
                    <span class="findings-label">Periapical Condition:</span>
                    <span class="findings-value">${examination.periapicalCondition}</span>
                </div>
            </c:if>
        </div>
        
        <!-- Clinical Notes - Only if present -->
        <c:if test="${not empty examination.examinationNotes}">
            <div class="notes-section">
                <div class="section-title">Clinical Notes</div>
                <div class="notes-content">${examination.examinationNotes}</div>
            </div>
        </c:if>
        
        <!-- Doctor Signature and Date -->
        <div class="doctor-section">
            <div class="doctor-info">
                <div class="doctor-name">Doctor</div>
                <div class="doctor-credentials">Dental Surgeon</div>
            </div>
            
            <div class="signature-area">
                Signature
            </div>
        </div>
        
        <div class="date-section">
            Date: 
            <c:if test="${not empty examination.examinationDate}">
                <c:set var="dateStr" value="${examination.examinationDate.toString()}" />
                <c:set var="datePart" value="${fn:substringBefore(dateStr, 'T')}" />
                <c:set var="year" value="${fn:substring(datePart, 0, 4)}" />
                <c:set var="month" value="${fn:substring(datePart, 5, 7)}" />
                <c:set var="day" value="${fn:substring(datePart, 8, 10)}" />
                ${day}/${month}/${year}
            </c:if>
        </div>
    </div>
    
    <div style="text-align: center; font-size: 10px; color: #888; margin-top: 30px; margin-bottom: 10px;">
        This is a computer generated prescription, cannot be used for medico-legal purposes.
    </div>
    
    <script>
        // Auto-print when page loads (optional)
        // window.onload = function() {
        //     window.print();
        // };
    </script>
</body>
</html> 