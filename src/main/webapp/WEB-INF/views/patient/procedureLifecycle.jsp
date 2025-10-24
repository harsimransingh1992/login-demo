<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ page import="com.example.logindemo.model.ProcedureStatus" %>

<!DOCTYPE html>
<html>
<head>
    <title>Procedure Lifecycle - PeriDesk</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/color-code-component.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/chairside-note-component.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/imageCompression.js"></script>
    <script src="${pageContext.request.contextPath}/js/imagePerformanceMonitor.js"></script>
    <script src="${pageContext.request.contextPath}/js/color-code-component.js"></script>
    <script src="${pageContext.request.contextPath}/js/chairside-note-component.js"></script>
    
    <!-- Include common menu styles -->
    <jsp:include page="/WEB-INF/views/common/menuStyles.jsp" />
    
    <script>
    window.showRescheduleNextSittingModal = function(followUpId, examinationId) {
        document.getElementById('rescheduleNextSittingId').value = followUpId;
        document.getElementById('rescheduleExaminationId').value = examinationId;
        var dateInput = document.getElementById('rescheduleDate');
        var timeInput = document.getElementById('rescheduleTime');
        var notesInput = document.getElementById('rescheduleNotes');
        if (dateInput) dateInput.value = '';
        if (timeInput) timeInput.value = '';
        if (notesInput) notesInput.value = '';
        document.getElementById('rescheduleNextSittingModal').style.display = 'block';
    };
    window.showCompleteNextSittingModal = function(followUpId, examinationId) {
        document.getElementById('completeNextSittingId').value = followUpId;
        document.getElementById('completeExaminationId').value = examinationId;
        var notesInput = document.getElementById('clinicalNotes');
        if (notesInput) notesInput.value = '';
        document.getElementById('completeNextSittingModal').style.display = 'block';
    };
    window.showCancelNextSittingModal = function(followUpId, examinationId) {
        document.getElementById('cancelNextSittingId').value = followUpId;
        document.getElementById('cancelExaminationId').value = examinationId;
        document.getElementById('cancelNextSittingModal').style.display = 'block';
    };
    </script>
    
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background: #f0f5fa;
            color: #2c3e50;
            line-height: 1.6;
        }
        
        .welcome-container {
            display: flex;
            min-height: 100vh;
            flex-direction: row;
        }
        
        .main-content {
            flex: 1;
            padding: 40px;
            position: relative;
            overflow-x: auto;
        }
        
        .welcome-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            margin-bottom: 30px;
        }
        
        .welcome-message {
            font-size: 1.5rem;
            color: #2c3e50;
            margin: 0;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
            font-weight: 500;
            font-size: 0.9rem;
            text-decoration: none;
            text-align: center;
            border: none;
        }
        
        /* Image loading optimization styles */
        .image-loading {
            opacity: 0;
            transition: opacity 0.3s ease-in-out;
        }
        
        .image-loaded {
            opacity: 1;
        }
        
        .image-error {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: #e74c3c;
            background: #f8f9fa;
            border: 1px dashed #dee2e6;
            border-radius: 8px;
            padding: 20px;
        }
        
        .image-loading-spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 2px solid #f3f3f3;
            border-top: 2px solid #3498db;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-right: 10px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.2);
        }
        
        /* Ensure button styling is not overridden */
        .welcome-header .btn {
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            gap: 8px !important;
            padding: 10px 20px !important;
            border-radius: 8px !important;
            cursor: pointer !important;
            transition: all 0.3s ease !important;
            font-family: 'Poppins', sans-serif !important;
            font-weight: 500 !important;
            font-size: 0.9rem !important;
            text-decoration: none !important;
            text-align: center !important;
            border: none !important;
        }
        
        .welcome-header .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9) !important;
            color: white !important;
        }
        
        .welcome-header .btn-primary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4) !important;
            transform: translateY(-2px) !important;
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.2) !important;
        }
        
        .btn-secondary {
            background: #95a5a6;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(127, 140, 141, 0.2);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #2ecc71, #27ae60);
            color: white;
        }
        
        .btn-success:hover {
            background: linear-gradient(135deg, #27ae60, #219a52);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(46, 204, 113, 0.2);
        }
        
        .container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            padding: 20px;
            margin-bottom: 20px;
            overflow: hidden;
        }
        
        .section-header {
            margin-bottom: 15px;
            padding-bottom: 12px;
            border-bottom: 1px solid #eee;
        }
        
        .section-header h2 {
            margin: 0;
            color: #2c3e50;
            font-size: 1.4rem;
            margin-bottom: 8px;
        }
        
        .meta-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .meta-item {
            display: flex;
            flex-direction: column;
        }
        
        .meta-label {
            color: #7f8c8d;
            font-size: 0.85rem;
            margin-bottom: 4px;
        }
        
        .meta-value {
            color: #2c3e50;
            font-weight: 500;
            font-size: 0.95rem;
        }
        
        /* Procedure status badge */
        .status-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            color: white;
            margin-left: 10px;
        }
        
        .status-waiting {
            background-color: #f39c12;
        }
        
        .status-assigned {
            background-color: #3498db;
        }
        
        .status-in-progress {
            background-color: #1abc9c;
        }
        
        .status-completed {
            background-color: #2ecc71;
        }
        
        .status-payment-pending {
            background-color: #e67e22;
        }
        
        .status-payment-complete {
            background-color: #9b59b6;
        }
        
        .status-follow-up-scheduled {
            background-color: #34495e;
        }
        
        .status-cancelled {
            background-color: #e74c3c;
        }
        
        /* Motivation Quote Styles */
        .motivation-quote-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }
        
        .motivation-quote-container::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: float 6s ease-in-out infinite;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }
        
        .motivation-quote-content {
            position: relative;
            z-index: 2;
        }
        
        .motivation-quote-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 15px;
        }
        
        .motivation-quote-icon {
            font-size: 1.5rem;
            color: rgba(255, 255, 255, 0.9);
        }
        
        .motivation-quote-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin: 0;
            color: rgba(255, 255, 255, 0.95);
        }
        
        .motivation-quote-text {
            font-size: 1.2rem;
            font-weight: 500;
            line-height: 1.6;
            margin: 0 0 15px 0;
            font-style: italic;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .motivation-quote-author {
            font-size: 0.9rem;
            color: rgba(255, 255, 255, 0.8);
            text-align: right;
            font-weight: 500;
        }
        
        .motivation-quote-category {
            position: absolute;
            top: 15px;
            right: 20px;
            background: rgba(255, 255, 255, 0.2);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            color: white;
            backdrop-filter: blur(10px);
        }
        
        /* Lifecycle timeline */
        .lifecycle-timeline {
            position: relative;
            margin: 40px 0;
            padding-left: 40px;
        }
        
        .timeline-line {
            position: absolute;
            left: 15px;
            top: 0;
            height: 100%;
            width: 2px;
            background-color: #e0e0e0;
        }
        
        .timeline-item {
            position: relative;
            margin-bottom: 30px;
        }
        
        .timeline-dot {
            position: absolute;
            left: -40px;
            top: 0;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background-color: #e0e0e0;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .timeline-dot.completed {
            background-color: #2ecc71;
        }
        
        .timeline-dot i {
            color: white;
            font-size: 0.7rem;
        }
        
        .timeline-content {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            border-left: 3px solid #e0e0e0;
        }
        
        .timeline-content.completed {
            border-left-color: #2ecc71;
        }
        
        .timeline-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 5px;
        }
        
        .timeline-title {
            font-weight: 600;
            color: #2c3e50;
            font-size: 1.1rem;
        }
        
        .timeline-meta {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 3px;
        }
        
        .timeline-timestamp {
            color: #7f8c8d;
            font-size: 0.85rem;
        }
        
        .timeline-user {
            color: #3498db;
            font-size: 0.85rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        
        .user-role {
            color: #95a5a6;
            font-size: 0.8rem;
            font-weight: 400;
        }
        
        .timeline-description {
            color: #2c3e50;
            margin: 5px 0 0 0;
        }
        
        /* Action buttons section */
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
            flex-wrap: wrap;
        }
        
        /* JIRA-like status dropdown */
        .status-dropdown {
            position: relative;
            display: inline-block;
        }
        
        .status-dropdown-btn {
            display: inline-flex;
            align-items: center;
            background-color: #f4f5f7;
            border: 1px solid #dfe1e6;
            border-radius: 3px;
            padding: 8px 12px;
            cursor: pointer;
            font-size: 14px;
            color: #172b4d;
            font-weight: 500;
            transition: background-color 0.2s;
        }
        
        .status-dropdown-btn:hover {
            background-color: #ebecf0;
        }
        
        .status-dropdown-btn.disabled {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }
        
        .status-dropdown-btn.disabled:hover {
            background-color: #f4f5f7;
        }
        
        .status-dropdown-btn.cancelled {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }
        
        .status-dropdown-btn.cancelled:hover {
            background-color: #f4f5f7;
        }
        
        .status-dropdown-btn .current-status {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .status-dropdown-btn .dropdown-icon {
            margin-left: 10px;
            transition: transform 0.2s;
        }
        
        .status-dropdown-content.show + .status-dropdown-btn .dropdown-icon,
        .status-dropdown-btn .dropdown-icon.open {
            transform: rotate(180deg);
        }
        
        .status-dropdown-content {
            display: none;
            position: absolute;
            min-width: 250px;
            background-color: #fff;
            border-radius: 3px;
            box-shadow: 0 4px 8px rgba(9, 30, 66, 0.25);
            z-index: 1000;
            max-height: 400px;
            overflow-y: auto;
            top: 100%;
            left: 0;
            margin-top: 4px;
            border: 1px solid #dfe1e6;
        }
        
        .status-dropdown-content.show {
            display: block;
        }
        
        .status-dropdown-header {
            padding: 10px 12px;
            font-size: 12px;
            color: #6b778c;
            border-bottom: 1px solid #dfe1e6;
        }
        
        .status-option {
            padding: 8px 12px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: background-color 0.2s;
        }
        
        .status-option:hover {
            background-color: #f4f5f7;
        }
        
        .status-option.active {
            background-color: #ebecf0;
        }
        
        .status-dot {
            width: 14px;
            height: 14px;
            border-radius: 50%;
            display: inline-block;
        }
        
        .status-dot.open { background-color: #3498db; }
        .status-dot.payment-pending { background-color: #e67e22; }
        .status-dot.payment-completed { background-color: #9b59b6; }
        .status-dot.payment-denied { background-color: #e74c3c; }
        .status-dot.in-progress { background-color: #1abc9c; }
        .status-dot.on-hold { background-color: #f39c12; }
        .status-dot.completed { background-color: #2ecc71; }
        .status-dot.follow-up-scheduled { background-color: #34495e; }
        .status-dot.follow-up-completed { background-color: #16a085; }
        .status-dot.closed { background-color: #7f8c8d; }
        .status-dot.cancelled { background-color: #c0392b; }
        
        .status-text {
            font-size: 14px;
            color: #172b4d;
        }
        
        .status-description {
            color: #6b778c;
            font-size: 12px;
            margin-top: 2px;
        }
        
        .status-notification {
            display: none;
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: #2ecc71;
            color: white;
            padding: 15px 20px;
            border-radius: 4px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            animation: slideIn 0.3s ease-out;
        }
        
        @keyframes slideIn {
            0% { transform: translateX(100%); opacity: 0; }
            100% { transform: translateX(0); opacity: 1; }
        }
        
        /* Responsive design */
        @media (max-width: 768px) {
            .main-content {
                padding: 20px;
            }
            
            .welcome-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .main-layout {
                grid-template-columns: 1fr !important;
                gap: 15px !important;
            }
            
            .clinical-info-layout {
                grid-template-columns: 1fr !important;
            }
            
            .lifecycle-timeline {
                padding-left: 30px;
            }
            
            .timeline-dot {
                left: -30px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .action-buttons .btn {
                width: 100%;
            }
            
            .status-dropdown {
                width: 100%;
                margin-bottom: 15px;
            }
            
            .status-dropdown-btn {
                width: 100%;
                justify-content: space-between;
            }
            
            .status-dropdown-content {
                width: 100%;
            }
            
            .quick-actions {
                flex-direction: column;
            }
            
            .btn-quick {
                width: 100%;
                justify-content: flex-start;
            }
        }
        
        /* Additional styling for better visual hierarchy */
        .main-layout {
            margin-bottom: 30px;
        }
        
        .left-column, .right-column {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .clinical-card {
            transition: all 0.3s ease;
        }
        
        .clinical-card:hover {
            box-shadow: 0 4px 16px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        
        /* Disable all hover effects when any modal is visible */
        .modal[style*="display: block"] ~ * *:hover,
        .modal[style*="display: block"] *:hover {
            transform: none !important;
            box-shadow: inherit !important;
            background-color: inherit !important;
        }
        
        .clinical-card-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        }
        
        .clinical-card-header h3 {
            color: #495057;
            font-weight: 600;
        }
        
        .clinical-card-header h3 i {
            color: #6c757d;
            margin-right: 8px;
        }
        
        /* New Clinical Interface Styles */
        .clinical-action-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #f8f9fa;
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .quick-actions {
            display: flex;
            gap: 10px;
        }
        
        .btn-quick {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 12px;
            border-radius: 4px;
            background-color: #f1f3f5;
            border: 1px solid #dee2e6;
            color: #495057;
            font-weight: 500;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .btn-quick:hover {
            background-color: #e9ecef;
        }
        
        .btn-quick i {
            margin-right: 6px;
        }
        
        .clinical-info-layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            position: relative;
            z-index: 1;
        }
        
        .clinical-info-column {
            position: relative;
            z-index: 1;
        }
        
        .clinical-card {
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            margin-bottom: 20px;
            border: 1px solid #eaedf0;
        }
        
        .clinical-card-header {
            padding: 12px 15px;
            background-color: #f8f9fa;
            border-bottom: 1px solid #eaedf0;
        }
        
        .clinical-card-header h3 {
            margin: 0;
            font-size: 1.1rem;
            color: #343a40;
            display: flex;
            align-items: center;
        }
        
        .clinical-card-header h3 i {
            margin-right: 8px;
            color: #6c757d;
        }
        
        .clinical-card-body {
            padding: 15px;
        }
        
        .patient-profile {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .patient-image {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            overflow: hidden;
        }
        
        .patient-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .patient-details h4 {
            margin: 0 0 5px 0;
            color: #343a40;
            font-size: 1.2rem;
        }
        
        .patient-id {
            color: #6c757d;
            font-size: 0.85rem;
            margin-bottom: 8px;
        }
        
        .patient-details p {
            margin: 5px 0;
            color: #495057;
            font-size: 0.95rem;
        }
        
        .patient-details p i {
            width: 20px;
            color: #6c757d;
        }
        
        .patient-medical-history {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eaedf0;
        }
        
        .patient-medical-history h5 {
            margin: 0 0 10px 0;
            font-size: 1rem;
            color: #343a40;
        }
        
        .patient-medical-history p {
            margin: 0 0 10px 0;
            color: #495057;
            font-size: 0.95rem;
        }
        
        .view-more {
            display: inline-block;
            color: #3498db;
            font-size: 0.9rem;
            text-decoration: none;
        }
        
        .view-more:hover {
            text-decoration: underline;
        }
        
        .procedure-info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }
        
        .procedure-info-item {
            display: flex;
            flex-direction: column;
        }
        
        .info-label {
            color: #6c757d;
            font-size: 0.85rem;
            margin-bottom: 4px;
        }
        
        .info-value {
            color: #343a40;
            font-weight: 500;
            font-size: 0.95rem;
        }
        
        .payment-status {
            font-weight: 600;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.9rem;
        }
        
        .payment-status.remaining {
            color: #e67e22;
            background-color: #fff3cd;
        }
        
        .payment-status.completed {
            color: #2ecc71;
            background-color: #d4edda;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
        }
        
        .form-row {
            display: flex;
            gap: 15px;
        }
        
        .form-group-half {
            flex: 1;
        }
        
        .form-actions {
            margin-top: 20px;
            display: flex;
            justify-content: flex-end;
        }
        
        .follow-up-required {
            margin-bottom: 15px;
        }
        
        .follow-up-toggle {
            display: flex;
            gap: 15px;
            margin-top: 8px;
        }
        
        .follow-up-toggle input[type="radio"] {
            margin-right: 5px;
        }
        
        .follow-up-reason {
            margin-top: 15px;
        }
        
        .checkbox-list {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
            margin-top: 8px;
        }
        
        .checkbox-item {
            display: flex;
            align-items: center;
        }
        
        .checkbox-item input[type="checkbox"] {
            margin-right: 6px;
        }
        
        @media (max-width: 992px) {
            .clinical-info-layout {
                grid-template-columns: 1fr;
            }
            
            .checkbox-list {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 768px) {
            .clinical-action-bar {
                flex-direction: column;
                align-items: stretch;
                gap: 15px;
            }
            
            .quick-actions {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
            }
            
            .form-row {
                flex-direction: column;
                gap: 10px;
            }
        }
        
        /* Timeline Navigation */
        .timeline-navigation {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            overflow-x: auto;
            padding-bottom: 5px;
        }
        
        .timeline-nav-item {
            padding: 8px 15px;
            background-color: #f8f9fa;
            border-radius: 20px;
            font-size: 0.85rem;
            color: #495057;
            cursor: pointer;
            white-space: nowrap;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 5px;
            border: 1px solid #dee2e6;
        }
        
        .timeline-nav-item:hover {
            background-color: #e9ecef;
            color: #212529;
        }
        
        .timeline-details {
            margin-top: 10px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 4px;
            font-size: 0.9em;
        }
        
        .detail-item {
            display: flex;
            margin-bottom: 5px;
        }
        
        .detail-label {
            font-weight: 600;
            color: #2c3e50;
            min-width: 120px;
        }
        
        .detail-value {
            color: #212529;
            flex: 1;
            line-height: 1.4;
        }
        
        .timeline-content.completed {
            background: #e8f5e9;
            border-left: 4px solid #4caf50;
        }
        
        .timeline-dot.completed {
            background: #4caf50;
            border-color: #4caf50;
        }
        
        /* Payment Pending Alert Styles */
        .payment-pending-alert {
            display: flex;
            align-items: flex-start;
            background-color: #fff3cd;
            border: 1px solid #ffeeba;
            border-radius: 8px;
            padding: 15px;
            margin: 20px 0;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .alert-icon {
            font-size: 24px;
            color: #856404;
            margin-right: 15px;
            padding-top: 2px;
        }
        
        .alert-content {
            flex: 1;
        }
        
        .alert-content h4 {
            color: #856404;
            margin: 0 0 8px 0;
            font-size: 1.1rem;
        }
        
        .alert-content p {
            color: #856404;
            margin: 0 0 12px 0;
            font-size: 0.95rem;
        }
        
        .alert-details {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }
        
        .detail-item {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #856404;
            font-size: 0.9rem;
        }
        
        .detail-item i {
            font-size: 1rem;
        }
        
        @media (max-width: 768px) {
            .payment-pending-alert {
                flex-direction: column;
            }
            
            .alert-icon {
                margin-right: 0;
                margin-bottom: 10px;
            }
            
            .alert-details {
                flex-direction: column;
                gap: 10px;
            }
        }
        
        /* Tooltip Styles */
        .tooltip-container {
            position: relative;
            display: inline-block;
        }
        
        .tooltip-text {
            visibility: hidden;
            width: 250px;
            background-color: #333;
            color: #fff;
            text-align: center;
            border-radius: 6px;
            padding: 8px;
            position: absolute;
            z-index: 1001;
            bottom: 125%;
            left: 50%;
            transform: translateX(-50%);
            opacity: 0;
            transition: opacity 0.3s;
            font-size: 0.85rem;
            font-weight: normal;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        
        .tooltip-text::after {
            content: "";
            position: absolute;
            top: 100%;
            left: 50%;
            margin-left: -5px;
            border-width: 5px;
            border-style: solid;
            border-color: #333 transparent transparent transparent;
        }
        
        .tooltip-container:hover .tooltip-text {
            visibility: visible;
            opacity: 1;
        }
        
        /* Simple Modal Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(5px);
            -webkit-backdrop-filter: blur(5px);
            z-index: 10000;
        }
        
        /* Alternative flexbox centering for better alignment */
        .modal.flex-center {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .modal.flex-center .modal-content {
            margin: 0;
            position: relative;
        }
        
        .modal-options {
            display: flex;
            gap: 10px;
            margin: 20px 0;
        }
        
        .modal-options .btn {
            flex: 1;
        }
        
        /* Ensure modal content stays white and properly positioned */
        .modal .modal-content {
            background-color: white !important;
            position: relative;
            margin: 5% auto;
            padding: 20px;
            border-radius: 8px;
            width: 90%;
            max-width: 600px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
            max-height: 90vh;
            overflow-y: auto;
        }
        
        /* Specific styles for reopenModal to ensure better alignment */
        #reopenModal .modal-content {
            margin: 2% auto;
            width: 95%;
            max-width: 700px;
            padding: 25px;
        }
        
        /* Improve form spacing in reopenModal */
        #reopenModal .form-group {
            margin-bottom: 20px;
        }
        
        #reopenModal .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 0.95rem;
            line-height: 1.4;
            resize: vertical;
        }
        
        #reopenModal .reopen-warning {
            margin-bottom: 25px;
        }
        
        #reopenModal .modal-header h3 {
            margin: 0;
            font-size: 1.3rem;
            color: #2c3e50;
        }
        
        #reopenModal .modal-footer {
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        
        /* Prevent modal content from turning black on hover */
        .modal .modal-content:hover,
        .modal .modal-content *:hover {
            background-color: white !important;
            color: inherit !important;
        }
        
        /* Ensure modal buttons stay properly colored */
        .modal .btn:hover {
            background-color: inherit !important;
            color: inherit !important;
        }
        
        /* Attached Images Styles */
        .image-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            transition: all 0.3s ease;
            border: 1px solid #e9ecef;
        }
        
        .image-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
        }
        
        .image-card .image-preview {
            position: relative;
            height: 180px;
            overflow: hidden;
            background: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .image-card .image-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            cursor: pointer;
            transition: transform 0.3s ease;
        }
        
        .image-card .image-preview img:hover {
            transform: scale(1.05);
        }
        
        .image-card .image-preview .pdf-thumbnail {
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: #e3f2fd;
            cursor: pointer;
            color: #1976d2;
        }
        
        .image-card .image-preview .pdf-thumbnail i {
            font-size: 3rem;
            margin-bottom: 10px;
        }
        
        .image-card .image-preview .pdf-thumbnail .pdf-filename {
            font-size: 0.9rem;
            text-align: center;
            max-width: 90%;
            word-break: break-word;
        }
        
        .image-card .image-info {
            padding: 15px;
        }
        
        .image-card .image-type {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
            font-size: 0.95rem;
        }
        
        .image-card .image-upload-date {
            color: #7f8c8d;
            font-size: 0.85rem;
            margin-bottom: 12px;
        }
        
        .image-card .image-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        
        .image-card .image-actions .btn {
            flex: 1;
            min-width: 80px;
            font-size: 0.8rem;
            padding: 6px 12px;
        }
        
        .image-card .image-actions .btn i {
            margin-right: 4px;
        }
        
        /* Image Modal Styles */
        .image-modal {
            display: none;
            position: fixed;
            z-index: 10000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.8);
            backdrop-filter: blur(5px);
        }
        
        .image-modal.show {
            display: block;
        }
        
        .image-modal-content {
            position: relative;
            margin: 2% auto;
            padding: 0;
            width: 90%;
            max-width: 800px;
            max-height: 90vh;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }
        
        .image-modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            background: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
        }
        
        .image-modal-header h3 {
            margin: 0;
            color: #2c3e50;
            font-size: 1.2rem;
        }
        
        .image-modal-close {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: #6c757d;
            padding: 5px;
            border-radius: 50%;
            width: 35px;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }
        
        .image-modal-close:hover {
            background: #e9ecef;
            color: #495057;
        }
        
        .image-modal-body {
            padding: 0;
            text-align: center;
            max-height: 70vh;
            overflow: auto;
        }
        
        .image-modal-body img {
            max-width: 100%;
            max-height: 70vh;
            object-fit: contain;
        }
        
        .image-modal-body iframe {
            width: 100%;
            height: 70vh;
            border: none;
        }
        
        /* Collapsible Images Section Styles */
        .attached-images-section .section-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px 20px;
            transition: all 0.3s ease;
            user-select: none;
        }
        
        .attached-images-section .section-header:hover {
            background: linear-gradient(135deg, #e9ecef 0%, #dee2e6 100%);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        .attached-images-section .section-header:active {
            transform: translateY(1px);
        }
        
        #imagesToggleIcon {
            color: #6c757d;
            transition: transform 0.3s ease;
        }
        
        #imagesSectionContent {
            transition: all 0.3s ease;
            overflow: hidden;
        }
        
        .modal-content {
            background-color: white;
            margin: 2% auto;
            padding: 0;
            border-radius: 12px;
            width: 100%;
            max-width: 600px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.4);
            animation: modalSlideIn 0.3s ease-out;
            position: relative;
            z-index: 9999;
        }
        
        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(-30px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 25px;
            border-bottom: 1px solid #eee;
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
            border-radius: 12px 12px 0 0;
            position: sticky;
            top: 0;
            z-index: 10;
        }
        
        /* Follow-up Modal Specific Styles */
        #completeFollowUpModal .modal-header,
        #rescheduleFollowUpModal .modal-header,
        #cancelFollowUpModal .modal-header {
            background: linear-gradient(135deg, #3498db, #2980b9);
        }
        
        #completeFollowUpModal .modal-footer .btn-success,
        #rescheduleFollowUpModal .modal-footer .btn-warning,
        #cancelFollowUpModal .modal-footer .btn-danger {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border: none;
        }
        
        #completeFollowUpModal .modal-footer .btn-success:hover,
        #rescheduleFollowUpModal .modal-footer .btn-warning:hover,
        #cancelFollowUpModal .modal-footer .btn-danger:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-1px);
        }
        
        .modal-header h3 {
            margin: 0;
            font-size: 1.3rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .close-modal {
            color: white;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            line-height: 1;
            padding: 5px;
            border-radius: 4px;
            transition: background-color 0.2s;
        }
        
        .close-modal:hover {
            background-color: rgba(255, 255, 255, 0.2);
        }
        
        .modal-body {
            padding: 25px;
            max-height: 60vh;
            overflow-y: auto;
        }
        
        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            padding: 20px 25px;
            border-top: 1px solid #eee;
            background: #f8f9fa;
            border-radius: 0 0 12px 12px;
            position: sticky;
            bottom: 0;
            z-index: 10;
        }
        
        .modal-footer .btn {
            min-width: 120px;
            font-weight: 500;
            padding: 12px 20px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        
        .modal-footer .btn-secondary {
            background: #6c757d;
            color: white;
            border: none;
        }
        
        .modal-footer .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-1px);
        }
        
        .modal-footer .btn-primary {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
            border: none;
        }
        
        .modal-footer .btn-primary:hover:not(:disabled) {
            background: linear-gradient(135deg, #c0392b, #a93226);
            transform: translateY(-1px);
        }
        
        .modal-footer .btn-primary:disabled {
            background: #bdc3c7;
            color: #7f8c8d;
            cursor: not-allowed;
            transform: none;
        }
        
        .xray-upload-section {
            background: white;
            border-radius: 8px;
            padding: 20px;
            border: 2px solid #e8f5e9;
        }
        
        .xray-upload-section h3 {
            color: #2c3e50;
            font-size: 1.2rem;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .xray-upload-section h3 i {
            color: #e74c3c;
        }
        
        .upload-description {
            color: #7f8c8d;
            font-size: 0.9rem;
            margin-bottom: 20px;
            line-height: 1.5;
        }
        
        .xray-upload-container {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .xray-upload-item {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        
        .upload-label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            color: #2c3e50;
            font-size: 0.95rem;
        }
        
        .upload-label i {
            color: #e74c3c;
        }
        
        .required-indicator {
            color: #e74c3c;
            font-weight: bold;
        }
        
        .xray-file-input {
            display: none;
        }
        
        .xray-preview {
            border: 2px dashed #bdc3c7;
            border-radius: 8px;
            padding: 30px;
            text-align: center;
            background: #f8f9fa;
            cursor: pointer;
            transition: all 0.3s ease;
            min-height: 150px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .xray-preview:hover {
            border-color: #e74c3c;
            background: #fff5f5;
        }
        
        .xray-preview i {
            font-size: 3rem;
            color: #bdc3c7;
        }
        
        .xray-preview span {
            color: #7f8c8d;
            font-size: 0.9rem;
        }
        
        .xray-preview img {
            max-width: 100%;
            max-height: 120px;
            border-radius: 4px;
            object-fit: cover;
        }
        
        .upload-status {
            font-size: 0.85rem;
            padding: 5px 0;
        }
        
        .upload-status.success {
            color: #27ae60;
        }
        
        .upload-status.error {
            color: #e74c3c;
        }
        
        .upload-status.loading {
            color: #f39c12;
        }
        
        .upload-validation {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 6px;
            padding: 12px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
            color: #856404;
        }
        
        .upload-validation.success {
            background: #d4edda;
            border-color: #c3e6cb;
            color: #155724;
        }
        
        .upload-validation.error {
            background: #f8d7da;
            border-color: #f5c6cb;
            color: #721c24;
        }
        
        .upload-validation i {
            font-size: 1rem;
        }
        
        /* Responsive Modal Styles */
        @media (max-width: 768px) {
            .modal {
                padding: 10px;
            }
            
            .modal-content {
                margin: 5% auto;
                max-height: 95vh;
                width: 95%;
            }
            
            #reopenModal .modal-content {
                margin: 2% auto;
                width: 98%;
                max-width: none;
                padding: 20px;
            }
            
            .modal-header {
                padding: 15px 20px;
            }
            
            .modal-header h3 {
                font-size: 1.1rem;
            }
            
            .modal-body {
                padding: 20px;
                max-height: 60vh;
            }
        }
        
        /* Large screen optimizations */
        @media (min-width: 1200px) {
            #reopenModal .modal-content {
                margin: 3% auto;
                width: 60%;
                max-width: 800px;
            }
        }
        
        /* Extra large screen optimizations */
        @media (min-width: 1600px) {
            #reopenModal .modal-content {
                margin: 5% auto;
                width: 50%;
                max-width: 900px;
            }
        }
        
        @media (max-width: 768px) {
            .modal-footer {
                padding: 15px 20px;
                flex-direction: column;
                gap: 10px;
            }
            
            .modal-footer .btn {
                width: 100%;
                min-width: auto;
            }
            
            .xray-preview {
                min-height: 120px;
                padding: 20px;
            }
            
            .xray-preview i {
                font-size: 2.5rem;
            }
        }
        
        @media (max-width: 480px) {
            .modal-content {
                margin: 2% auto;
                width: 98%;
            }
            
            .modal-header {
                padding: 12px 15px;
            }
            
            .modal-body {
                padding: 15px;
            }
            
            .modal-footer {
                padding: 12px 15px;
            }
        }
        
        /* Follow-up Modal Styles */
        .follow-up-scheduling-section {
            padding: 15px 0;
        }
        
        .scheduling-description {
            color: #2c3e50;
            font-size: 0.95rem;
            margin-bottom: 15px;
            line-height: 1.4;
        }
        
        .validation-message {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 10px;
            border-radius: 6px;
            margin-top: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
        }
        
        .validation-message i {
            color: #f39c12;
        }
        
        .required-indicator {
            color: #e74c3c;
            font-weight: bold;
        }
        
        .form-group-half {
            width: 48%;
        }
        
        .form-row {
            display: flex;
            gap: 15px;
            margin-bottom: 12px;
        }
        
        .form-group {
            margin-bottom: 12px;
        }
        
        .form-group label {
            font-size: 0.9rem;
            margin-bottom: 5px;
        }
        
        .form-control {
            padding: 8px 12px;
            font-size: 0.9rem;
        }
        
        #modalFollowupNotes {
            resize: vertical;
            min-height: 60px;
            max-height: 100px;
        }
        
        /* Follow-up History Styles */
        .follow-up-stats {
            display: flex;
            gap: 20px;
            margin-top: 15px;
            flex-wrap: wrap;
        }
        
        .stat-item {
            display: flex;
            align-items: center;
            gap: 8px;
            background: #f8f9fa;
            padding: 8px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
            color: #495057;
            font-weight: 500;
        }
        
        .stat-item i {
            color: #28a745;
        }
        
        .follow-up-history {
            display: flex;
            flex-direction: column;
            gap: 20px;
            margin-top: 20px;
        }
        
        .follow-up-card {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }
        
        .follow-up-card:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            transform: translateY(-2px);
        }
        
        .follow-up-card.scheduled {
            border-left: 4px solid #f39c12;
        }
        
        .follow-up-card.completed {
            border-left: 4px solid #27ae60;
        }
        
        .follow-up-card.cancelled {
            border-left: 4px solid #e74c3c;
        }
        
        .follow-up-card.no_show {
            border-left: 4px solid #95a5a6;
        }
        
        .follow-up-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .follow-up-number {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .sequence-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .follow-up-number h4 {
            margin: 0;
            color: #2c3e50;
            font-size: 1.1rem;
        }
        
        .follow-up-status {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-badge.scheduled {
            background: #f39c12;
            color: #ffffff;
        }
        
        .status-badge.completed {
            background: #27ae60;
            color: #ffffff;
        }
        
        .status-badge.cancelled {
            background: #e74c3c;
            color: #ffffff;
        }
        
        .status-badge.no_show {
            background: #95a5a6;
            color: #ffffff;
        }
        
        .latest-badge {
            background: #007bff;
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 0.7rem;
            font-weight: 600;
        }
        
        .follow-up-details {
            margin-bottom: 15px;
        }
        
        .follow-up-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .btn-sm {
            padding: 6px 12px;
            font-size: 0.8rem;
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        
        <div class="main-content">
            <div class="welcome-header">
                <h1 class="welcome-message">
                    Procedure Lifecycle
                </h1>
                <div>
                    <a href="${pageContext.request.contextPath}/patients/examination/${examination.id}" class="btn btn-primary">
                        <i class="fas fa-arrow-left"></i> Back to Examination
                    </a>
                    <a href="${pageContext.request.contextPath}/patients/details/${patient.id}" class="btn btn-primary" style="margin-left:8px;">
                        <i class="fas fa-user"></i> Back to Patient Details
                    </a>
                </div>
            </div>
            
            <!-- Motivation Quote for In Progress Cases -->
            <c:if test="${not empty motivationQuote}">
            <div class="motivation-quote-container">
                <div class="motivation-quote-category">${motivationQuote.category}</div>
                <div class="motivation-quote-content">
                    <div class="motivation-quote-header">
                        <i class="fas fa-lightbulb motivation-quote-icon"></i>
                        <h3 class="motivation-quote-title">Daily Inspiration</h3>
                    </div>
                    <p class="motivation-quote-text">"${motivationQuote.quoteText}"</p>
                    <div class="motivation-quote-author">— ${motivationQuote.author}</div>
                </div>
            </div>
            </c:if>
            
            <!-- Collapsible Follow-up Section (at the top, after header) -->
            <div class="container follow-up-container" style="margin-bottom: 30px; background: linear-gradient(135deg, #3498db 0%, #2980b9 100%); border-radius: 16px; box-shadow: 0 8px 32px rgba(52, 152, 219, 0.15); overflow: hidden;">
                <div class="follow-up-collapsible-header" style="display: flex; align-items: center; justify-content: space-between; padding: 20px 25px; background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); border-bottom: 1px solid rgba(255, 255, 255, 0.2);">
                    <div style="display: flex; align-items: center; gap: 15px;">
                        <div style="width: 40px; height: 40px; background: linear-gradient(135deg, #3498db, #2980b9); border-radius: 50%; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);">
                            <i class="fas fa-calendar-alt" style="color: white; font-size: 1.1rem;"></i>
                        </div>
                        <div>
                            <span style="font-weight: 700; font-size: 1.2rem; color: #2c3e50; margin-bottom: 2px; display: block;">Next Sitting Management</span>
                            <c:choose>
                                <c:when test="${not empty followUpRecords}">
                                    <c:set var="scheduledCount" value="0" />
                                    <c:forEach var="followUp" items="${followUpRecords}">
                                        <c:if test="${followUp.status.name() == 'SCHEDULED'}">
                                            <c:set var="scheduledCount" value="${scheduledCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${scheduledCount > 0}">
                                        <span style="font-size: 0.9rem; color: #27ae60; font-weight: 600; display: flex; align-items: center; gap: 5px;">
                                            <i class="fas fa-clock" style="font-size: 0.8rem;"></i>
                                            ${scheduledCount} Active Next Sitting${scheduledCount > 1 ? 's' : ''}
                                        </span>
                                    </c:if>
                                    <c:if test="${scheduledCount == 0}">
                                        <span style="font-size: 0.9rem; color: #95a5a6; font-weight: 500; display: flex; align-items: center; gap: 5px;">
                                            <i class="fas fa-check-circle" style="font-size: 0.8rem;"></i>
                                            No Active Next Sittings
                                        </span>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <span style="font-size: 0.9rem; color: #95a5a6; font-weight: 500; display: flex; align-items: center; gap: 5px;">
                                        <i class="fas fa-info-circle" style="font-size: 0.8rem;"></i>
                                        No Follow-up Scheduled
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <button id="nextSittingToggleBtn" class="btn btn-sm" type="button" style="background: linear-gradient(135deg, #3498db, #2980b9); color: white; border: none; padding: 10px 16px; border-radius: 25px; font-size: 0.9rem; font-weight: 600; box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3); transition: all 0.3s ease;" onclick="toggleNextSittingSection()">
                        <span id="nextSittingToggleIcon" class="fas fa-chevron-down" style="margin-right: 6px;"></span>
                        <span>View Details</span>
                    </button>
                </div>
                <div id="nextSittingSectionBody" style="display: none; background: white; padding: 25px;">
                    <!-- BEGIN: Follow-up Planning Form, Scheduling Modal, History, and Modals -->
                    <!-- (Move all follow-up related code from the bottom of the file here) -->

                    <!-- Follow-up History Section -->
                    <c:if test="${not empty followUpRecords}">
                        <div class="container" style="background: #f8f9fa; border-radius: 12px; padding: 20px; margin-bottom: 20px;">
                            <div class="section-header" style="margin-bottom: 20px;">
                                <h2 style="color: #2c3e50; font-size: 1.3rem; margin-bottom: 15px; display: flex; align-items: center; gap: 10px;">
                                    <i class="fas fa-history" style="color: #3498db;"></i> 
                                    Next Sitting History
                                </h2>
                                <div class="follow-up-stats" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 15px;">
                                    <div class="stat-item" style="background: white; padding: 12px 16px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); text-align: center;">
                                        <i class="fas fa-calendar-check" style="color: #3498db; font-size: 1.2rem; margin-bottom: 5px; display: block;"></i>
                                        <div style="font-size: 1.1rem; font-weight: 700; color: #2c3e50;">${followUpStats.totalFollowUps}</div>
                                        <div style="font-size: 0.8rem; color: #7f8c8d;">Total</div>
                                    </div>
                                    <div class="stat-item" style="background: white; padding: 12px 16px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); text-align: center;">
                                        <i class="fas fa-check-circle" style="color: #27ae60; font-size: 1.2rem; margin-bottom: 5px; display: block;"></i>
                                        <div style="font-size: 1.1rem; font-weight: 700; color: #2c3e50;">${followUpStats.completedFollowUps}</div>
                                        <div style="font-size: 0.8rem; color: #7f8c8d;">Completed</div>
                                    </div>
                                    <div class="stat-item" style="background: white; padding: 12px 16px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); text-align: center;">
                                        <i class="fas fa-clock" style="color: #f39c12; font-size: 1.2rem; margin-bottom: 5px; display: block;"></i>
                                        <div style="font-size: 1.1rem; font-weight: 700; color: #2c3e50;">${followUpStats.scheduledFollowUps}</div>
                                        <div style="font-size: 0.8rem; color: #7f8c8d;">Scheduled</div>
                                    </div>
                                    <div class="stat-item" style="background: white; padding: 12px 16px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); text-align: center;">
                                        <i class="fas fa-percentage" style="color: #9b59b6; font-size: 1.2rem; margin-bottom: 5px; display: block;"></i>
                                        <div style="font-size: 1.1rem; font-weight: 700; color: #2c3e50;">${followUpStats.completionRate}%</div>
                                        <div style="font-size: 0.8rem; color: #7f8c8d;">Success Rate</div>
                                    </div>
                                </div>
                            </div>
                            <div class="follow-up-history" style="display: flex; flex-direction: column; gap: 15px;">
                                <c:forEach var="followUp" items="${followUpRecords}" varStatus="status">
                                    <div class="follow-up-card ${followUp.status.name().toLowerCase()}" style="background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 16px rgba(0,0,0,0.1); transition: all 0.3s ease;">
                                        <div class="follow-up-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                                            <div class="follow-up-number" style="display: flex; align-items: center; gap: 12px;">
                                                <span class="sequence-badge" style="background: linear-gradient(135deg, #3498db, #2980b9); color: white; padding: 6px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 700;">${followUp.sequenceNumber}</span>
                                                <h4 style="margin: 0; color: #2c3e50; font-size: 1.1rem;">${followUp.followUpNumber}</h4>
                                            </div>
                                            <div class="follow-up-status" style="display: flex; align-items: center; gap: 8px;">
                                                <span class="status-badge ${followUp.status.name().toLowerCase()}" style="padding: 6px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 600;">
                                                        ${followUp.status.label}
                                                </span>
                                                <c:if test="${followUp.isLatest}">
                                                    <span class="latest-badge" style="background: #667eea; color: white; padding: 4px 8px; border-radius: 12px; font-size: 0.7rem; font-weight: 600;">Latest</span>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="follow-up-details" style="margin-bottom: 15px;">
                                            <div class="detail-row" style="display: flex; margin-bottom: 8px; align-items: center;">
                                                <span class="detail-label" style="font-weight: 600; color: #7f8c8d; min-width: 120px; font-size: 0.9rem;">Scheduled Date:</span>
                                                <span class="detail-value" style="color: #2c3e50; font-weight: 500;">
                                                    <c:if test="${not empty followUp.scheduledDate}">
                                                        <i class="fas fa-calendar" style="color: #667eea; margin-right: 5px;"></i>
                                                        ${followUp.formattedScheduledDate}
                                                    </c:if>
                                                </span>
                                            </div>
                                            <c:if test="${not empty followUp.completedDate}">
                                                <div class="detail-row" style="display: flex; margin-bottom: 8px; align-items: center;">
                                                    <span class="detail-label" style="font-weight: 600; color: #7f8c8d; min-width: 120px; font-size: 0.9rem;">Completed Date:</span>
                                                    <span class="detail-value" style="color: #2c3e50; font-weight: 500;">
                                                        <i class="fas fa-check-circle" style="color: #27ae60; margin-right: 5px;"></i>
                                                        ${followUp.formattedCompletedDate}
                                                    </span>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty followUp.assignedDoctor}">
                                                <div class="detail-row" style="display: flex; margin-bottom: 8px; align-items: center;">
                                                    <span class="detail-label" style="font-weight: 600; color: #7f8c8d; min-width: 120px; font-size: 0.9rem;">Assigned Doctor:</span>
                                                    <span class="detail-value" style="color: #2c3e50; font-weight: 500;">
                                                        <i class="fas fa-user-md" style="color: #667eea; margin-right: 5px;"></i>
                                                        Dr. ${followUp.assignedDoctor.firstName} ${followUp.assignedDoctor.lastName}
                                                    </span>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty followUp.followUpNotes}">
                                                <div class="detail-row" style="display: flex; margin-bottom: 8px; align-items: flex-start;">
                                                    <span class="detail-label" style="font-weight: 600; color: #7f8c8d; min-width: 120px; font-size: 0.9rem;">Instructions:</span>
                                                    <span class="detail-value" style="color: #2c3e50; font-weight: 500; flex: 1;">
                                                        <i class="fas fa-sticky-note" style="color: #f39c12; margin-right: 5px;"></i>
                                                        ${followUp.followUpNotes}
                                                    </span>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty followUp.clinicalNotes}">
                                                <div class="detail-row" style="display: flex; margin-bottom: 8px; align-items: flex-start;">
                                                    <span class="detail-label" style="font-weight: 600; color: #7f8c8d; min-width: 120px; font-size: 0.9rem;">Clinical Notes:</span>
                                                    <span class="detail-value" style="color: #2c3e50; font-weight: 500; flex: 1;">
                                                        <i class="fas fa-notes-medical" style="color: #9b59b6; margin-right: 5px;"></i>
                                                        ${followUp.clinicalNotes}
                                                    </span>
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="follow-up-actions" style="display: flex; gap: 10px; flex-wrap: wrap;">
                                            <c:if test="${followUp.status.name() == 'SCHEDULED'}">
                                                <!-- Simple form-based actions using dedicated FollowUpController -->
                                                <button type="button" class="btn btn-sm btn-success" onclick="showCompleteNextSittingModal('${followUp.id}', '${examination.id}')" style="background: linear-gradient(135deg, #27ae60, #2ecc71); border: none; padding: 8px 16px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; box-shadow: 0 2px 8px rgba(39, 174, 96, 0.3);">
                                                    <i class="fas fa-check"></i> Mark Complete
                                                </button>
                                                <button type="button" class="btn btn-sm btn-warning" onclick="showRescheduleNextSittingModal('${followUp.id}', '${examination.id}')" style="background: linear-gradient(135deg, #f39c12, #e67e22); border: none; padding: 8px 16px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; box-shadow: 0 2px 8px rgba(243, 156, 18, 0.3);">
                                                    <i class="fas fa-calendar-alt"></i> Reschedule
                                                </button>
                                                <button type="button" class="btn btn-sm btn-danger" onclick="showCancelNextSittingModal('${followUp.id}', '${examination.id}')" style="background: linear-gradient(135deg, #e74c3c, #c0392b); border: none; padding: 8px 16px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; box-shadow: 0 2px 8px rgba(231, 76, 60, 0.3);">
                                                    <i class="fas fa-times"></i> Cancel
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <!-- Schedule New Next-sitting Section - Show when status is FOLLOW_UP_SCHEDULED -->
                    <c:if test="${examination.procedureStatus.name() == 'FOLLOW_UP_SCHEDULED'}">
                        <c:choose>
                            <c:when test="${followUpStats.scheduledFollowUps > 0}">
                                <div class="container" style="background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 12px; padding: 20px; margin-bottom: 20px;">
                                    <div class="section-header" style="margin-bottom: 10px; display: flex; align-items: center; gap: 10px;">
                                        <i class="fas fa-exclamation-triangle" style="color: #f39c12; font-size: 1.3rem;"></i>
                                        <span style="color: #856404; font-size: 1.1rem; font-weight: 600;">Cannot schedule a new next sitting</span>
                                    </div>
                                    <div style="color: #856404; font-size: 0.95rem;">
                                        You must complete, reschedule, or cancel the current scheduled next sitting before creating a new one. This ensures a clear next sitting history for the case.
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="container" style="background: #e8f5e8; border: 1px solid #c3e6c3; border-radius: 12px; padding: 20px; margin-bottom: 20px;">
                                    <div class="section-header" style="margin-bottom: 20px;">
                                        <h2 style="color: #2d5a2d; font-size: 1.3rem; margin-bottom: 15px; display: flex; align-items: center; gap: 10px;">
                                            <i class="fas fa-calendar-plus" style="color: #27ae60;"></i> 
                                            Schedule New Next Sitting
                                        </h2>
                                        <p style="color: #2d5a2d; font-size: 0.9rem; margin: 0;">
                                            Schedule a new next sitting appointment for this patient.
                                        </p>
                                    </div>
                                    
                                    <form id="scheduleNextSittingForm" method="post" action="${pageContext.request.contextPath}/patients/examination/${examination.id}/schedule-followup">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                        
                                        <div class="form-row" style="display: flex; gap: 15px; margin-bottom: 15px;">
                                            <div class="form-group" style="flex: 1;">
                                                <label for="newFollowUpDate" style="display: block; margin-bottom: 5px; font-weight: 600; color: #2d5a2d;">Next-sitting Date <span style="color: #e74c3c;">*</span></label>
                                                <input type="date" id="newFollowUpDate" name="followupDate" class="form-control" required style="width: 100%; padding: 10px; border: 1px solid #c3e6c3; border-radius: 6px; font-size: 14px; background-color: white;">
                                            </div>
                                            <div class="form-group" style="flex: 1;">
                                                <label for="newFollowUpTime" style="display: block; margin-bottom: 5px; font-weight: 600; color: #2d5a2d;">Next-sitting Time <span style="color: #e74c3c;">*</span></label>
                                                <input type="time" id="newFollowUpTime" name="followupTime" class="form-control" required style="width: 100%; padding: 10px; border: 1px solid #c3e6c3; border-radius: 6px; font-size: 14px; background-color: white;">
                                            </div>
                                        </div>
                                        
                                        <div class="form-group" style="margin-bottom: 15px;">
                                            <label for="newFollowUpNotes" style="display: block; margin-bottom: 5px; font-weight: 600; color: #2d5a2d;">Next-sitting Instructions/Notes</label>
                                            <textarea id="newFollowUpNotes" name="followupNotes" class="form-control" rows="3" placeholder="Enter any specific instructions or notes for this next-sitting..." style="width: 100%; padding: 10px; border: 1px solid #c3e6c3; border-radius: 6px; font-size: 14px; resize: vertical; background-color: white;"></textarea>
                                        </div>
                                        
                                        <c:if test="${not empty doctors}">
                                        <div class="form-group" style="margin-bottom: 20px;">
                                            <label for="newFollowUpDoctorId" style="display: block; margin-bottom: 5px; font-weight: 600; color: #2d5a2d;">Assigned Doctor</label>
                                            <select id="newFollowUpDoctorId" name="doctorId" class="form-control" style="width: 100%; padding: 10px; border: 1px solid #c3e6c3; border-radius: 6px; font-size: 14px; background-color: white;">
                                                <option value="">Use Assigned Doctor</option>
                                                <c:forEach items="${doctors}" var="doctor">
                                                    <option value="${doctor.id}">${doctor.firstName} ${doctor.lastName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        </c:if>
                                        
                                        <div class="form-actions" style="display: flex; justify-content: flex-end; gap: 12px;">
                                            <button type="submit" class="btn btn-success" style="background: linear-gradient(135deg, #27ae60, #2ecc71); color: white; border: none; padding: 12px 24px; border-radius: 6px; cursor: pointer; font-weight: 600; font-size: 0.9rem;">
                                                <i class="fas fa-calendar-plus"></i> Schedule Next-sitting
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:if>

                    <!-- Complete Next-sitting Modal -->
                    <div id="completeNextSittingModal" class="modal" style="display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5);">
                        <div class="modal-content" style="background-color: white; margin: 5% auto; padding: 0; border-radius: 12px; width: 90%; max-width: 500px; box-shadow: 0 8px 32px rgba(0,0,0,0.3);">
                            <div class="modal-header" style="background: linear-gradient(135deg, #27ae60, #2ecc71); color: white; padding: 20px; border-radius: 12px 12px 0 0;">
                                <h3 style="margin: 0; font-size: 1.3rem; display: flex; align-items: center; gap: 10px;">
                                    <i class="fas fa-check-circle"></i> Complete Next-sitting
                                </h3>
                                <span class="close-modal" onclick="closeCompleteFollowUpModal()" style="position: absolute; right: 20px; top: 20px; font-size: 28px; font-weight: bold; cursor: pointer; color: white;">&times;</span>
                            </div>
                            <div class="modal-body" style="padding: 25px;">
                                <form id="completeNextSittingForm" method="post" action="${pageContext.request.contextPath}/follow-up/complete">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                    <input type="hidden" id="completeNextSittingId" name="followUpId">
                                    <input type="hidden" id="completeExaminationId" name="examinationId">
                                    <div class="form-group" style="margin-bottom: 20px;">
                                        <label for="clinicalNotes" style="display: block; margin-bottom: 5px; font-weight: 600; color: #2c3e50;">Clinical Notes <span style="color: #e74c3c;">*</span></label>
                                        <textarea id="clinicalNotes" name="clinicalNotes" class="form-control" rows="4" placeholder="Enter clinical notes for this next-sitting..." required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; resize: vertical;"></textarea>
                                    </div>
                                    <div class="modal-footer" style="display: flex; justify-content: flex-end; gap: 12px; padding: 20px 0 0 0; border-top: 1px solid #eee; margin-top: 20px;">
                                        <button type="button" class="btn btn-secondary" onclick="closeCompleteFollowUpModal()" style="background: #95a5a6; color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer;">Cancel</button>
                                        <button type="submit" class="btn btn-success" style="background: linear-gradient(135deg, #27ae60, #2ecc71); color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: 600;">
                                            <i class="fas fa-check"></i> Mark Complete
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Reschedule Next-sitting Modal -->
                    <div id="rescheduleNextSittingModal" class="modal" style="display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5);">
                        <div class="modal-content" style="background-color: white; margin: 5% auto; padding: 0; border-radius: 12px; width: 90%; max-width: 500px; box-shadow: 0 8px 32px rgba(0,0,0,0.3);">
                            <div class="modal-header" style="background: linear-gradient(135deg, #f39c12, #e67e22); color: white; padding: 20px; border-radius: 12px 12px 0 0;">
                                <h3 style="margin: 0; font-size: 1.3rem; display: flex; align-items: center; gap: 10px;">
                                    <i class="fas fa-calendar-alt"></i> Reschedule Next-sitting
                                </h3>
                                <span class="close-modal" onclick="closeRescheduleFollowUpModal()" style="position: absolute; right: 20px; top: 20px; font-size: 28px; font-weight: bold; cursor: pointer; color: white;">&times;</span>
                            </div>
                            <div class="modal-body" style="padding: 25px;">
                                <form id="rescheduleNextSittingForm" method="post" action="${pageContext.request.contextPath}/follow-up/reschedule">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                    <input type="hidden" id="rescheduleNextSittingId" name="followUpId">
                                    <input type="hidden" id="rescheduleExaminationId" name="examinationId">
                                    <div class="form-row" style="display: flex; gap: 15px; margin-bottom: 15px;">
                                        <div class="form-group" style="flex: 1;">
                                            <label for="rescheduleDate" style="display: block; margin-bottom: 5px; font-weight: 600; color: #2c3e50;">New Date <span style="color: #e74c3c;">*</span></label>
                                            <input type="date" id="rescheduleDate" name="newDate" class="form-control" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px;">
                                        </div>
                                        <div class="form-group" style="flex: 1;">
                                            <label for="rescheduleTime" style="display: block; margin-bottom: 5px; font-weight: 600; color: #2c3e50;">New Time <span style="color: #e74c3c;">*</span></label>
                                            <input type="time" id="rescheduleTime" name="newTime" class="form-control" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px;">
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-bottom: 20px;">
                                        <label for="rescheduleNotes" style="display: block; margin-bottom: 5px; font-weight: 600; color: #2c3e50;">Notes</label>
                                        <textarea id="rescheduleNotes" name="rescheduleNotes" class="form-control" rows="2" placeholder="Enter notes for rescheduling..." style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; resize: vertical;"></textarea>
                                    </div>
                                    <c:if test="${not empty doctors}">
                                    <div class="form-group" style="margin-bottom: 20px;">
                                        <label for="rescheduleDoctorId" style="display: block; margin-bottom: 5px; font-weight: 600; color: #2c3e50;">Doctor (Optional)</label>
                                        <select id="rescheduleDoctorId" name="doctorId" class="form-control">
                                            <option value="">Use Assigned Doctor</option>
                                            <c:forEach items="${doctors}" var="doctor">
                                                <option value="${doctor.id}">${doctor.firstName} ${doctor.lastName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    </c:if>
                                    <div class="modal-footer" style="display: flex; justify-content: flex-end; gap: 12px; padding: 20px 0 0 0; border-top: 1px solid #eee; margin-top: 20px;">
                                        <button type="button" class="btn btn-secondary" onclick="closeRescheduleFollowUpModal()" style="background: #95a5a6; color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer;">Cancel</button>
                                        <button type="submit" class="btn btn-warning" style="background: linear-gradient(135deg, #f39c12, #e67e22); color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: 600;">
                                            <i class="fas fa-calendar-alt"></i> Reschedule
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Cancel Next-sitting Modal -->
                    <div id="cancelNextSittingModal" class="modal" style="display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5);">
                        <div class="modal-content" style="background-color: white; margin: 5% auto; padding: 0; border-radius: 12px; width: 90%; max-width: 500px; box-shadow: 0 8px 32px rgba(0,0,0,0.3);">
                            <div class="modal-header" style="background: linear-gradient(135deg, #e74c3c, #c0392b); color: white; padding: 20px; border-radius: 12px 12px 0 0;">
                                <h3 style="margin: 0; font-size: 1.3rem; display: flex; align-items: center; gap: 10px;">
                                    <i class="fas fa-times-circle"></i> Cancel Next-sitting
                                </h3>
                                <span class="close-modal" onclick="closeCancelFollowUpModal()" style="position: absolute; right: 20px; top: 20px; font-size: 28px; font-weight: bold; cursor: pointer; color: white;">&times;</span>
                            </div>
                            <div class="modal-body" style="padding: 25px;">
                                <form id="cancelNextSittingForm" method="post" action="${pageContext.request.contextPath}/follow-up/cancel">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                    <input type="hidden" id="cancelNextSittingId" name="followUpId">
                                    <input type="hidden" id="cancelExaminationId" name="examinationId">
                                    <div class="form-group" style="margin-bottom: 20px;">
                                        <label for="cancelReason" style="display: block; margin-bottom: 5px; font-weight: 600; color: #2c3e50;">Reason for Cancellation <span style="color: #e74c3c;">*</span></label>
                                        <textarea id="cancelReason" name="reason" class="form-control" rows="3" placeholder="Enter reason for cancelling this next-sitting..." required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; resize: vertical;"></textarea>
                                    </div>
                                    <div class="modal-footer" style="display: flex; justify-content: flex-end; gap: 12px; padding: 20px 0 0 0; border-top: 1px solid #eee; margin-top: 20px;">
                                        <button type="button" class="btn btn-secondary" onclick="closeCancelFollowUpModal()" style="background: #95a5a6; color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer;">Cancel</button>
                                        <button type="submit" class="btn btn-danger" style="background: linear-gradient(135deg, #e74c3c, #c0392b); color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: 600;">
                                            <i class="fas fa-times"></i> Cancel Next-sitting
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <!-- END: Next-sitting Planning Form, Scheduling Modal, History, and Modals -->
                </div>
            </div>
            <!-- End Collapsible Next-sitting Section -->
            
            <!-- Image Modal for Viewing Attached Images -->
            <div id="imageModal" class="image-modal">
                <div class="image-modal-content">
                    <div class="image-modal-header">
                        <h3 id="imageModalTitle">Image View</h3>
                        <button type="button" class="image-modal-close" onclick="closeImageModal()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <div class="image-modal-body" id="imageModalBody">
                        <!-- Image or PDF will be displayed here -->
                    </div>
                </div>
            </div>

            <script>
            // Global modal functions - defined immediately for onclick attributes
            window.showXrayUploadModal = function() {
                const modal = document.getElementById('xrayUploadModal');
                if (modal) {
                    modal.style.display = 'block';
                }
            };
            
            window.closeXrayUploadModal = function() {
                const modal = document.getElementById('xrayUploadModal');
                if (modal) {
                    modal.style.display = 'none';
                }
            };
            
            window.showXrayConfirmationModal = function() {
                const modal = document.getElementById('xrayConfirmationModal');
                if (modal) {
                    modal.style.display = 'block';
                }
            };
            
            window.closeXrayConfirmationModal = function() {
                const modal = document.getElementById('xrayConfirmationModal');
                if (modal) {
                    modal.style.display = 'none';
                }
            };
            
            window.showPaymentPendingModal = function() {
                const modal = document.getElementById('paymentPendingModal');
                if (modal) {
                    modal.style.display = 'block';
                }
            };
            
            window.closePaymentPendingModal = function() {
                const modal = document.getElementById('paymentPendingModal');
                if (modal) {
                    modal.style.display = 'none';
                }
            };
            
            // Add event listener for the simplified X-ray upload modal
            document.addEventListener('DOMContentLoaded', function() {
                const confirmXrayUploadBtn = document.getElementById('confirmXrayUpload');
                if (confirmXrayUploadBtn) {
                    confirmXrayUploadBtn.addEventListener('click', async function() {
                        
                        const fileInput = document.getElementById('xray-upload');
                        const files = fileInput.files;
                        
                        if (!files || files.length === 0) {
                            alert('Please select at least one image to upload.');
                            return;
                        }
                        
                        // Disable button and show loading
                        confirmXrayUploadBtn.disabled = true;
                        confirmXrayUploadBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Uploading...';
                        
                        try {
                            const examinationId = document.getElementById('examinationId').value;
                            const formData = new FormData();
                            
                            // Add all selected files
                            for (let i = 0; i < files.length; i++) {
                                formData.append('xrayPictures', files[i]);
                            }
                            
                            // CSRF token
                            const token = $("meta[name='_csrf']").attr("content");
                            const header = $("meta[name='_csrf_header']").attr("content");
                            
                            
                            // Upload X-ray images
                            const response = await fetch(
                                `${pageContext.request.contextPath}/patients/examination/${examinationId}/upload-xray`,
                                {
                                    method: 'POST',
                                    headers: { [header]: token },
                                    body: formData
                                }
                            );
                            
                            if (response.ok) {
                                
                                // Images uploaded, now close the case
                                const statusResponse = await fetch(
                                    `${pageContext.request.contextPath}/patients/update-procedure-status`,
                                    {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/json',
                                            [header]: token
                                        },
                                        body: JSON.stringify({ examinationId: examinationId, status: 'CLOSED' })
                                    }
                                );
                                
                                if (statusResponse.ok) {
                                    const statusResult = await statusResponse.json();
                                    alert('Images uploaded and case closed successfully!');
                                    document.getElementById('xrayUploadModal').style.display = 'none';
                                    window.location.reload();
                                } else {
                                    const statusErrorText = await statusResponse.text();
                                    
                                    // Check if it's a payment pending error
                                    if (statusErrorText.includes('payment') && statusErrorText.includes('pending')) {
                                        showPaymentPendingModal();
                                    } else {
                                        alert('Images uploaded, but failed to close the case. Error: ' + statusErrorText);
                                    }
                                }
                            } else {
                                let errorMsg = 'Failed to upload images.';
                                try {
                                    const errorData = await response.json();
                                    if (errorData && errorData.message) errorMsg = errorData.message;
                                } catch (e) {}
                                alert(errorMsg);
                            }
                        } catch (error) {
                            alert('Error uploading images. Please try again.');
                        } finally {
                            // Reset button
                            confirmXrayUploadBtn.disabled = false;
                            confirmXrayUploadBtn.innerHTML = '<i class="fas fa-check"></i> Upload Images';
                        }
                    });
                }
            });
            
            window.selectXrayOption = function(option) {
                
                closeXrayConfirmationModal();
                
                if (option === 'upload') {
                    const xrayUploadModal = document.getElementById('xrayUploadModal');
                    if (xrayUploadModal) {
                        xrayUploadModal.style.display = 'block';
                    }
                } else if (option === 'close') {
                    
                    // Check current payment status before proceeding
                    const paymentStatusElement = document.querySelector('.payment-status');
                    if (paymentStatusElement) {
                        const currentPaymentStatus = paymentStatusElement.textContent.trim();
                        
                        if (currentPaymentStatus.includes('PENDING') || currentPaymentStatus.includes('pending')) {
                            showPaymentPendingModal();
                            return;
                        }
                    }
                    
                    // Continue with the status update without X-ray
                    if (window.pendingStatusUpdate) {
                        updateProcedureStatusDirect(window.pendingStatusUpdate);
                    } else {
                        // Fallback: directly update to CLOSED status
                        updateProcedureStatusDirect('CLOSED');
                    }
                }
            };
            
            // Simple click outside to close for modals
            document.addEventListener('DOMContentLoaded', function() {
                // Add click outside to close for all modals
                const modals = ['xrayConfirmationModal', 'xrayUploadModal', 'completeFollowUpModal', 'rescheduleFollowUpModal', 'cancelFollowUpModal', 'reopenModal', 'paymentPendingModal'];
                
                modals.forEach(function(modalId) {
                    const modal = document.getElementById(modalId);
                    if (modal) {
                        modal.addEventListener('click', function(e) {
                            if (e.target === modal) {
                                modal.style.display = 'none';
                            }
                        });
                    }
                });
            });
            
            window.closeClinicalNotesModal = function() {
                document.getElementById('clinicalNotesModal').style.display = 'none';
            };
            
            // Image Modal Functions
            window.openImageModal = function(imageUrl, title) {
                const modal = document.getElementById('imageModal');
                const modalTitle = document.getElementById('imageModalTitle');
                const modalBody = document.getElementById('imageModalBody');
                
                modalTitle.textContent = title || 'Image View';
                
                // Check if it's a PDF or image
                if (imageUrl.toLowerCase().endsWith('.pdf')) {
                    modalBody.innerHTML = '<iframe src="' + imageUrl + '" title="' + title + '"></iframe>';
                } else {
                    modalBody.innerHTML = '<img src="' + imageUrl + '" alt="' + title + '" style="max-width: 100%; max-height: 70vh; object-fit: contain;">';
                }
                
                modal.style.display = 'block';
                document.body.style.overflow = 'hidden';
                
            };
            
            window.closeImageModal = function() {
                const modal = document.getElementById('imageModal');
                modal.style.display = 'none';
                document.body.style.overflow = 'auto';
            };
            

            
            // Load attached images
            window.loadAttachedImages = async function() {
                const examinationId = document.getElementById('examinationId').value;
                const imagesGrid = document.getElementById('attachedImagesGrid');
                const noImagesMessage = document.getElementById('noImagesMessage');
                
                try {
                    const contextPath = ''; // Root context
                    const url = `${contextPath}/patients/examination/${examinationId}/media-files`;
                    
                    const response = await fetch(url);
                    
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    
                    const result = await response.json();
                    
                    if (result.success && result.mediaFiles && result.mediaFiles.length > 0) {
                        displayAttachedImages(result.mediaFiles);
                        noImagesMessage.style.display = 'none';
                    } else {
                        imagesGrid.innerHTML = '';
                        noImagesMessage.style.display = 'block';
                    }
                } catch (error) {
                    imagesGrid.innerHTML = `<div style="text-align: center; padding: 20px; color: #e74c3c;">
                        <i class="fas fa-exclamation-triangle" style="font-size: 2rem; margin-bottom: 10px;"></i>
                        <p>Error loading images: ${error.message}</p>
                    </div>`;
                    noImagesMessage.style.display = 'none';
                }
            };
            
            // Display attached images
            window.displayAttachedImages = function(mediaFiles) {
                const imagesGrid = document.getElementById('attachedImagesGrid');
                
                const imagesHtml = mediaFiles.map(file => {
                    const displayName = getImageTypeDisplayName(file.fileType);
                    const filePath = file.filePath;
                    const fileType = file.fileType;
                    const fileId = file.id;
                    const uploadedAt = (function(v){
                         if (!v) return 'Unknown';
                         try {
                             // Handle Jackson-style arrays: [year, month, day, hour, minute, second, nanos]
                             if (Array.isArray(v)) {
                                 const y = Number(v[0]);
                                 const m = Number(v[1]);
                                 const dDay = Number(v[2]);
                                 const h = Number(v[3] || 0);
                                 const min = Number(v[4] || 0);
                                 const s = Number(v[5] || 0);
                                 const dArr = new Date(y, m - 1, dDay, h, min, s);
                                 return isNaN(dArr) ? 'Unknown' : dArr.toLocaleDateString('en-IN');
                             }
                             if (typeof v === 'number') {
                                 const d = new Date(v);
                                 return isNaN(d) ? 'Unknown' : d.toLocaleDateString('en-IN');
                             }
                             if (typeof v === 'string') {
                                 let d = new Date(v);
                                 if (!isNaN(d)) return d.toLocaleDateString('en-IN');
                                 const m = v.match(/^(\d{4})-(\d{2})-(\d{2})[ T](\d{2}):(\d{2}):(\d{2})$/);
                                 if (m) {
                                     const d2 = new Date(Number(m[1]), Number(m[2]) - 1, Number(m[3]), Number(m[4]), Number(m[5]), Number(m[6]));
                                     if (!isNaN(d2)) return d2.toLocaleDateString('en-IN');
                                 }
                                 const m2 = v.match(/^(\d{4})-(\d{2})-(\d{2})$/);
                                 if (m2) {
                                     const d3 = new Date(Number(m2[1]), Number(m2[2]) - 1, Number(m2[3]));
                                     if (!isNaN(d3)) return d3.toLocaleDateString('en-IN');
                                 }
                                 d = new Date(v.replace(' ', 'T'));
                                 if (!isNaN(d)) return d.toLocaleDateString('en-IN');
                             }
                         } catch(e) {}
                         return 'Unknown';
                     })(file.uploadedAt);
                    

                    
                    // Determine if it's an image or PDF
                    const imageTypes = ['upper_arch', 'lower_arch', 'xray'];
                    const isImage = imageTypes.includes(fileType);
                    
                    if (isImage) {
                        const contextPath = ''; // Root context
                        const imageSrc = contextPath + '/uploads/' + filePath;
                        return '<div class="image-card">' +
                            '<div class="image-preview">' +
                            '<img src="' + imageSrc + '" alt="' + displayName + '" loading="lazy" onclick="openImageModal(\'' + imageSrc + '\', \'' + displayName + '\')" onerror="this.style.display=\'none\'; this.parentElement.innerHTML=\'<div style=\\\'display: flex; align-items: center; justify-content: center; height: 100%; color: #e74c3c;\\\'><i class=\\\'fas fa-exclamation-triangle\\\'></i> Image not found</div>\';">' +
                            '</div>' +
                            '<div class="image-info">' +
                            '<div class="image-type">' + displayName + '</div>' +
                            '<div class="image-upload-date">Uploaded: ' + uploadedAt + '</div>' +
                            '<div class="image-actions">' +
                            '<button type="button" class="btn btn-primary" onclick="openImageModal(\'' + imageSrc + '\', \'' + displayName + '\')">' +
                            '<i class="fas fa-eye"></i> View' +
                            '</button>' +
                            '<a href="' + imageSrc + '" download="' + filePath.split('/').pop() + '" class="btn btn-success">' +
                            '<i class="fas fa-download"></i> Download' +
                            '</a>' +
                            '</div>' +
                            '</div>' +
                            '</div>';
                    } else {
                        // Handle PDF files
                        const contextPath = ''; // Root context
                        const pdfSrc = contextPath + '/uploads/' + filePath;
                        const fileName = filePath.split('/').pop();
                        return '<div class="image-card">' +
                            '<div class="image-preview">' +
                            '<div class="pdf-thumbnail" onclick="openImageModal(\'' + pdfSrc + '\', \'' + displayName + '\')">' +
                            '<i class="fas fa-file-pdf"></i>' +
                            '<div class="pdf-filename">' + fileName + '</div>' +
                            '</div>' +
                            '</div>' +
                            '<div class="image-info">' +
                            '<div class="image-type">' + displayName + '</div>' +
                            '<div class="image-upload-date">Uploaded: ' + uploadedAt + '</div>' +
                            '<div class="image-actions">' +
                            '<button type="button" class="btn btn-primary" onclick="openImageModal(\'' + pdfSrc + '\', \'' + displayName + '\')">' +
                            '<i class="fas fa-eye"></i> View' +
                            '</button>' +
                            '<a href="' + pdfSrc + '" download="' + fileName + '" class="btn btn-success">' +
                            '<i class="fas fa-download"></i> Download' +
                            '</a>' +
                            '</div>' +
                            '</div>' +
                            '</div>';
                    }
                }).join('');
                
                imagesGrid.innerHTML = imagesHtml;
                
                // Update the images count
                const imagesCountElement = document.getElementById('imagesCount');
                if (imagesCountElement) {
                    imagesCountElement.textContent = mediaFiles.length;
                }
            };
            
            // Toggle images section
            window.toggleImagesSection = function() {
                const content = document.getElementById('imagesSectionContent');
                const icon = document.getElementById('imagesToggleIcon');
                const iconElement = icon.querySelector('i');
                
                if (content.style.display === 'none') {
                    // Expand
                    content.style.display = 'block';
                    content.style.opacity = '0';
                    content.style.transform = 'translateY(-10px)';
                    
                    setTimeout(() => {
                        content.style.opacity = '1';
                        content.style.transform = 'translateY(0)';
                    }, 10);
                    
                    iconElement.classList.remove('fa-chevron-right');
                    iconElement.classList.add('fa-chevron-down');
                } else {
                    // Collapse
                    content.style.opacity = '0';
                    content.style.transform = 'translateY(-10px)';
                    
                    setTimeout(() => {
                        content.style.display = 'none';
                    }, 300);
                    
                    iconElement.classList.remove('fa-chevron-down');
                    iconElement.classList.add('fa-chevron-right');
                }
            };
            
            // Test function for image modal
            window.testImageModal = function() {
                openImageModal('/uploads/dental-images/086b8428-2241-4f97-8d49-05240928fb80.jpeg', 'Test Image');
            };
            
            // Test function to check image URLs
            window.testImageUrls = async function() {
                const testUrls = [
                    '/uploads/dental-images/086b8428-2241-4f97-8d49-05240928fb80.jpeg',
                    '/uploads/xray-pictures/0bad5d21-99e9-471c-873b-afbd5ac4c428.jpeg',
                    '/uploads/documents/1997869e-2a35-4677-98f6-17f11bd87fe1.pdf'
                ];
                
                const results = [];
                for (const url of testUrls) {
                    try {
                        const response = await fetch(url, { method: 'HEAD' });
                        const result = `${url}: ${response.status} ${response.statusText}`;
                        results.push(result);
                    } catch (error) {
                        const result = `${url}: Error - ${error.message}`;
                        results.push(result);
                    }
                }
                
                // Show results in an alert
                alert('Image URL Test Results:\n\n' + results.join('\n'));
            };
            
            // Helper function to get display name for file type
            window.getImageTypeDisplayName = function(fileType) {
                switch (fileType) {
                    case 'upper_arch': return 'Upper Arch';
                    case 'lower_arch': return 'Lower Arch';
                    case 'xray': return 'X-Ray Image';
                    case 'document': return 'Document';
                    default: return fileType.charAt(0).toUpperCase() + fileType.slice(1).replace('_', ' ');
                }
            };
            
            // Debug: Check if functions are defined
            
            
            // Ensure all modals are hidden on page load
            document.addEventListener('DOMContentLoaded', function() {
                // Hide all modals explicitly and remove show class
                const modals = document.querySelectorAll('.modal');
                modals.forEach(modal => {
                    modal.style.display = 'none';
                    modal.classList.remove('show');
                });
                
                // Style payment status based on content
                const paymentStatusElement = document.querySelector('.payment-status');
                if (paymentStatusElement) {
                    const statusText = paymentStatusElement.textContent;
                    if (statusText.includes('Remaining')) {
                        paymentStatusElement.classList.add('remaining');
                    } else if (statusText.includes('Full Payment Received')) {
                        paymentStatusElement.classList.add('completed');
                    }
                }
            });

            function toggleNextSittingSection() {
                const section = document.getElementById('nextSittingSectionBody');
                const icon = document.getElementById('nextSittingToggleIcon');
                const button = document.getElementById('nextSittingToggleBtn');
                const buttonText = button.querySelector('span:last-child');
                
                if (section.style.display === 'none') {
                    section.style.display = 'block';
                    icon.classList.remove('fa-chevron-down');
                    icon.classList.add('fa-chevron-up');
                    buttonText.textContent = 'Hide Details';
                } else {
                    section.style.display = 'none';
                    icon.classList.remove('fa-chevron-up');
                    icon.classList.add('fa-chevron-down');
                    buttonText.textContent = 'View Details';
                }
            }
            </script>
            
            <!-- Patient and Procedure Information -->
            <div class="container">
                <div class="section-header">
                    <h2>Clinical Case Information</h2>
                </div>
                
                <!-- Store examination ID in a hidden input for JavaScript to access -->
                <input type="hidden" id="examinationId" value="${examination.id}" />
                
                <!-- CSRF token for AJAX -->
                <meta name="_csrf" content="${_csrf.token}"/>
                <meta name="_csrf_header" content="${_csrf.headerName}"/>
                
                <!-- Attached Images Section -->
                <div class="attached-images-section" style="margin-bottom: 30px;">
                    <div class="section-header" style="margin-bottom: 20px; cursor: pointer;" onclick="toggleImagesSection()">
                        <h3 style="color: #2c3e50; font-size: 1.3rem; font-weight: 600; display: flex; align-items: center; gap: 10px; margin: 0;">
                            <i class="fas fa-images" style="color: #3498db;"></i>
                            Attached Images
                            <span id="imagesCount" style="background: #3498db; color: white; padding: 2px 8px; border-radius: 12px; font-size: 0.8rem; font-weight: 600;">0</span>
                            <span id="imagesToggleIcon" style="margin-left: auto; transition: transform 0.3s ease;">
                                <i class="fas fa-chevron-right"></i>
                            </span>
                        </h3>
                    </div>
                    
                    <div id="imagesSectionContent" style="display: none;">
                    
                    <!-- Images Grid Container -->
                    <div class="images-grid-container" id="attachedImagesGrid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px;">
                        <!-- Images will be loaded here via JavaScript -->
                        <div class="loading-placeholder" style="text-align: center; padding: 40px; color: #7f8c8d;">
                            <i class="fas fa-spinner fa-spin" style="font-size: 2rem; margin-bottom: 10px;"></i>
                            <p>Loading attached images...</p>
                        </div>
                    </div>
                    
                    <!-- No Images Message (hidden by default) -->
                    <div class="no-images-message" id="noImagesMessage" style="display: none; text-align: center; padding: 40px; background: #f8f9fa; border-radius: 12px; border: 2px dashed #dee2e6;">
                        <i class="fas fa-images" style="font-size: 3rem; color: #adb5bd; margin-bottom: 15px;"></i>
                        <h4 style="color: #6c757d; margin-bottom: 10px;">No Images Attached</h4>
                        <p style="color: #6c757d; margin: 0;">No images have been uploaded for this examination yet.</p>
                        <button type="button" class="btn btn-primary" onclick="loadAttachedImages()" style="margin-top: 15px;">
                            <i class="fas fa-refresh"></i> Retry Loading Images
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="testImageUrls()" style="margin-top: 15px; margin-left: 10px;">
                            <i class="fas fa-test"></i> Test Image URLs
                        </button>
                        <button type="button" class="btn btn-info" onclick="testImageModal()" style="margin-top: 15px; margin-left: 10px;">
                            <i class="fas fa-eye"></i> Test Modal
                        </button>
                    </div>
                    </div>
                </div>
                
                <!-- Top Action Bar with Status and Quick Actions -->
                <div class="clinical-action-bar">
                    <div class="status-dropdown" id="statusDropdown">
                        <div class="status-dropdown-btn${scheduledCount > 0 && examination.procedureStatus != 'CLOSED' ? ' disabled' : ''}${examination.procedureStatus == 'CANCELLED' ? ' cancelled' : ''}" id="statusDropdownBtn"
                             title="${scheduledCount > 0 && examination.procedureStatus != 'CLOSED' ? 'Cannot change status while follow-ups are scheduled. Please complete or cancel all follow-ups first.' : examination.procedureStatus == 'CANCELLED' ? 'Cannot change status for cancelled procedures.' : ''}">
                            <span class="current-status">
                                <span class="status-dot ${fn:toLowerCase(examination.procedureStatus)}"></span>
                                <span class="status-text">${examination.procedureStatus.label}</span>
                            </span>
                            <span class="dropdown-icon">
                                <i class="fas fa-chevron-down"></i>
                            </span>
                        </div>
                        <div class="status-dropdown-content">
                            <div class="status-dropdown-header">Change status</div>
                            <c:forEach items="${examination.procedureStatus.allowedTransitions}" var="nextStatus">
                                <c:if test="${nextStatus != 'REOPEN' || examination.procedureStatus != 'CLOSED'}">
                                    <div class="status-option" data-status="${nextStatus}">
                                        <span class="status-dot ${fn:toLowerCase(nextStatus)}"></span>
                                        <div>
                                            <div class="status-text">${nextStatus.label}</div>
                                            <div class="status-description">${nextStatus.description}</div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <!-- Special allowance: show Payment Completed when effective total is zero (full waiver) -->
                            <c:if test="${examination.procedureStatus == 'PAYMENT_PENDING' && examination.effectiveTotalProcedureAmount <= 0}">
                                <div class="status-option" data-status="PAYMENT_COMPLETED">
                                    <span class="status-dot payment-completed"></span>
                                    <div>
                                        <div class="status-text">Payment Completed</div>
                                        <div class="status-description">No charge applies; proceed without payment</div>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                        <c:if test="${scheduledCount > 0 && examination.procedureStatus != 'CLOSED'}">
                            <div class="status-blocked-message" style="margin-top: 8px; color: #e74c3c; font-size: 0.95rem; font-weight: 600; display: flex; align-items: center; gap: 8px;">
                                <i class="fas fa-exclamation-triangle"></i>
                                In order to change status, please close all scheduled follow-ups first.
                            </div>
                        </c:if>
                        <c:if test="${scheduledCount > 0 && examination.procedureStatus == 'CLOSED'}">
                            <div class="status-info-message" style="margin-top: 8px; color: #3498db; font-size: 0.95rem; font-weight: 600; display: flex; align-items: center; gap: 8px;">
                                <i class="fas fa-info-circle"></i>
                                Case is closed but has ${scheduledCount} scheduled follow-up${scheduledCount > 1 ? 's' : ''}. You can manage follow-ups or reopen the case if needed.
                            </div>
                        </c:if>
                    </div>
                    
                    <div class="quick-actions">
                        <button class="btn-quick" id="toggleClinicalNotes">
                            <i class="fas fa-clipboard-list"></i> Clinical Notes
                        </button>
                        <c:if test="${canAttachMoreImages}">
                            <button class="btn btn-secondary" id="attachMoreImagesBtn" style="margin-left: 10px;">
                                <i class="fas fa-paperclip"></i> Attach More Images
                            </button>
                        </c:if>
                        <button class="btn btn-success" id="printPrescriptionBtn" type="button" style="margin-left: 10px;">
                            <i class="fas fa-print"></i> Print Prescription
                        </button>
                    </div>
                </div>
                
                <!-- Payment Pending Message -->
                <c:if test="${examination.procedureStatus == 'PAYMENT_PENDING'}">
                    <div class="payment-pending-alert">
                        <div class="alert-icon">
                            <i class="fas fa-exclamation-circle"></i>
                        </div>
                        <div class="alert-content">
                            <h4>Payment Required</h4>
                            <p>Please guide the patient to complete the payment at the Front Desk to proceed with the procedure.</p>
                            <div class="alert-details">
                                <div class="detail-item">
                                    <i class="fas fa-rupee-sign"></i>
                                    <span>Amount Due: ₹${examination.totalProcedureAmount - examination.totalPaidAmount}</span>
                                </div>
                                <div class="detail-item">
                                    <i class="fas fa-info-circle"></i>
                                    <span>Status will automatically update once payment is received</span>
                                </div>
                                <div class="detail-item">
                                    <i class="fas fa-sync-alt"></i>
                                    <span><strong>Refresh the screen to check if the payment is completed or not</strong></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
                
                <!-- Reopen Case Section (only for closed cases) -->
                <c:if test="${examination.procedureStatus == 'CLOSED'}">
                    <div class="reopen-section" style="margin: 20px 0; padding: 20px; background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%); border: 1px solid #f39c12; border-radius: 12px; box-shadow: 0 4px 12px rgba(243, 156, 18, 0.15);">
                        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 15px;">
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <i class="fas fa-exclamation-triangle" style="color: #d68910; font-size: 1.2rem;"></i>
                                <h4 style="margin: 0; color: #d68910; font-weight: 600; font-size: 1.1rem;">Case Reopening</h4>
                            </div>
                            <span class="badge" style="background: #e74c3c; color: white; padding: 4px 10px; border-radius: 15px; font-size: 0.8rem; font-weight: 600;">
                                ${examination.reopenCount} time${examination.reopenCount != 1 ? 's' : ''}
                            </span>
                        </div>
                        <p style="margin: 0 0 15px 0; color: #d68910; font-size: 0.9rem; line-height: 1.5;">
                            <strong>Important:</strong> Only reopen this case if you are the doctor who will treat this patient further. 
                            This action will be tracked under your name and the reopening will be recorded in the system.
                        </p>
                        <div class="action-buttons">
                            <button class="btn btn-warning" onclick="showReopenModal()" style="background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%); border: none; color: white; padding: 10px 20px; font-size: 0.9rem; font-weight: 600; border-radius: 8px; box-shadow: 0 3px 6px rgba(243, 156, 18, 0.3); transition: all 0.3s ease;">
                                <i class="fas fa-redo" style="margin-right: 8px;"></i> Reopen Case
                            </button>
                        </div>
                    </div>
                </c:if>
                
                <!-- Reopening History Section -->
                <c:if test="${examination.reopenCount > 0}">
                    <div class="reopening-history-section" style="margin: 20px 0; padding: 20px; background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 12px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);">
                        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 15px;">
                            <i class="fas fa-history" style="color: #6c757d; font-size: 1.2rem;"></i>
                            <h4 style="margin: 0; color: #495057; font-weight: 600; font-size: 1.1rem;">Reopening History</h4>
                            <span class="badge" style="background: #6c757d; color: white; padding: 4px 10px; border-radius: 15px; font-size: 0.8rem; font-weight: 600;">
                                ${examination.reopenCount} reopening${examination.reopenCount != 1 ? 's' : ''}
                            </span>
                        </div>
                        
                        <div class="reopening-timeline" style="position: relative;">
                            <!-- Timeline connector -->
                            <div class="timeline-connector" style="position: absolute; left: 12px; top: 0; bottom: 0; width: 2px; background-color: #e9ecef; z-index: 1;"></div>
                            
                            <c:forEach var="reopening" items="${examination.reopeningRecords}" varStatus="status">
                                <div class="reopening-item" style="position: relative; padding: 15px 15px 15px 30px; margin-bottom: 20px; background: white; border-radius: 8px; border-left: 4px solid #e67e22; box-shadow: 0 3px 6px rgba(0, 0, 0, 0.08);">
                                    <!-- Timeline dot -->
                                    <div class="timeline-dot" style="position: absolute; left: -14px; top: 20px; width: 28px; height: 28px; background: #e67e22; border: 4px solid #fff; border-radius: 50%; z-index: 2; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; font-size: 0.8rem;">
                                        ${reopening.reopeningSequence}
                                    </div>
                                    
                                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
                                        <div style="display: flex; flex-direction: column;">
                                            <h5 style="margin: 0; color: #2c3e50; font-weight: 600; font-size: 1.05rem;">
                                                Reopened by Dr. ${reopening.reopenedByDoctor.firstName} ${reopening.reopenedByDoctor.lastName}
                                                <c:if test="${not empty reopening.reopenedByDoctor.specialization}">
                                                    <span style="font-size: 0.85rem; color: #6c757d; font-weight: normal;">(${reopening.reopenedByDoctor.specialization})</span>
                                                </c:if>
                                            </h5>
                              
                                        </div>
                                        <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 5px;">
                                            <span class="status-badge" style="background: #e67e22; color: white; padding: 3px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: 600;">
                                                Reopened
                                            </span>

                                        </div>
                                    </div>
                                    
                                    <div class="reopening-details" style="margin-top: 15px; background: #f8f9fa; border-radius: 6px; padding: 12px;">
                                        <c:if test="${not empty reopening.reopeningReason}">
                                            <div class="detail-item" style="margin-bottom: 12px;">
                                                <strong style="color: #e74c3c; font-size: 0.9rem; display: flex; align-items: center; gap: 5px;">
                                                    <i class="fas fa-exclamation-circle"></i> Reason for Reopening:
                                                </strong>
                                                <p style="margin: 5px 0 0 0; color: #2c3e50; font-size: 0.9rem; line-height: 1.5; background: #fff; padding: 8px; border-radius: 4px; border-left: 3px solid #e74c3c;">${reopening.reopeningReason}</p>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty reopening.patientCondition}">
                                            <div class="detail-item" style="margin-bottom: 12px;">
                                                <strong style="color: #3498db; font-size: 0.9rem; display: flex; align-items: center; gap: 5px;">
                                                    <i class="fas fa-user-md"></i> Patient's Condition:
                                                </strong>
                                                <p style="margin: 5px 0 0 0; color: #2c3e50; font-size: 0.9rem; line-height: 1.5; background: #fff; padding: 8px; border-radius: 4px; border-left: 3px solid #3498db;">${reopening.patientCondition}</p>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty reopening.treatmentPlan}">
                                            <div class="detail-item" style="margin-bottom: 12px;">
                                                <strong style="color: #2ecc71; font-size: 0.9rem; display: flex; align-items: center; gap: 5px;">
                                                    <i class="fas fa-clipboard-list"></i> Treatment Plan:
                                                </strong>
                                                <p style="margin: 5px 0 0 0; color: #2c3e50; font-size: 0.9rem; line-height: 1.5; background: #fff; padding: 8px; border-radius: 4px; border-left: 3px solid #2ecc71;">${reopening.treatmentPlan}</p>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty reopening.notes}">
                                            <div class="detail-item" style="margin-bottom: 8px;">
                                                <strong style="color: #9b59b6; font-size: 0.9rem; display: flex; align-items: center; gap: 5px;">
                                                    <i class="fas fa-sticky-note"></i> Additional Notes:
                                                </strong>
                                                <p style="margin: 5px 0 0 0; color: #2c3e50; font-size: 0.9rem; line-height: 1.5; background: #fff; padding: 8px; border-radius: 4px; border-left: 3px solid #9b59b6;">${reopening.notes}</p>
                                            </div>
                                        </c:if>
                                        

                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
                
                <!-- Two-column layout for patient and procedure info -->
                <div class="clinical-info-layout" data-patient-id="${patient.id}">
                    <!-- Left column: Patient info -->
                    <div class="clinical-info-column">
                        <!-- Color Code Strip -->
                        <jsp:include page="/WEB-INF/views/common/color-code-component.jsp" />
                        
                        <div class="clinical-card">
                            <div class="clinical-card-header">
                                <h3><i class="fas fa-user"></i> Patient Information</h3>
                            </div>
                            <div class="clinical-card-body">
                                <div id="notification" class="notification" style="display:none"></div>
                                <div class="patient-profile">
                                    <c:if test="${not empty patient.profilePicturePath}">
                                        <div class="patient-image">
                                            <img src="${pageContext.request.contextPath}/uploads/${patient.profilePicturePath}" alt="${patient.firstName} ${patient.lastName}">
                                        </div>
                                    </c:if>
                                    <div class="patient-details">
                                        <h4>${patient.firstName} ${patient.lastName}</h4>
                                        <p class="patient-id">Registration Code: ${patient.registrationCode}</p>
                                        <p class="patient-id">Examination ID: ${examination.id}</p>
                                        <p><i class="fas fa-phone"></i> ${patient.phoneNumber}</p>
                                        <p><i class="fas fa-calendar-alt"></i> Age: 
                                            <c:if test="${not empty patient.age}">
                                                ${patient.age} years
                                            </c:if>
                                            <c:if test="${empty patient.age}">
                                                Not specified
                                            </c:if>
                                        </p>
                                        <c:if test="${not empty patient.gender}">
                                            <p><i class="fas fa-venus-mars"></i> ${patient.gender}</p>
                                        </c:if>
                                    </div>
                                </div>
                                
                                <div class="patient-medical-history">
                                    <h5><i class="fas fa-file-medical"></i> Medical History</h5>
                                    <p>${not empty patient.medicalHistory ? patient.medicalHistory : 'No medical history recorded'}</p>
                                    
                                    <a href="${pageContext.request.contextPath}/patients/details/${patient.id}" class="view-more">
                                        View Full Patient Record <i class="fas fa-external-link-alt"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Right column: Procedure info and doctor's actions -->
                    <div class="clinical-info-column">
                        <div class="clinical-card">
                            <div class="clinical-card-header">
                                <h3><i class="fas fa-teeth"></i> Procedure Details</h3>
                            </div>
                            <div class="clinical-card-body">
                                <div class="procedure-info-grid">
                                    <div class="procedure-info-item">
                                        <span class="info-label">Procedure</span>
                                        <span class="info-value">${procedure.procedureName}</span>
                                    </div>
                                    <div class="procedure-info-item">
                                        <span class="info-label">Department</span>
                                        <span class="info-value">${procedure.dentalDepartment.displayName}</span>
                                    </div>
                                    <div class="procedure-info-item">
                                        <span class="info-label">Tooth Number</span>
                                        <span class="info-value">${examination.toothNumber}</span>
                                    </div>
                                    <c:if test="${not empty examination.toothCondition}">
                                        <div class="procedure-info-item">
                                            <span class="info-label">Tooth Condition</span>
                                            <span class="info-value">${examination.toothCondition}</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty examination.existingRestoration}">
                                        <div class="procedure-info-item">
                                            <span class="info-label">Existing Restoration</span>
                                            <span class="info-value">${examination.existingRestoration}</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty examination.toothMobility}">
                                        <div class="procedure-info-item">
                                            <span class="info-label">Tooth Mobility</span>
                                            <span class="info-value">${examination.toothMobility}</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty examination.pocketDepth}">
                                        <div class="procedure-info-item">
                                            <span class="info-label">Pocket Depth</span>
                                            <span class="info-value">${examination.pocketDepth}</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty examination.bleedingOnProbing}">
                                        <div class="procedure-info-item">
                                            <span class="info-label">Bleeding on Probing</span>
                                            <span class="info-value">${examination.bleedingOnProbing}</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty examination.plaqueScore}">
                                        <div class="procedure-info-item">
                                            <span class="info-label">Plaque Score</span>
                                            <span class="info-value">${examination.plaqueScore}</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty examination.gingivalRecession}">
                                        <div class="procedure-info-item">
                                            <span class="info-label">Gingival Recession</span>
                                            <span class="info-value">${examination.gingivalRecession}</span>
                                        </div>
                                    </c:if>
                

                                    <c:if test="${not empty examination.toothVitality}">
                                        <div class="procedure-info-item">
                                            <span class="info-label">Tooth Vitality</span>
                                            <span class="info-value">${examination.toothVitality}</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty examination.furcationInvolvement}">
                                        <div class="procedure-info-item">
                                            <span class="info-label">Furcation Involvement</span>
                                            <span class="info-value">${examination.furcationInvolvement}</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty examination.toothSensitivity}">
                                        <div class="procedure-info-item">
                                            <span class="info-label">Tooth Sensitivity</span>
                                            <span class="info-value">${examination.toothSensitivity}</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty examination.chiefComplaints}">
                                        <div class="procedure-info-item">
                                            <span class="info-label">Chief Complaints</span>
                                            <span class="info-value">${examination.chiefComplaints}</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty examination.advised}">
                                        <div class="procedure-info-item">
                                            <span class="info-label">Treatment Advised</span>
                                            <span class="info-value">${examination.advised}</span>
                                        </div>
                                    </c:if>
                                    <div class="procedure-info-item">
                                        <span class="info-label">Assigned Doctor</span>
                                        <span class="info-value">
                                            <c:if test="${not empty doctor}">
                                                Dr. ${doctor.firstName} ${doctor.lastName}
                                            </c:if>
                                            <c:if test="${empty doctor}">
                                                Not assigned yet
                                            </c:if>
                                        </span>
                                    </div>
                                    <c:if test="${not empty opdDoctor}">
                                        <div class="procedure-info-item">
                                            <span class="info-label">OPD Doctor</span>
                                            <span class="info-value">Dr. ${opdDoctor.firstName} ${opdDoctor.lastName}</span>
                                        </div>
                                    </c:if>
                                    <!-- Pricing: show discounted final price if any discount is applied -->
                                    <c:set var="basePrice" value="${not empty examination.basePriceAtAssociation ? examination.basePriceAtAssociation : procedure.price}" />
                                    <c:set var="effectivePrice" value="${not empty examination.effectiveTotalProcedureAmount ? examination.effectiveTotalProcedureAmount : basePrice}" />
                                    <c:set var="hasDiscount" value="${(examination.aggregatedDiscountPercentage gt 0) or (not empty examination.discountPercentage and examination.discountPercentage gt 0)}" />
                                    <c:choose>
                                        <c:when test="${hasDiscount}">
                                            <div class="procedure-info-item">
                                                <span class="info-label">Final Price</span>
                                                <span class="info-value">₹${effectivePrice}</span>
                                            </div>
                                            <div class="procedure-info-item">
                                                <span class="info-label">Base Price</span>
                                                <span class="info-value">₹${basePrice}</span>
                                            </div>
                                            <div class="procedure-info-item">
                                                <span class="info-label">Discount</span>
                                                <span class="info-value">
                                                    <c:choose>
                                                        <c:when test="${not empty examination.aggregatedDiscountPercentage and examination.aggregatedDiscountPercentage gt 0}">
                                                            ${examination.aggregatedDiscountPercentage}%
                                                        </c:when>
                                                        <c:when test="${not empty examination.discountPercentage and examination.discountPercentage gt 0}">
                                                            ${examination.discountPercentage}%
                                                        </c:when>
                                                        <c:otherwise>
                                                            Applied
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <c:if test="${not empty examination.discountReason}">
                                                        - ${examination.discountReason}
                                                    </c:if>
                                                </span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="procedure-info-item">
                                                <span class="info-label">Price</span>
                                                <span class="info-value">₹${basePrice}</span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="procedure-info-item">
                                        <span class="info-label">Payment Status</span>
                                        <span class="info-value payment-status">${paymentStatus}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Clinical Notes Modal -->
                        <div id="clinicalNotesModal" class="modal" style="display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5);">
                            <div class="modal-content" style="background-color: white; margin: 5% auto; padding: 0; border-radius: 12px; width: 90%; max-width: 600px; box-shadow: 0 8px 32px rgba(0,0,0,0.3);">
                                <div class="modal-header" style="background: linear-gradient(135deg, #3498db, #2980b9); color: white; padding: 20px; border-radius: 12px 12px 0 0;">
                                    <h3 style="margin: 0; font-size: 1.3rem; display: flex; align-items: center; gap: 10px;">
                                        <i class="fas fa-clipboard-list"></i> Clinical Notes
                                    </h3>
                                    <span class="close-modal" onclick="closeClinicalNotesModal()" style="position: absolute; right: 20px; top: 20px; font-size: 28px; font-weight: bold; cursor: pointer; color: white;">&times;</span>
                                </div>
                                <div class="modal-body" style="padding: 25px;">
                                    <form id="clinicalNotesForm">
                                        <div class="form-group" style="margin-bottom: 20px;">
                                            <label for="mainClinicalNotes" style="display: block; margin-bottom: 8px; font-weight: 600; color: #2c3e50;">Add New Clinical Notes</label>
                                            <textarea id="mainClinicalNotes" class="form-control" rows="4" placeholder="Enter new clinical observations, treatment notes, and any complications..." style="width: 100%; padding: 15px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; resize: vertical; font-family: 'Poppins', sans-serif;"></textarea>
                                        </div>
                                        
                                        <c:if test="${not empty examination.examinationNotes}">
                                            <div class="form-group" style="margin-bottom: 20px;">
                                                <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #2c3e50;">Clinical Notes History</label>
                                                <div class="notes-history" style="background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 15px; max-height: 300px; overflow-y: auto; font-family: 'Courier New', monospace; font-size: 12px; white-space: pre-wrap; line-height: 1.4; color: #495057;">
                                                    ${examination.examinationNotes}
                                                </div>
                                            </div>
                                        </c:if>
                                        <div class="modal-footer" style="display: flex; justify-content: flex-end; gap: 12px; padding: 20px 0 0 0; border-top: 1px solid #eee; margin-top: 20px;">
                                            <button type="button" class="btn btn-secondary" onclick="closeClinicalNotesModal()" style="background: #95a5a6; color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer;">Cancel</button>
                                            <button type="button" id="saveClinicalNotes" class="btn btn-primary" style="background: linear-gradient(135deg, #3498db, #2980b9); color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: 600;">
                                                <i class="fas fa-save"></i> Save Notes
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Follow-up Planning Section (Initially Hidden) -->
                        <div class="clinical-card next-sitting-card" id="nextSittingCard" style="display: none;">
                            <div class="clinical-card-header">
                                <h3><i class="fas fa-calendar-alt"></i> Next Sitting Planning</h3>
                            </div>
                            <div class="clinical-card-body">
                                <form id="nextSittingForm" action="${pageContext.request.contextPath}/patients/examination/${examination.id}/schedule-followup" method="post">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    
                                    <div class="follow-up-required">
                                        <label>Next Sitting Required?</label>
                                        <div class="follow-up-toggle">
                                            <input type="radio" id="nextSittingYes" name="followUpRequired" value="yes" 
                                                ${not empty examination.followUpDate ? 'checked' : ''} 
                                                ${examination.procedureStatus == 'CANCELLED' ? 'disabled' : ''}>
                                            <label for="followUpYes">Yes</label>
                                            
                                            <input type="radio" id="nextSittingNo" name="followUpRequired" value="no" 
                                                ${empty examination.followUpDate ? 'checked' : ''} 
                                                ${examination.procedureStatus == 'CANCELLED' ? 'disabled' : ''}>
                                            <label for="followUpNo">No</label>
                                        </div>
                                    </div>
                                    
                                    <div id="nextSittingDetails" ${not empty examination.followUpDate ? '' : 'style="display: none;"'}>
                                        <div class="form-row">
                                            <div class="form-group form-group-half">
                                                <label for="followupDate">Next Sitting Date</label>
                                                <input type="date" id="followupDate" name="followupDate" class="form-control" 
                                                    value="${not empty examination.followUpDate ? examination.followUpDate.toLocalDate() : ''}"
                                                    ${examination.procedureStatus == 'CANCELLED' ? 'disabled' : ''}>
                                            </div>
                                            <div class="form-group form-group-half">
                                                <label for="followupTime">Next Sitting Time</label>
                                                <input type="time" id="followupTime" name="followupTime" class="form-control"
                                                    value="${not empty examination.followUpDate ? examination.followUpDate.toLocalTime() : ''}"
                                                    ${examination.procedureStatus == 'CANCELLED' ? 'disabled' : ''}>
                                            </div>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="followupNotes">Next Sitting Instructions</label>
                                            <textarea id="followupNotes" name="followupNotes" class="form-control" rows="2" 
                                                placeholder="Enter next sitting instructions for the patient..."
                                                ${examination.procedureStatus == 'CANCELLED' ? 'disabled' : ''}></textarea>
                                        </div>
                                        
                                        <div class="follow-up-reason">
                                            <label>Reason for Next Sitting</label>
                                            <div class="checkbox-list">
                                                <div class="checkbox-item">
                                                    <input type="checkbox" id="reason1" name="followUpReason" value="checkHealing">
                                                    <label for="reason1">Check Healing</label>
                                                </div>
                                                <div class="checkbox-item">
                                                    <input type="checkbox" id="reason2" name="followUpReason" value="removalOfSutures">
                                                    <label for="reason2">Removal of Sutures</label>
                                                </div>
                                                <div class="checkbox-item">
                                                    <input type="checkbox" id="reason3" name="followUpReason" value="adjustments">
                                                    <label for="reason3">Adjustments</label>
                                                </div>
                                                <div class="checkbox-item">
                                                    <input type="checkbox" id="reason4" name="followUpReason" value="furtherTreatment">
                                                    <label for="reason4">Further Treatment</label>
                                                </div>
                                                <div class="checkbox-item">
                                                    <input type="checkbox" id="reason5" name="followUpReason" value="nextPhase">
                                                    <label for="reason5">Next Phase of Treatment</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="form-actions">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> Save Next Sitting Plan
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Procedure Lifecycle Timeline -->
            <div class="container">
                <div class="section-header">
                    <h2>Treatment Timeline</h2>
                </div>
                
                <!-- Timeline navigation for quick jumping -->
                <div class="timeline-navigation">
                    <div class="timeline-nav-item" data-target="#stage-examination">
                        <i class="fas fa-search"></i> Examination
                    </div>
                    <div class="timeline-nav-item" data-target="#stage-doctor">
                        <i class="fas fa-user-md"></i> Doctor Assignment
                    </div>
                    <div class="timeline-nav-item" data-target="#stage-procedure">
                        <i class="fas fa-clipboard-check"></i> Procedure
                    </div>
                    <div class="timeline-nav-item" data-target="#stage-payment">
                        <i class="fas fa-credit-card"></i> Payment
                    </div>
                    <div class="timeline-nav-item" data-target="#stage-followup">
                        <i class="fas fa-calendar-check"></i> Next Sitting
                    </div>
                </div>
                
                <div class="lifecycle-timeline">
                    <div class="timeline-line"></div>
                    
                    <c:forEach var="stage" items="${lifecycleStages}" varStatus="status">
                        <div id="stage-${status.index}" class="timeline-item">
                            <div class="timeline-dot ${stage.completed ? 'completed' : ''}">
                                <c:if test="${stage.completed}">
                                    <i class="fas fa-check"></i>
                                </c:if>
                            </div>
                            <div class="timeline-content ${stage.completed ? 'completed' : ''}">
                                <div class="timeline-header">
                                    <span class="timeline-title">${stage.name}</span>
                                    <div class="timeline-meta">
                                    <span class="timeline-timestamp">
                                        <c:if test="${not empty stage.timestamp}">
                                            <i class="far fa-clock"></i> ${stage.timestamp}
                                        </c:if>
                                    </span>
                                        <c:if test="${not empty stage.transitionedBy}">
                                            <span class="timeline-user">
                                                <i class="fas fa-user"></i> ${stage.transitionedBy}
                                                <c:if test="${not empty stage.transitionedByRole}">
                                                    <span class="user-role">(${stage.transitionedByRole})</span>
                                                </c:if>
                                            </span>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="timeline-description">
                                    ${stage.description}
                                </div>
                                <c:if test="${not empty stage.details}">
                                    <div class="timeline-details">
                                        <c:forEach var="detail" items="${stage.details}">
                                            <div class="detail-item">
                                                <span class="detail-label">${detail.key}:</span>
                                                <span class="detail-value">${detail.value}</span>
                                            </div>
                                        </c:forEach>
                                        <c:if test="${stage.name == 'Examination' && not empty opdDoctor}">
                                            <div class="detail-item">
                                                <span class="detail-label">Created By:</span>
                                                <span class="detail-value">Dr. ${opdDoctor.firstName} ${opdDoctor.lastName}</span>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            
            <!-- Flash Messages -->
            <%--
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert" style="position: fixed; top: 20px; right: 20px; z-index: 10000; min-width: 300px; max-width: 500px;">
                    <i class="fas fa-check-circle"></i> ${success}
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                        </div>
                                        </c:if>
            --%>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert" style="position: fixed; top: 20px; right: 20px; z-index: 10000; min-width: 300px; max-width: 500px;">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                                        </button>
                </div>
            </c:if>
            
            <!-- Status Update Notification -->
            <div class="status-notification">
                Status updated successfully
            </div>
        </div>
    </div>
    
    <script>
        $(document).ready(function() {
            // Ensure all modals are hidden on page load
            const modals = document.querySelectorAll('.modal');
            modals.forEach(modal => {
                modal.style.display = 'none';
            });
            
            // Initialize variables
            window.pendingStatusUpdate = null;
            const xrayUploadModal = document.getElementById('xrayUploadModal');
            
            // Get CSRF token
            const token = $("meta[name='_csrf']").attr("content");
            const header = $("meta[name='_csrf_header']").attr("content");
            
            // Setup AJAX to always send CSRF token
            $(function() {
                $(document).ajaxSend(function(e, xhr, options) {
                    xhr.setRequestHeader(header, token);
                });
            });
            
            // X-ray upload variables
            let xrayFile = null;
            let xrayUploadComplete = false;
            
            // X-ray upload elements
            const xrayInput = document.getElementById('xray-upload');
            const xrayPreview = document.getElementById('xray-preview');
            const xrayStatus = document.getElementById('xray-status');
            const xrayValidation = document.getElementById('xray-validation');
            const confirmXrayUpload = document.getElementById('confirmXrayUpload');
            const cancelXrayUpload = document.getElementById('cancelXrayUpload');
            const closeXrayModal = document.getElementById('closeXrayModal');
            const addMoreImagesBtn = document.getElementById('addMoreImagesBtn');
            let allSelectedFiles = [];
            
            // Initialize X-ray upload functionality
            function initializeXrayUpload() {
                const xrayInput = document.getElementById('xray-upload');
                const xrayDropzone = document.getElementById('xray-dropzone');
                const xrayThumbnails = document.getElementById('xray-thumbnails');
                const xrayStatus = document.getElementById('xray-status');
                const xrayValidation = document.getElementById('xray-validation');
                const confirmXrayUpload = document.getElementById('confirmXrayUpload');
                const addMoreImagesBtn = document.getElementById('addMoreImagesBtn');
                const cancelXrayUpload = document.getElementById('cancelXrayUpload');
                const closeXrayModal = document.getElementById('closeXrayModal');
                const xrayUploadModal = document.getElementById('xrayUploadModal');
                let allSelectedFiles = [];

                // Check if all required elements exist before proceeding
                if (!xrayInput || !xrayDropzone || !xrayThumbnails || !xrayStatus || !xrayValidation || 
                    !confirmXrayUpload || !addMoreImagesBtn || !cancelXrayUpload || !closeXrayModal || !xrayUploadModal) {
                    console.warn('Some X-ray upload elements not found, skipping initialization');
                    return;
                }

                // Click or keyboard focus opens file dialog
                xrayDropzone.addEventListener('click', () => xrayInput.click());
                xrayDropzone.addEventListener('keydown', (e) => {
                    if (e.key === 'Enter' || e.key === ' ') {
                        e.preventDefault();
                        xrayInput.click();
                    }
                });
                addMoreImagesBtn.addEventListener('click', () => xrayInput.click());

                // Drag-and-drop support
                xrayDropzone.addEventListener('dragover', (e) => {
                    e.preventDefault();
                    xrayDropzone.style.background = '#fff5f5';
                    xrayDropzone.style.outlineColor = '#e74c3c';
                });
                xrayDropzone.addEventListener('dragleave', (e) => {
                    e.preventDefault();
                    xrayDropzone.style.background = '#f8f9fa';
                    xrayDropzone.style.outlineColor = '#bdc3c7';
                });
                xrayDropzone.addEventListener('drop', async (e) => {
                    e.preventDefault();
                    xrayDropzone.style.background = '#f8f9fa';
                    xrayDropzone.style.outlineColor = '#bdc3c7';
                    const files = Array.from(e.dataTransfer.files).filter(f => f.type.startsWith('image/'));
                    if (files.length > 0) {
                        await mergeFiles(files);
                    }
                });

                // File input change
                xrayInput.addEventListener('change', async function(event) {
                    const files = Array.from(event.target.files);
                    await mergeFiles(files);
                });

                async function mergeFiles(newFiles) {
                    for (const file of newFiles) {
                        if (!allSelectedFiles.some(f => f.name === file.name && f.size === file.size)) {
                            // Compress the image before adding
                            const compressed = await ImageCompression.compressImage(file, {
                                maxSizeKB: 500,      // or your preferred size
                                maxDimension: 1200,  // or your preferred dimension
                                quality: 0.8
                            });
                            allSelectedFiles.push(compressed);
                        }
                    }
                    updateThumbnails();
                }

                function updateThumbnails() {
                    xrayThumbnails.innerHTML = '';
                    if (allSelectedFiles.length === 0) {
                        xrayThumbnails.innerHTML = '';
                        confirmXrayUpload.disabled = true;
                        xrayStatus.textContent = '';
                        xrayValidation.className = 'upload-validation';
                        xrayValidation.innerHTML = '<i class="fas fa-info-circle"></i> At least one X-ray image is required to close the case.';
                        return;
                    }
                    allSelectedFiles.forEach(file => {
                        if (!file.type.startsWith('image/')) return;
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            const img = document.createElement('img');
                            img.src = e.target.result;
                            img.style.maxWidth = '90px';
                            img.style.maxHeight = '90px';
                            img.style.borderRadius = '6px';
                            img.style.boxShadow = '0 1px 4px rgba(0,0,0,0.08)';
                            xrayThumbnails.appendChild(img);
                        };
                        reader.readAsDataURL(file);
                    });
                    confirmXrayUpload.disabled = false;
                    xrayStatus.textContent = allSelectedFiles.length + ' image(s) selected.';
                    xrayStatus.className = 'upload-status success';
                    xrayValidation.className = 'upload-validation success';
                    xrayValidation.innerHTML = '<i class="fas fa-check-circle"></i> Ready to upload ' + allSelectedFiles.length + ' image(s).';
                }

                // Modal close/cancel logic
                function resetXrayUpload() {
                    allSelectedFiles = [];
                    xrayInput.value = '';
                    xrayThumbnails.innerHTML = '';
                    xrayStatus.textContent = '';
                    xrayValidation.className = 'upload-validation';
                    xrayValidation.innerHTML = '<i class="fas fa-info-circle"></i> At least one X-ray image is required to close the case.';
                    confirmXrayUpload.disabled = true;
                }

                cancelXrayUpload.addEventListener('click', () => {
                    xrayUploadModal.style.display = 'none';
                    if (typeof window.pendingStatusUpdate !== 'undefined') window.pendingStatusUpdate = null;
                    resetXrayUpload();
                });
                closeXrayModal.addEventListener('click', () => {
                    xrayUploadModal.style.display = 'none';
                    if (typeof window.pendingStatusUpdate !== 'undefined') window.pendingStatusUpdate = null;
                    resetXrayUpload();
                });
                xrayUploadModal.addEventListener('click', (e) => {
                    if (e.target === xrayUploadModal) {
                        xrayUploadModal.style.display = 'none';
                        if (typeof window.pendingStatusUpdate !== 'undefined') window.pendingStatusUpdate = null;
                        resetXrayUpload();
                    }
                });

                // Confirm X-ray upload: send allSelectedFiles to backend
                confirmXrayUpload.addEventListener('click', async function() {
                    if (!allSelectedFiles || allSelectedFiles.length === 0) {
                        alert('Please select at least one X-ray image.');
                        return;
                    }
                    confirmXrayUpload.disabled = true;
                    confirmXrayUpload.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Uploading...';

                    try {
                        const examinationId = document.getElementById('examinationId').value;
                        const formData = new FormData();
                        allSelectedFiles.forEach(file => formData.append('xrayPictures', file));

                        // CSRF token
                        const token = $("meta[name='_csrf']").attr("content");
                        const header = $("meta[name='_csrf_header']").attr("content");

                        const response = await fetch(
                            `${pageContext.request.contextPath}/patients/examination/${examinationId}/upload-xray`,
                            {
                                method: 'POST',
                                headers: { [header]: token },
                                body: formData
                            }
                        );

                        if (response.ok) {
                            // Images uploaded, now close the case
                            const statusResponse = await fetch(
                                `${pageContext.request.contextPath}/patients/update-procedure-status`,
                                {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/json',
                                        [header]: token
                                    },
                                    body: JSON.stringify({ examinationId: examinationId, status: 'CLOSED' })
                                }
                            );
                            if (statusResponse.ok) {
                                alert('Case closed successfully!');
                                document.getElementById('xrayUploadModal').style.display = 'none';
                                resetXrayUpload();
                                window.location.reload();
                            } else {
                                alert('Images uploaded, but failed to close the case.');
                            }
                            return;
                        } else {
                            let errorMsg = 'Failed to upload X-ray images.';
                            try {
                                const errorData = await response.json();
                                if (errorData && errorData.message) errorMsg = errorData.message;
                            } catch (e) {}
                            alert(errorMsg);
                        }
                    } catch (error) {
                        alert('Error uploading X-ray images. Please try again.');
                    } finally {
                        confirmXrayUpload.disabled = false;
                        confirmXrayUpload.innerHTML = '<i class="fas fa-check"></i> Close Case';
                    }
                });

                // When submitting, use allSelectedFiles for upload
                window.getAllSelectedXrayFiles = function() {
                    return allSelectedFiles;
                };
            }
            
            // Initialize follow-up modal functionality
            function initializeNextSittingModal() {
                 const followUpModal = document.getElementById('nextSittingModal');
                const closeFollowUpModal = document.getElementById('closeNextSittingModal');
                const cancelFollowUp = document.getElementById('cancelNextSitting');
                const confirmFollowUp = document.getElementById('confirmNextSitting');
                const followUpValidation = document.getElementById('nextSittingValidation');
                const modalFollowupDate = document.getElementById('modalFollowupDate');
                const modalFollowupTime = document.getElementById('modalFollowupTime');
                
                // Only initialize if the elements exist (for backward compatibility)
                if (!followUpModal || !closeFollowUpModal || !cancelFollowUp || !confirmFollowUp) {

                    return;
                }
                
                // Modal controls
                cancelFollowUp.addEventListener('click', () => {
                    followUpModal.style.display = 'none';
                    window.pendingStatusUpdate = null;
                    resetFollowUpForm();
                });
                
                closeFollowUpModal.addEventListener('click', () => {
                    followUpModal.style.display = 'none';
                    window.pendingStatusUpdate = null;
                    resetFollowUpForm();
                });
                
                // Close modal when clicking outside
                followUpModal.addEventListener('click', (e) => {
                    if (e.target === followUpModal) {
                        followUpModal.style.display = 'none';
                        window.pendingStatusUpdate = null;
                        resetFollowUpForm();
                    }
                });
                
                // Validate form on input change
                if (modalFollowupDate) {
                modalFollowupDate.addEventListener('change', validateFollowUpForm);
                }
                if (modalFollowupTime) {
                modalFollowupTime.addEventListener('change', validateFollowUpForm);
                }
                
                // Confirm follow-up scheduling
                confirmFollowUp.addEventListener('click', handleFollowUpConfirm);
            }
            
            // Validate follow-up form
            function validateNextSittingForm() {
                 const modalFollowupDate = document.getElementById('modalNextSittingDate');
                 const modalFollowupTime = document.getElementById('modalNextSittingTime');
                const confirmFollowUp = document.getElementById('confirmFollowUp');
                const followUpValidation = document.getElementById('followUpValidation');
                
                const hasDate = modalFollowupDate.value.trim() !== '';
                const hasTime = modalFollowupTime.value.trim() !== '';
                
                if (hasDate && hasTime) {
                    confirmFollowUp.disabled = false;
                    followUpValidation.style.display = 'none';
                } else {
                    confirmFollowUp.disabled = true;
                    followUpValidation.style.display = 'block';
                }
            }
            
            // Handle follow-up confirmation
            async function handleNextSittingConfirm() {
                 const examinationId = $('#examinationId').val();
                 const modalFollowupDate = document.getElementById('modalNextSittingDate');
                 const modalFollowupTime = document.getElementById('modalNextSittingTime');
                 const modalFollowupNotes = document.getElementById('modalNextSittingNotes');
                const confirmFollowUp = document.getElementById('confirmFollowUp');
                
                // Validate required fields
                if (!modalFollowupDate.value || !modalFollowupTime.value) {
                    document.getElementById('followUpValidation').style.display = 'block';
                    return;
                }
                
                // Disable button and show loading
                confirmFollowUp.disabled = true;
                confirmFollowUp.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Scheduling...';
                
                try {
                    // Schedule the follow-up
                    const followUpData = {
                        followupDate: modalFollowupDate.value,
                        followupTime: modalFollowupTime.value,
                        followupNotes: modalFollowupNotes.value
                    };
                    
                    const followUpResponse = await fetch('${pageContext.request.contextPath}/patients/examination/' + examinationId + '/schedule-followup', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            [header]: token
                        },
                        body: JSON.stringify(followUpData)
                    });
                    
                    if (followUpResponse.ok) {
                        // Success - reload page to show new follow-up
                            window.location.reload();
                    } else {
                        throw new Error('Failed to schedule follow-up');
                        }
                } catch (error) {
                    alert('Failed to schedule follow-up. Please try again.');
                } finally {
                    // Reset button
                    confirmFollowUp.disabled = false;
                    confirmFollowUp.innerHTML = '<i class="fas fa-check"></i> Schedule Next Sitting';
                }
            }
            
            // Reset follow-up form
            function resetNextSittingForm() {
                 const modalFollowupDate = document.getElementById('modalNextSittingDate');
                 const modalFollowupTime = document.getElementById('modalNextSittingTime');
                 const modalFollowupNotes = document.getElementById('modalNextSittingNotes');
                const followUpValidation = document.getElementById('followUpValidation');
                
                if (modalFollowupDate) modalFollowupDate.value = '';
                if (modalFollowupTime) modalFollowupTime.value = '';
                if (modalFollowupNotes) modalFollowupNotes.value = '';
                if (followUpValidation) followUpValidation.style.display = 'none';
            }
            
            // Handle X-ray upload
            async function handleXrayUpload(event) {
                const file = event.target.files[0];
                if (!file) return;
                
                // Validate file type
                if (!file.type.startsWith('image/')) {
                    xrayStatus.textContent = 'Please select an image file';
                    xrayStatus.className = 'upload-status error';
                    return;
                }
                
                // Show loading state
                ImageCompression.showLoading(xrayPreview, 'Compressing X-ray image...');
                xrayStatus.textContent = 'Compressing image...';
                xrayStatus.className = 'upload-status';
                
                try {
                    // Compress the image with appropriate settings for X-ray
                    const compressedFile = await ImageCompression.compressImage(file, {
                        maxSizeKB: 500,  // Allow larger size for X-ray images
                        maxDimension: 1200,  // Higher resolution for medical images
                        quality: 0.8
                    });
                    
                    // Update the file input with compressed file
                    ImageCompression.updateFileInput(xrayInput, compressedFile);
                    
                    // Create preview
                    ImageCompression.createPreview(compressedFile, xrayPreview, {
                        defaultIcon: '<i class="fas fa-image"></i>',
                        defaultText: 'No image selected'
                    });
                    
                    xrayFile = compressedFile;
                    xrayStatus.textContent = 'X-ray image compressed and ready: ' + compressedFile.name;
                    xrayStatus.className = 'upload-status success';
                    
                    // Enable confirm button
                    confirmXrayUpload.disabled = false;
                    xrayValidation.className = 'upload-validation success';
                    xrayValidation.innerHTML = '<i class="fas fa-check-circle"></i> X-ray image compressed and ready for upload';
                } catch (error) {
                    xrayStatus.textContent = 'Error compressing image. Please try again.';
                    xrayStatus.className = 'upload-status error';
                    ImageCompression.createPreview(null, xrayPreview, {
                        defaultIcon: '<i class="fas fa-image"></i>',
                        defaultText: 'No image selected'
                    });
                }
            }
            
            // Handle X-ray confirmation
            async function handleXrayConfirm() {
                if (!xrayFile) {
                    alert('Please select an X-ray image first');
                    return;
                }
                confirmXrayUpload.disabled = true;
                confirmXrayUpload.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Closing Case...';
                try {
                    // Prepare form data for combined X-ray upload and status update
                    const formData = new FormData();
                    formData.append('examinationId', $('#examinationId').val());
                    formData.append('status', 'CLOSED');
                    formData.append('xrayPicture', xrayFile);
                    // Use the combined endpoint
                    const response = await fetch('${pageContext.request.contextPath}/patients/update-examination-status-with-xray', {
                        method: 'POST',
                        headers: {
                            [header]: token
                        },
                        body: formData
                    });
                    if (response.ok) {
                        xrayUploadComplete = true;
                        xrayUploadModal.style.display = 'none';
                        alert('X-ray uploaded and case closed successfully!');
                        window.location.reload();
                    } else {
                        let errorMsg = 'Failed to close case';
                        try {
                            const errorData = await response.json();
                            if (errorData && errorData.message) errorMsg = errorData.message;
                        } catch (e) {}
                        alert(errorMsg);
                        return;
                    }
                } catch (error) {
                    alert('Error processing request. Please try again.');
                } finally {
                    confirmXrayUpload.disabled = false;
                    confirmXrayUpload.innerHTML = '<i class="fas fa-check"></i> Close Case';
                }
            }
            
            // Status dropdown functionality
            const statusDropdown = document.querySelector('.status-dropdown');
            const statusDropdownContent = document.querySelector('.status-dropdown-content');
            const statusOptions = document.querySelectorAll('.status-option');
            
            
            
            if (statusDropdown) {
                statusDropdown.addEventListener('click', function(e) {
                    e.stopPropagation();
                    const statusDropdownBtn = this.querySelector('.status-dropdown-btn');
                    if (statusDropdownBtn && !statusDropdownBtn.classList.contains('disabled') && !statusDropdownBtn.classList.contains('cancelled')) {
                        statusDropdownContent.classList.toggle('show');
                        const dropdownIcon = statusDropdownBtn.querySelector('.dropdown-icon i');
                        if (dropdownIcon) {
                            dropdownIcon.style.transform = statusDropdownContent.classList.contains('show') ? 'rotate(180deg)' : 'rotate(0deg)';
                        }
                    }
                });
                
                // Close dropdown when clicking outside
                document.addEventListener('click', function(e) {
                    if (!statusDropdown.contains(e.target) && !statusDropdownContent.contains(e.target)) {
                        statusDropdownContent.classList.remove('show');
                        const dropdownIcon = statusDropdown.querySelector('.dropdown-icon i');
                        if (dropdownIcon) {
                            dropdownIcon.style.transform = 'rotate(0deg)';
                        }
                    }
                });
                
                // Handle status option clicks
                statusOptions.forEach(option => {
                    option.addEventListener('click', function() {
                        const newStatus = this.getAttribute('data-status');
                        const currentStatus = '${examination.procedureStatus}';
                        
                        if (newStatus) {
                            // Prevent selecting the same status
                            if (newStatus === currentStatus) {
                                alert('This status is already active. No change needed.');
                                statusDropdownContent.classList.remove('show');
                                const dropdownIcon = statusDropdown.querySelector('.dropdown-icon i');
                                if (dropdownIcon) {
                                    dropdownIcon.style.transform = 'rotate(0deg)';
                                }
                                return;
                            }
                            
                            updateProcedureStatus(newStatus);
                        }
                        statusDropdownContent.classList.remove('show');
                        const dropdownIcon = statusDropdown.querySelector('.dropdown-icon i');
                        if (dropdownIcon) {
                            dropdownIcon.style.transform = 'rotate(0deg)';
                        }
                    });
                });
            }
            
            // Update procedure status directly (without X-ray)
            window.updateProcedureStatusDirect = async function(newStatus) {
                const examinationId = $('#examinationId').val();
                
                // First, refresh the payment status from server
                try {
                    const refreshResponse = await fetch(`${pageContext.request.contextPath}/patients/examination/${examinationId}/payment-status`, {
                        method: 'GET',
                        headers: {
                            'Content-Type': 'application/json'
                        }
                    });
                    
                    if (refreshResponse.ok) {
                        const paymentData = await refreshResponse.json();
                        
                        // Update the payment status on the page
                        const paymentStatusElement = document.querySelector('.payment-status');
                        if (paymentStatusElement && paymentData.paymentStatus) {
                            paymentStatusElement.textContent = paymentData.paymentStatus;
                        }
                    }
                } catch (error) {
                    // Silent on refresh errors
                }
                
                // Get CSRF token
                const token = $("meta[name='_csrf']").attr("content");
                const header = $("meta[name='_csrf_header']").attr("content");
                
                try {
                    const url = '${pageContext.request.contextPath}/patients/update-procedure-status';
                    
                    const response = await fetch(url, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            [header]: token
                        },
                        body: JSON.stringify({ examinationId: examinationId, status: newStatus })
                    });
                    
                    const responseText = await response.text();
                    
                    if (responseText.trim().startsWith('<!DOCTYPE')) {
                        alert('Authentication error. Please refresh the page and try again.');
                        return;
                    }
                    
                    let result;
                    try {
                        result = JSON.parse(responseText);
                    } catch (parseError) {
                        alert('Server returned invalid response. Please try again.');
                        return;
                    }
                    
                    if (result.success) {
                        alert('Status updated successfully!');
                        window.location.reload();
                    } else {
                        // Check if it's a payment pending error
                        if (result.message && result.message.includes('payment') && result.message.includes('pending')) {
                            showPaymentPendingModal();
                        } else {
                            alert(result.message || 'Failed to update status');
                        }
                    }
                } catch (error) {
                    alert('Failed to update status. Please try again.');
                }
            }
            
            // Update procedure status
            async function updateProcedureStatus(newStatus) {
                const examinationId = $('#examinationId').val();
                
                // Get CSRF token
                const token = $("meta[name='_csrf']").attr("content");
                const header = $("meta[name='_csrf_header']").attr("content");
                
                // Check if X-ray is required for closing
                const currentStatus = '${examination.procedureStatus}';
                
                if (newStatus === 'CLOSED' && currentStatus !== 'CLOSED' && !xrayUploadComplete) {
                    window.pendingStatusUpdate = newStatus;
                    try {
                        showXrayConfirmationModal();
                    } catch (error) {
                        // Fallback to alert
                        const userChoice = confirm('Do you want to upload an X-ray image before closing the case?\n\nClick "OK" to upload X-ray\nClick "Cancel" to close without X-ray');
                        if (userChoice) {
                            const xrayUploadModal = document.getElementById('xrayUploadModal');
                            if (xrayUploadModal) {
                                xrayUploadModal.style.display = 'block';
                            }
                        } else {
                            updateProcedureStatusDirect(newStatus);
                        }
                    }
                    return;
                }
                
                if (newStatus === 'CLOSED' && currentStatus === 'CLOSED') {
                    alert('This case is already closed. No action needed.');
                    return;
                }
                
                try {
                    const url = '${pageContext.request.contextPath}/patients/update-procedure-status';
                    
                    const response = await fetch(url, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                            // Temporarily removed CSRF token for testing
                        },
                        body: JSON.stringify({ examinationId: examinationId, status: newStatus })
                    });
                    
                    // Debug: Check if response is JSON or HTML
                    const responseText = await response.text();
                    
                    if (responseText.trim().startsWith('<!DOCTYPE')) {
                        alert('Authentication error. Please refresh the page and try again.');
                        return;
                    }
                    
                    // Try to parse as JSON
                    let result;
                    try {
                        result = JSON.parse(responseText);
                    } catch (parseError) {
                        alert('Server returned invalid response. Please try again.');
                        return;
                    }
                    
                    if (result.success) {
                        // Show success notification
                        const notification = document.querySelector('.status-notification');
                        notification.style.display = 'block';
                        setTimeout(() => {
                            notification.style.display = 'none';
                        }, 3000);
                        
                        // Reload page to reflect changes
                        setTimeout(() => {
                        window.location.reload();
                        }, 1000);
                    } else {
                        alert(result.message || 'Failed to update status');
                        return;
                    }
                } catch (error) {
                    alert('Failed to update status. Please try again.');
                }
            }
            
            // Clinical notes modal toggle
            const toggleClinicalNotes = document.getElementById('toggleClinicalNotes');
            
            if (toggleClinicalNotes) {
                toggleClinicalNotes.addEventListener('click', function() {
                    document.getElementById('clinicalNotesModal').style.display = 'block';
                });
            }
            
            // Attach more images button
            const attachMoreImagesBtn = document.getElementById('attachMoreImagesBtn');
            
            if (attachMoreImagesBtn) {
                attachMoreImagesBtn.addEventListener('click', function() {
                    showXrayUploadModal();
                });
            }
            
            // Load attached images when page loads
            loadAttachedImages();
            
            // Image modal event listeners
            const imageModal = document.getElementById('imageModal');
            if (imageModal) {
                imageModal.addEventListener('click', function(e) {
                    if (e.target === this) {
                        closeImageModal();
                    }
                });
            }
            
            // Close image modal with Escape key
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape' && document.getElementById('imageModal').style.display === 'block') {
                    closeImageModal();
                }
                
                // Toggle images section with 'I' key
                if (e.key === 'i' || e.key === 'I') {
                    toggleImagesSection();
                }
            });
            
            // Save clinical notes
            const saveClinicalNotes = document.getElementById('saveClinicalNotes');
            const mainClinicalNotes = document.getElementById('mainClinicalNotes');
            
            if (saveClinicalNotes && mainClinicalNotes) {
                saveClinicalNotes.addEventListener('click', async function() {
                    const notes = mainClinicalNotes.value;
                    const examinationId = $('#examinationId').val();
                    
                    // Get CSRF token
                    const token = $("meta[name='_csrf']").attr("content");
                    const header = $("meta[name='_csrf_header']").attr("content");
                
                    try {
                        const response = await fetch('${pageContext.request.contextPath}/patients/examination/' + examinationId + '/save-notes', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                                [header]: token
                            },
                            body: JSON.stringify({ notes: notes })
                        });
                        
                        if (response.ok) {
                            const result = await response.json();
                            if (result.success) {
                                alert('Clinical notes saved successfully!');
                                // Close the modal after successful save
                                document.getElementById('clinicalNotesModal').style.display = 'none';
                            } else {
                                throw new Error(result.message || 'Failed to save notes');
                            }
                        } else {
                            throw new Error('Failed to save notes');
                        }
                    } catch (error) {
                        alert('Failed to save notes. Please try again.');
                    }
                });
            }
            
            // Follow-up form toggle
            const followUpRequiredRadios = document.querySelectorAll('input[name="followUpRequired"]');
            const followUpDetails = document.getElementById('followUpDetails');
            
            followUpRequiredRadios.forEach(radio => {
                radio.addEventListener('change', function() {
                    if (this.value === 'yes') {
                        followUpDetails.style.display = 'block';
                    } else {
                        followUpDetails.style.display = 'none';
                    }
                });
            });
            
            // Timeline navigation
            const timelineNavItems = document.querySelectorAll('.timeline-nav-item');
            const timelineItems = document.querySelectorAll('.timeline-item');
            
            timelineNavItems.forEach(item => {
                item.addEventListener('click', function() {
                    const targetId = this.getAttribute('data-target');
                    const targetElement = document.querySelector(targetId);
                    
                    if (targetElement) {
                        targetElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                });
            });
            
            // Initialize all functionality
            initializeXrayUpload();
            (typeof initializeFollowUpModal === 'function') && initializeFollowUpModal();
            
            // Close modal functions
            window.closeCompleteNextSittingModal = function() {
                document.getElementById('completeNextSittingModal').style.display = 'none';
            };
            
            window.closeRescheduleNextSittingModal = function() {
                document.getElementById('rescheduleNextSittingModal').style.display = 'none';
            };
            
            window.closeCancelNextSittingModal = function() {
                document.getElementById('cancelNextSittingModal').style.display = 'none';
            };
            

            
            window.showCancelNextSittingModal = function(followUpId, examinationId) {
                document.getElementById('cancelNextSittingId').value = followUpId;
                document.getElementById('cancelExaminationId').value = examinationId;
                var reasonInput = document.getElementById('cancelReason');
                if (reasonInput) reasonInput.value = '';
                document.getElementById('cancelFollowUpModal').style.display = 'block';
            };
            
            // Reopen case functionality
            window.showReopenModal = function() {
                const modal = document.getElementById('reopenModal');
                modal.style.display = 'flex';
                modal.classList.add('flex-center');
                // Clear form
                document.getElementById('reopenForm').reset();
            };
            
            window.closeReopenModal = function() {
                const modal = document.getElementById('reopenModal');
                modal.style.display = 'none';
                modal.classList.remove('flex-center');
            };
            
            window.reopenCase = async function() {
                const reopeningReason = document.getElementById('reopeningReason').value.trim();
                const patientCondition = document.getElementById('patientCondition').value.trim();
                const treatmentPlan = document.getElementById('treatmentPlan').value.trim();
                const notes = document.getElementById('notes').value.trim();
                
                if (!reopeningReason) {
                    alert('Please provide a reason for reopening the case.');
                    return;
                }
                
                if (!patientCondition) {
                    alert('Please describe the patient\'s current condition.');
                    return;
                }
                
                if (!treatmentPlan) {
                    alert('Please outline the treatment plan.');
                    return;
                }
                
                if (!confirm('Are you sure you want to reopen this case? This action will be recorded under your name.')) {
                    return;
                }
                
                const examinationId = '${examination.id}';
                const csrfToken = document.querySelector('meta[name="_csrf"]').content;
                
                try {
                    const response = await fetch('${pageContext.request.contextPath}/patients/examination/' + examinationId + '/reopen', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'X-CSRF-TOKEN': csrfToken
                        },
                        body: JSON.stringify({
                            reopeningReason: reopeningReason,
                            patientCondition: patientCondition,
                            treatmentPlan: treatmentPlan,
                            notes: notes
                        })
                    });
                    
                    const result = await response.json();
                    
                    if (result.success) {
                        alert('Case reopened successfully! The case is now in "Reopen" status and can be moved to "In Progress".');
                        closeReopenModal();
                        // Reload the page to show updated status
                        window.location.reload();
                    } else {
                        alert('Error reopening case: ' + result.message);
                    }
                } catch (error) {
                    alert('Error reopening case. Please try again.');
                }
            };
            

        });
    </script>
    <script>
    document.getElementById('printPrescriptionBtn').addEventListener('click', function() {
        const examinationId = '${examination.id}';
        const contextPath = '${pageContext.request.contextPath}';
        const prescriptionWindow = window.open(
            contextPath + '/patients/examination/' + examinationId + '/prescription',
            'Prescription',
            'width=800,height=600,scrollbars=yes,resizable=yes'
        );
        if (prescriptionWindow) {
            prescriptionWindow.focus();
                } else {
            alert('Please allow pop-ups for this site to print prescription');
        }
        });
    </script>
    
    <!-- Chairside Note Component -->
    <jsp:include page="/WEB-INF/views/common/chairside-note-component.jsp" />
    
    <script>
    // Doctor assignment moved to the procedures page
    </script>

    <!-- X-ray Upload Confirmation Modal -->
    <div id="xrayConfirmationModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-question-circle"></i> Close Case Options</h3>
                <span class="close-modal" onclick="closeXrayConfirmationModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p>Do you want to upload an X-ray image before closing the case?</p>
                <div class="modal-options">
                    <button type="button" class="btn btn-primary" onclick="selectXrayOption('upload')">
                        <i class="fas fa-upload"></i> Upload X-ray Image
                    </button>
                    <button type="button" class="btn btn-success" onclick="selectXrayOption('close');">
                        <i class="fas fa-check-circle"></i> Close Without X-ray
                    </button>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeXrayConfirmationModal()">Cancel</button>
            </div>
        </div>
    </div>

    <!-- X-ray Upload Modal for Attaching More Images -->
    <div id="xrayUploadModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-paperclip"></i> Attach Additional Images</h3>
                <span class="close-modal" onclick="closeXrayUploadModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p>Upload X-ray or clinical images for this case.</p>
                <input type="file" id="xray-upload" name="xrayPictures" accept="image/*" multiple>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeXrayUploadModal()">Cancel</button>
                <button type="button" class="btn btn-primary" id="confirmXrayUpload">
                    <i class="fas fa-check"></i> Upload Images
                </button>
            </div>
        </div>
    </div>

    <!-- Payment Pending Modal -->
    <div id="paymentPendingModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-exclamation-triangle"></i> Payment Required</h3>
                <span class="close-modal" onclick="closePaymentPendingModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div style="text-align: center; margin: 20px 0;">
                    <i class="fas fa-credit-card" style="font-size: 3rem; color: #e74c3c; margin-bottom: 15px;"></i>
                    <h4 style="color: #e74c3c; margin-bottom: 15px;">Payment Pending</h4>
                    <p style="font-size: 1.1rem; line-height: 1.6; color: #2c3e50;">
                        Cannot close the case because payment is still pending. Please collect the full payment before closing the case.
                    </p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="closePaymentPendingModal()">
                    <i class="fas fa-check"></i> Understood
                </button>
            </div>
        </div>
    </div>

    <!-- Reopen Case Modal -->
    <div id="reopenModal" class="modal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-redo"></i> Reopen Case</h3>
                <span class="close-modal" onclick="closeReopenModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div class="reopen-warning" style="background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 6px; padding: 15px; margin-bottom: 20px;">
                    <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 10px;">
                        <i class="fas fa-exclamation-triangle" style="color: #856404;"></i>
                        <strong style="color: #856404;">Important Notice</strong>
                    </div>
                    <p style="margin: 0 0 15px 0; color: #856404; font-size: 0.95rem;">
                        Only reopen this case if you are the doctor who will treat this patient further. 
                        This action will be tracked under your name and the reopening will be recorded in the system.
                    </p>
                </div>
                
                <form id="reopenForm">
                    <div class="form-group">
                        <label for="reopeningReason" style="font-weight: 600; color: #2c3e50; margin-bottom: 8px; display: block;">
                            Reason for Reopening <span style="color: #e74c3c;">*</span>
                        </label>
                        <textarea id="reopeningReason" name="reopeningReason" rows="3" class="form-control" 
                                  placeholder="Please provide a detailed reason for reopening this case..." required></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="patientCondition" style="font-weight: 600; color: #2c3e50; margin-bottom: 8px; display: block;">
                            Patient's Current Condition <span style="color: #e74c3c;">*</span>
                        </label>
                        <textarea id="patientCondition" name="patientCondition" rows="3" class="form-control" 
                                  placeholder="Describe the patient's current condition..." required></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="treatmentPlan" style="font-weight: 600; color: #2c3e50; margin-bottom: 8px; display: block;">
                            Treatment Plan <span style="color: #e74c3c;">*</span>
                        </label>
                        <textarea id="treatmentPlan" name="treatmentPlan" rows="3" class="form-control" 
                                  placeholder="Outline the treatment plan for the reopened case..." required></textarea>
                    </div>
                    
                    <!-- Clinic field removed as it's not needed -->
                    
                    <div class="form-group">
                        <label for="notes" style="font-weight: 600; color: #2c3e50; margin-bottom: 8px; display: block;">
                            Additional Notes
                        </label>
                        <textarea id="notes" name="notes" rows="2" class="form-control" 
                                  placeholder="Any additional notes or observations..."></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeReopenModal()">Cancel</button>
                <button type="button" class="btn btn-warning" onclick="reopenCase()" style="background: #ffc107; border-color: #ffc107; color: #212529;">
                    <i class="fas fa-redo"></i> Reopen Case
                </button>
            </div>
        </div>
    </div>
    
    <!-- Image optimization and preloading script -->
    <script>
        // Image preloading for better performance
        function preloadImages(imageUrls) {
            imageUrls.forEach(url => {
                const img = new Image();
                img.src = url;
            });
        }
        
        // Preload common images when page loads
        document.addEventListener('DOMContentLoaded', function() {
            // Preload common UI images
            const commonImages = [
                '${pageContext.request.contextPath}/images/tooth-repair.svg',
                '${pageContext.request.contextPath}/images/default-profile.png'
            ];
            preloadImages(commonImages);
            
            // Add intersection observer for lazy loading
            if ('IntersectionObserver' in window) {
                const imageObserver = new IntersectionObserver((entries, observer) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            const img = entry.target;
                            img.src = img.dataset.src;
                            img.classList.remove('lazy');
                            observer.unobserve(img);
                        }
                    });
                });
                
                // Observe all lazy images
                document.querySelectorAll('img[data-src]').forEach(img => {
                    imageObserver.observe(img);
                });
            }
        });
        
        // Image loading optimization
        function optimizeImageLoading() {
            const images = document.querySelectorAll('img[src*="/uploads/"]');
            images.forEach(img => {
                // Add loading="lazy" if not already present
                if (!img.hasAttribute('loading')) {
                    img.setAttribute('loading', 'lazy');
                }
                
                // Add error handling
                img.onerror = function() {
                    this.style.display = 'none';
                    this.parentElement.innerHTML = '<div style="display: flex; align-items: center; justify-content: center; height: 100%; color: #e74c3c;"><i class="fas fa-exclamation-triangle"></i> Image not found</div>';
                };
            });
        }
        
        // Call optimization when page loads
        document.addEventListener('DOMContentLoaded', optimizeImageLoading);
    </script>
</body>
</html>