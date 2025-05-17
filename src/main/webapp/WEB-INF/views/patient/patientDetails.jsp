<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
    <title>Patient Details - PeriDesk</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-ui-timepicker-addon/1.6.3/jquery-ui-timepicker-addon.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-ui-timepicker-addon/1.6.3/jquery-ui-timepicker-addon.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <!-- Add flatpickr CSS and JS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/default.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/plugins/confirmDate/confirmDate.js"></script>

    <style>
        /* Enhanced Base Styles */
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background: #f8fafc;
            color: #1e293b;
            line-height: 1.6;
        }
        
        .welcome-container {
            display: flex;
            min-height: 100vh;
            flex-direction: row;
            background: #f8fafc;
        }
        
        .sidebar-menu {
            width: 280px;
            background: white;
            padding: 30px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
            display: flex;
            flex-direction: column;
            position: relative;
            z-index: 10;
            transition: all 0.3s ease;
        }
        
        .logo {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 35px;
        }
        
        .logo img {
            width: 40px;
            height: 40px;
            filter: drop-shadow(0 4px 6px rgba(0, 0, 0, 0.1));
        }
        
        .logo h1 {
            font-size: 1.5rem;
            color: #2c3e50;
            margin: 0;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        
        .action-card {
            background: white;
            padding: 16px 20px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.03);
            transition: all 0.3s;
            text-decoration: none;
            border: 1px solid #f0f0f0;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .action-card i {
            font-size: 1.2rem;
            color: #3498db;
            width: 30px;
        }
        
        .action-card:hover {
            transform: translateX(5px);
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border-color: transparent;
            box-shadow: 0 6px 15px rgba(52, 152, 219, 0.2);
        }
        
        .action-card:hover h3,
        .action-card:hover p,
        .action-card:hover i {
            color: white;
        }
        
        .action-card h3 {
            margin: 0;
            color: #2c3e50;
            font-size: 1rem;
            font-weight: 600;
        }
        
        .action-card p {
            margin: 4px 0 0 0;
            color: #7f8c8d;
            font-size: 0.8rem;
        }
        
        .card-text {
            flex: 1;
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
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }
        
        .btn-secondary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.2);
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
        
        /* Additional styles for patient details page */
        .patient-details-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            padding: 25px;
            margin-bottom: 20px;
        }
        
        .patient-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .patient-header h2 {
            margin: 0;
            color: #2c3e50;
            font-size: 1.5rem;
        }
        
        .patient-actions {
            display: flex;
            gap: 10px;
        }
        
        .patient-info {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .info-section {
            margin-bottom: 20px;
        }
        
        .info-section h3 {
            color: #3498db;
            font-size: 1.1rem;
            margin-bottom: 15px;
            font-weight: 600;
            border-bottom: 1px solid #f0f0f0;
            padding-bottom: 8px;
        }
        
        .info-item {
            margin-bottom: 12px;
        }
        
        .info-label {
            color: #7f8c8d;
            font-size: 0.9rem;
            display: block;
            margin-bottom: 4px;
        }
        
        .info-value {
            color: #2c3e50;
            font-weight: 500;
            font-size: 1rem;
        }
        
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
            
            .patient-info {
                grid-template-columns: 1fr;
            }
            
            .patient-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .patient-actions {
                width: 100%;
                justify-content: flex-start;
            }
        }
        
        /* Styles for Examination History section */
        .examination-history-section {
            margin-top: 30px;
        }
        
        .sort-controls {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        .filter-group, .sort-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .custom-select {
            padding: 8px 12px;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.9rem;
        }
        
        .table-info {
            text-align: right;
            margin-bottom: 10px;
            color: #666;
            font-size: 0.9rem;
        }
        
        .table-responsive {
            overflow-x: auto;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }
        
        .table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }
        
        .table th {
            background: #f8f9fa;
            color: #2c3e50;
            font-weight: 600;
            padding: 15px;
            text-align: left;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .table td {
            padding: 12px 15px;
            border-bottom: 1px solid #e0e0e0;
            color: #4b5563;
        }
        
        .examination-row:hover {
            background-color: #f0f7ff;
            cursor: pointer;
        }
        
        .doctor-dropdown {
            width: 100%;
            padding: 6px 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        .doctor-assigned {
            border-color: #3498db;
            background-color: #f0f7ff;
        }
        
        .btn-sm {
            padding: 5px 10px;
            border-radius: 4px;
            background: #3498db;
            color: white;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        
        .no-records-message {
            padding: 20px;
            text-align: center;
            color: #666;
            background: #f8f9fa;
            border-radius: 8px;
            margin-top: 15px;
        }
        
        .no-data {
            color: #999;
            font-style: italic;
        }
        
        /* Dental Chart section styles */
        .dental-chart-section {
            margin-top: 30px;
        }
        
        /* Clinic Code Styling */
        .clinic-code {
            font-weight: 600;
            color: #3498db;
            background-color: #f0f7ff;
            padding: 2px 6px;
            border-radius: 4px;
            display: inline-block;
        }
        
        .chart-instructions {
            text-align: center;
            margin-bottom: 10px;
            color: #7f8c8d;
            font-size: 0.9rem;
        }
        
        .dental-chart {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 30px;
            background: white;
            border-radius: 12px;
            min-height: 250px;
        }
        
        .teeth-row {
            display: flex;
            flex-direction: row;
            justify-content: center;
            gap: 12px;
            margin: 15px 0;
            width: 100%;
        }
        
        .quadrant {
            display: flex;
            flex-direction: row;
            gap: 12px;
        }
        
        .tooth {
            position: relative;
            display: flex;
            flex-direction: column;
            align-items: center;
            cursor: pointer;
            transition: transform 0.2s;
            margin: 0 5px;
            height: 90px; /* Add fixed height for consistent layout */
        }
        
        .tooth:hover {
            transform: translateY(-3px);
        }
        
        .tooth-graphic {
            width: 40px;
            height: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            position: relative;
            margin-bottom: 20px; /* Add space below the tooth image */
        }
        
        .tooth-number-bottom {
            margin-top: 5px;
            font-size: 0.85rem;
            color: #2c3e50;
            font-weight: 600;
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 8px;
            padding: 1px 4px;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
        }
        
        .jaw-separator {
            width: 80%;
            height: 1px;
            background-color: #e0e0e0;
            margin: 30px 0;
        }
        
        .chart-legend {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .legend-icon {
            width: 20px;
            height: 20px;
            border-radius: 4px;
            border: 1px solid #ddd;
        }
        
        .healthy {
            background-color: #e8f4fc;
            border-color: #c5e1f9;
        }
        
        .caries {
            background-color: #ffebee;
            border-color: #ffcdd2;
        }
        
        .restored {
            background-color: #fff8e1;
            border-color: #ffecb3;
        }
        
        .missing {
            background-color: #f5f5f5;
            border-color: #e0e0e0;
            position: relative;
        }
        
        .missing::before {
            content: "✕";
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: #9e9e9e;
            font-size: 12px;
        }
        
        /* Add condition styles to tooth elements */
        .tooth.condition-healthy svg path {
            fill: #e8f4fc;
            stroke: #3498db;
        }
        
        .tooth.condition-caries svg path {
            fill: #ffebee;
            stroke: #e74c3c;
        }
        
        .tooth.condition-restored svg path {
            fill: #fff8e1;
            stroke: #f39c12;
        }
        
        .tooth.condition-missing svg path {
            fill: #f5f5f5;
            stroke: #9e9e9e;
        }
        
        .tooth.condition-missing .tooth-graphic::before {
            content: "✕";
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: #9e9e9e;
            font-size: 18px;
            z-index: 1;
        }
        
        /* Tooth number inside SVG */
        .tooth-number-overlay {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 12px;
            font-weight: 500;
            color: #2c3e50;
            z-index: 2;
            background-color: rgba(255, 255, 255, 0.85);
            border-radius: 8px;
            padding: 2px 4px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        /* Alternative layout - place number below image */
        .tooth-with-number {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        
        .tooth-number-bottom {
            position: absolute;
            bottom: -5px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 0.85rem;
            color: #2c3e50;
            font-weight: 600;
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 8px;
            padding: 1px 4px;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
            z-index: 3;
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
        
        /* Modal Select Dropdown Styles */
        .modal select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%232c3e50' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            padding-right: 40px;
            cursor: pointer;
            transition: all 0.3s ease;
            height: 45px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            color: #2c3e50;
            background-color: white;
            width: 100%;
        }

        .modal select.form-control:hover {
            border-color: #3498db;
            background-color: #f8f9fa;
        }

        .modal select.form-control:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            background-color: #fff;
            outline: none;
        }

        .modal select.form-control option {
            padding: 12px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            color: #2c3e50;
            background-color: white;
        }

        .modal select.form-control option:hover {
            background-color: #f8f9fa;
        }

        .modal select.form-control option:checked {
            background-color: #3498db;
            color: white;
        }

        /* Doctor Dropdown Specific Styles */
        .modal .doctor-dropdown {
            height: 45px;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 0 15px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            color: #2c3e50;
            background-color: white;
            width: 100%;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .modal .doctor-dropdown:hover {
            border-color: #3498db;
            background-color: #f8f9fa;
        }

        .modal .doctor-dropdown:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            background-color: #fff;
            outline: none;
        }

        .modal .doctor-dropdown.doctor-assigned {
            border-color: #3498db;
            background-color: #f0f7ff;
        }
        
        .modal textarea.form-control {
            min-height: 120px;
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
            padding: 8px 16px;
            font-size: 0.85rem;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .modal .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border: none;
        }
        
        .modal .btn-primary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(52, 152, 219, 0.2);
        }
        
        .modal .btn-secondary {
            background: #95a5a6;
            color: white;
            border: none;
        }
        
        .modal .btn-secondary:hover {
            background: #7f8c8d;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(127, 140, 141, 0.2);
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
                padding: 10px 20px;
            }
        }

        /* Examination Modal Dropdown Styles */
        #examinationDetailsModal select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%232c3e50' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            padding: 0 15px;
            height: 45px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            color: #2c3e50;
            background-color: white;
            width: 100%;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        #examinationDetailsModal select.form-control:hover {
            border-color: #3498db;
            background-color: #f8f9fa;
        }

        #examinationDetailsModal select.form-control:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            background-color: #fff;
            outline: none;
        }

        #examinationDetailsModal select.form-control option {
            padding: 12px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            color: #2c3e50;
            background-color: white;
        }

        #examinationDetailsModal select.form-control option:hover {
            background-color: #f8f9fa;
        }

        #examinationDetailsModal select.form-control option:checked {
            background-color: #3498db;
            color: white;
        }

        /* Doctor Dropdown in Examination Modal */
        #examinationDetailsModal .doctor-dropdown {
            height: 45px;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 0 15px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            color: #2c3e50;
            background-color: white;
            width: 100%;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        #examinationDetailsModal .doctor-dropdown:hover {
            border-color: #3498db;
            background-color: #f8f9fa;
        }

        #examinationDetailsModal .doctor-dropdown:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            background-color: #fff;
            outline: none;
        }

        #examinationDetailsModal .doctor-dropdown.doctor-assigned {
            border-color: #3498db;
            background-color: #f0f7ff;
        }

        /* Modal Dropdown Styles */
        #toothModal select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%232c3e50' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            padding: 0 15px;
            height: 45px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            color: #2c3e50;
            background-color: white;
            width: 100%;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        #toothModal select:hover {
            border-color: #3498db;
            background-color: #f8f9fa;
        }

        #toothModal select:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            background-color: #fff;
            outline: none;
        }

        #toothModal select option {
            padding: 12px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            color: #2c3e50;
            background-color: white;
        }

        #toothModal select option:hover {
            background-color: #f8f9fa;
        }

        #toothModal select option:checked {
            background-color: #3498db;
            color: white;
        }

        /* Doctor Dropdown in Modal */
        #toothModal .doctor-dropdown {
            height: 45px;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 0 15px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            color: #2c3e50;
            background-color: white;
            width: 100%;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        #toothModal .doctor-dropdown:hover {
            border-color: #3498db;
            background-color: #f8f9fa;
        }

        #toothModal .doctor-dropdown:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            background-color: #fff;
            outline: none;
        }

        #toothModal .doctor-dropdown.doctor-assigned {
            border-color: #3498db;
            background-color: #f0f7ff;
        }

        .patient-info-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .patient-header {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
        }
        
        .patient-profile-picture {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            overflow: hidden;
            border: 3px solid #3498db;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            background-color: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .patient-profile-picture img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .patient-profile-picture i {
            font-size: 3rem;
            color: #bbb;
        }
        
        .patient-details {
            flex: 1;
        }
        
        .patient-name {
            font-size: 1.8rem;
            color: #2c3e50;
            margin: 0 0 5px 0;
            font-weight: 600;
        }
        
        .patient-id {
            font-size: 0.9rem;
            color: #7f8c8d;
            margin: 0;
        }
        
        .patient-meta {
            margin-top: 10px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 0.9rem;
            color: #7f8c8d;
        }
        
        .meta-item i {
            color: #3498db;
            font-size: 0.9rem;
        }
        
        .meta-item strong {
            color: #2c3e50;
        }
    </style>
