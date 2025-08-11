<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html>
<head>
    <title>Select Procedure - PeriDesk</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/imageCompression.js"></script>
    
    <!-- Include common menu styles -->
    <jsp:include page="/WEB-INF/views/common/menuStyles.jsp" />
    
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
        
        .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.2);
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
        
        .footer {
            margin-top: auto;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
            text-align: center;
            font-size: 12px;
            color: #999;
        }
        
        .copyright {
            margin: 5px 0;
        }
        
        .powered-by {
            color: #3498db;
            font-weight: 500;
        }
        
        .navtech {
            color: #2c3e50;
            font-weight: 600;
        }
        
        /* Procedure Selection Specific Styles */
        .procedure-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            padding: 20px;
            margin-bottom: 20px;
            overflow: hidden;
        }
        
        .procedure-header {
            margin-bottom: 15px;
            padding-bottom: 12px;
            border-bottom: 1px solid #eee;
        }
        
        .procedure-header h2 {
            margin: 0;
            color: #2c3e50;
            font-size: 1.4rem;
            margin-bottom: 8px;
        }
        
        .city-tier-info {
            margin: 8px 0;
            padding: 6px 10px;
            background-color: #f0f7ff;
            border-left: 3px solid #3498db;
            color: #2c3e50;
            font-size: 0.85rem;
            border-radius: 4px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        
        .city-tier-info i {
            color: #3498db;
            font-size: 0.9rem;
        }
        
        .city-tier-info strong {
            color: #3498db;
            font-weight: 600;
        }
        
        .procedure-meta {
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
        
        .selected-procedures-info {
            display: flex;
            flex-direction: column;
            align-items: stretch;
            margin-top: 10px;
            padding: 16px;
            background-color: #f8f9fa;
            border-radius: 8px;
            font-weight: 500;
            font-size: 0.9rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            border: 1px solid #eee;
        }
        
        .selection-status {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }
        
        .action-buttons {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        #selected-count {
            color: #3498db;
            font-weight: 600;
        }
        
        .total-amount {
            color: #3498db;
            font-weight: 600;
            background-color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .selected-procedure-info {
            background-color: #e8f5e9;
            padding: 8px 12px;
            border-radius: 4px;
            margin-right: auto;
            font-weight: 500;
            color: #1b5e20;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 5px;
            display: none;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        
        /* Button styling */
        #view-selected-procedures {
            background: #6c7ae0;
            color: white;
            transition: all 0.3s ease;
            position: relative;
            white-space: nowrap;
            padding: 10px 16px;
        }
        
        #view-selected-procedures:hover {
            background: #5a65c5;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(108, 122, 224, 0.3);
        }
        
        #submit-procedures {
            background: linear-gradient(135deg, #4caf50, #2e7d32);
            color: white;
            transition: all 0.3s ease;
            padding: 10px 20px;
            font-weight: 500;
        }
        
        #submit-procedures:hover:not([disabled]) {
            background: linear-gradient(135deg, #43a047, #2e7d32);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(76, 175, 80, 0.3);
        }
        
        #submit-procedures:disabled {
            background: #cccccc;
            color: #777777;
            cursor: not-allowed;
        }
        
        /* Denture Upload Section Styles - REMOVED FROM PROCEDURES PAGE */
        /*
        .denture-upload-section {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            padding: 25px;
            margin-bottom: 25px;
            border: 2px solid #e8f5e9;
        }
        
        .denture-upload-section h3 {
            color: #2c3e50;
            font-size: 1.3rem;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .denture-upload-section h3 i {
            color: #3498db;
        }
        
        .upload-description {
            color: #7f8c8d;
            font-size: 0.9rem;
            margin-bottom: 20px;
            line-height: 1.5;
        }
        
        .denture-upload-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 20px;
        }
        
        .denture-upload-item {
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
            color: #3498db;
        }
        
        .required-indicator {
            color: #e74c3c;
            font-weight: bold;
        }
        
        .denture-file-input {
            display: none;
        }
        
        .denture-preview {
            border: 2px dashed #bdc3c7;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            background: #f8f9fa;
            cursor: pointer;
            transition: all 0.3s ease;
            min-height: 120px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .denture-preview:hover {
            border-color: #3498db;
            background: #f0f7ff;
        }
        
        .denture-preview i {
            font-size: 2rem;
            color: #bdc3c7;
        }
        
        .denture-preview span {
            color: #7f8c8d;
            font-size: 0.9rem;
        }
        
        .denture-preview img {
            max-width: 100%;
            max-height: 100px;
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
        
        @media (max-width: 768px) {
            .denture-upload-container {
                grid-template-columns: 1fr;
                gap: 20px;
            }
        }
        */
        
        @media (max-width: 768px) {
            .action-buttons {
                flex-direction: column;
                align-items: stretch;
            }
            
            .selected-procedure-info {
                margin-right: 0;
                margin-bottom: 10px;
                width: 100%;
            }
            
            #view-selected-procedures,
            #submit-procedures {
                width: 100%;
                margin-bottom: 8px;
            }
            
            .selection-status {
                flex-direction: column;
                align-items: flex-start;
            gap: 8px;
            }
            
            .total-amount {
                align-self: flex-end;
            }
        }
        
        .duplicate-procedures-error {
            display: none;
            background-color: #ffebee;
            border-left: 3px solid #e74c3c;
            padding: 8px 12px;
            margin-top: 10px;
            border-radius: 4px;
            font-size: 0.85rem;
            color: #e74c3c;
        }
        
        .duplicate-procedures-error ul {
            margin: 5px 0 0 0;
            padding-left: 20px;
        }
        
        .duplicate-procedures-error li {
            margin-bottom: 2px;
        }
        
        .btn-narrow {
            width: 240px; /* Increase width for longer button text */
            padding: 6px 10px;
            font-size: 0.85rem;
            position: relative; /* For tooltip positioning */
            white-space: nowrap; /* Prevent text wrapping */
            overflow: hidden; /* In case text is too long */
            text-overflow: ellipsis; /* Show ellipsis if text gets cut off */
        }
        
        /* Tooltip for View All Saved Procedures button */
        #view-selected-procedures:hover::after {
            content: "Shows both selected and already saved procedures";
            position: absolute;
            bottom: -35px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(44, 62, 80, 0.9);
            color: white;
            padding: 6px 8px;
            border-radius: 4px;
            font-size: 0.75rem;
            white-space: nowrap;
            z-index: 100;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }
        
        .procedures-list {
            display: block;
            width: 100%;
        }
        
        .procedure-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid #eee;
            position: relative;
        }
        
        .procedure-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
            border-color: #3498db;
        }
        
        .procedure-card h3 {
            margin: 0 0 10px 0;
            color: #2c3e50;
            font-size: 1.2rem;
        }
        
        .procedure-price {
            font-size: 1.5rem;
            color: #3498db;
            font-weight: 600;
            margin: 10px 0;
        }
        
        .procedure-tier {
            display: inline-block;
            padding: 5px 10px;
            background: #e8f4f8;
            color: #3498db;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            margin-bottom: 15px;
        }
        
        .procedure-actions {
            margin-top: 15px;
        }
        
        .tier-filter {
            display: flex;
            gap: 10px;
            margin-top: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .tier-filter button {
            padding: 8px 15px;
            border-radius: 20px;
            border: 1px solid #ddd;
            background: white;
            cursor: pointer;
            font-family: 'Poppins', sans-serif;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        
        .tier-filter button:hover,
        .tier-filter button.active {
            background: #3498db;
            color: white;
            border-color: #3498db;
        }
        
        .no-procedures {
            text-align: center;
            padding: 30px;
            color: #7f8c8d;
            font-size: 1.1rem;
        }
        
        /* Examination Details Styles */
        .examination-details {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
            border: 1px solid #eee;
        }
        
        .examination-details h3 {
            color: #2c3e50;
            font-size: 1.2rem;
            margin-top: 0;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .detail-item {
            display: flex;
            flex-direction: column;
            background-color: white;
            padding: 12px;
            border-radius: 6px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        
        .detail-label {
            font-size: 0.85rem;
            color: #7f8c8d;
            margin-bottom: 5px;
        }
        
        .detail-value {
            font-size: 1rem;
            color: #2c3e50;
            font-weight: 500;
        }
        
        .notes-section {
            margin-top: 20px;
            background-color: white;
            padding: 15px;
            border-radius: 6px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        
        .notes-section h4 {
            color: #3498db;
            font-size: 1rem;
            margin-top: 0;
            margin-bottom: 10px;
        }
        
        .notes-section p {
            color: #2c3e50;
            margin: 0;
            line-height: 1.6;
            white-space: pre-line;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .welcome-container {
                flex-direction: column;
            }
            
            .sidebar-menu {
                width: 100%;
                padding: 15px;
            }
            
            .main-content {
                padding: 20px;
            }
            
            .procedures-list {
                grid-template-columns: 1fr;
            }
            
            .procedure-meta {
                grid-template-columns: 1fr;
            }
            
            .departments-tabs {
                display: grid;
                grid-template-rows: repeat(2, 1fr);
                grid-auto-flow: column;
                grid-auto-columns: 1fr;
                gap: 4px;
                margin-bottom: 0;
                position: relative;
                z-index: 10;
                padding-bottom: 5px;
                max-width: 100%;
            }
            
            .department-tab {
                padding: 8px 12px;
                font-size: 0.9rem;
            }
            
            .department-content .procedure-card {
                grid-template-columns: 1fr auto;
                padding: 10px;
            }
            
            .department-content .procedure-card .procedure-price {
                text-align: left;
                grid-column: 1;
                grid-row: 2;
                padding-top: 4px;
            }
            
            .department-content .procedure-card .procedure-actions {
                grid-column: 2;
                grid-row: 1 / span 2;
                align-self: center;
            }
            
            .department-content .procedure-card.selected {
                grid-template-rows: auto auto auto;
            }
            
            .department-content .procedure-card .procedure-name-indicator {
                grid-column: 1 / -1;
                grid-row: 3;
                text-align: left;
                margin-top: 6px;
            }
            
            /* Adjust button display for small screens */
            .action-buttons {
                flex-direction: column;
                align-items: stretch;
            }
            
            .selected-procedure-info {
                margin-right: 0;
                margin-bottom: 10px;
                width: 100%;
            }
            
            #view-selected-procedures,
            #submit-procedures {
                width: 100%;
                margin-bottom: 8px;
            }
            
            .selection-status {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }
            
            .total-amount {
                align-self: flex-end;
            }
        }
        
        /* Updated procedure card styles */
        .department-content .procedure-card {
            margin: 0;
            border-radius: 0;
            border-left: none;
            border-right: none;
            border-bottom: 1px solid #eee;
            border-top: none;
            display: grid !important; /* Force grid display */
            grid-template-columns: minmax(100px, 1.5fr) minmax(60px, auto) minmax(80px, auto);
            align-items: center;
            gap: 6px;
            padding: 12px 15px;
            box-shadow: none;
            position: relative;
            width: 100%;
            max-width: 100%;
            box-sizing: border-box;
        }
        
        .department-content .procedure-card:last-child {
            border-bottom: none;
        }
        
        .department-content .procedure-card:hover {
            background-color: #f5f9fc;
            transform: none;
            box-shadow: none;
        }
        
        .department-content .procedure-card h3 {
            margin: 0;
            font-size: 0.95rem;
            color: #2c3e50;
            overflow: hidden;
            text-overflow: ellipsis;
            padding-right: 5px;
        }
        
        .department-content .procedure-card .procedure-price {
            margin: 0;
            font-size: 1rem;
            font-weight: 600;
            text-align: right;
            white-space: nowrap;
            padding-right: 5px;
            color: #3498db;
        }
        
        .department-content .procedure-card .procedure-actions {
            margin: 0;
            text-align: right;
        }
        
        .department-content .procedure-card .btn {
            padding: 5px 10px;
            font-size: 0.85rem;
            white-space: nowrap;
            min-width: 80px;
        }
        
        .department-content .procedure-card.selected {
            background-color: #edf7fd;
            border-left: 3px solid #3498db;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(52, 152, 219, 0.15);
            position: relative;
        }
        
        .department-content .procedure-card.selected::after {
            content: "Selected";
            position: absolute;
            top: 8px;
            right: 8px;
            background-color: #3498db;
            color: white;
            font-size: 0.75rem;
            padding: 2px 8px;
            border-radius: 12px;
            font-weight: 500;
        }
        
        .department-content .procedure-card.selected .select-procedure {
            background-color: #3498db;
            color: white;
        }
        
        /* Updated Department tabs styles */
        .departments-tabs-container {
            margin-bottom: 15px;
            width: 100%;
        }
        
        .departments-tabs {
            display: flex;
            flex-wrap: wrap;
            gap: 4px;
            margin-bottom: 0;
            position: relative;
            z-index: 10;
            overflow-x: visible;
            padding-bottom: 5px;
            scrollbar-width: thin;
            max-width: 100%; /* Ensure it doesn't overflow parent */
        }
        
        .department-tab {
            background: #f0f5fa;
            color: #2c3e50;
            padding: 8px 12px;
            cursor: pointer;
            font-weight: 600;
            border-radius: 8px 8px 0 0;
            transition: all 0.3s ease;
            border: 1px solid #e0e0e0;
            border-bottom: none;
            display: flex;
            align-items: center;
            gap: 8px;
            position: relative;
            margin-bottom: -1px;
            /* flex-shrink: 0;  REMOVED */
            /* white-space: nowrap; REMOVED */
            font-size: 0.93rem;
            box-shadow: 0 -2px 5px rgba(0, 0, 0, 0.03);
            min-width: 110px;
            flex: 1 1 110px;
            word-break: break-word;
        }
        
        .department-tab.active {
            background: white;
            color: #3498db;
            border-bottom: 1px solid white;
            box-shadow: 0 -3px 5px rgba(0, 0, 0, 0.05);
            transform: translateY(-2px);
            z-index: 11;
        }
        
        .department-tab:hover:not(.active) {
            background: #e6f0fa;
            transform: translateY(-1px);
        }
        
        .department-tab i {
            font-size: 1.1rem;
        }
        
        .department-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 20px;
            padding: 1px 6px;
            font-size: 0.75rem;
            font-weight: bold;
            min-width: 18px;
            height: 18px;
            color: white;
            box-shadow: 0 1px 2px rgba(0,0,0,0.2);
            transition: all 0.2s ease;
        }
        
        .department-tab.active .department-badge {
            filter: brightness(1.2);
        }
        
        .departments-content {
            border: 1px solid #e0e0e0;
            border-radius: 0 8px 8px 8px;
            background: white;
            padding: 0;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            width: 100%;
            overflow: hidden; /* Contains all content */
            height: 350px; /* Fixed height */
            position: relative;
            box-sizing: border-box;
        }
        
        .department-content {
            display: none;
            width: 100%;
            overflow-y: auto;
            overflow-x: hidden;
            height: 100%; /* Fill the container */
            padding: 0;
        }
        
        .department-content.active {
            display: block !important;
            animation: fadeIn 0.3s ease-in-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0.7; }
            to { opacity: 1; }
        }
        
        /* Show a message when no tab is active */
        .departments-content::after {
            content: 'Select a department tab to view procedures';
            display: none;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: #7f8c8d;
            font-size: 1rem;
            text-align: center;
            font-style: italic;
        }
        
        .departments-content.no-active-tab::after {
            display: block;
        }
        
        /* No procedures message styling */
        .no-procedures {
            text-align: center;
            padding: 30px;
            color: #7f8c8d;
            font-size: 1.1rem;
            margin: 30px auto;
            background-color: #f8f9fa;
            border-radius: 8px;
            width: 80%;
        }
        
        /* Department badge styling */
        .department-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 20px;
            padding: 1px 6px;
            font-size: 0.75rem;
            font-weight: bold;
            min-width: 18px;
            height: 18px;
            color: white;
            box-shadow: 0 1px 2px rgba(0,0,0,0.2);
            transition: all 0.2s ease;
        }
        
        /* Department-specific badge colors */
        .badge-orthodontics {
            background-color: #3498db; /* Blue */
        }
        
        .badge-periodontics {
            background-color: #27ae60; /* Green */
        }
        
        .badge-prosthodontics {
            background-color: #f39c12; /* Orange */
        }
        
        .badge-pedodontics {
            background-color: #e74c3c; /* Red */
        }
        
        .badge-endodontics {
            background-color: #9b59b6; /* Purple */
        }
        
        .badge-implantology {
            background-color: #16a085; /* Teal */
        }
        
        .badge-diagnosis {
            background-color: #34495e; /* Dark blue */
        }
        
        .badge-other {
            background-color: #7f8c8d; /* Gray */
        }
        
        /* Department icon styling */
        .department-tab i {
            font-size: 1rem;
            color: #7f8c8d;
        }
        
        .department-tab.active i {
            color: #3498db;
        }

        /* Department icons */
        .dept-icon-orthodontics:before { content: "\f7dc"; /* fa-tooth */ }
        .dept-icon-periodontics:before { content: "\f0fa"; /* fa-medkit */ }
        .dept-icon-pedodontics:before { content: "\f1ae"; /* fa-child */ }
        .dept-icon-prosthodontics:before { content: "\f4d0"; /* fa-cog */ }
        .dept-icon-implantology:before { content: "\f5d0"; /* fa-toolbox */ }
        .dept-icon-endodontics:before { content: "\f52c"; /* fa-microscope */ }
        .dept-icon-diagnosis:before { content: "\f53f"; /* fa-microscope */ }
        .dept-icon-other:before { content: "\f055"; /* fa-plus-circle */ }
        
        .notification {
            padding: 12px 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            background-color: #e3f2fd;
            color: #0d47a1;
            border-left: 4px solid #1976d2;
            display: none;
        }
        
        .notification.error {
            background-color: #ffebee;
            color: #b71c1c;
            border-left-color: #f44336;
        }
        
        .notification.success {
            background-color: #e8f5e9;
            color: #1b5e20;
            border-left-color: #4caf50;
        }
        
        /* Updated box model for all containers */
        * {
            box-sizing: border-box;
        }
        
        /* Hide scrollbar for Chrome, Safari and Opera */
        .departments-tabs::-webkit-scrollbar {
            height: 4px;
        }
        
        .departments-tabs::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        
        .departments-tabs::-webkit-scrollbar-thumb {
            background: #ddd;
            border-radius: 4px;
        }
        
        /* Duplicate procedure error styling */
        .procedure-card.duplicate-error {
            border-left: 3px solid #e74c3c;
            background-color: #ffebee;
            position: relative;
        }
        
        .duplicate-warning {
            position: absolute;
            top: 0;
            right: 0;
            background-color: #e74c3c;
            color: white;
            padding: 2px 8px;
            font-size: 0.75rem;
            border-radius: 0 0 0 8px;
            display: flex;
            align-items: center;
            gap: 4px;
            max-width: 80%;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            z-index: 10;
        }
        
        .duplicate-warning i {
            font-size: 0.8rem;
            flex-shrink: 0;
        }
        
        /* Add tooltip on hover to show full procedure name */
        .duplicate-warning:hover::after {
            content: attr(data-full-name);
            position: absolute;
            top: 100%;
            right: 0;
            background-color: #333;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 0.8rem;
            white-space: normal;
            max-width: 200px;
            z-index: 20;
        }
        
        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 100;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        
        .modal-content {
            position: relative;
            background-color: #fff;
            margin: 10% auto;
            padding: 20px;
            border-radius: 8px;
            width: 90%;
            max-width: 800px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        
        .close-modal {
            position: absolute;
            right: 20px;
            top: 10px;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            color: #aaa;
        }
        
        .close-modal:hover {
            color: #555;
        }
        
        .modal-header {
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .modal-header h3 {
            margin: 0;
            color: #2c3e50;
            font-size: 1.3rem;
        }
        
        .modal-body {
            margin-bottom: 20px;
            max-height: 60vh;
            overflow-y: auto;
        }
        
        .modal-footer {
            display: flex;
            justify-content: flex-end;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        
        /* Selected procedures table styles */
        .selected-procedures-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        
        .selected-procedures-table th,
        .selected-procedures-table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .selected-procedures-table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .selected-procedures-table tr:hover {
            background-color: #f5f5f5;
        }
        
        .selected-procedures-table .price-cell {
            text-align: right;
            color: #3498db;
            font-weight: 500;
        }
        
        .selected-procedures-table tfoot tr {
            background-color: #f0f7ff;
        }
        
        .selected-procedures-table tfoot td {
            border-bottom: none;
        }
        
        .no-procedures-message {
            color: #7f8c8d;
            text-align: center;
            padding: 20px;
            font-style: italic;
        }
        
        .hint-text {
            display: block;
            margin-top: 5px;
            font-size: 0.8rem;
            color: #95a5a6;
            font-style: normal;
        }
        
        .remove-procedure-btn {
            background-color: #e74c3c;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 4px 8px;
            cursor: pointer;
            font-size: 0.8rem;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        
        .remove-procedure-btn:hover {
            background-color: #c0392b;
            transform: translateY(-1px);
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }
        
        .remove-procedure-btn:active {
            transform: translateY(0);
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
        }
        
        /* Section titles in modal */
        .section-title {
            color: #2c3e50;
            font-size: 1.1rem;
            margin: 0 0 15px 0;
            padding-bottom: 8px;
            border-bottom: 1px solid #eee;
        }
        
        /* Modal divider */
        .modal-divider {
            height: 1px;
            background-color: #eee;
            margin: 20px 0;
        }
        
        /* Procedures list container */
        .procedures-list-container {
            margin-bottom: 20px;
        }
        
        /* Loading spinner */
        .loading-spinner {
            display: none;
            align-items: center;
            gap: 10px;
            margin-right: auto;
        }
        
        .spinner {
            width: 20px;
            height: 20px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid #3498db;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* Error message in modal */
        .modal-error-message {
            color: #e74c3c;
            font-size: 0.9rem;
            margin-right: auto;
            display: none;
        }
        
        .selected-procedure-info {
            background-color: #e8f5e9;
            padding: 8px 12px;
            border-radius: 4px;
            margin-right: auto;
            font-weight: 500;
            color: #1b5e20;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 5px;
            display: none;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        <div class="main-content">
            <div class="welcome-header">
                <h1 class="welcome-message">Select Procedure</h1>
                <a href="${pageContext.request.contextPath}/patients/examination/${examination.id}" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i> Back to Examination
                </a>
            </div>
            
            <div id="notification" class="notification"></div>
            
            <!-- Hidden input to store existing procedure IDs -->
            <input type="hidden" id="existingProcedureIds" value="<c:forEach items="${existingProcedureIds}" var="id" varStatus="loop">${id}<c:if test="${!loop.last}">,</c:if></c:forEach>">
            
            <div class="procedure-container">
                <div class="procedure-meta">
                    <div class="meta-item">
                        <span class="meta-label">Patient Name</span>
                        <span class="meta-value">${patient.firstName} ${patient.lastName}</span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Age</span>
                        <span class="meta-value">
                            <c:if test="${not empty patient.age}">
                                ${patient.age} years
                            </c:if>
                            <c:if test="${empty patient.age}">
                                Not specified
                            </c:if>
                        </span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Occupation</span>
                        <span class="meta-value">
                            <c:choose>
                                <c:when test="${not empty patient.occupation}">
                                    ${patient.occupation}
                                </c:when>
                                <c:otherwise>
                                    Not specified
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Address</span>
                        <span class="meta-value">
                            <c:if test="${not empty patient.streetAddress}">
                                ${patient.streetAddress}, ${patient.city}, ${patient.state} - ${patient.pincode}
                            </c:if>
                            <c:if test="${empty patient.streetAddress}">
                                Not specified
                            </c:if>
                        </span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Examination ID</span>
                        <span class="meta-value">${examination.id}</span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Tooth Number</span>
                        <span class="meta-value">${examination.toothNumber}</span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Treating Doctor</span>
                        <span class="meta-value">
                            <c:choose>
                                <c:when test="${currentUserRole == 'RECEPTIONIST'}">
                                    <c:if test="${not empty examination.assignedDoctorId}">
                                        <c:forEach items="${doctors}" var="d">
                                            <c:if test="${d.id == examination.assignedDoctorId}">
                                                Dr. ${d.firstName} ${d.lastName}
                                            </c:if>
                                        </c:forEach>
                                    </c:if>
                                    <c:if test="${empty examination.assignedDoctorId}">
                                        Not assigned yet
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <select id="treatingDoctorSelect" class="form-control" style="
                                            width: 100%;
                                            padding: 10px;
                                            border: 1px solid #dee2e6;
                                            border-radius: 8px;
                                            font-size: 14px;
                                            background-color: #ffffff;
                                            box-shadow: inset 0 1px 2px rgba(0,0,0,0.02);
                                            transition: border-color 0.2s ease, box-shadow 0.2s ease;"
                                            <c:if test="${not empty examination.assignedDoctorId}">disabled</c:if>>
                                        <option value="">Select Doctor</option>
                                        <c:forEach items="${doctors}" var="d">
                                            <option value="${d.id}"
                                                <c:if test="${not empty examination.assignedDoctorId and d.id == examination.assignedDoctorId}">selected</c:if>>
                                                ${d.firstName} ${d.lastName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <c:if test="${not empty examination.assignedDoctorId}">
                                        <small class="doctor-assignment-info">
                                            <i class="fas fa-info-circle"></i> Doctor assignment cannot be changed once set
                                        </small>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
                
                <!-- Hidden field for JavaScript to access the examination ID -->
                <input type="hidden" id="current-examination-id" value="${examination.id}" />
                
                <div class="examination-details">
                    <h3>Tooth Examination Details</h3>
                    <div class="details-grid">
                        <div class="detail-item">
                            <span class="detail-label">Condition</span>
                            <span class="detail-value">${examination.toothCondition != null ? examination.toothCondition : 'Not specified'}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Mobility</span>
                            <span class="detail-value">${examination.toothMobility != null ? examination.toothMobility : 'Not specified'}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Pocket Depth</span>
                            <span class="detail-value">${examination.pocketDepth != null ? examination.pocketDepth : 'Not specified'}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Bleeding on Probing</span>
                            <span class="detail-value">${examination.bleedingOnProbing != null ? examination.bleedingOnProbing : 'Not specified'}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Plaque Score</span>
                            <span class="detail-value">${examination.plaqueScore != null ? examination.plaqueScore : 'Not specified'}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Gingival Recession</span>
                            <span class="detail-value">${examination.gingivalRecession != null ? examination.gingivalRecession : 'Not specified'}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Vitality</span>
                            <span class="detail-value">${examination.toothVitality != null ? examination.toothVitality : 'Not specified'}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Furcation</span>
                            <span class="detail-value">${examination.furcationInvolvement != null ? examination.furcationInvolvement : 'Not specified'}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Sensitivity</span>
                            <span class="detail-value">${examination.toothSensitivity != null ? examination.toothSensitivity : 'Not specified'}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Existing Restoration</span>
                            <span class="detail-value">${examination.existingRestoration != null ? examination.existingRestoration : 'Not specified'}</span>
                        </div>
                    </div>
                    <c:if test="${not empty examination.examinationNotes}">
                        <div class="notes-section">
                            <h4>Clinical Notes</h4>
                            <p>${examination.examinationNotes}</p>
                        </div>
                    </c:if>
                    
                    <!-- PROCEDURE SELECTION ACTIONS AREA - START -->
                    <div class="selected-procedures-info">
                        <div class="selection-status">
                            <span><i class="fas fa-clipboard-check"></i> <span id="selected-count">0</span> procedure selected</span>
                            <span id="total-amount" class="total-amount">₹0</span>
                        </div>
                        <div class="action-buttons">
                            <div id="selected-procedure-info" class="selected-procedure-info">
                                <i class="fas fa-check-circle"></i> Selected: <span id="selected-procedure-name">None</span>
                            </div>
                            <button id="view-selected-procedures" class="btn btn-secondary">
                                <i class="fas fa-eye"></i> View Selection
                            </button>
                            <button id="submit-procedures" class="btn btn-primary" disabled>
                                <i class="fas fa-check"></i> Submit
                            </button>
                        </div>
                    </div>
                    <!-- PROCEDURE SELECTION ACTIONS AREA - END -->
                    
                    <!-- Error message for duplicate procedures -->
                    <div id="duplicate-procedures-error" class="duplicate-procedures-error">
                        <strong><i class="fas fa-exclamation-triangle"></i> This procedure is already assigned</strong>
                        <ul id="duplicate-procedures-list"></ul>
                    </div>
                </div>
                
                <div class="procedures-list">
                    <c:if test="${empty procedures}">
                        <div class="no-procedures">
                            <p>No procedures available for your clinic's tier. Please contact administration.</p>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty procedures}">
                        <div class="departments-tabs-container">
                            <%-- Horizontal Department Tabs --%>
                            <div class="departments-tabs">
                                <%-- Show tabs for all available departments from the enum --%>
                                <c:forEach var="department" items="${dentalDepartments}" varStatus="deptStatus">
                                    <c:set var="deptName" value="${department.displayName}" />
                                    <c:set var="safeDeptName" value="${fn:toLowerCase(fn:replace(deptName, ' ', '_'))}" />
                                        
                                        <%-- Count procedures in department --%>
                                        <c:set var="deptCount" value="0" />
                                        <c:forEach var="procedure" items="${procedures}">
                                        <c:if test="${procedure.dentalDepartment == department}">
                                                <c:set var="deptCount" value="${deptCount + 1}" />
                                            </c:if>
                                        </c:forEach>
                                        
                                        <%-- Set appropriate icon class based on department name --%>
                                        <c:set var="deptIconClass" value="dept-icon-other" />
                                        <c:choose>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'orthodontic')}">
                                                <c:set var="deptIconClass" value="dept-icon-orthodontics" />
                                            </c:when>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'periodontic')}">
                                                <c:set var="deptIconClass" value="dept-icon-periodontics" />
                                            </c:when>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'pedodontic')}">
                                                <c:set var="deptIconClass" value="dept-icon-pedodontics" />
                                            </c:when>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'prosthodontic')}">
                                                <c:set var="deptIconClass" value="dept-icon-prosthodontics" />
                                            </c:when>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'implantology')}">
                                                <c:set var="deptIconClass" value="dept-icon-implantology" />
                                            </c:when>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'diagnos')}">
                                                <c:set var="deptIconClass" value="dept-icon-diagnosis" />
                                            </c:when>
                                        </c:choose>
                                        
                                        <%-- Set appropriate badge class based on department name --%>
                                        <c:set var="badgeClass" value="badge-other" />
                                        <c:choose>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'orthodontic')}">
                                                <c:set var="badgeClass" value="badge-orthodontics" />
                                            </c:when>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'periodontic')}">
                                                <c:set var="badgeClass" value="badge-periodontics" />
                                            </c:when>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'pedodontic')}">
                                                <c:set var="badgeClass" value="badge-pedodontics" />
                                            </c:when>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'prosthodontic')}">
                                                <c:set var="badgeClass" value="badge-prosthodontics" />
                                            </c:when>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'implantology')}">
                                                <c:set var="badgeClass" value="badge-implantology" />
                                            </c:when>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'endodontic')}">
                                                <c:set var="badgeClass" value="badge-endodontics" />
                                            </c:when>
                                            <c:when test="${fn:contains(fn:toLowerCase(deptName), 'diagnos')}">
                                                <c:set var="badgeClass" value="badge-diagnosis" />
                                            </c:when>
                                        </c:choose>
                                        
                                        <div class="department-tab${deptStatus.count == 1 ? ' active' : ''}" data-dept="${safeDeptName}">
                                            <i class="fas ${deptIconClass}"></i>
                                            ${deptName}
                                            <span class="department-badge ${badgeClass}">${deptCount}</span>
                                        </div>
                                </c:forEach>
                            </div>
                            
                            <%-- Department Contents --%>
                            <div class="departments-content">
                                <c:forEach var="department" items="${dentalDepartments}" varStatus="deptStatus">
                                    <c:set var="deptName" value="${department.displayName}" />
                                    <c:set var="safeDeptName" value="${fn:toLowerCase(fn:replace(deptName, ' ', '_'))}" />
                                        
                                        <div class="department-content${deptStatus.count == 1 ? ' active' : ''}" data-dept="${safeDeptName}">
                                        <c:set var="hasProcedures" value="false" />
                                            <c:forEach var="procedure" items="${procedures}">
                                            <c:if test="${procedure.dentalDepartment == department}">
                                                <c:set var="hasProcedures" value="true" />
                                                    <div class="procedure-card" data-id="${procedure.id}">
                                                        <h3>${not empty procedure.procedureName ? procedure.procedureName : 'Unnamed Procedure'}</h3>
                                                        <div class="procedure-price">₹${procedure.price != null ? procedure.price : '0'}</div>
                                                        <div class="procedure-actions">
                                                            <button class="btn btn-outline select-procedure" 
                                                                data-id="${procedure.id}" 
                                                                data-name="${not empty procedure.procedureName ? procedure.procedureName : 'Unnamed Procedure'}" 
                                                                data-price="${procedure.price != null ? procedure.price : '0'}">
                                                                <i class="fas fa-plus-circle"></i> Select
                                                            </button>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        <c:if test="${hasProcedures == 'false'}">
                                            <div class="no-procedures">
                                                <i class="fas fa-info-circle"></i> No procedures available in the ${deptName} department.
                                        </div>
                                    </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Selected Procedures Modal -->
    <div id="selected-procedures-modal" class="modal">
        <div class="modal-content">
            <span class="close-modal">&times;</span>
            <div class="modal-header">
                <h3>All Saved Procedures</h3>
            </div>
            <div class="modal-body">
                <!-- Already saved procedures section -->
                <div id="saved-procedures-section">
                    <h4 class="section-title">Already Saved Procedures</h4>
                    <div id="saved-procedures-list" class="procedures-list-container">
                        <p id="no-saved-procedures-message" class="no-procedures-message">
                            No procedures have been saved to this examination yet.
                            <span class="hint-text">The procedures you submit will appear here after saving.</span>
                        </p>
                        <table id="saved-procedures-table" class="selected-procedures-table">
                            <thead>
                                <tr>
                                    <th>Procedure Name</th>
                                    <th>Price</th>
                                    <th>Department</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody id="saved-procedures-table-body">
                                <!-- Already saved procedures will be added here dynamically -->
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="3"><strong>Total</strong></td>
                                    <td id="saved-procedures-total" class="price-cell"><strong>₹0</strong></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
                
                <!-- Divider -->
                <div class="modal-divider"></div>
                
                <!-- Currently selected procedures section -->
                <div id="selected-procedures-section">
                    <h4 class="section-title">Currently Selected Procedures</h4>
                    <div id="selected-procedures-list" class="procedures-list-container">
                        <p id="no-procedures-message" class="no-procedures-message">
                            No procedures selected yet. 
                            <span class="hint-text">Select procedures from the list above before submitting.</span>
                        </p>
                        <table id="selected-procedures-table" class="selected-procedures-table">
                            <thead>
                                <tr>
                                    <th>Procedure Name</th>
                                    <th>Price</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody id="selected-procedures-table-body">
                                <!-- Selected procedures will be added here dynamically -->
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="2"><strong>Total</strong></td>
                                    <td id="selected-procedures-total" class="price-cell"><strong>₹0</strong></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <div id="loading-spinner" class="loading-spinner">
                    <div class="spinner"></div>
                    <span>Loading procedures...</span>
                </div>
                <div id="error-message" class="modal-error-message"></div>
                <button type="button" class="btn btn-secondary close-button">Close</button>
            </div>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const csrfToken = document.querySelector('meta[name="_csrf"]').content;
            const notification = document.getElementById('notification');
            const selectedCountElement = document.getElementById('selected-count');
            const submitButton = document.getElementById('submit-procedures');
            const totalAmountElement = document.getElementById('total-amount');
            const selectedProceduresModal = document.getElementById('selected-procedures-modal');
            const selectedProceduresTable = document.getElementById('selected-procedures-table');
            const selectedProceduresTableBody = document.getElementById('selected-procedures-table-body');
            const selectedProceduresTotal = document.getElementById('selected-procedures-total');
            const noProceduresMessage = document.getElementById('no-procedures-message');
            const closeModalButtons = document.querySelectorAll('.close-modal, .close-button');
            const viewSelectedButton = document.getElementById('view-selected-procedures');
            
            // Track selected procedures
            let selectedProcedure = null; // Single procedure object to store the selected procedure
            
            // Denture upload variables - REMOVED FROM PROCEDURES PAGE
            /*
            let upperDentureFile = null;
            let lowerDentureFile = null;
            let dentureUploadsComplete = false;
            
            // Denture upload elements
            const upperDentureInput = document.getElementById('upper-denture-upload');
            const lowerDentureInput = document.getElementById('lower-denture-upload');
            const upperDenturePreview = document.getElementById('upper-denture-preview');
            const lowerDenturePreview = document.getElementById('lower-denture-preview');
            const upperDentureStatus = document.getElementById('upper-denture-status');
            const lowerDentureStatus = document.getElementById('lower-denture-status');
            const dentureValidation = document.getElementById('denture-validation');
            
            // Initialize denture upload functionality
            function initializeDentureUploads() {
                // Upper denture upload
                upperDenturePreview.addEventListener('click', () => upperDentureInput.click());
                upperDentureInput.addEventListener('change', handleUpperDentureUpload);
                
                // Lower denture upload
                lowerDenturePreview.addEventListener('click', () => lowerDentureInput.click());
                lowerDentureInput.addEventListener('change', handleLowerDentureUpload);
                
                // Update validation on page load
                updateDentureValidation();
            }
            
            // Handle upper denture upload
            async function handleUpperDentureUpload(event) {
                const file = event.target.files[0];
                if (!file) return;
                
                if (!file.type.startsWith('image/')) {
                    showDentureStatus('upper', 'error', 'Please select an image file');
                    return;
                }
                
                try {
                    showDentureStatus('upper', 'loading', 'Compressing image...');
                    ImageCompression.showLoading(upperDenturePreview, 'Compressing image...');
                    
                    // Compress the image
                    const compressedFile = await ImageCompression.compressImage(file, {
                        maxSizeKB: 150,
                        maxDimension: 800,
                        quality: 0.9
                    });
                    
                    // Update the file input
                    ImageCompression.updateFileInput(upperDentureInput, compressedFile);
                    
                    // Create preview
                    ImageCompression.createPreview(compressedFile, upperDenturePreview, {
                        defaultIcon: '<i class="fas fa-image"></i>',
                        defaultText: 'No image selected'
                    });
                    
                    // Store the file
                    upperDentureFile = compressedFile;
                    
                    showDentureStatus('upper', 'success', 'Image uploaded successfully');
                    updateDentureValidation();
                    
                } catch (error) {
                    console.error('Error compressing upper denture image:', error);
                    showDentureStatus('upper', 'error', 'Error processing image');
                    ImageCompression.createPreview(null, upperDenturePreview, {
                        defaultIcon: '<i class="fas fa-image"></i>',
                        defaultText: 'No image selected'
                    });
                }
            }
            
            // Handle lower denture upload
            async function handleLowerDentureUpload(event) {
                const file = event.target.files[0];
                if (!file) return;
                
                if (!file.type.startsWith('image/')) {
                    showDentureStatus('lower', 'error', 'Please select an image file');
                    return;
                }
                
                try {
                    showDentureStatus('lower', 'loading', 'Compressing image...');
                    ImageCompression.showLoading(lowerDenturePreview, 'Compressing image...');
                    
                    // Compress the image
                    const compressedFile = await ImageCompression.compressImage(file, {
                        maxSizeKB: 150,
                        maxDimension: 800,
                        quality: 0.9
                    });
                    
                    // Update the file input
                    ImageCompression.updateFileInput(lowerDentureInput, compressedFile);
                    
                    // Create preview
                    ImageCompression.createPreview(compressedFile, lowerDenturePreview, {
                        defaultIcon: '<i class="fas fa-image"></i>',
                        defaultText: 'No image selected'
                    });
                    
                    // Store the file
                    lowerDentureFile = compressedFile;
                    
                    showDentureStatus('lower', 'success', 'Image uploaded successfully');
                    updateDentureValidation();
                    
                } catch (error) {
                    console.error('Error compressing lower denture image:', error);
                    showDentureStatus('lower', 'error', 'Error processing image');
                    ImageCompression.createPreview(null, lowerDenturePreview, {
                        defaultIcon: '<i class="fas fa-image"></i>',
                        defaultText: 'No image selected'
                    });
                }
            }
            
            // Show denture upload status
            function showDentureStatus(type, status, message) {
                const statusElement = type === 'upper' ? upperDentureStatus : lowerDentureStatus;
                statusElement.textContent = message;
                statusElement.className = `upload-status ${status}`;
            }
            
            // Update denture validation
            function updateDentureValidation() {
                const hasUpper = upperDentureFile !== null;
                const hasLower = lowerDentureFile !== null;
                dentureUploadsComplete = hasUpper && hasLower;
                
                if (dentureUploadsComplete) {
                    dentureValidation.className = 'upload-validation success';
                    dentureValidation.innerHTML = '<i class="fas fa-check-circle"></i><span>Both denture pictures uploaded successfully. You can now select procedures.</span>';
                } else {
                    const missing = [];
                    if (!hasUpper) missing.push('upper');
                    if (!hasLower) missing.push('lower');
                    dentureValidation.className = 'upload-validation error';
                    dentureValidation.innerHTML = `<i class="fas fa-exclamation-triangle"></i><span>Please upload ${missing.join(' and ')} picture${missing.length > 1 ? 's' : ''} to proceed.</span>`;
                }
                
                // Update submit button state based on denture uploads and procedure selection
                updateSubmitButtonState();
            }
            */
            
            // Update submit button state based on both procedure selection and denture uploads
            function updateSubmitButtonState() {
                const hasProcedure = selectedProcedure !== null;
                const treatingDoctorSelect = document.getElementById('treatingDoctorSelect');
                const hasDoctor = treatingDoctorSelect ? (treatingDoctorSelect.value !== '' || treatingDoctorSelect.disabled) : true;
                const messages = [];
                if (!hasProcedure) messages.push('Select a procedure');
                if (!hasDoctor) messages.push('Select a treating doctor');
                const canSubmit = messages.length === 0;
                submitButton.disabled = !canSubmit;
                submitButton.title = canSubmit ? 'Submit procedure' : messages.join(' | ');
            }
            
            // Initialize denture uploads - REMOVED FROM PROCEDURES PAGE
            // initializeDentureUploads();
            
            // Add event listener for view selected procedures button
            if (viewSelectedButton) {
                viewSelectedButton.addEventListener('click', function() {
                    // Update modal content before showing
                    updateSelectedProceduresModal();
                    // Show the modal
                    selectedProceduresModal.style.display = 'block';
                });
            }
            
            // Check if examination ID is available
            const examinationIdInput = document.getElementById('current-examination-id');
            const examinationId = examinationIdInput ? examinationIdInput.value : '';
            
            if (!examinationId || examinationId.trim() === '') {
                console.error('Examination ID not found on page load');
                showNotification('Error: Examination data not available. Please go back and try again.', true);
            }
            
            // Output examination details for debugging
            console.log('Examination details available on page:');
            console.log('  - Examination ID from hidden field:', examinationId);
            
            // Ensure all procedure cards are displayed with grid style
            document.querySelectorAll('.procedure-card').forEach(card => {
                card.style.display = 'grid';
                console.log('Initialized procedure card:', card.querySelector('h3').textContent);
            });
            
            // Function to update UI based on selection state
            function updateSelectionUI() {
                if (!selectedProcedure) {
                    // Update count
                    if (selectedCountElement) {
                        selectedCountElement.textContent = "0";
                    }
                    
                    // Update total amount
                    if (totalAmountElement) {
                        totalAmountElement.textContent = '₹0';
                    }
                    
                    // Update the selected procedure info if available
                    const selectedProcedureInfo = document.getElementById('selected-procedure-info');
                    const selectedProcedureName = document.getElementById('selected-procedure-name');
                    
                    if (selectedProcedureInfo && selectedProcedureName) {
                        selectedProcedureName.textContent = 'None';
                        selectedProcedureInfo.style.display = 'none';
                    }
                } else {
                    // We have a selection
                    // Update count
                    if (selectedCountElement) {
                        selectedCountElement.textContent = "1";
                    }
                    
                    // Update total amount
                    if (totalAmountElement) {
                        const total = parseFloat(selectedProcedure.price);
                        totalAmountElement.textContent = '₹' + total.toFixed(2);
                    }
                    
                    // Update the selected procedure info if available
                    const selectedProcedureInfo = document.getElementById('selected-procedure-info');
                    const selectedProcedureName = document.getElementById('selected-procedure-name');
                    
                    if (selectedProcedureInfo && selectedProcedureName) {
                        selectedProcedureName.textContent = selectedProcedure.name;
                        selectedProcedureInfo.style.display = 'flex';
                    }
                    
                    // Scroll to the submit button to ensure user sees it
                    const submitArea = document.querySelector('.action-buttons');
                    if (submitArea) {
                        submitArea.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                }
                
            // Update submit button state on load
            updateSubmitButtonState();
            const treatingDoctorSelect = document.getElementById('treatingDoctorSelect');
            if (treatingDoctorSelect) {
                treatingDoctorSelect.addEventListener('change', async function(){
                    // Clear red border on selection
                    if (treatingDoctorSelect.value) {
                        try { treatingDoctorSelect.style.borderColor = '#dee2e6'; } catch (e) {}
                    }
                    
                    // If user selected a doctor, assign immediately via AJAX
                    if (this.value) {
                        const examinationId = '${examination.id}';
                        const doctorId = this.value;
                        const token = $("meta[name='_csrf']").attr("content");
                        const header = $("meta[name='_csrf_header']").attr("content");
                        // Disable while assigning
                        this.disabled = true;
                        try {
                            const res = await fetch('${pageContext.request.contextPath}/patients/tooth-examination/assign-doctor', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json', [header]: token },
                                body: JSON.stringify({ examinationId: examinationId, doctorId: doctorId })
                            });
                            if (!res.ok) {
                                // Restore selection and state on failure
                                this.disabled = false;
                                const errText = await res.text();
                                showNotification('Error assigning doctor: ' + (errText || res.status), true);
                                return;
                            }
                            const result = await res.json();
                            if (result && result.success) {
                                // Lock the select after successful assignment
                                this.disabled = true;
                                // Show info note if not already present
                                const info = document.createElement('small');
                                info.className = 'doctor-assignment-info';
                                info.innerHTML = '<i class="fas fa-info-circle"></i> Doctor assignment cannot be changed once set';
                                this.parentNode.appendChild(info);
                                showNotification('Doctor assigned successfully.');
                            } else {
                                this.disabled = false;
                                showNotification('Error: ' + (result && result.message ? result.message : 'Failed to assign doctor'), true);
                            }
                        } catch (e) {
                            this.disabled = false;
                            showNotification('Error assigning doctor: ' + e.message, true);
                        }
                    }
                    
                    updateSubmitButtonState();
                });
            }
            }
            
            // Function to update the selected procedures modal content
            function updateSelectedProceduresModal() {
                // Clear the table body
                selectedProceduresTableBody.innerHTML = '';
                
                // Check if there is a selected procedure
                if (!selectedProcedure) {
                    // Hide table and show message
                    selectedProceduresTable.style.display = 'none';
                    noProceduresMessage.style.display = 'block';
                } else {
                    // Show table and hide message
                    selectedProceduresTable.style.display = 'table';
                    noProceduresMessage.style.display = 'none';
                    
                    // Add the selected procedure to the table
                        const row = document.createElement('tr');
                        
                        // Procedure name cell
                        const nameCell = document.createElement('td');
                    nameCell.textContent = selectedProcedure.name;
                        row.appendChild(nameCell);
                        
                        // Price cell
                        const priceCell = document.createElement('td');
                    priceCell.textContent = '₹' + parseFloat(selectedProcedure.price).toFixed(2);
                        priceCell.className = 'price-cell';
                        row.appendChild(priceCell);
                        
                        // Action cell with remove button
                        const actionCell = document.createElement('td');
                        const removeButton = document.createElement('button');
                        removeButton.className = 'remove-procedure-btn';
                        removeButton.innerHTML = '<i class="fas fa-times"></i> Remove';
                    removeButton.onclick = function(e) {
                        // Prevent any parent elements from receiving the click
                        e.preventDefault();
                        e.stopPropagation();
                        
                        console.log('Remove button clicked in modal');
                        removeProcedure();
                        
                        // No need to call updateSelectedProceduresModal here since removeProcedure 
                        // will now handle closing the modal when appropriate
                        };
                        actionCell.appendChild(removeButton);
                        row.appendChild(actionCell);
                        
                        selectedProceduresTableBody.appendChild(row);
                    
                    // Update the total
                    selectedProceduresTotal.textContent = '₹' + parseFloat(selectedProcedure.price).toFixed(2);
                }
            }
            
            // Remove a procedure from selection
            function removeProcedure() {
                if (selectedProcedure) {
                    const procedureId = selectedProcedure.id;
                    
                    // Update the button and card in the procedures list
                    const button = document.querySelector('.select-procedure[data-id="' + procedureId + '"]');
                    if (button) {
                        const card = button.closest('.procedure-card');
                        card.classList.remove('selected');
                        button.innerHTML = '<i class="fas fa-plus-circle"></i> Select';
                    }
                    
                    selectedProcedure = null;
                    
                    // Update the UI to reflect the change
                    updateSelectionUI();
                    
                    // If we're in the modal, we should close it since we no longer have a selected procedure
                    if (selectedProceduresModal && selectedProceduresModal.style.display === 'block') {
                        // Show a notification instead of immediately closing to give feedback
                        showNotification('Procedure removed from selection', false);
                        
                        // Close the modal after a brief delay
                        setTimeout(() => {
                            selectedProceduresModal.style.display = 'none';
                        }, 1000);
                    }
                }
            }
            
            // Handle procedure selection via the button
            const selectButtons = document.querySelectorAll('.select-procedure');
            
            selectButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    // Stop the event from bubbling up to the card to prevent double handling
                                    e.stopPropagation();
                    
                    const procedureId = this.dataset.id;
                    const procedureName = this.dataset.name;
                    const procedurePrice = this.dataset.price;
                    const card = this.closest('.procedure-card');
                    
                    // If this procedure is already selected, deselect it
                    if (selectedProcedure && selectedProcedure.id === procedureId) {
                        selectedProcedure = null;
                        card.classList.remove('selected');
                        this.innerHTML = '<i class="fas fa-plus-circle"></i> Select';
                    } else {
                        // If another procedure is already selected, deselect it first
                        if (selectedProcedure) {
                            const previousButton = document.querySelector('.select-procedure[data-id="' + selectedProcedure.id + '"]');
                            if (previousButton) {
                                const previousCard = previousButton.closest('.procedure-card');
                                previousCard.classList.remove('selected');
                                previousButton.innerHTML = '<i class="fas fa-plus-circle"></i> Select';
                            }
                        }
                        
                        // Select the new procedure
                        selectedProcedure = {
                            id: procedureId,
                            name: procedureName,
                            price: procedurePrice
                        };
                        card.classList.add('selected');
                        this.innerHTML = '<i class="fas fa-check-circle"></i> Selected';
                        
                        // Clear any duplicate procedures error when user makes a new selection
                        const duplicateError = document.getElementById('duplicate-procedures-error');
                        if (duplicateError) {
                            duplicateError.style.display = 'none';
                        }
                    }
                    
                    updateSelectionUI();
                });
            });
            
            // Handle submission of the procedure
            submitButton.addEventListener('click', async function() {
                const treatingDoctorSelect = document.getElementById('treatingDoctorSelect');
                const errors = [];
                if (!selectedProcedure) {
                    errors.push('Please select a procedure');
                }
                if (treatingDoctorSelect && !treatingDoctorSelect.disabled && !treatingDoctorSelect.value) {
                    errors.push('Please select a treating doctor');
                    try { treatingDoctorSelect.style.borderColor = '#e74c3c'; } catch (e) {}
                }
                if (errors.length) {
                    showNotification(errors.join(' | '), true);
                    return;
                }
                
                // Validate denture pictures are uploaded - REMOVED FROM PROCEDURES PAGE
                // if (!dentureUploadsComplete) {
                //     showNotification('Please upload both upper and lower denture pictures before proceeding', true);
                //     return;
                // }
                
                const examinationId = '${examination.id}';
                const procedureId = selectedProcedure.id;
                
                try {
                    // Show loading state
                    submitButton.disabled = true;
                    submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Submitting...';
                    
                    // Create FormData to send procedure data (no denture files)
                    const formData = new FormData();
                    formData.append('examinationId', examinationId);
                    formData.append('procedureId', procedureId);
                    // formData.append('upperDenturePicture', upperDentureFile); // REMOVED
                    // formData.append('lowerDenturePicture', lowerDentureFile); // REMOVED
                    
                    // If treating doctor is selected and not already assigned, assign before starting
                    const treatingDoctorSelect = document.getElementById('treatingDoctorSelect');
                    if (treatingDoctorSelect && treatingDoctorSelect.value) {
                        try {
                            const token = $("meta[name='_csrf']").attr("content");
                            const header = $("meta[name='_csrf_header']").attr("content");
                            await fetch('${pageContext.request.contextPath}/patients/tooth-examination/assign-doctor', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json', [header]: token },
                                body: JSON.stringify({ examinationId: examinationId, doctorId: treatingDoctorSelect.value })
                            });
                        } catch (e) {
                            console.warn('Treating doctor assignment failed before starting procedure:', e);
                        }
                    }

                    // Submit the selected procedure
                    showNotification('Submitting procedure...');
                    const response = await fetch('${pageContext.request.contextPath}/patients/examination/start-procedure', {
                        method: 'POST',
                        headers: {
                            'X-CSRF-TOKEN': csrfToken
                        },
                        body: formData
                    });
                    
                    // Parse the response
                    const result = await response.json();
                    
                    if (result.success) {
                        showNotification('Successfully assigned procedure');
                        
                        // Redirect after a short delay to the procedure lifecycle page
                        setTimeout(() => {
                            if (result.redirect) {
                                // Redirect to the examination lifecycle page
                                window.location.href = '${pageContext.request.contextPath}/patients/examination/' + examinationId + '/lifecycle';
                            } else {
                                // Fallback to examination lifecycle page
                                window.location.href = '${pageContext.request.contextPath}/patients/examination/' + examinationId + '/lifecycle';
                            }
                        }, 1500);
                    } else {
                        // Check if there is a duplicate procedure
                        if (result.duplicateProcedure) {
                            // Show error message near the submit button
                            const duplicateError = document.getElementById('duplicate-procedures-error');
                            const duplicateList = document.getElementById('duplicate-procedures-list');
                            
                            // Clear previous errors
                            duplicateList.innerHTML = '';
                            
                            // Add the duplicate procedure to the list
                            const listItem = document.createElement('li');
                            listItem.textContent = result.duplicateProcedure.name || selectedProcedure.name;
                            duplicateList.appendChild(listItem);
                            
                            // Show the error message
                            duplicateError.style.display = 'block';
                            
                            // Scroll to the error message
                            duplicateError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        } else {
                            // Show the top notification for other errors
                            showNotification('Error: ' + (result.message || 'Unknown error occurred'), true);
                        }
                    }
                    
                } catch (error) {
                    console.error('Error submitting procedure:', error);
                    showNotification('Error: ' + error.message, true);
                } finally {
                    // Reset button state
                    submitButton.disabled = false;
                    submitButton.innerHTML = '<i class="fas fa-check"></i> Submit';
                }
            });
            
            // Function to show notification
            function showNotification(message, isError = false) {
                notification.textContent = message;
                notification.className = 'notification ' + (isError ? 'error' : 'success');
                notification.style.display = 'block';
                
                // Hide after 5 seconds
                setTimeout(() => {
                    notification.style.display = 'none';
                }, 5000);
            }
            
            // Function to fetch and display already saved procedures
            async function fetchSavedProcedures() {
                console.log('fetchSavedProcedures called');
                
                // For simplicity, we're now using a single procedure approach
                // just show the selected procedure in the modal
                console.log('Currently selected procedure:', selectedProcedure);
                updateSelectedProceduresModal();
                
                // Hide saved procedures section as we're now only working with a single procedure
                const savedProceduresSection = document.getElementById('saved-procedures-section');
                if (savedProceduresSection) {
                    console.log('Hiding saved procedures section');
                    savedProceduresSection.style.display = 'none';
                } else {
                    console.log('Warning: savedProceduresSection element not found');
                }
                
                // Show a message that only one procedure can be selected now
                const procedureMessage = document.getElementById('no-saved-procedures-message');
                if (procedureMessage) {
                    console.log('Updating saved procedures message');
                    procedureMessage.textContent = 'The system now supports only one procedure per examination.';
                } else {
                    console.log('Warning: procedureMessage element not found');
                }
            }
            
            // Handle procedure selection via the entire card
            const procedureCards = document.querySelectorAll('.procedure-card');
            
            procedureCards.forEach(card => {
                card.addEventListener('click', function(e) {
                    // Don't handle clicks on buttons or links inside the card
                    if (e.target.closest('.btn') || e.target.closest('a')) {
                        return;
                    }
                    
                    // Find the select button within this card
                    const selectButton = this.querySelector('.select-procedure');
                    if (selectButton) {
                        // Trigger a click on the select button
                        selectButton.click();
                    }
                });
            });
        // Close modal when clicking close button or outside the modal
        closeModalButtons.forEach(button => {
            button.addEventListener('click', function() {
                selectedProceduresModal.style.display = 'none';
                });
            });
            
        window.addEventListener('click', function(e) {
            if (e.target === selectedProceduresModal) {
                selectedProceduresModal.style.display = 'none';
            }
        });
        
        // Show modal function
        function showModal(modal) {
            modal.style.display = 'block';
        }
        
        // Initialize UI
                    updateSelectionUI();
        
        // Initialize saved procedures display
        fetchSavedProcedures();
        
        // Handle clicks on remove buttons inside the modal using event delegation
        document.addEventListener('click', function(e) {
            if (e.target && (e.target.classList.contains('remove-procedure-btn') || e.target.closest('.remove-procedure-btn'))) {
                e.preventDefault();
                e.stopPropagation();
                
                // Get the procedure ID from the button's data attribute or find it from the row
                const removeBtnElement = e.target.classList.contains('remove-procedure-btn') ? 
                    e.target : e.target.closest('.remove-procedure-btn');
                
                console.log('Remove button clicked');
                
                // Call removeProcedure function
                removeProcedure();
                
                // Update the modal to reflect changes
                    updateSelectedProceduresModal();
            }
        });
        
        // Initialize department tabs
        const departmentTabs = document.querySelectorAll('.department-tab');
        const departmentContents = document.querySelectorAll('.department-content');
        const departmentsContent = document.querySelector('.departments-content');
        
        // Debug: Log all department tabs and their data-dept attributes
        console.log('All department tabs:');
        departmentTabs.forEach(tab => {
            console.log(`Tab: data-dept="${tab.dataset.dept}", text="${tab.textContent.trim()}"`);
        });
        
        // Debug: Log all department content elements and their data-dept attributes
        console.log('All department content elements:');
        departmentContents.forEach(content => {
            console.log(`Content: data-dept="${content.dataset.dept}"`);
        });
        
        // Function to switch tabs
        function switchTab(tabElement) {
            const dept = tabElement.dataset.dept;
            console.log('Switching to department tab:', dept);
            
            // Remove active class from all tabs
            departmentTabs.forEach(t => t.classList.remove('active'));
            
            // Add active class to current tab
            tabElement.classList.add('active');
            
            // Hide all department contents
            departmentContents.forEach(content => {
                content.classList.remove('active');
                content.style.display = 'none'; // Explicitly hide
            });
            
            // Show the content for the current department - try case-insensitive matching if exact match fails
            let content = document.querySelector(`.department-content[data-dept="${dept}"]`);
            if (!content) {
                // Try case-insensitive match
                departmentContents.forEach(el => {
                    if (el.dataset.dept && el.dataset.dept.toLowerCase() === dept.toLowerCase()) {
                        content = el;
                    }
                });
            }
            
            console.log('Found department content element:', content);
            
            if (content) {
                content.classList.add('active');
                content.style.display = 'block'; // Explicitly show
                departmentsContent.classList.remove('no-active-tab');
                
                // Remove any existing "no procedures" messages
                const existingMessages = content.querySelectorAll('.no-procedures');
                existingMessages.forEach(msg => msg.remove());
                
                // Debug: Log all department-content elements and their data-dept attributes
                console.log('All department content elements:');
                document.querySelectorAll('.department-content').forEach(el => {
                    console.log(`  Element: data-dept="${el.dataset.dept}", visible: ${el.classList.contains('active')}`);
                });
                
                // Make sure all procedure cards in this department are visible
                const procedureCards = content.querySelectorAll('.procedure-card');
                console.log('Found procedure cards in this department:', procedureCards.length);
                
                procedureCards.forEach(card => {
                    console.log('Making card visible:', card.dataset.id);
                    card.style.display = 'grid';
                });
                
                // If no cards are found, show a message
                if (procedureCards.length === 0) {
                    console.log('No procedure cards found, adding message');
                    const noCardMessage = document.createElement('div');
                    noCardMessage.className = 'no-procedures';
                    noCardMessage.innerHTML = '<i class="fas fa-info-circle"></i> No procedures available in this department.';
                    content.appendChild(noCardMessage);
                }
                
                // If a procedure was previously selected, ensure its card shows as selected
                if (selectedProcedure) {
                    const selectedCard = content.querySelector(`.procedure-card[data-id="${selectedProcedure.id}"]`);
                    if (selectedCard) {
                        selectedCard.classList.add('selected');
                        const selectButton = selectedCard.querySelector('.select-procedure');
                        if (selectButton) {
                            selectButton.innerHTML = '<i class="fas fa-check-circle"></i> Selected';
                        }
                    }
                }
                    } else {
                console.error('Content element not found for department:', dept);
                departmentsContent.classList.add('no-active-tab');
                
                // If no content found, fallback to showing the first department tab
                if (departmentContents.length > 0) {
                    console.log('Falling back to first department content');
                    const firstContent = departmentContents[0];
                    firstContent.classList.add('active');
                    firstContent.style.display = 'block';
                    departmentsContent.classList.remove('no-active-tab');
                }
            }
        }
        
        // Add click event listeners to tabs
        departmentTabs.forEach(tab => {
            tab.addEventListener('click', function(e) {
                e.preventDefault();
                switchTab(this);
            });
        });
        
        // Function to initialize tabs
        function initializeTabs() {
            console.log('Initializing tabs on page load');
            
            // First try using the active class that might be set in JSP
            const activeTab = document.querySelector('.department-tab.active');
            const activeContent = document.querySelector('.department-content.active');
            
            if (activeTab && activeContent) {
                console.log('Found active tab and content from JSP');
                switchTab(activeTab);
                return;
            }
            
            // Otherwise use the first tab
            if (departmentTabs.length > 0) {
                console.log('Using first available tab');
                switchTab(departmentTabs[0]);
            } else if (departmentContents.length > 0) {
                // If no tabs but we have content, show the first content
                console.log('No tabs found, showing first content');
                departmentContents.forEach(content => {
                    content.classList.remove('active');
                    content.style.display = 'none';
                });
                
                departmentContents[0].classList.add('active');
                departmentContents[0].style.display = 'block';
                        } else {
                console.error('No tabs or content found at all');
            }
            
            // Force check of all procedure cards in active content
            document.querySelectorAll('.department-content.active .procedure-card').forEach(card => {
                console.log('Procedure card in active tab:', card.querySelector('h3').textContent);
                card.style.display = 'grid';
            });
        }
        
        // Call initialization after a short delay
        setTimeout(initializeTabs, 500);
        });
    </script>
</body>
</html> 