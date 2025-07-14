<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html>
<head>
    <title>Examination Details - PeriDesk</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    
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
        
        /* Style for disabled form elements for receptionists */
        .form-control:disabled {
            background-color: #f8f9fa !important;
            color: #6c757d !important;
            cursor: not-allowed !important;
            opacity: 0.7 !important;
            border-color: #dee2e6 !important;
        }
        
        .form-control:disabled:focus {
            box-shadow: none !important;
            border-color: #dee2e6 !important;
        }
        
        /* Style for read-only doctor assignment text */
        .read-only-doctor {
            font-weight: 500;
            color: #2c3e50;
            padding: 8px 12px;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            display: inline-block;
            min-width: 200px;
        }
        
        .read-only-doctor.not-assigned {
            color: #7f8c8d;
            font-style: italic;
        }
        
        .welcome-container {
            display: flex;
            min-height: 100vh;
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
        
        .btn-success {
            background: linear-gradient(135deg, #2ecc71, #27ae60);
            color: white;
        }
        
        .btn-success:hover {
            background: linear-gradient(135deg, #27ae60, #229954);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(46, 204, 113, 0.2);
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
        
        /* Examination Details Specific Styles */
        .examination-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            padding: 25px;
            margin-bottom: 20px;
        }
        
        .examination-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .examination-header h2 {
            margin: 0;
            color: #2c3e50;
            font-size: 1.5rem;
        }
        
        .header-actions {
            display: flex;
            gap: 10px;
        }
        
        .examination-meta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        
        .meta-item {
            display: flex;
            flex-direction: column;
        }
        
        .meta-label {
            color: #7f8c8d;
            font-size: 0.9rem;
            margin-bottom: 5px;
        }
        
        .meta-value {
            color: #2c3e50;
            font-weight: 500;
            font-size: 1rem;
        }
        
        .form-sections-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
        }
        
        .form-section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }
        
        .form-section h3 {
            color: #3498db;
            font-size: 1.1rem;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            color: #2c3e50;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }
        
        select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%232c3e50' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 10px center;
            padding-right: 30px;
        }
        
        .notes-section {
            grid-column: 1 / -1;
        }
        
        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }
        
        .form-actions {
            grid-column: 1 / -1;
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        /* Flatpickr Customization */
        .flatpickr-calendar {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 3px 13px rgba(0, 0, 0, 0.08);
            font-family: 'Poppins', sans-serif;
            padding-bottom: 50px !important;
        }
        
        .flatpickr-day {
            border-radius: 6px;
            margin: 2px;
        }
        
        .flatpickr-day.selected {
            background: #3498db;
            border-color: #3498db;
        }
        
        .flatpickr-time {
            border-top: 1px solid #eee;
            margin: 5px 0;
        }
        
        .flatpickr-time input {
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
        }
        
        .treatment-date-picker {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.9rem;
            cursor: pointer;
            background: #fff;
        }
        
        .treatment-date-picker:hover {
            border-color: #3498db;
        }
        
        .treatment-date-picker:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }
        
        /* Notification Styles */
        .notification {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: none;
            animation: slideIn 0.3s ease;
        }
        
        @keyframes slideIn {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        .notification.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .notification.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        /* Disabled button style */
        .btn.disabled {
            background: #cccccc;
            color: #666666;
            cursor: not-allowed;
            pointer-events: none;
            box-shadow: none;
        }
        
        .btn.disabled:hover {
            transform: none;
            box-shadow: none;
        }
        
        /* Custom tooltip styles */
        .tooltip-container {
            position: relative;
            display: inline-block;
        }
        
        .tooltip-container .tooltip-text {
            visibility: hidden;
            width: 200px;
            background-color: #2c3e50;
            color: #fff;
            text-align: center;
            border-radius: 6px;
            padding: 8px;
            position: absolute;
            z-index: 1;
            bottom: 125%;
            left: 50%;
            margin-left: -100px;
            opacity: 0;
            transition: opacity 0.3s;
            font-size: 0.8rem;
        }
        
        .tooltip-container:hover .tooltip-text {
            visibility: visible;
            opacity: 1;
        }
        
        /* Doctor Assignment Styles */
        .doctor-dropdown {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            width: 200px;
            background-color: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .doctor-dropdown.doctor-assigned {
            border-color: #3498db;
            background-color: #f8f9fa;
            font-weight: 500;
        }
        
        .doctor-dropdown option {
            padding: 8px;
        }
        
        .doctor-dropdown option:checked {
            background-color: #3498db;
            color: white;
            font-weight: 500;
        }
        
        .doctor-dropdown option[value="remove"] {
            color: #e74c3c;
            font-style: italic;
        }
        
        .doctor-dropdown option[value="remove"]:checked {
            background-color: #e74c3c;
            color: white;
        }
        
        /* Style for disabled doctor dropdown specifically */
        #doctorSelect:disabled {
            background-color: #e9ecef !important;
            color: #495057 !important;
            cursor: not-allowed !important;
            opacity: 0.8 !important;
            border-color: #ced4da !important;
            font-weight: 500 !important;
        }
        
        #doctorSelect:disabled option {
            color: #495057 !important;
        }
        
        /* Style for doctor assignment info message */
        .doctor-assignment-info {
            display: block;
            margin-top: 8px;
            color: #6c757d;
            font-size: 0.875rem;
            font-style: italic;
        }
        
        .doctor-assignment-info i {
            margin-right: 5px;
            color: #17a2b8;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .welcome-container {
                flex-direction: column;
            }
            
            .main-content {
                padding: 20px;
            }
            
            .form-sections-container {
                grid-template-columns: 1fr;
            }
            
            .examination-meta {
                grid-template-columns: 1fr;
            }
        }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            overflow-y: auto;
        }
        
        .modal-content {
            background-color: white;
            margin: 2% auto;
            padding: 30px;
            border-radius: 12px;
            width: 95%;
            max-width: 1200px;
            position: relative;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .modal-content h2 {
            color: #2c3e50;
            font-size: 1.5rem;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
            font-weight: 600;
        }
        
        .close {
            position: absolute;
            right: 30px;
            top: 30px;
            font-size: 28px;
            cursor: pointer;
            color: #666;
            transition: color 0.3s ease;
            background: none;
            border: none;
            padding: 0;
            line-height: 1;
        }
        
        .close:hover {
            color: #000;
        }
        
        /* Form Sections in Modal */
        .modal .form-sections-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 20px;
        }
        
        .modal .form-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            border: 1px solid #eee;
        }
        
        .modal .form-section h3 {
            color: #3498db;
            font-size: 1.1rem;
            margin-bottom: 25px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
            font-weight: 600;
        }
        
        .modal .form-group {
            margin-bottom: 25px;
        }
        
        .modal .form-group label {
            display: block;
            color: #2c3e50;
            margin-bottom: 10px;
            font-weight: 500;
            font-size: 0.95rem;
        }
        
        .modal .form-group label.required:after {
            content: " *";
            color: #e74c3c;
        }
        
        .modal .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background-color: white;
        }
        
        .modal .form-control:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }
        
        .modal select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%232c3e50' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            padding-right: 40px;
        }
        
        .modal textarea.form-control {
            min-height: 150px;
            resize: vertical;
        }
        
        .modal .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 40px;
            padding-top: 25px;
            border-top: 1px solid #eee;
        }
        
        .modal .btn {
            padding: 6px 12px;
            font-size: 0.85rem;
            border-radius: 4px;
            font-weight: 500;
            transition: all 0.2s ease;
            min-width: 80px;
            height: 32px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 4px;
        }
        
        .modal .btn i {
            font-size: 0.8rem;
        }
        
        .modal .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border: none;
        }
        
        .modal .btn-primary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(52, 152, 219, 0.2);
        }
        
        .modal .btn-secondary {
            background: #95a5a6;
            color: white;
            border: none;
        }
        
        .modal .btn-secondary:hover {
            background: #7f8c8d;
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(127, 140, 141, 0.2);
        }
        
        /* Form validation styles */
        .modal .form-control.error {
            border-color: #e74c3c;
        }
        
        .modal .error-message {
            color: #e74c3c;
            font-size: 0.85rem;
            margin-top: 5px;
            display: none;
        }
        
        .modal .form-control.error + .error-message {
            display: block;
        }
        
        /* Responsive Modal */
        @media (max-width: 768px) {
            .modal-content {
                margin: 5% auto;
                width: 90%;
                padding: 20px;
            }
            
            .modal .form-sections-container {
                grid-template-columns: 1fr;
            }
            
            .modal .form-section {
                padding: 20px;
            }
            
            .modal .btn {
                padding: 5px 10px;
                font-size: 0.8rem;
                height: 28px;
                min-width: 70px;
            }
        }
        
        /* Denture Photos Styles */
        .denture-photos-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 15px;
        }
        
        .denture-photo-item {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            border: 1px solid #e9ecef;
            transition: all 0.3s ease;
        }
        
        .denture-photo-item:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
        }
        
        .photo-preview {
            text-align: center;
            margin-bottom: 15px;
        }
        
        .denture-thumbnail {
            max-width: 100%;
            max-height: 200px;
            border-radius: 6px;
            cursor: pointer;
            transition: transform 0.3s ease;
            border: 2px solid #e9ecef;
        }
        
        .denture-thumbnail:hover {
            transform: scale(1.05);
            border-color: #3498db;
        }
        
        .denture-thumbnail.error {
            border-color: #e74c3c;
            background-color: #fdf2f2;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 150px;
            color: #e74c3c;
            font-weight: 500;
        }
        
        .image-error-message {
            text-align: center;
            color: #e74c3c;
            font-size: 0.9rem;
            margin-top: 10px;
        }
        
        .photo-actions {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        
        .photo-label {
            font-weight: 600;
            color: #2c3e50;
            text-align: center;
            font-size: 1rem;
        }
        
        .action-buttons {
            display: flex;
            gap: 8px;
            justify-content: center;
        }
        
        .btn-sm {
            padding: 6px 12px;
            font-size: 0.8rem;
            border-radius: 4px;
        }
        
        /* Image Modal Styles */
        .image-modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.8);
            backdrop-filter: blur(5px);
        }
        
        .image-modal-content {
            position: relative;
            margin: auto;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            max-width: 90%;
            max-height: 90%;
        }
        
        .modal-image {
            max-width: 100%;
            max-height: 80vh;
            object-fit: contain;
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }
        
        .modal-header {
            position: absolute;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0, 0, 0, 0.7);
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            font-weight: 500;
            z-index: 1001;
        }
        
        .modal-close {
            position: absolute;
            top: 20px;
            right: 30px;
            color: white;
            font-size: 35px;
            font-weight: bold;
            cursor: pointer;
            z-index: 1001;
            background: rgba(0, 0, 0, 0.5);
            border-radius: 50%;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }
        
        .modal-close:hover {
            background: rgba(0, 0, 0, 0.8);
            transform: scale(1.1);
        }
        
        .modal-actions {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 10px;
            z-index: 1001;
        }
        
        .modal-btn {
            background: rgba(52, 152, 219, 0.9);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .modal-btn:hover {
            background: rgba(52, 152, 219, 1);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
        }
        
        .modal-btn.download {
            background: rgba(46, 204, 113, 0.9);
        }
        
        .modal-btn.download:hover {
            background: rgba(46, 204, 113, 1);
            box-shadow: 0 4px 12px rgba(46, 204, 113, 0.3);
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .denture-photos-grid {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .modal-image {
                max-height: 70vh;
            }
            
            .modal-close {
                top: 10px;
                right: 15px;
                width: 40px;
                height: 40px;
                font-size: 25px;
            }
            
            .modal-header {
                top: 10px;
                padding: 8px 16px;
                font-size: 0.9rem;
            }
            
            .modal-actions {
                bottom: 10px;
                flex-direction: column;
                gap: 8px;
            }
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        <div class="main-content">
            <div class="welcome-header">
                <h1 class="welcome-message">Examination Details</h1>
                <a href="${pageContext.request.contextPath}/patients/details/${patient.id}" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i> Back to Patient Details
                </a>
            </div>
            
            <div id="notification" class="notification"></div>
            
            <!-- Role-based message for receptionists -->
            <c:if test="${currentUserRole == 'RECEPTIONIST'}">
                <div class="alert alert-info" style="background: #e3f2fd; border: 1px solid #2196f3; color: #1976d2; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
                    <i class="fas fa-info-circle"></i>
                    <strong>View Only Mode:</strong> Receptionists can only view examination details. Editing is restricted to doctors and staff members.
                </div>
            </c:if>
            
            <div class="examination-container">
                <div class="examination-header">
                    <h2>Tooth ${examination.toothNumber} Examination</h2>
                    <div class="header-actions">
                        <!-- Only show action buttons for non-receptionists -->
                        <c:if test="${currentUserRole != 'RECEPTIONIST'}">
                        <div class="tooltip-container">
                            <c:choose>
                                <c:when test="${examination.assignedDoctorId == null}">
                                    <a href="#" class="btn btn-primary disabled" disabled>
                                        <i class="fas fa-play"></i> Start Procedure
                                    </a>
                                    <span class="tooltip-text">Please assign a doctor first</span>
                                </c:when>
                                <c:when test="${not empty examination.procedure}">
                                    <a href="#" class="btn btn-secondary disabled" disabled>
                                        <i class="fas fa-play"></i> Start Procedure
                                    </a>
                                    <span class="tooltip-text">Procedure is already started</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/patients/examination/${examination.id}/procedures" class="btn btn-primary">
                                        <i class="fas fa-play"></i> Start Procedure
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <!-- View Attached Procedure Button -->
                        <div class="tooltip-container">
                            <c:choose>
                                <c:when test="${empty examination.procedure}">
                                    <a href="#" 
                                       class="btn btn-secondary disabled" 
                                       id="viewProcedureBtn">
                                        <i class="fas fa-list-alt"></i> View Procedure
                                    </a>
                                    <span class="tooltip-text">No procedure attached to this examination yet</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/patients/examination/${examination.id}/lifecycle" 
                                       class="btn btn-primary" 
                                       id="viewProcedureBtn">
                                        <i class="fas fa-list-alt"></i> View Procedure
                                    </a>
                                    <span class="tooltip-text">View attached procedure details and lifecycle</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        </c:if>
                    </div>
                </div>
                <div class="examination-meta">
                    <div class="meta-item">
                        <span class="meta-label">Patient Name</span>
                        <span class="meta-value">${patient.firstName} ${patient.lastName}</span>
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
                        <span class="meta-label">Created</span>
                        <span class="meta-value">
                            <c:if test="${not empty examination.examinationDate}">
                                <c:set var="dateStr" value="${examination.examinationDate.toString()}" />
                                <c:set var="datePart" value="${fn:substringBefore(dateStr, 'T')}" />
                                <c:set var="timePart" value="${fn:substringBefore(fn:substringAfter(dateStr, 'T'), '.')}" />
                                
                                <c:set var="year" value="${fn:substring(datePart, 0, 4)}" />
                                <c:set var="month" value="${fn:substring(datePart, 5, 7)}" />
                                <c:set var="day" value="${fn:substring(datePart, 8, 10)}" />
                                
                                ${day}/${month}/${year} ${timePart} IST
                            </c:if>
                        </span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Assigned Doctor</span>
                        <span class="meta-value">
                            <c:choose>
                                <c:when test="${currentUserRole == 'RECEPTIONIST'}">
                                    <!-- Show as read-only text for receptionists -->
                                    <c:choose>
                                        <c:when test="${examination.assignedDoctorId != null}">
                                            <c:forEach items="${doctors}" var="doctor">
                                                <c:if test="${doctor.id == examination.assignedDoctorId}">
                                                    <span class="read-only-doctor">${doctor.firstName} ${doctor.lastName}</span>
                                                </c:if>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="read-only-doctor not-assigned">Not Assigned</span>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <!-- Show as dropdown for other roles -->
                                    <!-- Debug: assignedDoctorId = ${examination.assignedDoctorId} -->
                                    <!-- Debug: doctors count = ${fn:length(doctors)} -->
                                    <select id="doctorSelect" class="form-control" 
                                            <c:if test="${examination.assignedDoctorId != null}">disabled</c:if>>
                                        <option value="">Select Doctor</option>
                                        <c:forEach items="${doctors}" var="doctor">
                                            <!-- Debug: doctor.id = ${doctor.id}, assignedDoctorId = ${examination.assignedDoctorId} -->
                                            <option value="${doctor.id}" 
                                                    <c:if test="${examination.assignedDoctorId != null and doctor.id == examination.assignedDoctorId}">selected</c:if>>
                                                ${doctor.firstName} ${doctor.lastName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <c:if test="${examination.assignedDoctorId != null}">
                                        <small class="doctor-assignment-info">
                                            <i class="fas fa-info-circle"></i> Doctor assignment cannot be changed once set
                                        </small>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
                
                <!-- Denture Photos Section -->
                <c:if test="${not empty examination.upperDenturePicturePath or not empty examination.lowerDenturePicturePath or not empty examination.xrayPicturePath}">
                <div class="examination-container">
                    <h3><i class="fas fa-images"></i> Dental Photos</h3>
                    <div class="denture-photos-grid">
                        <c:if test="${not empty examination.upperDenturePicturePath}">
                        <div class="denture-photo-item">
                            <div class="photo-preview">
                                <img src="${pageContext.request.contextPath}/uploads/${examination.upperDenturePicturePath}" 
                                     alt="Upper Denture" class="denture-thumbnail" 
                                     onclick="openImageModal('${pageContext.request.contextPath}/uploads/${examination.upperDenturePicturePath}', 'Upper Denture')">
                            </div>
                            <div class="photo-actions">
                                <span class="photo-label">Upper Denture</span>
                                <div class="action-buttons">
                                    <button type="button" class="btn btn-sm btn-primary" 
                                            onclick="openImageModal('${pageContext.request.contextPath}/uploads/${examination.upperDenturePicturePath}', 'Upper Denture')">
                                        <i class="fas fa-search-plus"></i> View
                                    </button>
                                    <a href="${pageContext.request.contextPath}/uploads/${examination.upperDenturePicturePath}" 
                                       download="upper_denture_${examination.id}.jpg" class="btn btn-sm btn-success">
                                        <i class="fas fa-download"></i> Download
                                    </a>
                                </div>
                            </div>
                        </div>
                        </c:if>
                        
                        <c:if test="${not empty examination.lowerDenturePicturePath}">
                        <div class="denture-photo-item">
                            <div class="photo-preview">
                                <img src="${pageContext.request.contextPath}/uploads/${examination.lowerDenturePicturePath}" 
                                     alt="Lower Denture" class="denture-thumbnail" 
                                     onclick="openImageModal('${pageContext.request.contextPath}/uploads/${examination.lowerDenturePicturePath}', 'Lower Denture')">
                            </div>
                            <div class="photo-actions">
                                <span class="photo-label">Lower Denture</span>
                                <div class="action-buttons">
                                    <button type="button" class="btn btn-sm btn-primary" 
                                            onclick="openImageModal('${pageContext.request.contextPath}/uploads/${examination.lowerDenturePicturePath}', 'Lower Denture')">
                                        <i class="fas fa-search-plus"></i> View
                                    </button>
                                    <a href="${pageContext.request.contextPath}/uploads/${examination.lowerDenturePicturePath}" 
                                       download="lower_denture_${examination.id}.jpg" class="btn btn-sm btn-success">
                                        <i class="fas fa-download"></i> Download
                                    </a>
                                </div>
                            </div>
                        </div>
                        </c:if>
                        
                        <c:if test="${not empty examination.xrayPicturePath}">
                        <div class="denture-photo-item xray-photo">
                            <div class="photo-preview">
                                <img src="${pageContext.request.contextPath}/uploads/${examination.xrayPicturePath}" 
                                     alt="X-Ray Image" class="denture-thumbnail" 
                                     onclick="openImageModal('${pageContext.request.contextPath}/uploads/${examination.xrayPicturePath}', 'X-Ray Image')">
                            </div>
                            <div class="photo-actions">
                                <span class="photo-label">X-Ray Image</span>
                                <div class="action-buttons">
                                    <button type="button" class="btn btn-sm btn-primary" 
                                            onclick="openImageModal('${pageContext.request.contextPath}/uploads/${examination.xrayPicturePath}', 'X-Ray Image')">
                                        <i class="fas fa-search-plus"></i> View
                                    </button>
                                    <a href="${pageContext.request.contextPath}/uploads/${examination.xrayPicturePath}" 
                                       download="xray_${examination.id}.jpg" class="btn btn-sm btn-success">
                                        <i class="fas fa-download"></i> Download
                                    </a>
                                </div>
                            </div>
                        </div>
                        </c:if>
                    </div>
                </div>
                </c:if>
                
                <!-- No Photos Message -->
                <c:if test="${empty examination.upperDenturePicturePath and empty examination.lowerDenturePicturePath and empty examination.xrayPicturePath}">
                <div class="examination-container">
                    <h3><i class="fas fa-images"></i> Dental Photos</h3>
                    <div style="text-align: center; padding: 40px; color: #7f8c8d;">
                        <i class="fas fa-camera" style="font-size: 3rem; margin-bottom: 15px; opacity: 0.5;"></i>
                        <p style="font-size: 1.1rem; margin: 0;">No dental photos have been uploaded for this examination.</p>
                        <p style="font-size: 0.9rem; margin: 10px 0 0 0; opacity: 0.7;">Photos will appear here once uploaded during the procedure selection process.</p>
                    </div>
                </div>
                </c:if>
                
                <form id="examinationForm" method="post" class="examination-details-compact">
                    <input type="hidden" id="examinationId" value="${examination.id}">
                    <input type="hidden" id="patientId" value="${examination.patient.id}">
                    <input type="hidden" id="toothNumber" value="${examination.toothNumber}">
                    
                    <!-- Chief Complaints Section -->
                    <div class="chief-complaints-section">
                        <h3>Chief Complaints</h3>
                        <div class="form-group">
                            <label for="chiefComplaints">Patient's Chief Complaints</label>
                            <textarea name="chiefComplaints" id="chiefComplaints" rows="6" class="form-control"
                                      <c:if test="${currentUserRole == 'RECEPTIONIST'}">disabled</c:if>>${examination.chiefComplaints}</textarea>
                        </div>
                    </div>
                    
                    <div class="form-grid">
                        <!-- Left Column -->
                        <div class="form-column">
                            <div class="form-section">
                                <h3>Basic Assessment</h3>
                                <div class="form-group">
                                    <label for="toothSurface">Surface</label>
                                    <select name="toothSurface" id="toothSurface" class="form-control"
                                            <c:if test="${currentUserRole == 'RECEPTIONIST'}">disabled</c:if>>
                                        <option value="">Select</option>
                                        <c:forEach items="${toothSurfaces}" var="surface">
                                            <option value="${surface}" ${examination.toothSurface == surface ? 'selected' : ''}>${surface}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="toothCondition">Condition</label>
                                    <select name="toothCondition" id="toothCondition" class="form-control"
                                            <c:if test="${currentUserRole == 'RECEPTIONIST'}">disabled</c:if>>
                                        <option value="">Select</option>
                                        <c:forEach items="${toothConditions}" var="condition">
                                            <option value="${condition}" ${examination.toothCondition == condition ? 'selected' : ''}>${condition}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="existingRestoration">Restoration</label>
                                    <select name="existingRestoration" id="existingRestoration" class="form-control"
                                            <c:if test="${currentUserRole == 'RECEPTIONIST'}">disabled</c:if>>
                                        <option value="">Select</option>
                                        <c:forEach items="${existingRestorations}" var="restoration">
                                            <option value="${restoration}" ${examination.existingRestoration == restoration ? 'selected' : ''}>${restoration}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="form-section">
                                <h3>Periodontal Assessment</h3>
                                <div class="form-group">
                                    <label for="pocketDepth">Pocket Depth</label>
                                    <select name="pocketDepth" id="pocketDepth" class="form-control"
                                            <c:if test="${currentUserRole == 'RECEPTIONIST'}">disabled</c:if>>
                                        <option value="">Select</option>
                                        <c:forEach items="${pocketDepths}" var="depth">
                                            <option value="${depth}" ${examination.pocketDepth == depth ? 'selected' : ''}>${depth}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="bleedingOnProbing">Bleeding on Probing</label>
                                    <select name="bleedingOnProbing" id="bleedingOnProbing" class="form-control"
                                            <c:if test="${currentUserRole == 'RECEPTIONIST'}">disabled</c:if>>
                                        <option value="">Select</option>
                                        <c:forEach items="${bleedingOnProbings}" var="bleeding">
                                            <option value="${bleeding}" ${examination.bleedingOnProbing == bleeding ? 'selected' : ''}>${bleeding}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="plaqueScore">Plaque Score</label>
                                    <select name="plaqueScore" id="plaqueScore" class="form-control"
                                            <c:if test="${currentUserRole == 'RECEPTIONIST'}">disabled</c:if>>
                                        <option value="">Select</option>
                                        <c:forEach items="${plaqueScores}" var="score">
                                            <option value="${score}" ${examination.plaqueScore == score ? 'selected' : ''}>${score}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="gingivalRecession">Gingival Recession</label>
                                    <select name="gingivalRecession" id="gingivalRecession" class="form-control"
                                            <c:if test="${currentUserRole == 'RECEPTIONIST'}">disabled</c:if>>
                                        <option value="">Select</option>
                                        <c:forEach items="${gingivalRecessions}" var="recession">
                                            <option value="${recession}" ${examination.gingivalRecession == recession ? 'selected' : ''}>${recession}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Right Column -->
                        <div class="form-column">
                            <div class="form-section">
                                <h3>Clinical Assessment</h3>
                                <div class="form-group">
                                    <label for="toothMobility">Mobility</label>
                                    <select name="toothMobility" id="toothMobility" class="form-control"
                                            <c:if test="${currentUserRole == 'RECEPTIONIST'}">disabled</c:if>>
                                        <option value="">Select</option>
                                        <c:forEach items="${toothMobilities}" var="mobility">
                                            <option value="${mobility}" ${examination.toothMobility == mobility ? 'selected' : ''}>${mobility}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="toothVitality">Vitality</label>
                                    <select name="toothVitality" id="toothVitality" class="form-control"
                                            <c:if test="${currentUserRole == 'RECEPTIONIST'}">disabled</c:if>>
                                        <option value="">Select</option>
                                        <c:forEach items="${toothVitalities}" var="vitality">
                                            <option value="${vitality}" ${examination.toothVitality == vitality ? 'selected' : ''}>${vitality}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="toothSensitivity">Sensitivity</label>
                                    <select name="toothSensitivity" id="toothSensitivity" class="form-control"
                                            <c:if test="${currentUserRole == 'RECEPTIONIST'}">disabled</c:if>>
                                        <option value="">Select</option>
                                        <c:forEach items="${toothSensitivities}" var="sensitivity">
                                            <option value="${sensitivity}" ${examination.toothSensitivity == sensitivity ? 'selected' : ''}>${sensitivity}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="furcationInvolvement">Furcation</label>
                                    <select name="furcationInvolvement" id="furcationInvolvement" class="form-control"
                                            <c:if test="${currentUserRole == 'RECEPTIONIST'}">disabled</c:if>>
                                        <option value="">Select</option>
                                        <c:forEach items="${furcationInvolvements}" var="furcation">
                                            <option value="${furcation}" ${examination.furcationInvolvement == furcation ? 'selected' : ''}>${furcation}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Advised Section -->
                    <div class="form-section notes-section">
                        <h3>Treatment Advised</h3>
                        <div class="form-group">
                            <label for="advised">Treatment/Procedure Advised</label>
                            <textarea name="advised" id="advised" rows="3" class="form-control"
                                      <c:if test="${currentUserRole == 'RECEPTIONIST'}">disabled</c:if>>${examination.advised}</textarea>
                        </div>
                    </div>

                    <!-- Notes Section -->
                    <div class="form-section notes-section">
                        <h3>Clinical Notes</h3>
                        <div class="form-group">
                            <label for="examinationNotes">Notes</label>
                            <textarea name="examinationNotes" id="examinationNotes" rows="4" class="form-control"
                                      <c:if test="${currentUserRole == 'RECEPTIONIST'}">disabled</c:if>>${examination.examinationNotes}</textarea>
                        </div>
                    </div>

                    <!-- Form Actions -->
                    <div class="form-actions">
                        <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/patients/details/${patient.id}'" class="btn btn-secondary">Cancel</button>
                        
                        <!-- Only show Update button to doctors and admins -->
                        <c:if test="${currentUserRole != 'RECEPTIONIST'}">
                        <sec:authorize access="hasAnyRole('DOCTOR', 'ADMIN')">
                            <button type="submit" id="updateExaminationBtn" class="btn btn-primary disabled" disabled>Update Examination</button>
                        </sec:authorize>
                        
                        <!-- Show message for other roles -->
                        <sec:authorize access="!hasAnyRole('DOCTOR', 'ADMIN')">
                            <div class="tooltip-container">
                                <button type="button" class="btn btn-primary disabled" disabled>Update Examination</button>
                                <span class="tooltip-text">Only doctors and administrators can update examinations</span>
                            </div>
                        </sec:authorize>
                        </c:if>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <div id="examinationDetailsModal" class="modal">
        <div class="modal-content">
            <h2>Examination Details</h2>
            <span class="close">&times;</span>
            <div class="form-sections-container">
                <!-- Basic Information Section -->
                <div class="form-section">
                    <h3>Basic Information</h3>
                    <div class="form-group">
                        <label for="toothSurface" class="required">Surface</label>
                        <select name="toothSurface" id="toothSurface" class="form-control" required>
                            <option value="">Select</option>
                            <c:forEach items="${toothSurfaces}" var="surface">
                                <option value="${surface}" ${examination.toothSurface == surface ? 'selected' : ''}>${surface}</option>
                            </c:forEach>
                        </select>
                        <div class="error-message">Please select a surface</div>
                    </div>
                    <div class="form-group">
                        <label for="toothCondition" class="required">Condition</label>
                        <select name="toothCondition" id="toothCondition" class="form-control" required>
                            <option value="">Select</option>
                            <c:forEach items="${toothConditions}" var="condition">
                                <option value="${condition}" ${examination.toothCondition == condition ? 'selected' : ''}>${condition}</option>
                            </c:forEach>
                        </select>
                        <div class="error-message">Please select a condition</div>
                    </div>
                    <div class="form-group">
                        <label for="existingRestoration" class="required">Restoration</label>
                        <select name="existingRestoration" id="existingRestoration" class="form-control" required>
                            <option value="">Select</option>
                            <c:forEach items="${existingRestorations}" var="restoration">
                                <option value="${restoration}" ${examination.existingRestoration == restoration ? 'selected' : ''}>${restoration}</option>
                            </c:forEach>
                        </select>
                        <div class="error-message">Please select a restoration</div>
                    </div>
                </div>

                <!-- Periodontal Assessment Section -->
                <div class="form-section">
                    <h3>Periodontal Assessment</h3>
                    <div class="form-group">
                        <label for="pocketDepth">Pocket Depth</label>
                        <select name="pocketDepth" id="pocketDepth" class="form-control">
                            <option value="">Select</option>
                            <c:forEach items="${pocketDepths}" var="depth">
                                <option value="${depth}" ${examination.pocketDepth == depth ? 'selected' : ''}>${depth}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="bleedingOnProbing">Bleeding on Probing</label>
                        <select name="bleedingOnProbing" id="bleedingOnProbing" class="form-control">
                            <option value="">Select</option>
                            <c:forEach items="${bleedingOnProbings}" var="bleeding">
                                <option value="${bleeding}" ${examination.bleedingOnProbing == bleeding ? 'selected' : ''}>${bleeding}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="plaqueScore">Plaque Score</label>
                        <select name="plaqueScore" id="plaqueScore" class="form-control">
                            <option value="">Select</option>
                            <c:forEach items="${plaqueScores}" var="score">
                                <option value="${score}" ${examination.plaqueScore == score ? 'selected' : ''}>${score}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="gingivalRecession">Gingival Recession</label>
                        <select name="gingivalRecession" id="gingivalRecession" class="form-control">
                            <option value="">Select</option>
                            <c:forEach items="${gingivalRecessions}" var="recession">
                                <option value="${recession}" ${examination.gingivalRecession == recession ? 'selected' : ''}>${recession}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <!-- Clinical Assessment Section -->
                <div class="form-section">
                    <h3>Clinical Assessment</h3>
                    <div class="form-group">
                        <label for="toothMobility">Mobility</label>
                        <select name="toothMobility" id="toothMobility" class="form-control">
                            <option value="">Select</option>
                            <c:forEach items="${toothMobilities}" var="mobility">
                                <option value="${mobility}" ${examination.toothMobility == mobility ? 'selected' : ''}>${mobility}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="toothVitality">Vitality</label>
                        <select name="toothVitality" id="toothVitality" class="form-control">
                            <option value="">Select</option>
                            <c:forEach items="${toothVitalities}" var="vitality">
                                <option value="${vitality}" ${examination.toothVitality == vitality ? 'selected' : ''}>${vitality}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="toothSensitivity">Sensitivity</label>
                        <select name="toothSensitivity" id="toothSensitivity" class="form-control">
                            <option value="">Select</option>
                            <c:forEach items="${toothSensitivities}" var="sensitivity">
                                <option value="${sensitivity}" ${examination.toothSensitivity == sensitivity ? 'selected' : ''}>${sensitivity}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="furcationInvolvement">Furcation</label>
                        <select name="furcationInvolvement" id="furcationInvolvement" class="form-control">
                            <option value="">Select</option>
                            <c:forEach items="${furcationInvolvements}" var="furcation">
                                <option value="${furcation}" ${examination.furcationInvolvement == furcation ? 'selected' : ''}>${furcation}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <!-- Advised Section -->
                <div class="form-section notes-section">
                    <h3>Treatment Advised</h3>
                    <div class="form-group">
                        <label for="advised">Treatment/Procedure Advised</label>
                        <textarea name="advised" id="advised" rows="3" class="form-control"
                                  <c:if test="${currentUserRole == 'RECEPTIONIST'}">disabled</c:if>>${examination.advised}</textarea>
                    </div>
                </div>

                <!-- Notes Section -->
                <div class="form-section notes-section">
                    <h3>Clinical Notes</h3>
                    <div class="form-group">
                        <label for="examinationNotes">Notes</label>
                        <textarea name="examinationNotes" id="examinationNotes" rows="4" class="form-control"
                                  <c:if test="${currentUserRole == 'RECEPTIONIST'}">disabled</c:if>>${examination.examinationNotes}</textarea>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/patients/details/${patient.id}'" class="btn btn-secondary">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Examination</button>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Add context path variable
        const contextPath = '${pageContext.request.contextPath}';

        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('examinationForm');
            const notification = document.getElementById('notification');
            const csrfToken = document.querySelector('meta[name="_csrf"]').content;
            const updateButton = document.getElementById('updateExaminationBtn');

            // Enable update button when any form field changes
            const formFields = form.querySelectorAll('select, textarea');
            formFields.forEach(field => {
                field.addEventListener('change', function() {
                    updateButton.classList.remove('disabled');
                    updateButton.disabled = false;
                });
            });

            // Handle doctor selection change
            document.getElementById('doctorSelect').addEventListener('change', function() {
                const selectedValue = this.value;
                const examinationId = '${examination.id}';
                const currentDoctorId = '${examination.assignedDoctorId}';
                
                // If no doctor is currently assigned, show confirmation popup
                if (!currentDoctorId && selectedValue) {
                    const confirmed = confirm('Are you sure you want to assign this doctor? Once assigned, the doctor cannot be changed.');
                    if (!confirmed) {
                        // Reset to empty selection
                        this.value = '';
                        return;
                    }
                }
                
                // If a doctor is already assigned, prevent changes
                if (currentDoctorId && selectedValue !== currentDoctorId) {
                    alert('Doctor assignment cannot be changed once set. Please contact an administrator if you need to make changes.');
                    // Reset to current doctor
                    this.value = currentDoctorId;
                    return;
                }
                
                // Get CSRF token
                const token = $("meta[name='_csrf']").attr("content");
                const header = $("meta[name='_csrf_header']").attr("content");
                
                $.ajax({
                    url: contextPath + '/patients/tooth-examination/assign-doctor',
                    type: 'POST',
                    contentType: 'application/json',
                    headers: {
                        [header]: token
                    },
                    data: JSON.stringify({
                        examinationId: examinationId,
                        doctorId: selectedValue
                    }),
                    success: function(response) {
                        if (response.success) {
                            // Show success message
                            showNotification('Doctor assigned successfully! The assignment cannot be changed.', false);
                            // Disable the dropdown after successful assignment
                            document.getElementById('doctorSelect').disabled = true;
                            // Add the info message
                            const infoMessage = document.createElement('small');
                            infoMessage.className = 'doctor-assignment-info';
                            infoMessage.innerHTML = '<i class="fas fa-info-circle"></i> Doctor assignment cannot be changed once set';
                            document.getElementById('doctorSelect').parentNode.appendChild(infoMessage);
                            // Reload the page after a short delay to show updated state
                            setTimeout(() => {
                            window.location.reload();
                            }, 2000);
                        } else {
                            alert('Error: ' + (response.message || 'Failed to update doctor assignment'));
                        }
                    },
                    error: function(xhr, status, error) {
                        alert('Error: ' + error);
                    }
                });
            });

            // Function to show notification
            function showNotification(message, isError = false) {
                notification.textContent = message;
                notification.className = 'notification ' + (isError ? 'error' : 'success');
                notification.style.display = 'block';
            }

            // Handle form submission
            form.addEventListener('submit', function(e) {
                e.preventDefault();
                
                const formData = {
                    id: '${examination.id}',
                    toothSurface: document.getElementById('toothSurface').value,
                    toothCondition: document.getElementById('toothCondition').value,
                    existingRestoration: document.getElementById('existingRestoration').value,
                    toothMobility: document.getElementById('toothMobility').value,
                    pocketDepth: document.getElementById('pocketDepth').value,
                    bleedingOnProbing: document.getElementById('bleedingOnProbing').value,
                    plaqueScore: document.getElementById('plaqueScore').value,
                    gingivalRecession: document.getElementById('gingivalRecession').value,
                    toothVitality: document.getElementById('toothVitality').value,
                    furcationInvolvement: document.getElementById('furcationInvolvement').value,
                    toothSensitivity: document.getElementById('toothSensitivity').value,
                    examinationNotes: document.getElementById('examinationNotes').value,
                    chiefComplaints: document.getElementById('chiefComplaints').value,
                    advised: document.getElementById('advised').value
                };

                // Get CSRF token
                const token = $("meta[name='_csrf']").attr("content");
                const header = $("meta[name='_csrf_header']").attr("content");

                fetch(contextPath + '/patients/examination/update', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        [header]: token
                    },
                    body: JSON.stringify(formData)
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showNotification(data.message, false);
                        // Optionally refresh the page after a short delay
                        setTimeout(() => {
                            window.location.reload();
                        }, 1500);
                    } else {
                        showNotification(data.message || 'Failed to update examination', true);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('An error occurred while updating the examination', true);
                });
            });
        });

        // Image Modal Functions
        let currentImageUrl = '';
        let currentImageTitle = '';
        
        function openImageModal(imageUrl, title) {
            currentImageUrl = imageUrl;
            currentImageTitle = title;
            
            document.getElementById('modalImage').src = imageUrl;
            document.getElementById('modalHeader').textContent = title;
            document.getElementById('imageModal').style.display = 'block';
            
            // Prevent body scroll when modal is open
            document.body.style.overflow = 'hidden';
        }
        
        function closeImageModal() {
            document.getElementById('imageModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }
        
        function downloadImage() {
            if (currentImageUrl) {
                const link = document.createElement('a');
                link.href = currentImageUrl;
                link.download = currentImageTitle.toLowerCase().replace(/\s+/g, '_') + '_' + '${examination.id}' + '.jpg';
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            }
        }
        
        // Close modal when clicking outside the image
        document.getElementById('imageModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeImageModal();
            }
        });
        
        // Close modal with Escape key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && document.getElementById('imageModal').style.display === 'block') {
                closeImageModal();
            }
        });
        
        // Handle image loading errors
        document.addEventListener('DOMContentLoaded', function() {
            const images = document.querySelectorAll('.denture-thumbnail');
            images.forEach(function(img) {
                img.addEventListener('error', function() {
                    console.error('Failed to load image:', this.src);
                    this.classList.add('error');
                    this.alt = 'Image failed to load';
                    
                    // Add error message below the image
                    const errorMsg = document.createElement('div');
                    errorMsg.className = 'image-error-message';
                    errorMsg.textContent = 'Image failed to load: ' + this.src;
                    this.parentNode.appendChild(errorMsg);
                });
                
                img.addEventListener('load', function() {
                    console.log('Successfully loaded image:', this.src);
                });
            });
        });
    </script>
    
    <!-- Image Modal -->
    <div id="imageModal" class="image-modal">
        <div class="image-modal-content">
            <div class="modal-header" id="modalHeader">Denture Photo</div>
            <span class="modal-close" onclick="closeImageModal()">&times;</span>
            <img id="modalImage" class="modal-image" src="" alt="Denture Photo">
            <div class="modal-actions">
                <button type="button" class="modal-btn" onclick="downloadImage()">
                    <i class="fas fa-download"></i> Download
                </button>
                <button type="button" class="modal-btn" onclick="closeImageModal()">
                    <i class="fas fa-times"></i> Close
                </button>
            </div>
        </div>
    </div>
</body>
</html> 