</head>
<body>
<div class="welcome-container">
    <div class="sidebar-menu">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/images/tooth-repair.svg" alt="PeriDesk Logo">
            <h1>PeriDesk</h1>
        </div>
        <a href="${pageContext.request.contextPath}/patients/list" class="action-card">
            <i class="fas fa-users"></i>
            <div class="card-text">
                <h3>Patients</h3>
                <p>View all patients</p>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/patients/appointments" class="action-card">
            <i class="fas fa-calendar-alt"></i>
            <div class="card-text">
                <h3>Appointments</h3>
                <p>Today's schedule</p>
            </div>
        </a>
        <div class="footer">
            <p class="copyright">© 2024 PeriDesk. All rights reserved.</p>
            <p>Powered by <span class="powered-by">Navtech</span><span class="navtech">Labs</span></p>
        </div>
    </div>
    <div class="main-content">
        <div class="welcome-header">
            <h1 class="welcome-message">Patient Details</h1>
            <div>
                <a href="${pageContext.request.contextPath}/patient/edit/${patient.id}" class="btn btn-secondary">
                    <i class="fas fa-edit"></i> Edit Patient
                </a>
                <a href="${pageContext.request.contextPath}/patients/list" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i> Back to Patients
                </a>
            </div>
        </div>
        
        <div class="patient-details-container">
            <div class="patient-header">
                <!-- Add profile picture container -->
                <div class="patient-profile-picture">
                    <c:choose>
                        <c:when test="${not empty patient.profilePicturePath}">
                            <img src="${pageContext.request.contextPath}/uploads/${patient.profilePicturePath}" 
                                 alt="Patient Profile" 
                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default-profile.png'; this.parentElement.classList.add('profile-error');">
                            <!-- Debug: ${patient.profilePicturePath} -->
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-user-circle"></i>
                        </c:otherwise>
                    </c:choose>
        </div>
                <!-- Patient name and other details -->
                <div class="patient-details">
                    <h2 class="patient-name">${patient.firstName} ${patient.lastName}</h2>
                    <p class="patient-id">Patient ID: ${patient.id}</p>
                    <div class="patient-meta">
                        <span class="meta-item"><i class="fas fa-calendar-alt"></i> Age: <strong>${patient.age}</strong></span>
                        <span class="meta-item"><i class="fas fa-venus-mars"></i> Gender: <strong>${patient.gender}</strong></span>
                        <span class="meta-item"><i class="fas fa-phone"></i> Phone: <strong>${patient.phoneNumber}</strong></span>
                    </div>
                </div>
                <div class="patient-actions">
                    <a href="${pageContext.request.contextPath}/patient/edit/${patient.id}" class="btn btn-secondary">
                        <i class="fas fa-edit"></i> Edit
                    </a>
                </div>
            </div>
            
            <div class="patient-info">
                <div class="info-section">
                    <h3>Personal Information</h3>
                    <div class="info-item">
                        <span class="info-label">Full Name</span>
                        <span class="info-value">${patient.firstName} ${patient.lastName}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Gender</span>
                        <span class="info-value">${patient.gender}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Age</span>
                        <span class="info-value">${patient.age}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Mobile Number</span>
                        <span class="info-value">${patient.phoneNumber}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Email</span>
                        <span class="info-value">${patient.email}</span>
                    </div>
                </div>
                
                <div class="info-section">
                    <h3>Location Details</h3>
                    <div class="info-item">
                        <span class="info-label">Address</span>
                        <span class="info-value">${patient.streetAddress}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">State</span>
                        <span class="info-value">${patient.state}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">City</span>
                        <span class="info-value">${patient.city}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Pincode</span>
                        <span class="info-value">${patient.pincode}</span>
                    </div>
                </div>
                
                <div class="info-section">
                    <h3>Medical Information</h3>
                    <div class="info-item">
                        <span class="info-label">Medical History</span>
                        <span class="info-value">${not empty patient.medicalHistory ? patient.medicalHistory : 'None reported'}</span>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Dental Chart Section -->
        <div class="patient-details-container dental-chart-section">
            <div class="patient-header">
            <h2>Dental Chart</h2>
                <p class="chart-instructions">Click on a tooth to add or edit examination record</p>
            </div>
            
            <div class="dental-chart">
                <!-- Upper Teeth (Maxillary) -->
            <div class="teeth-row upper-teeth">
                    <!-- Upper Right (Q1) -->
                    <div class="quadrant upper-right">
                        <div class="tooth" onclick="openToothDetails(18)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-molar.svg" alt="Tooth 18">
                                <span class="tooth-number-bottom">18</span>
                            </div>
                            <div class="tooth-number">UR8</div>
                    </div>
                    <div class="tooth" onclick="openToothDetails(17)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-molar.svg" alt="Tooth 17">
                                <span class="tooth-number-bottom">17</span>
                            </div>
                            <div class="tooth-number">UR7</div>
                    </div>
                    <div class="tooth" onclick="openToothDetails(16)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-molar.svg" alt="Tooth 16">
                                <span class="tooth-number-bottom">16</span>
                    </div>
                            <div class="tooth-number">UR6</div>
                        </div>
                    <div class="tooth" onclick="openToothDetails(15)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-premolar.svg" alt="Tooth 15">
                                <span class="tooth-number-bottom">15</span>
                            </div>
                            <div class="tooth-number">UR5</div>
                    </div>
                    <div class="tooth" onclick="openToothDetails(14)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-premolar.svg" alt="Tooth 14">
                                <span class="tooth-number-bottom">14</span>
                            </div>
                            <div class="tooth-number">UR4</div>
                        </div>
                    <div class="tooth" onclick="openToothDetails(13)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-canine.svg" alt="Tooth 13">
                                <span class="tooth-number-bottom">13</span>
                            </div>
                            <div class="tooth-number">UR3</div>
                        </div>
                    <div class="tooth" onclick="openToothDetails(12)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-incisor.svg" alt="Tooth 12">
                                <span class="tooth-number-bottom">12</span>
                            </div>
                            <div class="tooth-number">UR2</div>
                    </div>
                    <div class="tooth" onclick="openToothDetails(11)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-incisor.svg" alt="Tooth 11">
                                <span class="tooth-number-bottom">11</span>
                            </div>
                            <div class="tooth-number">UR1</div>
                    </div>
                </div>

                    <!-- Upper Left (Q2) -->
                    <div class="quadrant upper-left">
                    <div class="tooth" onclick="openToothDetails(21)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-incisor.svg" alt="Tooth 21">
                                <span class="tooth-number-bottom">21</span>
                            </div>
                            <div class="tooth-number">UL1</div>
                    </div>
                    <div class="tooth" onclick="openToothDetails(22)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-incisor.svg" alt="Tooth 22">
                                <span class="tooth-number-bottom">22</span>
                    </div>
                            <div class="tooth-number">UL2</div>
                        </div>
                    <div class="tooth" onclick="openToothDetails(23)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-canine.svg" alt="Tooth 23">
                                <span class="tooth-number-bottom">23</span>
                    </div>
                            <div class="tooth-number">UL3</div>
                        </div>
                    <div class="tooth" onclick="openToothDetails(24)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-premolar.svg" alt="Tooth 24">
                                <span class="tooth-number-bottom">24</span>
                            </div>
                            <div class="tooth-number">UL4</div>
                    </div>
                    <div class="tooth" onclick="openToothDetails(25)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-premolar.svg" alt="Tooth 25">
                                <span class="tooth-number-bottom">25</span>
                            </div>
                            <div class="tooth-number">UL5</div>
                        </div>
                    <div class="tooth" onclick="openToothDetails(26)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-molar.svg" alt="Tooth 26">
                                <span class="tooth-number-bottom">26</span>
                            </div>
                            <div class="tooth-number">UL6</div>
                    </div>
                    <div class="tooth" onclick="openToothDetails(27)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-molar.svg" alt="Tooth 27">
                                <span class="tooth-number-bottom">27</span>
                            </div>
                            <div class="tooth-number">UL7</div>
                    </div>
                    <div class="tooth" onclick="openToothDetails(28)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-molar.svg" alt="Tooth 28">
                                <span class="tooth-number-bottom">28</span>
                            </div>
                            <div class="tooth-number">UL8</div>
                    </div>
                </div>
            </div>

                <div class="jaw-separator"></div>
                
                <!-- Lower Teeth (Mandibular) -->
            <div class="teeth-row lower-teeth">
                    <!-- Lower Right (Q4) -->
                    <div class="quadrant lower-right">
                    <div class="tooth" onclick="openToothDetails(48)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-molar.svg" alt="Tooth 48">
                                <span class="tooth-number-bottom">48</span>
                            </div>
                            <div class="tooth-number">LR8</div>
                    </div>
                    <div class="tooth" onclick="openToothDetails(47)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-molar.svg" alt="Tooth 47">
                                <span class="tooth-number-bottom">47</span>
                            </div>
                            <div class="tooth-number">LR7</div>
                    </div>
                    <div class="tooth" onclick="openToothDetails(46)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-molar.svg" alt="Tooth 46">
                                <span class="tooth-number-bottom">46</span>
                    </div>
                            <div class="tooth-number">LR6</div>
                        </div>
                    <div class="tooth" onclick="openToothDetails(45)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-premolar.svg" alt="Tooth 45">
                                <span class="tooth-number-bottom">45</span>
                            </div>
                            <div class="tooth-number">LR5</div>
                    </div>
                    <div class="tooth" onclick="openToothDetails(44)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-premolar.svg" alt="Tooth 44">
                                <span class="tooth-number-bottom">44</span>
                    </div>
                            <div class="tooth-number">LR4</div>
                        </div>
                    <div class="tooth" onclick="openToothDetails(43)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-canine.svg" alt="Tooth 43">
                                <span class="tooth-number-bottom">43</span>
                    </div>
                            <div class="tooth-number">LR3</div>
                        </div>
                    <div class="tooth" onclick="openToothDetails(42)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-incisor.svg" alt="Tooth 42">
                                <span class="tooth-number-bottom">42</span>
                            </div>
                            <div class="tooth-number">LR2</div>
                    </div>
                    <div class="tooth" onclick="openToothDetails(41)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-incisor.svg" alt="Tooth 41">
                                <span class="tooth-number-bottom">41</span>
                            </div>
                            <div class="tooth-number">LR1</div>
                    </div>
                </div>

                    <!-- Lower Left (Q3) -->
                    <div class="quadrant lower-left">
                    <div class="tooth" onclick="openToothDetails(31)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-incisor.svg" alt="Tooth 31">
                                <span class="tooth-number-bottom">31</span>
                            </div>
                            <div class="tooth-number">LL1</div>
                    </div>
                    <div class="tooth" onclick="openToothDetails(32)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-incisor.svg" alt="Tooth 32">
                                <span class="tooth-number-bottom">32</span>
                    </div>
                            <div class="tooth-number">LL2</div>
                        </div>
                    <div class="tooth" onclick="openToothDetails(33)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-canine.svg" alt="Tooth 33">
                                <span class="tooth-number-bottom">33</span>
                    </div>
                            <div class="tooth-number">LL3</div>
                        </div>
                    <div class="tooth" onclick="openToothDetails(34)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-premolar.svg" alt="Tooth 34">
                                <span class="tooth-number-overlay">34</span>
                            </div>
                            <div class="tooth-number">LL4</div>
                    </div>
                    <div class="tooth" onclick="openToothDetails(35)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-premolar.svg" alt="Tooth 35">
                                <span class="tooth-number-overlay">35</span>
                    </div>
                            <div class="tooth-number">LL5</div>
                        </div>
                    <div class="tooth" onclick="openToothDetails(36)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-molar.svg" alt="Tooth 36">
                                <span class="tooth-number-overlay">36</span>
                            </div>
                            <div class="tooth-number">LL6</div>
                    </div>
                    <div class="tooth" onclick="openToothDetails(37)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-molar.svg" alt="Tooth 37">
                                <span class="tooth-number-overlay">37</span>
                            </div>
                            <div class="tooth-number">LL7</div>
                    </div>
                    <div class="tooth" onclick="openToothDetails(38)">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-molar.svg" alt="Tooth 38">
                                <span class="tooth-number-overlay">38</span>
                            </div>
                            <div class="tooth-number">LL8</div>
                </div>
            </div>
        </div>

                <div class="chart-legend">
                    <div class="legend-item">
                        <div class="legend-icon healthy"></div>
                        <span>Healthy</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-icon caries"></div>
                        <span>Caries</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-icon restored"></div>
                        <span>Restored</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-icon missing"></div>
                        <span>Missing</span>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Examination History Section -->
        <div class="patient-details-container examination-history-section">
            <div class="patient-header">
            <h2>Examination History</h2>
            </div>

                    <div class="sort-controls">
                <div class="filter-group">
                    <label for="doctorDropdown">Filter by Doctor:</label>
                    <select id="doctorDropdown" class="custom-select" onchange="filterByDoctor(this.value)">
                            <option value="all">All Examinations</option>
                            <option value="unassigned">Unassigned Examinations</option>
                        <c:forEach items="${doctorDetails}" var="doctor">
                                <option value="${doctor.id}">${doctor.doctorName}</option>
                            </c:forEach>
                        </select>
                    </div>
                
                <div class="filter-group">
                    <label for="clinicDropdown">Filter by Clinic:</label>
                    <select id="clinicDropdown" class="custom-select" onchange="filterByClinic(this.value)">
                        <option value="all">All Clinics</option>
                        <c:set var="clinicsSeen" value="" />
                        <c:forEach items="${examinationHistory}" var="exam">
                            <c:if test="${not empty exam.examinationClinic}">
                                <c:set var="clinicUsername" value="${exam.examinationClinic.username}" />
                                <c:if test="${!fn:contains(clinicsSeen, clinicUsername)}">
                                    <c:set var="clinicsSeen" value="${clinicsSeen}${clinicUsername}," />
                                    <option value="${clinicUsername}">${clinicUsername}</option>
                                </c:if>
                            </c:if>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="sort-group">
                    <label for="sortDropdown">Sort by:</label>
                    <select id="sortDropdown" class="custom-select" onchange="sortTable(this.value)">
                        <option value="dateDesc">Date (Newest First)</option>
                        <option value="dateAsc">Date (Oldest First)</option>
                        <option value="toothNumberAsc">Tooth Number (Ascending)</option>
                        <option value="toothNumberDesc">Tooth Number (Descending)</option>
                    </select>
                </div>
            </div>
            
            <div class="table-info">
                <small>
                    <c:choose>
                        <c:when test="${empty examinationHistory}">
                            No examinations found
                        </c:when>
                        <c:otherwise>
                            Showing ${fn:length(examinationHistory)} of ${fn:length(examinationHistory)} records
                        </c:otherwise>
                    </c:choose>
                </small>
                    </div>

                    <div class="table-responsive">
                <table id="examinationHistoryTable" class="table">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Tooth</th>
                                <th>Examination Date</th>
                                <th>Condition</th>
                                <th>Treatment Start Date</th>
                                <th>Notes</th>
                                <th>Clinic</th>
                                <th>Assigned Doctor</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                        <c:forEach items="${examinationHistory}" var="exam" varStatus="status">
                            <tr class="examination-row" onclick="openExaminationDetails('${exam.id}')">
                                    <td class="index-col">${status.index + 1}</td>
                                <td data-tooth="${exam.toothNumber}">${exam.toothNumber.toString().replace('TOOTH_', '')}</td>
                                    <td data-date="${exam.examinationDate}">
                                    <c:set var="dateStr" value="${exam.examinationDate}" />
                                            <c:set var="datePart" value="${fn:substringBefore(dateStr, 'T')}" />
                                            <c:set var="timePart" value="${fn:substringBefore(fn:substringAfter(dateStr, 'T'), '.')}" />
                                            
                                            <c:set var="year" value="${fn:substring(datePart, 0, 4)}" />
                                            <c:set var="month" value="${fn:substring(datePart, 5, 7)}" />
                                            <c:set var="day" value="${fn:substring(datePart, 8, 10)}" />
                                            
                                    ${day}/${month}/${year} ${timePart}
                                    </td>
                                <td>${exam.toothCondition}</td>
                                <td>
                                    <c:set var="rawDate" value="${exam.treatmentStartingDate}"/>
                                    <input type="text" 
                                           class="treatment-date-picker" 
                                           data-exam-id="${exam.id}"
                                           data-raw-date="${rawDate}"
                                           value="<c:if test="${not empty rawDate}"><fmt:parseDate value="${rawDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate"/><fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm"/></c:if>"
                                           placeholder="Select date"
                                           onchange="updateTreatmentDate(this.value, '${exam.id}')"
                                           onclick="event.stopPropagation();">
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty exam.examinationNotes}">
                                            <c:choose>
                                                <c:when test="${fn:length(exam.examinationNotes) > 50}">
                                                    ${fn:substring(exam.examinationNotes, 0, 50)}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${exam.examinationNotes}
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-data">No notes</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty exam.examinationClinic}">
                                            <span class="clinic-code">${exam.examinationClinic.username}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-data">--</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td data-doctor="${exam.assignedDoctor != null ? exam.assignedDoctor.id : ''}">
                                    <select onchange='assignDoctor(this.value, <c:out value="${exam.id}"/>)' class="doctor-dropdown ${exam.assignedDoctor != null ? 'doctor-assigned' : ''}" data-exam-id="${exam.id}" onclick="event.stopPropagation();">
                                        <option value="">Assign Doctor</option>
                                        <option value="remove" ${exam.assignedDoctor == null ? 'disabled' : ''}>
                                            -- Remove Assignment --
                                        </option>
                                        <c:forEach items="${doctorDetails}" var="doctor">
                                            <option value="${doctor.id}" ${exam.assignedDoctor != null && exam.assignedDoctor.id == doctor.id ? 'selected' : ''}>
                                                ${doctor.doctorName}
                                            </option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/patients/examination/${exam.id}" 
                                       class="btn btn-sm" 
                                       title="View Details"
                                       onclick="event.stopPropagation();">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
            
            <c:if test="${empty examinationHistory}">
                <div class="no-records-message">
                    <i class="fas fa-info-circle"></i> No examination records found for this patient.
                    </div>
            </c:if>
                    </div>
    </div>
    <div id="toothModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2>Clinical Examination for Tooth <span id="selectedToothNumber"></span></h2>

            <form id="toothExaminationForm" method="POST">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <input type="hidden" name="patientId" value="${patient.id}"/>
                <input type="hidden" name="toothNumber" id="toothNumberInput"/>

                <div class="form-sections-container">
                    <!-- Basic Information Section -->
                    <div class="form-section">
                        <h3>Basic Information</h3>
                        <div class="form-group">
                            <label for="toothSurface">Surface</label>
                            <select name="toothSurface" id="toothSurface">
                                <option value="">Select</option>
                                <c:forEach items="${toothSurfaces}" var="surface">
                                    <option value="${surface}">${surface}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="toothCondition">Condition</label>
                            <select name="toothCondition" id="toothCondition">
                                <option value="">Select</option>
                                <c:forEach items="${toothConditions}" var="condition">
                                    <option value="${condition}">${condition}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="existingRestoration">Restoration</label>
                            <select name="existingRestoration" id="existingRestoration">
                                <option value="">Select</option>
                                <c:forEach items="${existingRestorations}" var="restoration">
                                    <option value="${restoration}">${restoration}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Periodontal Assessment Section -->
                    <div class="form-section">
                        <h3>Periodontal Assessment</h3>
                        <div class="form-group">
                            <label for="pocketDepth">Pocket Depth</label>
                            <select name="pocketDepth" id="pocketDepth">
                                <option value="">Select</option>
                                <c:forEach items="${pocketDepths}" var="depth">
                                    <option value="${depth}">${depth}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="bleedingOnProbing">Bleeding on Probing</label>
                            <select name="bleedingOnProbing" id="bleedingOnProbing">
                                <option value="">Select</option>
                                <c:forEach items="${bleedingOnProbings}" var="bleeding">
                                    <option value="${bleeding}">${bleeding}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="plaqueScore">Plaque Score</label>
                            <select name="plaqueScore" id="plaqueScore">
                                <option value="">Select</option>
                                <c:forEach items="${plaqueScores}" var="score">
                                    <option value="${score}">${score}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="gingivalRecession">Gingival Recession</label>
                            <select name="gingivalRecession" id="gingivalRecession">
                                <option value="">Select</option>
                                <c:forEach items="${gingivalRecessions}" var="recession">
                                    <option value="${recession}">${recession}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Clinical Assessment Section -->
                    <div class="form-section">
                        <h3>Clinical Assessment</h3>
                        <div class="form-group">
                            <label for="toothMobility">Mobility</label>
                            <select name="toothMobility" id="toothMobility">
                                <option value="">Select</option>
                                <c:forEach items="${toothMobilities}" var="mobility">
                                    <option value="${mobility}">${mobility}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="toothVitality">Vitality</label>
                            <select name="toothVitality" id="toothVitality">
                                <option value="">Select</option>
                                <c:forEach items="${toothVitalities}" var="vitality">
                                    <option value="${vitality}">${vitality}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="toothSensitivity">Sensitivity</label>
                            <select name="toothSensitivity" id="toothSensitivity">
                                <option value="">Select</option>
                                <c:forEach items="${toothSensitivities}" var="sensitivity">
                                    <option value="${sensitivity}">${sensitivity}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="furcationInvolvement">Furcation</label>
                            <select name="furcationInvolvement" id="furcationInvolvement">
                                <option value="">Select</option>
                                <c:forEach items="${furcationInvolvements}" var="furcation">
                                    <option value="${furcation}">${furcation}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Notes Section -->
                    <div class="form-section notes-section">
                        <h3>Clinical Notes</h3>
                        <div class="form-group">
                            <label for="examinationNotes"></label><textarea name="examinationNotes" id="examinationNotes" rows="3"
                                                                            placeholder="Enter any additional notes here..."></textarea>
                        </div>
                    </div>

                    <!-- Form Actions -->
                    <div class="form-actions">
                        <button type="button" class="btn-secondary" onclick="closeModal()">Cancel</button>
                        <button type="submit" class="btn-primary">Save Examination</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    
