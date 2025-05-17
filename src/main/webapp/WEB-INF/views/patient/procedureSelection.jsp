<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
    <title>Select Procedure - PeriDesk</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
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
        
        .sidebar-menu {
            width: 280px;
            background: linear-gradient(180deg, #ffffff, #f8f9fa);
            padding: 30px;
            box-shadow: 0 0 25px rgba(0, 0, 0, 0.05);
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
            align-items: center;
            justify-content: space-between;
            margin-top: 10px;
            padding: 8px 12px;
            background-color: #f8f9fa;
            border-radius: 6px;
            font-weight: 500;
            font-size: 0.9rem;
        }
        
        #selected-count {
            color: #3498db;
            font-weight: 600;
        }
        
        .total-amount {
            color: #3498db;
            font-weight: 600;
            background-color: white;
            padding: 3px 8px;
            border-radius: 20px;
            font-size: 0.85rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .submit-area {
            display: flex;
            align-items: center;
            gap: 8px;
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
        #view-selected-procedures {
            background: #3498db; /* Make the button more prominent */
            position: relative;
            min-width: 240px; /* Ensure minimum width to fit text */
            white-space: nowrap; /* Prevent text wrapping */
        }
        
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
                flex-wrap: nowrap;
                overflow-x: auto;
                padding-bottom: 5px;
                -webkit-overflow-scrolling: touch;
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
            .submit-area {
                flex-wrap: wrap;
                gap: 8px;
                justify-content: flex-end;
            }
            
            .btn-narrow {
                width: auto;
                min-width: 130px;
                margin-top: 5px;
            }
            
            #view-selected-procedures {
                order: 2;
            }
            
            #submit-procedures {
                order: 3;
            }
            
            .total-amount {
                order: 1;
                margin-right: auto;
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
            display: grid;
            grid-template-columns: minmax(100px, 1.5fr) minmax(60px, auto) minmax(80px, auto);
            align-items: center;
            gap: 6px;
            padding: 6px 10px;
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
            font-size: 0.9rem;
            color: #2c3e50;
            overflow: hidden;
            text-overflow: ellipsis;
            padding-right: 5px;
            white-space: nowrap;
        }
        
        .department-content .procedure-card .procedure-price {
            margin: 0;
            font-size: 0.9rem;
            font-weight: 600;
            text-align: right;
            white-space: nowrap;
            padding-right: 5px;
        }
        
        .department-content .procedure-card .procedure-actions {
            margin: 0;
        }
        
        .department-content .procedure-card .btn {
            padding: 3px 8px;
            font-size: 0.8rem;
            white-space: nowrap;
            min-width: 70px;
        }
        
        .department-content .procedure-card.selected {
            background-color: #edf7fd;
            border-left: 3px solid #3498db;
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
            flex-wrap: nowrap;
            gap: 2px;
            margin-bottom: 0;
            position: relative;
            z-index: 10;
            overflow-x: auto;
            padding-bottom: 2px;
            scrollbar-width: thin; /* For Firefox */
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
            gap: 6px;
            position: relative;
            margin-bottom: -1px;
            flex-shrink: 0; /* Prevent tabs from shrinking */
            white-space: nowrap; /* Keep text on one line */
            font-size: 0.9rem;
        }
        
        .department-tab.active {
            background: white;
            color: #3498db;
            border-bottom: 1px solid white;
        }
        
        .department-tab:hover:not(.active) {
            background: #e6f0fa;
        }
        
        .department-tab i {
            font-size: 1rem;
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
        }
        
        .department-content.active {
            display: block;
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
            transition: background-color 0.2s;
        }
        
        .remove-procedure-btn:hover {
            background-color: #c0392b;
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
    </style>
</head>
<body>
    <div class="welcome-container">
        <div class="sidebar-menu">
            <div class="logo">
                <img src="${pageContext.request.contextPath}/images/tooth-repair.svg" alt="PeriDesk Logo">
                <h1>PeriDesk</h1>
            </div>
            <a href="${pageContext.request.contextPath}/welcome" class="action-card">
                <i class="fas fa-clipboard-list"></i>
                <div class="card-text">
                    <h3>Waiting Lobby</h3>
                    <p>View waiting patients</p>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/patients/register" class="action-card">
                <i class="fas fa-user-plus"></i>
                <div class="card-text">
                    <h3>Register Patient</h3>
                    <p>Add new patient</p>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/patients/list" class="action-card">
                <i class="fas fa-users"></i>
                <div class="card-text">
                    <h3>View Patients</h3>
                    <p>Manage records</p>
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
                </div>
                
                <!-- Hidden field for JavaScript to access the examination ID -->
                <input type="hidden" id="current-examination-id" value="${examination.id}" />
                
                <div class="examination-details">
                    <h3>Tooth Examination Details</h3>
                    <div class="details-grid">
                        <div class="detail-item">
                            <span class="detail-label">Tooth Condition</span>
                            <span class="detail-value">${examination.toothCondition != null ? examination.toothCondition : 'Not specified'}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Surface</span>
                            <span class="detail-value">${examination.toothSurface != null ? examination.toothSurface : 'Not specified'}</span>
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
                </div>
                
                <div class="procedure-header">
                    <h2>Available Procedures</h2>
                    <c:if test="${not empty userCityTier}">
                        <div class="city-tier-info">
                            <i class="fas fa-map-marker-alt"></i> Showing prices for <strong>${cityTierDisplayName}</strong>
                        </div>
                    </c:if>
                    <div class="selected-procedures-info">
                        <span><span id="selected-count">0</span> procedures selected</span>
                        <div class="submit-area">
                            <span id="total-amount" class="total-amount">₹0</span>
                            <button id="view-selected-procedures" class="btn btn-secondary btn-narrow">
                                <i class="fas fa-eye"></i>&nbsp;View All Saved Procedures
                            </button>
                            <button id="submit-procedures" class="btn btn-primary btn-narrow" disabled>
                                <i class="fas fa-check"></i> Submit
                            </button>
                        </div>
                    </div>
                    
                    <!-- Error message for duplicate procedures -->
                    <div id="duplicate-procedures-error" class="duplicate-procedures-error">
                        <strong><i class="fas fa-exclamation-triangle"></i> Cannot add duplicate procedures</strong>
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
                        <%-- First collect unique departments --%>
                        <c:set var="departments" value="" />
                        <c:forEach var="procedure" items="${procedures}">
                            <c:set var="deptName" value="Other" />
                            <c:if test="${procedure.dentalDepartment != null && procedure.dentalDepartment.displayName != null}">
                                <c:set var="deptName" value="${procedure.dentalDepartment.displayName}" />
                            </c:if>
                            <c:if test="${!fn:contains(departments, '|'.concat(deptName).concat('|'))}">
                                <c:set var="departments" value="${departments}|${deptName}|" />
                            </c:if>
                        </c:forEach>
                        
                        <div class="departments-tabs-container">
                            <%-- Horizontal Department Tabs --%>
                            <div class="departments-tabs">
                                <c:forEach var="deptStr" items="${fn:split(departments, '||')}" varStatus="deptStatus">
                                    <c:if test="${not empty deptStr}">
                                        <c:set var="deptName" value="${fn:replace(deptStr, '|', '')}" />
                                        <c:set var="safeDeptName" value="${fn:replace(deptName, ' ', '_')}" />
                                        
                                        <%-- Count procedures in department --%>
                                        <c:set var="deptCount" value="0" />
                                        <c:forEach var="procedure" items="${procedures}">
                                            <c:set var="procDeptName" value="Other" />
                                            <c:if test="${procedure.dentalDepartment != null && procedure.dentalDepartment.displayName != null}">
                                                <c:set var="procDeptName" value="${procedure.dentalDepartment.displayName}" />
                                            </c:if>
                                            <c:if test="${procDeptName eq deptName}">
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
                                    </c:if>
                                </c:forEach>
                            </div>
                            
                            <%-- Department Contents --%>
                            <div class="departments-content">
                                <c:forEach var="deptStr" items="${fn:split(departments, '||')}" varStatus="deptStatus">
                                    <c:if test="${not empty deptStr}">
                                        <c:set var="deptName" value="${fn:replace(deptStr, '|', '')}" />
                                        <c:set var="safeDeptName" value="${fn:replace(deptName, ' ', '_')}" />
                                        
                                        <div class="department-content${deptStatus.count == 1 ? ' active' : ''}" data-dept="${safeDeptName}">
                                            <c:forEach var="procedure" items="${procedures}">
                                                <c:set var="procDeptName" value="Other" />
                                                <c:if test="${procedure.dentalDepartment != null && procedure.dentalDepartment.displayName != null}">
                                                    <c:set var="procDeptName" value="${procedure.dentalDepartment.displayName}" />
                                                </c:if>
                                                <c:if test="${procDeptName eq deptName}">
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
                                        </div>
                                    </c:if>
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
            const viewSelectedButton = document.getElementById('view-selected-procedures');
            const selectedProceduresModal = document.getElementById('selected-procedures-modal');
            const selectedProceduresTable = document.getElementById('selected-procedures-table');
            const selectedProceduresTableBody = document.getElementById('selected-procedures-table-body');
            const selectedProceduresTotal = document.getElementById('selected-procedures-total');
            const noProceduresMessage = document.getElementById('no-procedures-message');
            const closeModalButtons = document.querySelectorAll('.close-modal, .close-button');
            
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
            
            // Track selected procedures
            const selectedProcedures = new Map(); // Using Map to store procedure details
            
            // Debug: Check if view selected button exists
            console.log('View selected button found:', viewSelectedButton !== null);
            console.log('Modal element found:', selectedProceduresModal !== null);
            
            // Utility function to show modal
            function showModal(modal) {
                if (!modal) {
                    console.error('Modal element not found');
                    return;
                }
                
                // First ensure the element is visible in the DOM
                modal.style.display = 'block';
                
                // Force a reflow to ensure the display change is applied
                void modal.offsetWidth;
                
                // Apply additional styling if needed
                modal.style.opacity = '1';
                modal.style.visibility = 'visible';
                
                console.log('Modal shown:', modal.id, 'Display:', modal.style.display);
            }
            
            // Close modal when clicking outside
            window.addEventListener('click', function(event) {
                if (event.target === selectedProceduresModal) {
                    selectedProceduresModal.style.display = 'none';
                }
            });
            
            // Close modal with close buttons
            closeModalButtons.forEach(button => {
                button.addEventListener('click', function() {
                    selectedProceduresModal.style.display = 'none';
                });
            });
            
            // Define tab manager
            const tabManager = {
                init: function() {
                    // Cache DOM elements
                    this.tabs = document.querySelectorAll('.department-tab');
                    this.contents = document.querySelectorAll('.department-content');
                    
                    // Add click listeners to all tabs
                    this.tabs.forEach(tab => {
                        tab.addEventListener('click', (e) => {
                            e.preventDefault();
                            e.stopPropagation();
                            
                            // Get the department name
                            const deptName = tab.getAttribute('data-dept');
                            
                            // First deactivate all tabs and content
                            this.tabs.forEach(t => t.classList.remove('active'));
                            this.contents.forEach(c => c.classList.remove('active'));
                            
                            // Then activate this tab
                            tab.classList.add('active');
                            
                            // Find and activate matching content
                            const contentToActivate = document.querySelector('.department-content[data-dept="' + deptName + '"]');
                            if (contentToActivate) {
                                contentToActivate.classList.add('active');
                            }
                        });
                    });
                    
                    // Activate first tab if none is active
                    const activeTab = document.querySelector('.department-tab.active');
                    if (!activeTab && this.tabs.length > 0) {
                        this.tabs[0].click();
                    }
                }
            };
            
            // Initialize tab manager
            tabManager.init();
            
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
            
            // Calculate total amount of selected procedures
            function calculateTotalAmount() {
                let total = 0;
                selectedProcedures.forEach(details => {
                    total += parseFloat(details.price);
                });
                return total;
            }
            
            // Update UI based on selection state
            function updateSelectionUI() {
                const count = selectedProcedures.size;
                selectedCountElement.textContent = count;
                submitButton.disabled = count === 0;
                
                // We set the button as enabled initially - it will be disabled in the fetchSavedProcedures
                // function if no saved procedures are available
                if (count > 0) {
                    // If we have selected procedures, enable the view button and remove the no-procedures attribute
                    viewSelectedButton.disabled = false;
                    viewSelectedButton.removeAttribute('data-no-procedures');
                } else {
                    // Check if we have any existing procedures
                    const existingIdsInput = document.getElementById('existingProcedureIds');
                    if (existingIdsInput && existingIdsInput.value) {
                        const existingIds = existingIdsInput.value.split(',').filter(id => id.trim() !== '').map(id => id.trim());
                        if (existingIds && existingIds.length === 0) {
                            // If no selected procedures and no existing procedures, disable the button
                            viewSelectedButton.disabled = true;
                            viewSelectedButton.setAttribute('data-no-procedures', 'true');
                        }
                    }
                }
                
                console.log('UI updated: selectedProcedures count =', count);
                console.log('viewSelectedButton disabled =', viewSelectedButton.disabled);
                
                // Update total amount
                totalAmountElement.textContent = '₹' + calculateTotalAmount().toFixed(2);
            }
            
            // Function to update the selected procedures modal content
            function updateSelectedProceduresModal() {
                // Clear the table body
                selectedProceduresTableBody.innerHTML = '';
                
                // Check if there are any selected procedures
                if (selectedProcedures.size === 0) {
                    // Hide table and show message
                    selectedProceduresTable.style.display = 'none';
                    noProceduresMessage.style.display = 'block';
                } else {
                    // Show table and hide message
                    selectedProceduresTable.style.display = 'table';
                    noProceduresMessage.style.display = 'none';
                    
                    // Add each selected procedure to the table
                    selectedProcedures.forEach((details, id) => {
                        const row = document.createElement('tr');
                        
                        // Procedure name cell
                        const nameCell = document.createElement('td');
                        nameCell.textContent = details.name;
                        row.appendChild(nameCell);
                        
                        // Price cell
                        const priceCell = document.createElement('td');
                        priceCell.textContent = '₹' + parseFloat(details.price).toFixed(2);
                        priceCell.className = 'price-cell';
                        row.appendChild(priceCell);
                        
                        // Action cell with remove button
                        const actionCell = document.createElement('td');
                        const removeButton = document.createElement('button');
                        removeButton.className = 'remove-procedure-btn';
                        removeButton.innerHTML = '<i class="fas fa-times"></i> Remove';
                        removeButton.onclick = function() {
                            removeProcedure(id);
                            updateSelectedProceduresModal();
                        };
                        actionCell.appendChild(removeButton);
                        row.appendChild(actionCell);
                        
                        selectedProceduresTableBody.appendChild(row);
                    });
                    
                    // Update the total
                    selectedProceduresTotal.textContent = '₹' + calculateTotalAmount().toFixed(2);
                }
            }
            
            // Function to fetch and display already saved procedures
            async function fetchSavedProcedures() {
                // Get the examination ID from the hidden input field
                const examinationIdInput = document.getElementById('current-examination-id');
                const examinationId = examinationIdInput ? examinationIdInput.value : '';
                
                console.log('Examination ID from hidden field:', examinationId);
                
                // Validate examination ID
                if (!examinationId || examinationId.trim() === '') {
                    console.error('Invalid examination ID:', examinationId);
                    const errorMessage = document.getElementById('error-message');
                    errorMessage.textContent = 'Error: Invalid or missing examination ID';
                    errorMessage.style.display = 'block';
                    
                    // Disable the view button if we can't fetch procedures
                    viewSelectedButton.disabled = true;
                    
                    return; // Don't proceed with the API call
                }
                
                const savedProceduresTableBody = document.getElementById('saved-procedures-table-body');
                const savedProceduresTable = document.getElementById('saved-procedures-table');
                const noSavedProceduresMessage = document.getElementById('no-saved-procedures-message');
                const savedProceduresTotal = document.getElementById('saved-procedures-total');
                const loadingSpinner = document.getElementById('loading-spinner');
                const errorMessage = document.getElementById('error-message');
                
                console.log('Starting fetchSavedProcedures for examination ID:', examinationId);
                console.log('DOM elements found:', {
                    savedProceduresTableBody: savedProceduresTableBody !== null,
                    savedProceduresTable: savedProceduresTable !== null,
                    noSavedProceduresMessage: noSavedProceduresMessage !== null,
                    savedProceduresTotal: savedProceduresTotal !== null,
                    loadingSpinner: loadingSpinner !== null,
                    errorMessage: errorMessage !== null
                });
                
                // Clear previous error message
                errorMessage.style.display = 'none';
                errorMessage.textContent = '';
                
                // Show loading spinner
                loadingSpinner.style.display = 'flex';
                
                try {
                    // Fetch saved procedures from the server using absolute URL construction
                    // Get each part separately for debugging
                    const origin = window.location.origin;
                    const contextPath = '${pageContext.request.contextPath}';
                    const apiPath = '/patients/examination/' + examinationId + '/procedures-json';
                    
                    // Construct the final URL
                    let apiUrl = origin + contextPath + apiPath;
                    
                    // Debug URL construction
                    console.log('URL parts:', {
                        origin: origin,
                        contextPath: contextPath,
                        apiPath: apiPath,
                        finalUrl: apiUrl
                    });
                    
                    // Check for malformed URL (handle the procedures-json at root case)
                    if (apiUrl.includes('//procedures-json') || apiUrl.endsWith('//procedures-json/')) {
                        console.warn('Detected malformed URL, using fallback construction');
                        // Construct URL from the current page URL as fallback
                        const currentUrl = window.location.href;
                        // Remove any fragment or query string
                        const basePath = currentUrl.split(/[?#]/)[0];
                        // Go up one level from current URL by removing the last path segment
                        const parentPath = basePath.substring(0, basePath.lastIndexOf('/'));
                        // Construct the API URL
                        apiUrl = parentPath + '/' + examinationId + '/procedures-json';
                        console.log('Fallback URL:', apiUrl);
                    }
                    
                    console.log('Fetching data from:', apiUrl);
                    const response = await fetch(apiUrl);
                    const result = await response.json();
                    
                    console.log('API response:', result);
                    
                    // Hide loading spinner
                    loadingSpinner.style.display = 'none';
                    
                    if (result.success) {
                        // Clear the table body
                        savedProceduresTableBody.innerHTML = '';
                        
                        const procedures = result.procedures;
                        console.log('Procedures from API:', procedures);
                        
                        // Check if there are any saved procedures
                        if (!procedures || procedures.length === 0) {
                            console.log('No procedures found');
                            // Hide table and show message
                            savedProceduresTable.style.display = 'none';
                            noSavedProceduresMessage.style.display = 'block';
                            
                            // Check if there are also no selected procedures
                            if (selectedProcedures.size === 0) {
                                // If no saved procedures and no selected procedures, disable the view button
                                viewSelectedButton.disabled = true;
                                
                                // Set a data attribute to indicate no saved procedures
                                viewSelectedButton.setAttribute('data-no-procedures', 'true');
                            }
                        } else {
                            console.log('Found', procedures.length, 'procedures');
                            // Show table and hide message
                            savedProceduresTable.style.display = 'table';
                            noSavedProceduresMessage.style.display = 'none';
                            
                            // Enable the view button since we have saved procedures
                            viewSelectedButton.disabled = false;
                            
                            // Remove the data attribute
                            viewSelectedButton.removeAttribute('data-no-procedures');
                            
                            // Add each saved procedure to the table
                            procedures.forEach((procedure, index) => {
                                console.log(`Building row for procedure ${index}:`, procedure);
                                const row = document.createElement('tr');
                                
                                // Procedure name cell
                                const nameCell = document.createElement('td');
                                nameCell.textContent = procedure.procedureName || 'Unnamed Procedure';
                                row.appendChild(nameCell);
                                
                                // Price cell
                                const priceCell = document.createElement('td');
                                priceCell.textContent = '₹' + (procedure.price ? parseFloat(procedure.price).toFixed(2) : '0.00');
                                priceCell.className = 'price-cell';
                                row.appendChild(priceCell);
                                
                                // Department cell - improved handling for different JSON structures
                                const deptCell = document.createElement('td');
                                // Let's handle all possible formats the department might be returned in
                                let departmentName = 'Not specified';
                                
                                if (procedure.dentalDepartment) {
                                    const dept = procedure.dentalDepartment;
                                    console.log('Dental department object:', dept);
                                    
                                    // Check if it's an enum object with displayName
                                    if (typeof dept === 'object' && dept.displayName) {
                                        departmentName = dept.displayName;
                                    }
                                    // Check if it's an enum with name field
                                    else if (typeof dept === 'object' && dept.name) {
                                        departmentName = dept.name.replace(/_/g, ' ').toLowerCase()
                                            .replace(/\b\w/g, l => l.toUpperCase());
                                    }
                                    // Check if it's just the enum name as a string
                                    else if (typeof dept === 'string') {
                                        departmentName = dept.replace(/_/g, ' ').toLowerCase()
                                            .replace(/\b\w/g, l => l.toUpperCase());
                                    }
                                    // For serialized enum without property access
                                    else if (typeof dept === 'object') {
                                        // Try to extract a sensible name from whatever properties are available
                                        const keys = Object.keys(dept);
                                        if (keys.length > 0) {
                                            // Look for common field names
                                            for (const key of ['displayName', 'name', 'value', 'type']) {
                                                if (dept[key] && typeof dept[key] === 'string') {
                                                    departmentName = dept[key];
                                                    break;
                                                }
                                            }
                                            // If none found, use the first string property
                                            if (departmentName === 'Not specified') {
                                                for (const key of keys) {
                                                    if (typeof dept[key] === 'string') {
                                                        departmentName = dept[key];
                                                        break;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                deptCell.textContent = departmentName;
                                row.appendChild(deptCell);
                                
                                // Add action cell with remove button
                                const actionCell = document.createElement('td');
                                const removeButton = document.createElement('button');
                                removeButton.className = 'remove-procedure-btn';
                                removeButton.innerHTML = '<i class="fas fa-trash-alt"></i> Remove';
                                removeButton.onclick = function(e) {
                                    e.preventDefault();
                                    e.stopPropagation();
                                    removeSavedProcedure(procedure.id, procedure.procedureName || 'Unnamed Procedure');
                                };
                                actionCell.appendChild(removeButton);
                                row.appendChild(actionCell);
                                
                                savedProceduresTableBody.appendChild(row);
                                console.log('Row added to table');
                            });
                            
                            // Update the total
                            const totalAmount = parseFloat(result.totalAmount).toFixed(2);
                            savedProceduresTotal.textContent = '₹' + totalAmount;
                            console.log('Updated total amount:', totalAmount);
                        }
                    } else {
                        console.error('API returned error:', result.message);
                        // Show error message
                        errorMessage.textContent = result.message || 'Failed to load saved procedures';
                        errorMessage.style.display = 'block';
                        
                        // Display a notification in the main UI
                        showNotification('Error loading saved procedures: ' + (result.message || 'Unknown error'), true);
                        
                        // Hide table and show message
                        savedProceduresTable.style.display = 'none';
                        noSavedProceduresMessage.style.display = 'block';
                    }
                } catch (error) {
                    console.error('Exception in fetchSavedProcedures:', error);
                    
                    // Hide loading spinner
                    loadingSpinner.style.display = 'none';
                    
                    // Show error message
                    errorMessage.textContent = 'Error loading saved procedures: ' + error.message;
                    errorMessage.style.display = 'block';
                    
                    // Hide table and show message
                    savedProceduresTable.style.display = 'none';
                    noSavedProceduresMessage.style.display = 'block';
                }
            }
            
            // Remove a procedure from selection
            function removeProcedure(procedureId) {
                if (selectedProcedures.has(procedureId)) {
                    const procedureName = selectedProcedures.get(procedureId).name;
                    selectedProcedures.delete(procedureId);
                    
                    // Update the button and card in the procedures list
                    const button = document.querySelector('.select-procedure[data-id="' + procedureId + '"]');
                    if (button) {
                        const card = button.closest('.procedure-card');
                        card.classList.remove('selected');
                        button.innerHTML = '<i class="fas fa-plus-circle"></i> Select';
                    }
                    
                    updateSelectionUI();
                }
            }
            
            // Function to remove a saved procedure from the examination
            async function removeSavedProcedure(procedureId, procedureName) {
                try {
                    if (!confirm(`Are you sure you want to remove the procedure "${procedureName}"?`)) {
                        return;
                    }
                    
                    const loadingSpinner = document.getElementById('loading-spinner');
                    const errorMessage = document.getElementById('error-message');
                    
                    // Show loading spinner
                    loadingSpinner.style.display = 'flex';
                    
                    // Get each part separately for debugging
                    const origin = window.location.origin;
                    const contextPath = '${pageContext.request.contextPath}';
                    const apiPath = '/patients/examination/' + examinationId + '/procedure/' + procedureId + '/remove';
                    
                    // Construct the final URL
                    const apiUrl = origin + contextPath + apiPath;
                    
                    console.log('Removing procedure with URL:', apiUrl);
                    
                    // Make the DELETE request
                    const response = await fetch(apiUrl, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'X-CSRF-TOKEN': csrfToken
                        }
                    });
                    
                    const result = await response.json();
                    
                    // Hide loading spinner
                    loadingSpinner.style.display = 'none';
                    
                    if (result.success) {
                        // Show success notification
                        showNotification(`Procedure "${procedureName}" has been successfully removed.`);
                        
                        // Refresh the saved procedures list
                        fetchSavedProcedures();
                        
                        // Refresh the page or just the procedure cards
                        location.reload(); // Simple approach: reload the page
                    } else {
                        // Show error message
                        errorMessage.textContent = result.message || 'Failed to remove procedure';
                        errorMessage.style.display = 'block';
                    }
                } catch (error) {
                    console.error('Error removing saved procedure:', error);
                    
                    // Hide loading spinner
                    const loadingSpinner = document.getElementById('loading-spinner');
                    loadingSpinner.style.display = 'none';
                    
                    // Show error message
                    const errorMessage = document.getElementById('error-message');
                    errorMessage.textContent = 'Error removing procedure: ' + error.message;
                    errorMessage.style.display = 'block';
                }
            }
            
            // Mark procedures that are already associated with this examination
            function markExistingProcedures() {
                // Get the list of existing procedure IDs from the hidden input
                const existingIdsInput = document.getElementById('existingProcedureIds');
                let hasExistingProcedures = false;
                
                if (existingIdsInput && existingIdsInput.value) {
                    const existingIds = existingIdsInput.value.split(',').filter(id => id.trim() !== '').map(id => id.trim());
                    
                    if (existingIds && existingIds.length > 0) {
                        // We have existing procedures, so enable the view button
                        hasExistingProcedures = true;
                        
                        // Get the error message elements
                        const duplicateError = document.getElementById('duplicate-procedures-error');
                        const duplicateList = document.getElementById('duplicate-procedures-list');
                        
                        // Clear previous errors
                        duplicateList.innerHTML = '';
                        
                        // Flag to track if we found any procedures
                        let foundProcedures = false;
                        
                        existingIds.forEach(procedureId => {
                            const card = document.querySelector(`.procedure-card[data-id="${procedureId}"]`);
                            if (card) {
                                foundProcedures = true;
                                card.classList.add('duplicate-error');
                                
                                // Get the procedure name from the card
                                const procedureName = card.querySelector('h3').textContent;
                                
                                // Add to error list
                                const listItem = document.createElement('li');
                                listItem.textContent = procedureName;
                                duplicateList.appendChild(listItem);
                                
                                // Disable the select button
                                const selectButton = card.querySelector('.select-procedure');
                                if (selectButton) {
                                    selectButton.disabled = true;
                                    selectButton.innerHTML = '<i class="fas fa-check-circle"></i> Added';
                                    selectButton.classList.add('already-added');
                                }
                            }
                        });
                        
                        // Show the error message if we found any procedures
                        if (foundProcedures) {
                            duplicateError.querySelector('strong').innerHTML = '<i class="fas fa-info-circle"></i> These procedures are already associated';
                            duplicateError.style.display = 'block';
                        }
                    }
                }
                
                // If no existing procedures and no selected procedures, disable the view button
                if (!hasExistingProcedures && selectedProcedures.size === 0) {
                    viewSelectedButton.disabled = true;
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
                    
                    // Don't handle clicks if this is a duplicate procedure
                    if (this.classList.contains('duplicate-error')) {
                        return;
                    }
                    
                    // Find the select button within this card
                    const selectButton = this.querySelector('.select-procedure');
                    if (selectButton && !selectButton.disabled) {
                        // Trigger a click on the select button
                        selectButton.click();
                    }
                });
            });
            
            // Handle procedure selection via the button
            const selectButtons = document.querySelectorAll('.select-procedure');
            
            selectButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    // Stop the event from bubbling up to the card to prevent double handling
                    e.stopPropagation();
                    
                    // Don't handle clicks if the button is disabled
                    if (this.disabled) {
                        return;
                    }
                    
                    const procedureId = this.dataset.id;
                    const procedureName = this.dataset.name;
                    const procedurePrice = this.dataset.price;
                    const card = this.closest('.procedure-card');
                    
                    if (selectedProcedures.has(procedureId)) {
                        // Deselect procedure
                        selectedProcedures.delete(procedureId);
                        card.classList.remove('selected');
                        this.innerHTML = '<i class="fas fa-plus-circle"></i> Select';
                    } else {
                        // Select procedure
                        selectedProcedures.set(procedureId, {
                            name: procedureName,
                            price: procedurePrice
                        });
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
            
            // Open modal when view selected button is clicked
            viewSelectedButton.addEventListener('click', function() {
                try {
                    console.log('View selected button clicked');
                    
                    if (!selectedProceduresModal) {
                        console.error('Modal element is null or undefined');
                        return;
                    }
                    
                    // Check if there are any selected procedures or any saved procedures
                    const hasSelectedProcedures = selectedProcedures.size > 0;
                    const hasNoProceduresAttr = viewSelectedButton.hasAttribute('data-no-procedures');
                    
                    if (!hasSelectedProcedures && hasNoProceduresAttr) {
                        // Show notification error
                        showNotification('No procedures available to view. Please select procedures or add procedures to the examination.', true);
                        return; // Don't open the modal
                    }
                    
                    // Update the content of currently selected procedures
                    updateSelectedProceduresModal();
                    
                    // Fetch saved procedures from the server
                    fetchSavedProcedures();
                    
                    // Use the utility function to show the modal
                    showModal(selectedProceduresModal);
                } catch (error) {
                    console.error('Error opening modal:', error);
                    alert('There was an error opening the procedures modal. Please try again or refresh the page.');
                }
            });
            
            // Initialize UI
            updateSelectionUI();
            
            // Check if there are existing procedures
            const existingIdsInput = document.getElementById('existingProcedureIds');
            if (existingIdsInput && existingIdsInput.value) {
                const existingIds = existingIdsInput.value.split(',').filter(id => id.trim() !== '').map(id => id.trim());
                if (existingIds && existingIds.length > 0) {
                    // We have existing procedures
                    viewSelectedButton.removeAttribute('data-no-procedures');
                } else {
                    // No existing procedures
                    viewSelectedButton.setAttribute('data-no-procedures', 'true');
                }
            } else {
                // No existing procedures input found
                viewSelectedButton.setAttribute('data-no-procedures', 'true');
            }
            
            // Mark existing procedures
            markExistingProcedures();
            
            // Handle submission of multiple procedures
            submitButton.addEventListener('click', async function() {
                if (selectedProcedures.size === 0) {
                    showNotification('Please select at least one procedure', true);
                    return;
                }
                
                const examinationId = '${examination.id}';
                const procedureIds = Array.from(selectedProcedures.keys());
                
                try {
                    // Here you would make an API call to submit all selected procedures
                    showNotification(selectedProcedures.size + ' procedures selected for submission');
                    
                    // Example of how you might submit all procedures at once
                    const response = await fetch('${pageContext.request.contextPath}/patients/examination/start-procedures', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'X-CSRF-TOKEN': csrfToken
                        },
                        body: JSON.stringify({
                            examinationId: examinationId,
                            procedureIds: procedureIds,
                            totalAmount: calculateTotalAmount().toFixed(2)
                        })
                    });
                    
                    // Parse the response
                    const result = await response.json();
                    
                    if (result.success) {
                        showNotification('Successfully started ' + result.procedureCount + ' procedures');
                        
                        // Redirect after a short delay
                        setTimeout(() => {
                            if (result.redirect) {
                                window.location.href = '${pageContext.request.contextPath}' + result.redirect;
                            } else {
                                window.location.href = '${pageContext.request.contextPath}/patients/examination/${examination.id}';
                            }
                        }, 1500);
                    } else {
                        // Check if there are duplicate procedures
                        if (result.duplicateProcedures && result.duplicateProcedures.details) {
                            // Show error message near the submit button
                            const duplicateError = document.getElementById('duplicate-procedures-error');
                            const duplicateList = document.getElementById('duplicate-procedures-list');
                            
                            // Clear previous errors
                            duplicateList.innerHTML = '';
                            
                            // Add each duplicate procedure to the list
                            result.duplicateProcedures.details.forEach(duplicate => {
                                const duplicateId = duplicate.id;
                                const duplicateName = duplicate.name;
                                
                                // Add to error list
                                const listItem = document.createElement('li');
                                listItem.textContent = duplicateName;
                                duplicateList.appendChild(listItem);
                                
                                // Highlight the card but don't add warning icon
                                const duplicateCard = document.querySelector(`.procedure-card[data-id="${duplicateId}"]`);
                                if (duplicateCard) {
                                    duplicateCard.classList.add('duplicate-error');
                                    
                                    // Remove the duplicate from selection
                                    removeProcedure(duplicateId);
                                }
                            });
                            
                            // Show the error message
                            duplicateError.style.display = 'block';
                            
                            // Scroll to the error message
                            duplicateError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            
                            // Don't show the top notification since we're showing the specific error near the submit button
                        } else {
                            // Only show the top notification if we're not showing duplicate errors
                            showNotification('Error: ' + (result.message || 'Unknown error occurred'), true);
                        }
                    }
                    
                } catch (error) {
                    console.error('Error submitting procedures:', error);
                    
                    // Only show the notification if the duplicate error isn't already visible
                    const duplicateError = document.getElementById('duplicate-procedures-error');
                    if (!duplicateError || duplicateError.style.display !== 'block') {
                        showNotification('Error: ' + error.message, true);
                    }
                }
            });
        });
    </script>
</body>
</html> 