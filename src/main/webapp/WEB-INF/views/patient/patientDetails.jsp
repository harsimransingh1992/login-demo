<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

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
    <script>
        // Add context path variable
        const contextPath = '${pageContext.request.contextPath}';
    </script>
    <script src="${pageContext.request.contextPath}/js/patient-details.js"></script>
    
    <!-- Include common menu styles -->
    <jsp:include page="/WEB-INF/views/common/menuStyles.jsp" />

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
            flex-wrap: wrap;
            justify-content: center;
            gap: 10px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 12px;
            margin: 10px;
        }
        
        .upper-right, .upper-left {
            flex-direction: row;
        }
        
        .lower-right, .lower-left {
            flex-direction: row;
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
            background-color: #fefefe;
            margin: 5% auto;
            padding: 20px;
            border: 1px solid #888;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            max-width: 900px;
            max-height: 90vh;
            overflow-y: auto;
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
            float: right;
            font-size: 24px;
            font-weight: bold;
            cursor: pointer;
            color: #6c757d;
        }
        
        .close:hover {
            color: #343a40;
        }
        
        /* Form Sections in Modal */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-column {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .form-section {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 6px;
            border: 1px solid #e9ecef;
        }
        
        .form-section h3 {
            margin-top: 0;
            margin-bottom: 15px;
            color: #495057;
            font-size: 1.1em;
        }
        
        .form-group {
            margin-bottom: 12px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #495057;
            font-weight: 500;
        }
        
        .form-group select,
        .form-group input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            background-color: white;
        }
        
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #dee2e6;
        }
        
        .btn {
            padding: 8px 16px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-weight: 500;
        }
        
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
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

        .quadrant {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 10px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 12px;
            margin: 10px;
        }

        .upper-right, .upper-left {
            flex-direction: row;
        }

        .lower-right, .lower-left {
            flex-direction: row;
        }

        /* Add this to your existing styles */
        .not-started {
            color: #666;
            font-style: italic;
        }
    </style>