</div>
<script>

    // --- DOM Ready Event Listener (Optional but good practice) ---
    // Ensures the DOM is fully loaded before attaching event listeners
    document.addEventListener('DOMContentLoaded', function() {
        // Hide modal on page load
        const toothModal = document.getElementById('toothModal');
        if (toothModal) {
            toothModal.style.display = 'none';
        }

        // Update tooth conditions in the dental chart based on examination history
        updateDentalChart();

        // Modal variable - use the same variable for all modal operations
        const modal = document.getElementById('toothModal');
        const form = document.getElementById('toothExaminationForm');
        const selectedToothSpan = document.getElementById('selectedToothNumber');
        const toothNumberInput = document.getElementById('toothNumberInput'); // Hidden input for tooth number
        const patientIdInput = form.querySelector('input[name="patientId"]'); // Hidden input for patient ID
        const csrfToken = document.querySelector("meta[name='_csrf']").content;

        if (!modal || !form || !selectedToothSpan || !toothNumberInput || !patientIdInput || !csrfToken) {
            console.error("CRITICAL ERROR: Could not find essential page elements (modal, form, inputs, CSRF token). Script cannot function.");
            alert("Page setup error. Please contact support.");
            return; // Stop script execution if essential elements are missing
        }

        // --- Global Helper Functions ---

        function showNotification(message, isError = false) {
            // Replace with a more sophisticated notification system if desired
            console.log(`Notification (${isError ? 'Error' : 'Success'}): ${message}`);
            alert(message);
        }

        // --- Update Dental Chart with Examination Data ---
        function updateDentalChart() {
            // Get all examinations from the table
            const examinationTable = document.getElementById('examinationHistoryTable');
            if (!examinationTable) return; // Table doesn't exist or no examinations
            
            // Map to store the latest examination condition for each tooth
            const toothConditions = new Map();
            
            // Process all examination rows
            const rows = Array.from(examinationTable.querySelectorAll('tbody tr'));
            rows.forEach(row => {
                const toothCell = row.querySelector('td[data-tooth]');
                const conditionCell = row.querySelector('td:nth-child(4)'); // Column with tooth condition
                
                if (toothCell && conditionCell) {
                    const toothNumber = toothCell.textContent.trim();
                    const condition = conditionCell.textContent.trim();
                    
                    // Only store if we don't already have this tooth, to keep the most recent (first in table)
                    if (!toothConditions.has(toothNumber)) {
                        toothConditions.set(toothNumber, condition);
                    }
                }
            });
            
            // Update tooth appearance in the chart
            toothConditions.forEach((condition, tooth) => {
                // Find the corresponding tooth in the chart
                const toothElement = document.querySelector(`.tooth[onclick="openToothDetails(${tooth})"]`);
                if (toothElement) {
                    // Remove all condition classes first
                    toothElement.classList.remove('condition-healthy', 'condition-caries', 'condition-restored', 'condition-missing');
                    
                    // Add appropriate class based on condition
                    if (condition === 'HEALTHY') {
                        toothElement.classList.add('condition-healthy');
                    } else if (condition === 'CARIES') {
                        toothElement.classList.add('condition-caries');
                    } else if (condition === 'RESTORED') {
                        toothElement.classList.add('condition-restored');
                    } else if (condition === 'MISSING') {
                        toothElement.classList.add('condition-missing');
                    }
                    
                    // Handle the SVG image itself for more direct visual control
                    const img = toothElement.querySelector('img');
                    if (img) {
                        // Apply visual style to the container based on condition
                        const container = img.closest('.tooth-graphic');
                        if (container) {
                            container.style.position = 'relative';
                            
                            if (condition === 'HEALTHY') {
                                img.style.filter = 'drop-shadow(0 0 2px #3498db)';
                            } else if (condition === 'CARIES') {
                                img.style.filter = 'drop-shadow(0 0 2px #e74c3c) brightness(1.1)';
                            } else if (condition === 'RESTORED') {
                                img.style.filter = 'drop-shadow(0 0 2px #f39c12) sepia(0.2)';
                            } else if (condition === 'MISSING') {
                                img.style.opacity = '0.5';
                                img.style.filter = 'grayscale(1)';
                            }
                        }
                    }
                }
            });
        }

        // --- Modal Handling ---

        window.openToothDetails = async function(toothNumber) { // Make it globally accessible from onclick
            console.log(`--- Opening modal for tooth: ${toothNumber} ---`);

            // 1. Validate Inputs
            const currentPatientId = patientIdInput.value;

            if (currentPatientId === null || currentPatientId === '') {
                console.error("Modal Open Error: Patient ID is missing from the hidden input.");
                showNotification("Cannot open details: Patient ID not found.", true);
                return;
            }
            if (toothNumber === null || toothNumber === '' || typeof toothNumber === 'undefined') {
                console.error("Modal Open Error: Invalid toothNumber provided:", toothNumber);
                showNotification("Cannot open details: Invalid tooth number.", true);
                return;
            }

            // 2. Update Modal UI & Hidden Input
            selectedToothSpan.textContent = toothNumber;
            toothNumberInput.value = toothNumber; // Set the hidden input for the form

            // 3. Reset form fields (preserving hidden inputs) before fetching new data
            resetFormFields();

            // 4. Fetch Existing Data
            const fetchUrl = `${pageContext.request.contextPath}/patients/tooth-examination/${currentPatientId}/${toothNumber}`;
            console.log(`Fetching existing data from: ${fetchUrl}`);

            try {
                const response = await fetch(fetchUrl);

                if (response.status === 404) {
                    console.log("No existing examination data found for this tooth (404).");
                    // Form is already reset, nothing more to do here.
                } else if (!response.ok) {
                    // Handle other HTTP errors (e.g., 500)
                    throw new Error(`HTTP error fetching data: ${response.status} ${response.statusText}`);
                } else {
                    // Success: Parse JSON and populate
                    const data = await response.json();
                    console.log("Existing data received:", data);
                    if (data) {
                        populateForm(data);
                    } else {
                        console.log("Received successful response but no data object.");
                    }
                }
            } catch (error) {
                console.error('Error loading examination data:', error);
                showNotification(`Error loading existing data: ${error.message}`, true);
                // Form should already be reset from step 3.
            }

            // 5. Display Modal
            modal.style.display = 'block';
        }

        window.closeModal = function() { // Make it globally accessible
            modal.style.display = 'none';
            // resetFormFields(); // Optionally reset fields again on close, or just rely on reset during open
            console.log("--- Modal closed ---");
        }

        // Attach closeModal to the close button
        const closeButton = modal.querySelector('.close');
        if (closeButton) {
            closeButton.addEventListener('click', closeModal);
        } else {
            console.warn("Could not find the modal close button.");
        }

        // --- Form Handling ---

        function resetFormFields() {
            console.log("Resetting form fields (excluding hidden inputs)...");
            const elementsToReset = form.querySelectorAll('select, textarea, input:not([type="hidden"])');

            elementsToReset.forEach(element => {
                const tagName = element.tagName.toLowerCase();
                if (tagName === 'select') {
                    element.selectedIndex = 0; // Reset select boxes to the first option ("Select")
                } else if (tagName === 'textarea') {
                    element.value = ''; // Clear textareas
                } else if (element.type !== 'button' && element.type !== 'submit' && element.type !== 'reset') {
                     element.value = ''; // Clear other input types (text, number, etc.)
                }
                // Add handling for checkboxes/radios if needed: element.checked = false;
            });
            // Note: We explicitly DO NOT reset the hidden patientId or toothNumber inputs here.
        }

        function populateForm(data) {
            console.log("Populating form with data:", data);
            // Helper function to safely set value
            const setValue = (id, value) => {
                const element = document.getElementById(id);
                if (element) {
                    element.value = value || ''; // Use empty string if value is null/undefined
                } else {
                    console.warn(`populateForm: Element with ID '${id}' not found.`);
                }
            };

            // Populate all form fields, ensuring IDs match your form elements
            setValue('toothSurface', data.toothSurface);
            setValue('toothCondition', data.toothCondition);
            setValue('existingRestoration', data.existingRestoration);
            setValue('pocketDepth', data.pocketDepth);
            setValue('bleedingOnProbing', data.bleedingOnProbing);
            setValue('plaqueScore', data.plaqueScore);
            setValue('gingivalRecession', data.gingivalRecession);
            setValue('toothMobility', data.toothMobility);
            setValue('toothVitality', data.toothVitality);
            setValue('toothSensitivity', data.toothSensitivity);
            setValue('furcationInvolvement', data.furcationInvolvement);
            // Ensure 'periapicalCondition' input exists if you need it
            // setValue('periapicalCondition', data.periapicalCondition);
            setValue('examinationNotes', data.examinationNotes);
        }

        // Form Submission Logic
        form.addEventListener('submit', async function(event) {
            event.preventDefault(); // Prevent default form submission
            console.log("--- Form submission initiated ---");

            // 1. Retrieve Essential IDs directly from hidden inputs
            const currentPatientId = patientIdInput.value;
            const currentToothNumber = toothNumberInput.value; // Value set by openToothDetails

            console.log(`Submitting for Patient ID: '${currentPatientId}', Tooth Number: '${currentToothNumber}'`);

            // 2. Validate Essential IDs
            if (!currentPatientId || !currentToothNumber) {
                 console.error("Form Submit Error: Patient ID or Tooth Number is missing from hidden inputs.");
                 showNotification("Cannot save: Missing critical patient or tooth identifier.", true);
                 return; // Stop submission
            }

            // 3. Build JSON Payload
            const jsonData = {
                patientId: currentPatientId,
                // Backend expects integer? Ensure conversion if needed. Assuming string is fine based on previous attempts.
                toothNumber: "TOOTH_"+currentToothNumber
                // Note: Backend might expect "TOOTH_18" - adjust if needed: toothNumber: `TOOTH_${currentToothNumber}`
            };

            // Gather data from other form fields
            const formElements = form.querySelectorAll('select, textarea, input:not([type="hidden"])');
            formElements.forEach(element => {
                const key = element.name;
                const value = element.value;
                // Include only non-empty fields, and exclude the CSRF token field if present by name
                if (key && key !== '_csrf' && value !== '') {
                    console.log(`  Adding field to JSON: '${key}': '${value}'`);
                    jsonData[key] = value;
                } else if (key && key !== '_csrf') {
                     console.log(`  Skipping empty field: '${key}'`);
                }
            });

            console.log('Final JSON payload being sent:', JSON.stringify(jsonData, null, 2));

            // 4. Send Data via Fetch
            const saveUrl = `${pageContext.request.contextPath}/patients/tooth-examination/save`;
            try {
                const response = await fetch(saveUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': csrfToken // Send CSRF token in header
                    },
                    body: JSON.stringify(jsonData)
                });

                if (!response.ok) {
                     // Attempt to get error details from response body if possible
                     let errorBody = await response.text(); // Read as text first
                     let errorMessage = `HTTP error ${response.status}: ${response.statusText}`;
                     try {
                         const errorJson = JSON.parse(errorBody); // Try parsing as JSON
                         errorMessage += ` - Server says: ${errorJson.message || errorBody}`;
                     } catch (e) {
                         errorMessage += ` - Server response: ${errorBody}`; // Use raw text if not JSON
                     }
                     throw new Error(errorMessage);
                }

                // Success
                const result = await response.json();
                console.log("Server response from save:", result);

                if (result.success) {
                    showNotification('Examination saved successfully');
                    closeModal();
                    // TODO: Optionally refresh part of the page (e.g., update the tooth's visual state)
                } else {
                    showNotification(`Error saving examination: ${result.message || 'Unknown server error'}`, true);
                }

            } catch (error) {
                console.error('Error submitting form:', error);
                showNotification(`Error saving examination: ${error.message}`, true);
            }
        });

    }); // End of DOMContentLoaded listener


    // Function to sort the examination history table based on dropdown selection
    function sortTable(sortOption) {
        const table = document.getElementById('examinationHistoryTable');
        const tbody = table.querySelector('tbody');
        const rows = Array.from(tbody.querySelectorAll('tr'));

        // Sort the rows based on the selected option
        rows.sort((a, b) => {
            let aValue, bValue;

            if (sortOption === 'toothNumberAsc' || sortOption === 'toothNumberDesc') {
                aValue = a.querySelector('td[data-tooth]').getAttribute('data-tooth');
                bValue = b.querySelector('td[data-tooth]').getAttribute('data-tooth');

                // Extract numeric portion from tooth number (e.g., "TOOTH_18" -> 18)
                const aNum = parseInt(aValue.replace(/\D/g, '')) || 0;
                const bNum = parseInt(bValue.replace(/\D/g, '')) || 0;

                return sortOption === 'toothNumberAsc' ? aNum - bNum : bNum - aNum;
            } else if (sortOption === 'dateAsc' || sortOption === 'dateDesc') {
                // Use data-date attribute which contains the original ISO date for reliable sorting
                aValue = a.querySelector('td[data-date]').getAttribute('data-date');
                bValue = b.querySelector('td[data-date]').getAttribute('data-date');

                // Convert dates for comparison
                const aDate = new Date(aValue);
                const bDate = new Date(bValue);

                return sortOption === 'dateDesc' ? bDate - aDate : aDate - bDate;
            }

            return 0;
        });

        // Remove all existing rows
        rows.forEach(row => tbody.removeChild(row));

        // Add the sorted rows back to the table and update index numbers
        rows.forEach((row, index) => {
            // Update the index column
            row.querySelector('td.index-col').textContent = index + 1;
            tbody.appendChild(row);
        });
    }

    // Set default sort option and sort the table when the page loads
    document.addEventListener('DOMContentLoaded', function() {
        // Set default sort to tooth number ascending
        document.getElementById('sortDropdown').value = 'toothNumberAsc';
        sortTable('toothNumberAsc');
        
        // Count and update unassigned examinations in the filter dropdown
        updateUnassignedCount();
    });

    // Function to count unassigned examinations and update the dropdown option
    function updateUnassignedCount() {
        const table = document.getElementById('examinationHistoryTable');
        if (!table) return; // Table might not exist if no examinations
        
        const rows = Array.from(table.querySelectorAll('tbody tr'));
        const unassignedCount = rows.filter(row => {
            const doctorCell = row.querySelector('td[data-doctor]');
            const doctorId = doctorCell ? doctorCell.getAttribute('data-doctor') : '';
            return doctorId === '';
        }).length;
        
        // Update the unassigned option text with count
        const unassignedOption = document.querySelector('#doctorDropdown option[value="unassigned"]');
        if (unassignedOption) {
            unassignedOption.textContent = `Unassigned Examinations (${unassignedCount})`;
        }
    }

    // Function to filter examination history by doctor
    function filterByDoctor(doctorId) {
        const table = document.getElementById('examinationHistoryTable');
        const tbody = table.querySelector('tbody');
        const rows = Array.from(tbody.querySelectorAll('tr'));

        rows.forEach(row => {
            if (doctorId === 'all') {
                row.style.display = ''; // Show all rows
            } else if (doctorId === 'unassigned') {
                // Show only unassigned examinations (empty data-doctor attribute)
                const doctorCell = row.querySelector('td[data-doctor]');
                const rowDoctorId = doctorCell ? doctorCell.getAttribute('data-doctor') : '';
                row.style.display = (rowDoctorId === '') ? '' : 'none';
            } else {
                // Show examinations for specific doctor
                const doctorCell = row.querySelector('td[data-doctor]');
                const rowDoctorId = doctorCell ? doctorCell.getAttribute('data-doctor') : '';
                row.style.display = (rowDoctorId === doctorId) ? '' : 'none';
            }
        });

        // Update the row indexes for visible rows
        updateIndexNumbers();

        // Update total count in table info
        updateRecordCount();
    }

    // Function to update index numbers for visible rows
    function updateIndexNumbers() {
        const tbody = document.getElementById('examinationHistoryTable').querySelector('tbody');
        const visibleRows = Array.from(tbody.querySelectorAll('tr')).filter(row => row.style.display !== 'none');

        visibleRows.forEach((row, index) => {
            row.querySelector('td.index-col').textContent = index + 1;
        });
    }

    // Function to update the record count in table info
    function updateRecordCount() {
        const tbody = document.getElementById('examinationHistoryTable').querySelector('tbody');
        const visibleRows = Array.from(tbody.querySelectorAll('tr')).filter(row => row.style.display !== 'none');

        document.querySelector('.table-info small').textContent = `Showing ${visibleRows.length} of ${tbody.querySelectorAll('tr').length} records`;
    }


    // Function to filter examination history by clinic
    function filterByClinic(clinicUsername) {
        const table = document.getElementById('examinationHistoryTable');
        const tbody = table.querySelector('tbody');
        const rows = Array.from(tbody.querySelectorAll('tr'));

        rows.forEach(row => {
            if (clinicUsername === 'all') {
                row.style.display = ''; // Show all rows
            } else {
                // Find the clinic cell (new 7th column we added - index 6)
                const clinicCell = row.querySelector('td:nth-child(7)');
                const clinicCode = clinicCell ? clinicCell.textContent.trim() : '';
                row.style.display = (clinicCode === clinicUsername) ? '' : 'none';
            }
        });

        // Update the row indexes for visible rows
        updateIndexNumbers();

        // Update total count in table info
        updateRecordCount();
    }

        // Add this function to your existing JavaScript to assign doctor
        function assignDoctor(doctorId, examinationId) {
        if (!doctorId) return; // Don't proceed if no doctor is selected
        
        const csrfToken = document.querySelector("meta[name='_csrf']").content;
        
        // Determine if we're removing a doctor
        const isRemove = doctorId === 'remove';
        
        // Create payload - if removing, set doctorId to null in the backend
        const payload = {
            examinationId: examinationId,
            doctorId: isRemove ? null : doctorId
        };

        // Send request to server
        fetch('${pageContext.request.contextPath}/patients/tooth-examination/assign-doctor', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': csrfToken
            },
            body: JSON.stringify(payload)
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to assign doctor');
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                // Show success indicator
                const select = document.querySelector(`select[data-exam-id="${examinationId}"]`);
                
                // Update the data-doctor attribute for filtering
                const doctorCell = select.closest('td[data-doctor]');
                if (doctorCell) {
                    if (isRemove) {
                        doctorCell.setAttribute('data-doctor', '');
                        select.classList.remove('doctor-assigned'); // Remove assigned class for removed doctors
                    } else {
                        doctorCell.setAttribute('data-doctor', doctorId);
                        select.classList.add('doctor-assigned'); // Add assigned class for assigned doctors
                    }
                }
                
                // Update unassigned count without refresh
                updateUnassignedCount();
                
                // Check if we need to update visibility based on current filter
                const currentFilter = document.getElementById('doctorDropdown').value;
                const row = select.closest('tr');
                
                if (isRemove) {
                    // If we removed a doctor and filter is set to "unassigned", make this row visible
                    if (currentFilter === 'unassigned') {
                        row.style.display = '';
                        updateIndexNumbers(); // Update numbering
                        updateRecordCount();  // Update count
                    } 
                    // If we removed a doctor but filter is set to a specific doctor, hide this row
                    else if (currentFilter !== 'all') {
                        row.style.display = 'none';
                        updateIndexNumbers(); // Update numbering
                        updateRecordCount();  // Update count
                    }
                } else {
                    // If we assigned a doctor and filter is set to "unassigned", hide this row
                    if (currentFilter === 'unassigned') {
                        row.style.display = 'none';
                        updateIndexNumbers(); // Update numbering
                        updateRecordCount();  // Update count
                    }
                    // If we assigned a doctor and filter matches this doctor, show this row
                    else if (currentFilter === doctorId) {
                        row.style.display = '';
                        updateIndexNumbers(); // Update numbering
                        updateRecordCount();  // Update count
                    }
                    // If we assigned a doctor but filter is for a different doctor, hide this row
                    else if (currentFilter !== 'all') {
                        row.style.display = 'none';
                        updateIndexNumbers(); // Update numbering
                        updateRecordCount();  // Update count
                    }
                }
                
                // Show notification
                showNotification(isRemove ? 'Doctor removed successfully' : 'Doctor assigned successfully');
                
                // We'll only refresh if the user is viewing "All Examinations"
                // Otherwise, we've already updated the UI appropriately
                if (currentFilter === 'all') {
                    // Refresh the page after a short delay to show the notification
                    setTimeout(() => {
                        window.location.reload();
                    }, 1000);
                }
            } else {
                throw new Error(data.message || 'Failed to update doctor assignment');
            }
        })
        .catch(error => {
            console.error('Error updating doctor assignment:', error);
            showNotification(`Error: ${error.message}`, true);
        });
    }

    // Function to open examination details page
    function openExaminationDetails(examinationId) {
        // Add debug logging
        console.log("openExaminationDetails called with ID:", examinationId);
        console.log("Value type:", typeof examinationId);
        
        // For empty string or 'undefined' string
        if (examinationId === '') {
            console.error("Empty string ID detected");
            showNotification("Cannot open examination details: Missing ID", true);
            return;
        }
        
        // For null/undefined or the string 'undefined'
        if (!examinationId || examinationId === 'undefined' || examinationId === '') {
            console.error("Invalid examination ID:", examinationId);
            showNotification("Cannot open examination details: Invalid ID", true);
            return;
        }
        
        // Ensure ID is part of URL by directly concatenating it
        var finalUrl = "${pageContext.request.contextPath}/patients/examination/" + examinationId;
        console.log("Proceeding with valid ID, redirecting to:", finalUrl);

        // Redirect to the examination details page with concatenated URL
        window.location.href = finalUrl;
    }
    
    // Update CSS for clickable rows
    document.addEventListener('DOMContentLoaded', function() {
        // Add this CSS dynamically
        const style = document.createElement('style');
        style.textContent = `
            .examination-row {
                cursor: pointer;
                transition: background-color 0.2s;
            }
            .examination-row:hover {
                background-color: #f0f7ff !important;
            }
            .examination-row td:not(:last-child):not([data-date]) {
                pointer-events: auto;
            }
            .examination-row td:last-child {
                pointer-events: none;
            }
            .examination-row td:last-child * {
                pointer-events: auto;
            }
            .examination-row td[data-date] {
                pointer-events: none;
            }
            .examination-row td[data-date] * {
                pointer-events: auto;
            }
        `;
        document.head.appendChild(style);

        // Add click handler to rows, excluding date picker cells
        document.querySelectorAll('.examination-row').forEach(row => {
            row.addEventListener('click', function(e) {
                // Check if the click was on a date picker or its children
                if (e.target.closest('.flatpickr-calendar') || 
                    e.target.closest('input.treatment-date-picker')) {
                    return; // Don't proceed with row click if clicking date picker
                }
                
                // Get the examination ID from the row
                const examinationId = this.getAttribute('data-exam-id');
                if (examinationId) {
                    openExaminationDetails(examinationId);
                }
            });
        });
    });

    document.addEventListener('DOMContentLoaded', function() {
        // Initialize flatpickr for all treatment date pickers
        const datePickers = document.querySelectorAll('.treatment-date-picker');
        
        datePickers.forEach(input => {
            const rawDate = input.dataset.rawDate;
            const examinationId = input.dataset.examId;
            
            // Initialize flatpickr
            const fp = flatpickr(input, {
                enableTime: true,
                dateFormat: "Y-m-d H:i",
                time_24hr: true,
                defaultDate: rawDate || new Date(),
                minuteIncrement: 5,
                allowInput: false,
                clickOpens: true,
                closeOnSelect: false,
                static: true,
                position: "auto",
                appendTo: document.body
            });

            // Create and style the button container
            const buttonContainer = document.createElement('div');
            buttonContainer.className = 'flatpickr-buttons';

            // Create and style the "Now" button
            const nowButton = document.createElement('button');
            nowButton.className = 'flatpickr-now-button';
            nowButton.textContent = 'Set Current Time';
            nowButton.addEventListener('click', function(e) {
                e.preventDefault();
                const now = new Date();
                fp.setDate(now);
            });

            // Create and style the "Save" button
            const saveButton = document.createElement('button');
            saveButton.className = 'flatpickr-confirm';
            saveButton.textContent = 'Save Time';
            saveButton.addEventListener('click', function(e) {
                e.preventDefault();
                const selectedDate = fp.selectedDates[0];
                if (selectedDate) {
                    updateTreatmentDate(selectedDate, examinationId);
                    fp.close();
                }
            });

            // Add the buttons to the container
            buttonContainer.appendChild(nowButton);
            buttonContainer.appendChild(saveButton);

            // Add the container to the calendar
            const calendarContainer = fp.calendarContainer;
            calendarContainer.appendChild(buttonContainer);
        });
    });

    // Function to update treatment date
    function updateTreatmentDate(date, examinationId) {
        if (!date) return;
        
        const csrfToken = document.querySelector("meta[name='_csrf']").content;
        
        // Format the date in 24-hour format
        const formattedDate = flatpickr.formatDate(date, "Y-m-d H:i");
        console.log('Sending date to backend:', formattedDate);
        
        fetch('${pageContext.request.contextPath}/patients/tooth-examination/update-treatment-date', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': csrfToken
            },
            body: JSON.stringify({
                examinationId: examinationId,
                treatmentStartDate: formattedDate
            })
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to update treatment date');
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                showNotification('Treatment start date updated successfully');
                // Update the input field with the formatted date
                const input = document.querySelector(`input[data-exam-id="${examinationId}"]`);
                if (input) {
                    // Format the date for display
                    const displayDate = flatpickr.formatDate(date, "Y-m-d H:i");
                    input.value = displayDate;
                }
            } else {
                throw new Error(data.message || 'Failed to update treatment date');
            }
        })
        .catch(error => {
            console.error('Error updating treatment date:', error);
            showNotification(`Error: ${error.message}`, true);
        });
    }

    // Function to open the examination modal
    function openExaminationModal(toothNumber) {
        const modal = document.getElementById('examinationDetailsModal');
        const form = modal.querySelector('form');
        
        // Clear all form fields
        const inputs = form.querySelectorAll('input, select, textarea');
        inputs.forEach(input => {
            if (input.type !== 'hidden') {
                input.value = '';
            }
        });
        
        // Set the tooth number
        form.querySelector('input[name="toothNumber"]').value = toothNumber;
        
        // Show the modal
        modal.style.display = 'block';
    }

    // Add click handler for tooth elements
    document.querySelectorAll('.tooth').forEach(tooth => {
        tooth.addEventListener('click', function() {
            const toothNumber = this.getAttribute('data-tooth-number');
            openExaminationModal(toothNumber);
        });
    });

</script>
</body>
</html>