</head>
<body>
<div class="welcome-container">
    <jsp:include page="/WEB-INF/views/common/menu.jsp" />
    <div class="main-content">
        <div class="welcome-header">
            <h1 class="welcome-message">Patient Details</h1>
            <div>
                <a href="${pageContext.request.contextPath}/patients/edit/${patient.id}" class="btn btn-secondary">
                    <i class="fas fa-edit"></i> Edit
                </a>
                <a href="${pageContext.request.contextPath}/patients/list" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i> Back to Patients
                </a>
            </div>
        </div>
        
        <!-- Check-in Status Notification -->
        <c:if test="${!patient.checkedIn && currentUserRole != 'RECEPTIONIST'}">
            <div class="alert alert-warning" style="margin: 20px 0; padding: 15px; background-color: #fff3cd; border: 1px solid #ffeaa7; border-radius: 8px; color: #856404;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-exclamation-triangle" style="font-size: 1.2em; color: #f39c12;"></i>
                    <div>
                        <strong>Patient Not Checked In</strong>
                        <p style="margin: 5px 0 0 0; font-size: 0.9em;">
                            This patient is not currently checked in. New tooth examinations cannot be added until the patient is checked in.
                            <a href="${pageContext.request.contextPath}/patients/list" style="color: #856404; text-decoration: underline;">
                                Go to patient list to check in
                            </a>
                        </p>
                    </div>
                </div>
            </div>
        </c:if>
        
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
                    <p class="patient-id">Patient ID: ${patient.id} | Registration Code: ${patient.registrationCode}</p>
                    <div class="patient-meta">
                        <span class="meta-item"><i class="fas fa-calendar-alt"></i> Age: <strong>${patient.age} years</strong></span>
                        <span class="meta-item"><i class="fas fa-venus-mars"></i> Gender: <strong>${patient.gender}</strong></span>
                        <span class="meta-item"><i class="fas fa-phone"></i> Phone: <strong>${patient.phoneNumber}</strong></span>
                        <span class="meta-item">
                            <i class="fas fa-user-check"></i> Status: 
                            <strong>
                                <c:choose>
                                    <c:when test="${patient.checkedIn}">
                                        <span style="color: #27ae60;">Checked In</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #7f8c8d;">Not Checked In</span>
                                    </c:otherwise>
                                </c:choose>
                            </strong>
                        </span>
                    </div>
                </div>
                <div class="patient-actions">
                    <a href="${pageContext.request.contextPath}/patients/edit/${patient.id}" class="btn btn-secondary">
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
                        <span class="info-label">Date of Birth</span>
                        <span class="info-value">
                            <fmt:formatDate value="${patient.dateOfBirth}" pattern="dd/MM/yyyy"/>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Age</span>
                        <span class="info-value">${patient.age} years</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Gender</span>
                        <span class="info-value">${patient.gender}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Occupation</span>
                        <span class="info-value">${not empty patient.occupation ? patient.occupation.displayName : 'Not specified'}</span>
                    </div>
                </div>
                
                <div class="info-section">
                    <h3>Contact Information</h3>
                    <div class="info-item">
                        <span class="info-label">Phone Number</span>
                        <span class="info-value">${patient.phoneNumber}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Email</span>
                        <span class="info-value">${not empty patient.email ? patient.email : 'Not provided'}</span>
                    </div>
                </div>
                
                <div class="info-section">
                    <h3>Address Information</h3>
                    <div class="info-item">
                        <span class="info-label">Street Address</span>
                        <span class="info-value">${not empty patient.streetAddress ? patient.streetAddress : 'Not provided'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">State</span>
                        <span class="info-value">${not empty patient.state ? patient.state : 'Not provided'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">City</span>
                        <span class="info-value">${not empty patient.city ? patient.city : 'Not provided'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Pincode</span>
                        <span class="info-value">${not empty patient.pincode ? patient.pincode : 'Not provided'}</span>
                    </div>
                </div>
                
                <div class="info-section">
                    <h3>Medical Information</h3>
                    <div class="info-item">
                        <span class="info-label">Medical History</span>
                        <span class="info-value">${not empty patient.medicalHistory ? patient.medicalHistory : 'None reported'}</span>
                    </div>
                </div>
                
                <div class="info-section">
                    <h3>Registration Information</h3>
                    <div class="info-item">
                        <span class="info-label">Registration Code</span>
                        <span class="info-value">${patient.registrationCode}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Registration Date</span>
                        <span class="info-value">
                            <fmt:formatDate value="${patient.registrationDate}" pattern="dd/MM/yyyy"/>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Referral Source</span>
                        <span class="info-value">${not empty patient.referralModel ? patient.referralModel.displayName : 'Not specified'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Current Status</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${patient.checkedIn}">
                                    <span style="color: #27ae60; font-weight: 500;">
                                        <i class="fas fa-user-check"></i> Checked In
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #7f8c8d;">
                                        <i class="fas fa-user"></i> Not Checked In
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Created By</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty patient.createdBy}">
                                    <i class="fas fa-user-plus"></i> ${patient.createdBy}
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #6c757d; font-style: italic;">Not recorded</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Registered At</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty patient.registeredClinic}">
                                    <i class="fas fa-hospital"></i> ${patient.registeredClinic}
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #6c757d; font-style: italic;">Not recorded</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Created At</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty patient.createdAt}">
                                    <i class="fas fa-clock"></i> <fmt:formatDate value="${patient.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #6c757d; font-style: italic;">Not recorded</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
                
                <div class="info-section">
                    <h3>Emergency Contact</h3>
                    <div class="info-item">
                        <span class="info-label">Emergency Contact Name</span>
                        <span class="info-value">${not empty patient.emergencyContactName ? patient.emergencyContactName : 'Not provided'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Emergency Contact Phone</span>
                        <span class="info-value">${not empty patient.emergencyContactPhoneNumber ? patient.emergencyContactPhoneNumber : 'Not provided'}</span>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Dental Chart Section -->
        <div class="patient-details-container dental-chart-section">
            <div class="patient-header">
            <h2>Dental Chart</h2>
                <c:choose>
                    <c:when test="${currentUserRole == 'RECEPTIONIST'}">
                        <p class="chart-instructions" style="color: #e74c3c; font-weight: 500;">
                            <i class="fas fa-info-circle"></i> 
                            Receptionists cannot add or edit tooth examinations. Please contact a doctor or staff member for clinical procedures.
                        </p>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${!patient.checkedIn}">
                                <p class="chart-instructions" style="color: #e74c3c; font-weight: 500;">
                                    <i class="fas fa-exclamation-triangle"></i> 
                                    Patient must be checked in before adding new tooth examinations. Please check in the patient first.
                                </p>
                            </c:when>
                            <c:otherwise>
                                <p class="chart-instructions">Click on a tooth to add or edit examination record</p>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="dental-chart" 
                 <c:if test="${currentUserRole == 'RECEPTIONIST' || !patient.checkedIn}">style="opacity: 0.6; pointer-events: none;"</c:if>>
                <!-- Upper Teeth (Maxillary) -->
            <div class="teeth-row upper-teeth">
                    <!-- Upper Right (Q1) -->
                    <div class="quadrant upper-right">
                        <div class="tooth" data-tooth-number="18">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-molar.svg" alt="Tooth 18">
                                <span class="tooth-number-bottom">18</span>
                            </div>
                            <div class="tooth-number">UR8</div>
                    </div>
                        <div class="tooth" data-tooth-number="17">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-molar.svg" alt="Tooth 17">
                                <span class="tooth-number-bottom">17</span>
                            </div>
                            <div class="tooth-number">UR7</div>
                    </div>
                        <div class="tooth" data-tooth-number="16">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-molar.svg" alt="Tooth 16">
                                <span class="tooth-number-bottom">16</span>
                    </div>
                            <div class="tooth-number">UR6</div>
                        </div>
                        <div class="tooth" data-tooth-number="15">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-premolar.svg" alt="Tooth 15">
                                <span class="tooth-number-bottom">15</span>
                            </div>
                            <div class="tooth-number">UR5</div>
                    </div>
                        <div class="tooth" data-tooth-number="14">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-premolar.svg" alt="Tooth 14">
                                <span class="tooth-number-bottom">14</span>
                            </div>
                            <div class="tooth-number">UR4</div>
                        </div>
                        <div class="tooth" data-tooth-number="13">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-canine.svg" alt="Tooth 13">
                                <span class="tooth-number-bottom">13</span>
                            </div>
                            <div class="tooth-number">UR3</div>
                        </div>
                        <div class="tooth" data-tooth-number="12">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-incisor.svg" alt="Tooth 12">
                                <span class="tooth-number-bottom">12</span>
                            </div>
                            <div class="tooth-number">UR2</div>
                    </div>
                        <div class="tooth" data-tooth-number="11">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-incisor.svg" alt="Tooth 11">
                                <span class="tooth-number-bottom">11</span>
                            </div>
                            <div class="tooth-number">UR1</div>
                    </div>
                </div>
                    <div class="quadrant upper-left">
                    <div class="tooth" data-tooth-number="21">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-incisor.svg" alt="Tooth 21">
                                <span class="tooth-number-bottom">21</span>
                            </div>
                            <div class="tooth-number">UL1</div>
                    </div>
                    <div class="tooth" data-tooth-number="22">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-incisor.svg" alt="Tooth 22">
                                <span class="tooth-number-bottom">22</span>
                    </div>
                            <div class="tooth-number">UL2</div>
                        </div>
                    <div class="tooth" data-tooth-number="23">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-canine.svg" alt="Tooth 23">
                                <span class="tooth-number-bottom">23</span>
                    </div>
                            <div class="tooth-number">UL3</div>
                        </div>
                    <div class="tooth" data-tooth-number="24">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-premolar.svg" alt="Tooth 24">
                                <span class="tooth-number-bottom">24</span>
                            </div>
                            <div class="tooth-number">UL4</div>
                    </div>
                    <div class="tooth" data-tooth-number="25">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-premolar.svg" alt="Tooth 25">
                                <span class="tooth-number-bottom">25</span>
                            </div>
                            <div class="tooth-number">UL5</div>
                        </div>
                    <div class="tooth" data-tooth-number="26">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-molar.svg" alt="Tooth 26">
                                <span class="tooth-number-bottom">26</span>
                            </div>
                            <div class="tooth-number">UL6</div>
                    </div>
                    <div class="tooth" data-tooth-number="27">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/upper-molar.svg" alt="Tooth 27">
                                <span class="tooth-number-bottom">27</span>
                            </div>
                            <div class="tooth-number">UL7</div>
                    </div>
                    <div class="tooth" data-tooth-number="28">
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
                    <div class="tooth" data-tooth-number="48">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-molar.svg" alt="Tooth 48">
                                <span class="tooth-number-bottom">48</span>
                            </div>
                            <div class="tooth-number">LR8</div>
                    </div>
                    <div class="tooth" data-tooth-number="47">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-molar.svg" alt="Tooth 47">
                                <span class="tooth-number-bottom">47</span>
                            </div>
                            <div class="tooth-number">LR7</div>
                    </div>
                    <div class="tooth" data-tooth-number="46">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-molar.svg" alt="Tooth 46">
                                <span class="tooth-number-bottom">46</span>
                    </div>
                            <div class="tooth-number">LR6</div>
                        </div>
                    <div class="tooth" data-tooth-number="45">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-premolar.svg" alt="Tooth 45">
                                <span class="tooth-number-bottom">45</span>
                            </div>
                            <div class="tooth-number">LR5</div>
                    </div>
                    <div class="tooth" data-tooth-number="44">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-premolar.svg" alt="Tooth 44">
                                <span class="tooth-number-bottom">44</span>
                    </div>
                            <div class="tooth-number">LR4</div>
                        </div>
                    <div class="tooth" data-tooth-number="43">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-canine.svg" alt="Tooth 43">
                                <span class="tooth-number-bottom">43</span>
                    </div>
                            <div class="tooth-number">LR3</div>
                        </div>
                    <div class="tooth" data-tooth-number="42">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-incisor.svg" alt="Tooth 42">
                                <span class="tooth-number-bottom">42</span>
                            </div>
                            <div class="tooth-number">LR2</div>
                    </div>
                    <div class="tooth" data-tooth-number="41">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-incisor.svg" alt="Tooth 41">
                                <span class="tooth-number-bottom">41</span>
                            </div>
                            <div class="tooth-number">LR1</div>
                    </div>
                </div>

                    <!-- Lower Left (Q3) -->
                    <div class="quadrant lower-left">
                    <div class="tooth" data-tooth-number="31">
                            <div class="tooth-graphic">
                                <img src="${pageContext.request.contextPath}/images/teeth/lower-incisor.svg" alt="Tooth 31">
                                <span class="tooth-number-bottom">31</span>
                            </div>
                            <div class="tooth-number">LL1</div>
                    </div>
                    <div class="tooth" data-tooth-number="32">
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
                            <option value="${doctor.id}">${doctor.firstName} ${doctor.lastName}</option>
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
                                <c:set var="clinicName" value="${exam.examinationClinic.clinicName}" />
                                <c:set var="clinicId" value="${exam.examinationClinic.clinicId}" />
                                <c:if test="${!fn:contains(clinicsSeen, clinicId)}">
                                    <c:set var="clinicsSeen" value="${clinicsSeen}${clinicId}," />
                                    <option value="${clinicId}">${clinicName}</option>
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
                                <th>Exam ID</th>
                                <th>Tooth</th>
                                <th>Examination Date</th>
                                <th>Condition</th>
                                <th>Treatment Start Date</th>
                                <th>Notes</th>
                                <th>Clinic</th>
                                <th>Treating Doctor</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                        <c:forEach items="${examinationHistory}" var="exam" varStatus="status">
                            <tr class="examination-row" onclick="openExaminationDetails('${exam.id}')">
                                <td class="exam-id-col">${exam.id}</td>
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
                                    <c:choose>
                                        <c:when test="${not empty rawDate}">
                                            <fmt:parseDate value="${rawDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate"/>
                                            <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="not-started">Not Started</span>
                                        </c:otherwise>
                                    </c:choose>
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
                                <td data-clinic-id="${not empty exam.examinationClinic ? exam.examinationClinic.clinicId : ''}">
                                    <c:choose>
                                        <c:when test="${not empty exam.examinationClinic}">
                                            <span class="clinic-code">${exam.examinationClinic.clinicName}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td data-doctor="${exam.assignedDoctorId != null ? exam.assignedDoctorId : ''}">
                                    <c:choose>
                                        <c:when test="${exam.assignedDoctorId != null}">
                                        <c:forEach items="${doctorDetails}" var="doctor">
                                                <c:if test="${doctor.id == exam.assignedDoctorId}">
                                                ${doctor.firstName} ${doctor.lastName}
                                                </c:if>
                                        </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            Not Assigned
                                        </c:otherwise>
                                    </c:choose>
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
    <!-- Tooth Examination Modal - Only show for non-receptionists -->
    <c:if test="${currentUserRole != 'RECEPTIONIST'}">
    <div id="toothModal" class="modal tooth-examination-modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2 style="margin: 0 0 15px 0; font-size: 1.2rem; color: #2c3e50;">Clinical Examination for Tooth <span id="selectedToothNumber"></span></h2>
            <form id="toothExaminationForm" method="post" action="${pageContext.request.contextPath}/patients/tooth-examination/save">
                <input type="hidden" id="examinationId" name="id" value="">
                <input type="hidden" id="patientId" name="patientId" value="${patient.id}">
                <input type="hidden" id="toothNumber" name="toothNumber" value="">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <!-- Chief Complaints Section -->
                <div class="chief-complaints-section">
                    <h3>Chief Complaints</h3>
                    <div class="form-group">
                        <label for="chiefComplaints">Patient's Chief Complaints</label>
                        <textarea name="chiefComplaints" id="chiefComplaints" rows="6" class="form-control" 
                                  placeholder="Enter the patient's chief complaints in detail..."></textarea>
                    </div>
                </div>

                <div class="form-grid">
                    <!-- Left Column -->
                    <div class="form-column">
                        <div class="form-section">
                            <h3>Basic Assessment</h3>
                            <div class="form-group">
                                <label for="toothSurface">Surface</label>
                                <select name="toothSurface" id="toothSurface" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${toothSurfaces}" var="surface">
                                        <option value="${surface}">${surface}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="toothCondition">Condition</label>
                                <select name="toothCondition" id="toothCondition" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${toothConditions}" var="condition">
                                        <option value="${condition}">${condition}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="toothMobility">Mobility</label>
                                <select name="toothMobility" id="toothMobility" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${toothMobilities}" var="mobility">
                                        <option value="${mobility}">${mobility}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3>Periodontal Assessment</h3>
                            <div class="form-group">
                                <label for="pocketDepth">Pocket Depth</label>
                                <select name="pocketDepth" id="pocketDepth" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${pocketDepths}" var="depth">
                                        <option value="${depth}">${depth}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="bleedingOnProbing">Bleeding on Probing</label>
                                <select name="bleedingOnProbing" id="bleedingOnProbing" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${bleedingOnProbings}" var="bleeding">
                                        <option value="${bleeding}">${bleeding}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="plaqueScore">Plaque Score</label>
                                <select name="plaqueScore" id="plaqueScore" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${plaqueScores}" var="score">
                                        <option value="${score}">${score}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column -->
                    <div class="form-column">
                        <div class="form-section">
                            <h3>Additional Assessment</h3>
                            <div class="form-group">
                                <label for="gingivalRecession">Gingival Recession</label>
                                <select name="gingivalRecession" id="gingivalRecession" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${gingivalRecessions}" var="recession">
                                        <option value="${recession}">${recession}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="toothVitality">Tooth Vitality</label>
                                <select name="toothVitality" id="toothVitality" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${toothVitalities}" var="vitality">
                                        <option value="${vitality}">${vitality}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="furcationInvolvement">Furcation Involvement</label>
                                <select name="furcationInvolvement" id="furcationInvolvement" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${furcationInvolvements}" var="furcation">
                                        <option value="${furcation}">${furcation}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="periapicalCondition">Periapical Condition</label>
                                <select name="periapicalCondition" id="periapicalCondition" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${periapicalConditions}" var="condition">
                                        <option value="${condition}">${condition}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="toothSensitivity">Tooth Sensitivity</label>
                                <select name="toothSensitivity" id="toothSensitivity" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${toothSensitivities}" var="sensitivity">
                                        <option value="${sensitivity}">${sensitivity}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="existingRestoration">Existing Restoration</label>
                                <select name="existingRestoration" id="existingRestoration" class="form-control">
                                    <option value="">Select</option>
                                    <c:forEach items="${existingRestorations}" var="restoration">
                                        <option value="${restoration}">${restoration}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Full Width Sections -->
                <div class="form-section notes-section">
                    <h3>Treatment Advised</h3>
                    <div class="form-group">
                        <label for="advised">Treatment/Procedure Advised</label>
                        <textarea name="advised" id="advised" rows="3" class="form-control" 
                                  placeholder="Enter the treatment or procedure advised..."></textarea>
                    </div>
                </div>

                <div class="form-section notes-section">
                    <h3>Clinical Notes</h3>
                    <div class="form-group">
                        <label for="examinationNotes">Notes</label>
                        <textarea name="examinationNotes" id="examinationNotes" rows="4" class="form-control"></textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Save Examination</button>
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>
    </c:if>
</div>
</body>
</html>
