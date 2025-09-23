<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
                    <!DOCTYPE html>
                    <html>

                    <head>
                        <meta charset="UTF-8">
                        <meta name="_csrf" content="${_csrf.token}" />
                        <title>Appointment Management - PeriDesk</title>
                        <jsp:include page="/WEB-INF/views/common/head.jsp" />
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                        <script src="${pageContext.request.contextPath}/js/common.js"></script>
                        <link
                            href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
                            rel="stylesheet">
                        <link rel="stylesheet"
                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                        <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
                        <!-- FullCalendar (jQuery v3) via jsDelivr to avoid ORB on cdnjs -->
                        <link rel="stylesheet"
                            href="https://cdn.jsdelivr.net/npm/fullcalendar@3.10.5/dist/fullcalendar.min.css" />
                        <script src="https://cdn.jsdelivr.net/npm/moment@2.29.4/min/moment.min.js"></script>
                        <script
                            src="https://cdn.jsdelivr.net/npm/fullcalendar@3.10.5/dist/fullcalendar.min.js"></script>

                        <!-- Flatpickr CSS and JS -->
                        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
                        <link rel="stylesheet"
                            href="https://cdn.jsdelivr.net/npm/flatpickr/dist/themes/material_blue.css">
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

                            .welcome-container {
                                display: flex;
                                min-height: 100vh;
                            }

                            .main-content {
                                flex: 1;
                                padding: 40px;
                                position: relative;
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

                            .card {
                                background: white;
                                border-radius: 12px;
                                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
                                margin-bottom: 30px;
                                overflow: hidden;
                            }

                            .card-header {
                                padding: 20px;
                                background: #f8f9fa;
                                border-bottom: 1px solid #f0f0f0;
                            }

                            .card-title {
                                margin: 0;
                                font-size: 1.2rem;
                                color: #2c3e50;
                                font-weight: 600;
                            }

                            .card-body {
                                padding: 20px;
                            }

                            .appointments-table {
                                width: 100%;
                                border-collapse: separate;
                                border-spacing: 0;
                            }

                            .appointments-table th {
                                background: #f8f9fa;
                                padding: 15px;
                                text-align: left;
                                font-weight: 600;
                                color: #2c3e50;
                                border-bottom: 2px solid #e0e0e0;
                            }

                            .appointments-table td {
                                padding: 15px;
                                border-bottom: 1px solid #e0e0e0;
                                vertical-align: middle;
                            }

                            .appointments-table tr:last-child td {
                                border-bottom: none;
                            }

                            .appointments-table tr:hover {
                                background-color: #f8f9fa;
                            }

                            .appointment-info {
                                display: flex;
                                flex-direction: column;
                                gap: 5px;
                            }

                            .patient-name {
                                font-weight: 500;
                                color: #2c3e50;
                                display: flex;
                                align-items: center;
                                gap: 8px;
                            }

                            .patient-name.registered {
                                color: #27ae60;
                            }

                            .patient-name.unregistered {
                                color: #e74c3c;
                            }

                            .patient-name-link {
                                text-decoration: none;
                                color: inherit;
                                transition: all 0.2s ease;
                            }

                            .patient-name-link.registered-patient:hover {
                                text-decoration: none;
                            }

                            .patient-name-link.registered-patient:hover .patient-name.registered {
                                color: #2980b9;
                                cursor: pointer;
                                transform: translateX(2px);
                            }

                            .patient-name.unregistered:hover {
                                color: #c0392b;
                                cursor: help;
                            }

                            /* Calendar event styling for registered vs unregistered patients */
                            .fc-event.registered-patient {
                                border-left: 4px solid #27ae60 !important;
                                cursor: pointer;
                            }

                            .fc-event.unregistered-patient {
                                border-left: 4px solid #e74c3c !important;
                                cursor: help;
                            }

                            .fc-event.registered-patient:hover {
                                box-shadow: 0 2px 8px rgba(39, 174, 96, 0.3);
                                transform: translateY(-1px);
                            }

                            .fc-event.unregistered-patient:hover {
                                box-shadow: 0 2px 8px rgba(231, 76, 60, 0.3);
                            }

                            .patient-name i {
                                font-size: 0.9rem;
                            }

                            .patient-mobile {
                                font-family: 'Courier New', monospace;
                                font-weight: 500;
                                color: #7f8c8d;
                                font-size: 0.9rem;
                            }

                            .appointment-datetime {
                                display: flex;
                                flex-direction: column;
                                gap: 3px;
                            }

                            .appointment-date {
                                font-weight: 500;
                                color: #2c3e50;
                                font-size: 0.9rem;
                            }

                            .appointment-time {
                                color: #7f8c8d;
                                font-size: 0.85rem;
                                display: flex;
                                align-items: center;
                                gap: 5px;
                            }

                            .doctor-info {
                                color: #7f8c8d;
                                font-size: 0.9rem;
                                display: flex;
                                align-items: center;
                                gap: 5px;
                            }

                            .patient-registration-id {
                                font-family: 'Courier New', monospace;
                                font-weight: 500;
                                color: #2c3e50;
                                font-size: 0.9rem;
                            }

                            .appointment-notes {
                                max-width: 200px;
                            }

                            .notes {
                                color: #7f8c8d;
                                font-size: 0.85rem;
                                line-height: 1.4;
                                display: -webkit-box;
                                -webkit-line-clamp: 2;
                                -webkit-box-orient: vertical;
                                overflow: hidden;
                                text-overflow: ellipsis;
                            }

                            .status-badge {
                                font-size: 0.8rem;
                                padding: 0.25rem 0.75rem;
                                border-radius: 20px;
                                font-weight: 500;
                                display: inline-block;
                            }

                            .status-scheduled {
                                background-color: #e3f2fd;
                                color: #1976d2;
                            }

                            .status-checked-in {
                                background-color: #e8f5e9;
                                color: #2e7d32;
                            }

                            .status-in-progress {
                                background-color: #fff3e0;
                                color: #f57c00;
                            }

                            .status-completed {
                                background-color: #e3f2fd;
                                color: #1976d2;
                            }

                            .status-cancelled {
                                background-color: #ffebee;
                                color: #c62828;
                            }

                            /* Calendar view styles */
                            .calendar-toolbar {
                                display: flex;
                                flex-direction: column;
                                gap: 10px;
                                margin-bottom: 16px;
                            }

                            .calendar-toolbar .btn {
                                padding: 8px 12px;
                                border-radius: 8px;
                                cursor: pointer;
                                border: none;
                            }

                            .toolbar-row {
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                                gap: 8px;
                                flex-wrap: wrap;
                            }

                            .calendar-view-toggle {
                                display: flex;
                                gap: 4px;
                            }

                            .calendar-view-toggle .btn {
                                padding: 6px 12px;
                                font-size: 0.9rem;
                            }

                            /* FullCalendar view-specific styles */
                            .fc-agendaWeek-view .fc-time-grid-event {
                                font-size: 11px;
                                padding: 2px 4px;
                            }

                            .fc-month-view .fc-event {
                                font-size: 11px;
                                padding: 1px 3px;
                                margin: 1px 0;
                            }

                            .fc-month-view .fc-day-number {
                                font-weight: 600;
                                color: #2c3e50;
                            }

                            .fc-agendaWeek-view .fc-axis {
                                font-size: 11px;
                            }

                            .fc-agendaWeek-view .fc-day-header {
                                font-weight: 600;
                                padding: 8px 0;
                            }

                            .nav-row {
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                                gap: 10px;
                                flex-wrap: nowrap;
                                width: 100%;
                            }

                            .view-toggle {
                                display: inline-flex;
                                gap: 8px;
                                align-items: center;
                                flex-wrap: nowrap;
                            }

                            .view-toggle .btn {
                                white-space: nowrap;
                            }

                            .doctor-filter {
                                display: inline-flex;
                                align-items: center;
                                gap: 8px;
                            }

                            .doctor-filter select {
                                padding: 6px 10px;
                                border: 1px solid #dee2e6;
                                border-radius: 8px;
                                font-size: 14px;
                            }

                            .date-label {
                                flex: 1 1 auto;
                                text-align: center;
                                font-weight: 600;
                                white-space: nowrap;
                            }

                            .nav-row .btn {
                                padding: 4px 8px;
                                line-height: 1.1;
                            }

                            .nav-row .btn i {
                                margin: 0;
                            }

                            /* Bold current time marker in FullCalendar agenda view */
                            .fc-unthemed .fc-time-grid .fc-now-indicator-line {
                                border-top: 3px solid #e74c3c;
                            }

                            .fc-unthemed .fc-time-grid .fc-now-indicator-arrow {
                                border-width: 8px;
                                border-top-color: #e74c3c;
                            }

                            .calendar-container {
                                position: relative;
                                height: 900px;
                                overflow: auto;
                                border: 1px solid #e0e0e0;
                                border-radius: 8px;
                                background: #fff;
                            }

                            .calendar-time-axis {
                                position: absolute;
                                left: 0;
                                top: 0;
                                width: 70px;
                                background: #f8f9fa;
                                border-right: 1px solid #e0e0e0;
                                height: 1440px;
                            }

                            .calendar-time-label {
                                position: absolute;
                                left: 0;
                                width: 100%;
                                text-align: right;
                                padding-right: 8px;
                                color: #7f8c8d;
                                font-size: 12px;
                            }

                            .calendar-day-column {
                                margin-left: 70px;
                                position: relative;
                                height: 1440px;
                                background: linear-gradient(#ffffff 49px, #f8f9fa 50px);
                                background-size: 100% 60px;
                            }

                            .calendar-hour-line {
                                position: absolute;
                                left: 0;
                                right: 0;
                                height: 1px;
                                background: #eaecee;
                            }

                            .calendar-event {
                                position: absolute;
                                left: 8px;
                                right: 8px;
                                background: #e3f2fd;
                                border-left: 4px solid #1976d2;
                                color: #2c3e50;
                                border-radius: 8px;
                                padding: 8px 10px;
                                font-size: 13px;
                                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.06);
                                overflow: hidden;
                            }

                            .calendar-event .title {
                                font-weight: 600;
                            }

                            .calendar-event .meta {
                                font-size: 12px;
                                color: #607d8b;
                                margin-top: 2px;
                            }

                            .calendar-legend {
                                display: flex;
                                gap: 10px;
                                align-items: center;
                                margin-top: 8px;
                                color: #7f8c8d;
                                font-size: 0.85rem;
                            }

                            .legend-dot {
                                display: inline-block;
                                width: 10px;
                                height: 10px;
                                border-radius: 50%;
                                margin-right: 6px;
                            }

                            .legend-scheduled {
                                background: #1976d2;
                            }

                            .legend-checked-in {
                                background: #2e7d32;
                            }

                            .legend-in-progress {
                                background: #f57c00;
                            }

                            .legend-completed {
                                background: #6c63ff;
                            }

                            .legend-cancelled {
                                background: #c62828;
                            }

                            .create-appointment-btn {
                                background: linear-gradient(135deg, #3498db, #2980b9);
                                color: white;
                                border: none;
                                border-radius: 6px;
                                padding: 12px 24px;
                                font-size: 0.95rem;
                                font-weight: 500;
                                cursor: pointer;
                                transition: all 0.3s;
                                display: inline-flex;
                                align-items: center;
                                gap: 8px;
                            }

                            .create-appointment-btn:hover {
                                background: linear-gradient(135deg, #2980b9, #1c6ea4);
                                box-shadow: 0 4px 8px rgba(52, 152, 219, 0.2);
                            }

                            .btn-outline-primary {
                                background: transparent;
                                color: #3498db;
                                border: 1px solid #3498db;
                                border-radius: 6px;
                                padding: 8px 16px;
                                font-size: 0.85rem;
                                font-weight: 500;
                                cursor: pointer;
                                transition: all 0.3s;
                            }

                            .btn-outline-primary:hover:not(:disabled) {
                                background: #3498db;
                                color: white;
                            }

                            .btn-outline-primary:disabled {
                                background: #f5f5f5;
                                color: #999;
                                border-color: #ddd;
                                cursor: not-allowed;
                                opacity: 0.7;
                            }

                            .btn-outline-primary.active {
                                background: #3498db;
                                color: white;
                            }

                            .modal-backdrop {
                                background-color: rgba(0, 0, 0, 0.5);
                            }

                            .modal-backdrop.show {
                                opacity: 1;
                            }

                            .modal {
                                display: none;
                                position: fixed;
                                z-index: 1050;
                                left: 0;
                                top: 0;
                                width: 100%;
                                height: 100%;
                                overflow-x: hidden;
                                overflow-y: auto;
                                outline: 0;
                            }

                            .modal-dialog {
                                position: relative;
                                width: auto;
                                margin: 1.75rem auto;
                                max-width: 600px;
                                pointer-events: none;
                            }

                            .modal-dialog-centered {
                                display: flex;
                                align-items: center;
                                min-height: calc(100% - 3.5rem);
                            }

                            .modal-content {
                                position: relative;
                                display: flex;
                                flex-direction: column;
                                width: 100%;
                                pointer-events: auto;
                                background-color: #fff;
                                background-clip: padding-box;
                                border: 1px solid rgba(0, 0, 0, 0.2);
                                border-radius: 12px;
                                outline: 0;
                                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                            }

                            .modal-header {
                                display: flex;
                                flex-shrink: 0;
                                align-items: center;
                                justify-content: space-between;
                                padding: 1.5rem;
                                border-bottom: 1px solid #eee;
                                border-top-left-radius: 12px;
                                border-top-right-radius: 12px;
                            }

                            .modal-title {
                                margin: 0;
                                line-height: 1.5;
                                font-size: 1.25rem;
                                font-weight: 600;
                                color: #2c3e50;
                            }

                            .modal-body {
                                position: relative;
                                flex: 1 1 auto;
                                padding: 1.5rem;
                            }

                            .modal-footer {
                                display: flex;
                                flex-wrap: wrap;
                                flex-shrink: 0;
                                align-items: center;
                                justify-content: flex-end;
                                padding: 1.5rem;
                                border-top: 1px solid #eee;
                                border-bottom-right-radius: 12px;
                                border-bottom-left-radius: 12px;
                                gap: 0.5rem;
                            }

                            .btn-close {
                                box-sizing: content-box;
                                width: 1em;
                                height: 1em;
                                padding: 0.25em;
                                color: #000;
                                background: transparent url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%23000'%3e%3cpath d='M.293.293a1 1 0 011.414 0L8 6.586 14.293.293a1 1 0 111.414 1.414L9.414 8l6.293 6.293a1 1 0 01-1.414 1.414L8 9.414l-6.293 6.293a1 1 0 01-1.414-1.414L6.586 8 .293 1.707a1 1 0 010-1.414z'/%3e%3c/svg%3e") center/1em auto no-repeat;
                                border: 0;
                                border-radius: 0.375rem;
                                opacity: 0.5;
                                cursor: pointer;
                                transition: opacity 0.15s ease-in-out;
                            }

                            .btn-close:hover {
                                opacity: 0.75;
                            }

                            .form-group {
                                margin-bottom: 1.5rem;
                            }

                            .form-group:last-child {
                                margin-bottom: 0;
                            }

                            .form-group label {
                                display: block;
                                margin-bottom: 0.5rem;
                                color: #2c3e50;
                                font-weight: 500;
                                font-size: 0.95rem;
                            }

                            .form-control {
                                display: block;
                                width: 100%;
                                padding: 0.75rem 1rem;
                                font-size: 0.95rem;
                                font-weight: 400;
                                line-height: 1.5;
                                color: #2c3e50;
                                background-color: #fff;
                                background-clip: padding-box;
                                border: 1px solid #ddd;
                                border-radius: 8px;
                                transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
                            }

                            .form-control:focus {
                                color: #2c3e50;
                                background-color: #fff;
                                border-color: #3498db;
                                outline: 0;
                                box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
                            }

                            .text-danger {
                                color: #dc3545;
                                font-size: 0.85rem;
                                margin-top: 0.25rem;
                            }

                            /* Reschedule styles */
                            .appointment-actions {
                                display: flex;
                                flex-direction: column;
                                gap: 8px;
                            }

                            .btn-outline-warning {
                                background: transparent;
                                color: #ffc107;
                                border: 1px solid #ffc107;
                                border-radius: 6px;
                                padding: 8px 16px;
                                font-size: 0.85rem;
                                font-weight: 500;
                                cursor: pointer;
                                transition: all 0.3s;
                            }

                            .btn-outline-warning:hover:not(:disabled) {
                                background: #ffc107;
                                color: #212529;
                            }

                            .btn-outline-warning:disabled {
                                background: #f5f5f5;
                                color: #999;
                                border-color: #ddd;
                                cursor: not-allowed;
                                opacity: 0.7;
                            }

                            .btn-outline-info {
                                background: transparent;
                                color: #17a2b8;
                                border: 1px solid #17a2b8;
                                border-radius: 6px;
                                padding: 6px 12px;
                                font-size: 0.8rem;
                                font-weight: 500;
                                cursor: pointer;
                                transition: all 0.3s;
                            }

                            .btn-outline-info:hover {
                                background: #17a2b8;
                                color: white;
                            }

                            .reschedule-count {
                                font-size: 0.75rem;
                                font-weight: 600;
                                margin-left: 4px;
                            }

                            .reschedule-status {
                                margin-top: 8px;
                            }

                            .reschedule-badge {
                                background: #fff3cd;
                                color: #856404;
                                padding: 4px 8px;
                                border-radius: 4px;
                                font-size: 0.75rem;
                                font-weight: 500;
                                display: inline-flex;
                                align-items: center;
                                gap: 4px;
                            }

                            .reschedule-history-list {
                                list-style: none;
                                padding: 0;
                                margin: 0;
                            }

                            .reschedule-history-list li {
                                background: #f8f9fa;
                                border: 1px solid #dee2e6;
                                border-radius: 8px;
                                padding: 15px;
                                margin-bottom: 10px;
                            }

                            .reschedule-history-list li:last-child {
                                margin-bottom: 0;
                            }

                            .reschedule-history-list strong {
                                color: #495057;
                                font-size: 1rem;
                            }

                            .reschedule-history-list span {
                                color: #6c757d;
                                font-size: 0.9rem;
                            }

                            @media (max-width: 768px) {
                                .modal-dialog {
                                    margin: 1rem;
                                    max-width: calc(100% - 2rem);
                                }

                                .modal-content {
                                    border-radius: 8px;
                                }

                                .modal-header,
                                .modal-body,
                                .modal-footer {
                                    padding: 1rem;
                                }
                            }

                            /* Custom tooltip styling */
                            .tooltip {
                                font-family: 'Poppins', sans-serif;
                            }

                            .tooltip .tooltip-inner {
                                background-color: #2c3e50;
                                color: white;
                                font-size: 0.85rem;
                                padding: 8px 12px;
                                border-radius: 6px;
                                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                            }

                            .tooltip.bs-tooltip-top .tooltip-arrow::before {
                                border-top-color: #2c3e50;
                            }

                            /* Flatpickr custom styles */
                            .flatpickr-calendar {
                                font-family: 'Poppins', sans-serif;
                                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                                border-radius: 12px;
                                border: none;
                            }

                            .flatpickr-day.selected {
                                background: #3498db;
                                border-color: #3498db;
                            }

                            .flatpickr-day:hover {
                                background: #e3f2fd;
                            }

                            .flatpickr-day.today {
                                border-color: #3498db;
                            }

                            .flatpickr-months .flatpickr-month {
                                background: #3498db;
                                color: white;
                                border-radius: 12px 12px 0 0;
                            }

                            .flatpickr-current-month .flatpickr-monthDropdown-months {
                                color: white;
                            }

                            .flatpickr-current-month .flatpickr-monthDropdown-months option {
                                color: #2c3e50;
                            }

                            .flatpickr-weekdays {
                                background: #f8f9fa;
                            }

                            .flatpickr-weekday {
                                color: #2c3e50;
                                font-weight: 500;
                            }

                            .date-picker-container {
                                position: relative;
                                min-width: 200px;
                                width: 220px;
                            }

                            .date-picker-container .form-control {
                                padding-left: 40px;
                                cursor: pointer;
                                width: 100%;
                                min-width: 200px;
                            }

                            .date-picker-container i {
                                position: absolute;
                                left: 12px;
                                top: 50%;
                                transform: translateY(-50%);
                                color: #3498db;
                                pointer-events: none;
                            }

                            .date-picker-container input:disabled {
                                background-color: #f8f9fa;
                                color: #6c757d;
                                cursor: not-allowed;
                                opacity: 0.7;
                            }

                            .date-picker-container input:disabled+i {
                                color: #6c757d;
                            }

                            .date-picker-container.disabled {
                                position: relative;
                            }

                            .date-picker-container.disabled::after {
                                content: '';
                                position: absolute;
                                top: 0;
                                left: 0;
                                right: 0;
                                bottom: 0;
                                background: rgba(248, 249, 250, 0.8);
                                border-radius: 8px;
                                pointer-events: none;
                                z-index: 1;
                            }

                            /* Disabled button styling */
                            .btn-outline-primary.disabled {
                                opacity: 0.6;
                                cursor: not-allowed;
                                background-color: #f8f9fa;
                                border-color: #dee2e6;
                                color: #6c757d;
                            }

                            .btn-outline-primary.disabled:hover {
                                background-color: #f8f9fa;
                                border-color: #dee2e6;
                                color: #6c757d;
                                transform: none;
                                box-shadow: none;
                            }

                            /* Mobile number validation styles */
                            .form-control.is-valid {
                                border-color: #28a745;
                                box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
                            }

                            .form-control.is-invalid {
                                border-color: #dc3545;
                                box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
                            }

                            .form-control.is-valid:focus {
                                border-color: #28a745;
                                box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
                            }

                            .form-control.is-invalid:focus {
                                border-color: #dc3545;
                                box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
                            }

                            #mobileError {
                                font-size: 0.875rem;
                                margin-top: 0.25rem;
                            }

                            /* Mobile input specific styling */
                            #patientMobile {
                                font-family: 'Courier New', monospace;
                                letter-spacing: 1px;
                            }

                            /* Pagination styles */
                            .pagination-container {
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                                margin-top: 20px;
                                padding: 15px;
                                background: white;
                                border-radius: 8px;
                                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                            }

                            .pagination-info {
                                color: #666;
                                font-size: 14px;
                            }

                            .pagination-controls {
                                display: flex;
                                gap: 10px;
                                align-items: center;
                            }

                            .pagination-button {
                                padding: 8px 12px;
                                border: 1px solid #ddd;
                                background: white;
                                color: #333;
                                text-decoration: none;
                                border-radius: 4px;
                                font-size: 14px;
                                transition: all 0.3s ease;
                                cursor: pointer;
                            }

                            .pagination-button:hover {
                                background: #f8f9fa;
                                border-color: #007bff;
                                color: #007bff;
                            }

                            .pagination-button:disabled {
                                background: #f8f9fa;
                                color: #6c757d;
                                cursor: not-allowed;
                                border-color: #dee2e6;
                            }

                            .pagination-button.active {
                                background: #007bff;
                                color: white;
                                border-color: #007bff;
                            }

                            .page-size-selector {
                                display: flex;
                                align-items: center;
                                gap: 8px;
                            }

                            .page-size-selector select {
                                padding: 6px 10px;
                                border: 1px solid #ddd;
                                border-radius: 4px;
                                font-size: 14px;
                            }

                            .sort-controls {
                                display: flex;
                                align-items: center;
                                gap: 8px;
                            }

                            .sort-controls select {
                                padding: 6px 10px;
                                border: 1px solid #ddd;
                                border-radius: 4px;
                                font-size: 14px;
                            }

                            @media (max-width: 768px) {
                                .pagination-container {
                                    flex-direction: column;
                                    gap: 15px;
                                    align-items: stretch;
                                }

                                .pagination-controls {
                                    flex-wrap: wrap;
                                    justify-content: center;
                                }
                            }
                        </style>
                    </head>

                    <body>
                        <div class="welcome-container">
                            <jsp:include page="/WEB-INF/views/common/menu.jsp" />

                            <div class="main-content">
                                <div class="welcome-header">
                                    <h1 class="welcome-message">Appointment Management</h1>
                                    <div style="display: flex; gap: 15px; align-items: center;">
                                        <div class="form-group date-picker-container ${myAppointments ? 'disabled' : ''}"
                                            style="margin: 0;" data-bs-toggle="tooltip" data-bs-placement="top"
                                            title="${myAppointments ? 'Date picker is disabled when viewing My Appointments' : 'Select a date to view appointments'}">
                                            <i class="fas fa-calendar"></i>
                                            <input type="text" id="appointmentDate" class="form-control"
                                                value="${selectedDate}" placeholder="Select Date" ${myAppointments
                                                ? 'disabled' : '' }>
                                        </div>
                                        <input type="hidden" id="myAppointmentsState" value="${myAppointments}">
                                        <sec:authorize access="hasRole('DOCTOR') or hasRole('OPD_DOCTOR')">
                                            <button class="btn-outline-primary ${myAppointments ? 'active' : ''}"
                                                id="myAppointmentsBtn" onclick="toggleMyAppointments()"
                                                data-bs-toggle="tooltip" data-bs-placement="top"
                                                title="View your upcoming appointments">
                                                <i class="fas fa-user"></i> My Appointments
                                            </button>
                                        </sec:authorize>
                                        <sec:authorize access="hasRole('RECEPTIONIST')">
                                            <button class="btn-outline-primary disabled" id="myAppointmentsBtn" disabled
                                                data-bs-toggle="tooltip" data-bs-placement="top"
                                                title="My Appointments feature is not available for Receptionist role">
                                                <i class="fas fa-user"></i> My Appointments
                                            </button>
                                        </sec:authorize>
                                        <sec:authorize access="hasAnyRole('RECEPTIONIST', 'ADMIN')">
                                            <button class="create-appointment-btn"
                                                onclick="openCreateAppointmentModal()">
                                                <i class="fas fa-plus-circle"></i> Create New Appointment
                                            </button>
                                        </sec:authorize>
                                    </div>
                                </div>
                                <div class="alert alert-info" style="margin: 20px 0 0 0;">
                                    <strong>Status Legend:</strong>
                                    <ul style="margin-bottom: 0;">
                                        <li><strong>Scheduled</strong>: Appointment is scheduled and upcoming.</li>
                                        <li><strong>Completed</strong>: Appointment has been completed.</li>
                                        <li><strong>Cancelled</strong>: Appointment was cancelled by the patient or
                                            staff.</li>
                                        <li><strong>No Show</strong>: Patient did not show up for the appointment.</li>
                                    </ul>
                                </div>

                                <!-- Main Content -->
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title">
                                            <i class="fas fa-calendar-check"></i>
                                            ${myAppointments ? 'My Upcoming Appointments' : 'Appointments'}
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <!-- Calendar/List Toggle and Navigation -->
                                        <div class="calendar-toolbar">
                                            <div class="toolbar-row">
                                                <div class="view-toggle">
                                                    <button id="calendarViewBtn" class="btn btn-primary"
                                                        type="button"><i class="fas fa-calendar-week"></i>
                                                        Calendar</button>
                                                    <button id="listViewBtn" class="btn btn-secondary" type="button"><i
                                                            class="fas fa-list"></i> List</button>
                                                </div>
                                                <div class="calendar-view-toggle" id="calendarViewToggle"
                                                    style="display: flex;">
                                                    <button id="dayViewBtn"
                                                        class="btn ${currentView == 'day' ? 'btn-primary' : 'btn-outline-primary'}"
                                                        type="button">
                                                        <i class="fas fa-calendar-day"></i> Day
                                                    </button>
                                                    <button id="weekViewBtn"
                                                        class="btn ${currentView == 'week' ? 'btn-primary' : 'btn-outline-primary'}"
                                                        type="button">
                                                        <i class="fas fa-calendar-week"></i> Week
                                                    </button>
                                                    <button id="monthViewBtn"
                                                        class="btn ${currentView == 'month' ? 'btn-primary' : 'btn-outline-primary'}"
                                                        type="button">
                                                        <i class="fas fa-calendar"></i> Month
                                                    </button>
                                                </div>
                                                <div class="doctor-filter" id="doctorFilterContainer">
                                                    <label for="doctorFilter"
                                                        style="color:#7f8c8d; font-size: 0.9rem;">Sort by
                                                        doctor:</label>
                                                    <select id="doctorFilter">
                                                        <option value="">All</option>
                                                    </select>
                                                </div>
                                                <button id="todayBtn" class="btn btn-secondary"
                                                    type="button">Today</button>
                                            </div>
                                            <div class="toolbar-row nav-row">
                                                <button id="prevDayBtn" class="btn btn-secondary" type="button"
                                                    title="Previous Day"><i class="fas fa-chevron-left"></i></button>
                                                <div id="calendarDateLabel" class="date-label"></div>
                                                <button id="nextDayBtn" class="btn btn-secondary" type="button"
                                                    title="Next Day"><i class="fas fa-chevron-right"></i></button>
                                            </div>
                                        </div>

                                        <!-- Calendar View (FullCalendar) -->
                                        <div id="calendarView" style="display:block;">
                                            <div id="appointmentsCalendar"></div>
                                        </div>
                                        <c:if test="${not empty successMessage}">
                                            <div class="alert alert-success">
                                                <i class="fas fa-check-circle"></i> ${successMessage}
                                            </div>
                                        </c:if>

                                        <c:if test="${not empty errorMessage}">
                                            <div class="alert alert-danger">
                                                <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                                            </div>
                                        </c:if>

                                        <div id="listView" style="display:none;">
                                            <c:choose>
                                                <c:when test="${empty appointments}">
                                                    <div class="text-center py-5">
                                                        <i class="fas fa-calendar-times fa-4x text-muted mb-4"></i>
                                                        <h3 class="text-muted mb-3">No Appointments Found</h3>
                                                        <p class="text-muted mb-4">
                                                            ${myAppointments ?
                                                            'You have no upcoming appointments.' :
                                                            'There are no appointments scheduled for the selected
                                                            date.'}
                                                        </p>
                                                        <sec:authorize access="hasAnyRole('RECEPTIONIST', 'ADMIN')">
                                                            <button class="create-appointment-btn"
                                                                onclick="openCreateAppointmentModal()">
                                                                <i class="fas fa-plus-circle"></i> Schedule New
                                                                Appointment
                                                            </button>
                                                        </sec:authorize>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <table class="appointments-table">
                                                        <thead>
                                                            <tr>
                                                                <th>Patient</th>
                                                                <th>Mobile</th>
                                                                <th>Registration ID</th>
                                                                <th>Date & Time</th>
                                                                <th>Doctor</th>
                                                                <th>Status</th>
                                                                <th>Notes</th>
                                                                <th>Actions</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach items="${appointments}" var="appointment">
                                                                <tr>
                                                                    <td>
                                                                        <div class="appointment-info">
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${appointment.patient != null}">
                                                                                    <a href="${pageContext.request.contextPath}/patients/details/${appointment.patient.id}"
                                                                                        class="patient-name-link registered-patient"
                                                                                        title="Click to view patient details (Registered Patient)">
                                                                                        <span
                                                                                            class="patient-name registered">
                                                                                            <i
                                                                                                class="fas fa-user-check"></i>
                                                                                            ${appointment.patientName !=
                                                                                            null ?
                                                                                            appointment.patientName :
                                                                                            appointment.patientMobile}
                                                                                        </span>
                                                                                    </a>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span
                                                                                        class="patient-name unregistered"
                                                                                        title="Patient is not registered">
                                                                                        <i
                                                                                            class="fas fa-user-times"></i>
                                                                                        ${appointment.patientName !=
                                                                                        null ? appointment.patientName :
                                                                                        appointment.patientMobile}
                                                                                    </span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                    </td>
                                                                    <td>
                                                                        <div class="appointment-info">
                                                                            <span class="patient-mobile">
                                                                                ${appointment.patientMobile != null ?
                                                                                appointment.patientMobile : '-'}
                                                                            </span>
                                                                        </div>
                                                                    </td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${appointment.patient != null}">
                                                                                <span class="appointment-info"
                                                                                    data-bs-toggle="tooltip"
                                                                                    data-bs-placement="top"
                                                                                    title="Patient Registration ID: ${appointment.patient.registrationCode}">
                                                                                    <span
                                                                                        class="patient-registration-id">${appointment.patient.registrationCode}</span>
                                                                                </span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="appointment-info"
                                                                                    data-bs-toggle="tooltip"
                                                                                    data-bs-placement="top"
                                                                                    title="No patient assigned">
                                                                                    <span
                                                                                        class="patient-registration-id">N/A</span>
                                                                                </span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td>
                                                                        <div class="appointment-datetime">
                                                                            <fmt:parseDate
                                                                                value="${appointment.appointmentDateTime}"
                                                                                pattern="yyyy-MM-dd'T'HH:mm"
                                                                                var="parsedDate" type="both" />
                                                                            <div class="appointment-date">
                                                                                <fmt:formatDate value="${parsedDate}"
                                                                                    pattern="dd/MM/yyyy" />
                                                                            </div>
                                                                            <div class="appointment-time">
                                                                                <i class="fas fa-clock"></i>
                                                                                <fmt:formatDate value="${parsedDate}"
                                                                                    pattern="hh:mm a" />
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${appointment.doctor != null}">
                                                                                <div class="doctor-info">
                                                                                    <i class="fas fa-user-md"></i>
                                                                                    ${appointment.doctor.firstName}
                                                                                    ${appointment.doctor.lastName}
                                                                                </div>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <div class="doctor-info">
                                                                                    <i class="fas fa-user-md"></i>
                                                                                    Unassigned
                                                                                </div>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td>
                                                                        <span
                                                                            class="status-badge status-${appointment.status.toString().toLowerCase()}">
                                                                            ${appointment.status}
                                                                        </span>
                                                                    </td>
                                                                    <td>
                                                                        <div class="appointment-notes"
                                                                            data-bs-toggle="tooltip"
                                                                            data-bs-placement="top"
                                                                            title="${appointment.notes != null && !appointment.notes.isEmpty() ? appointment.notes : 'No notes'}">
                                                                            <span class="notes">
                                                                                ${appointment.notes != null &&
                                                                                !appointment.notes.isEmpty() ?
                                                                                appointment.notes : '-'}
                                                                            </span>
                                                                        </div>
                                                                    </td>
                                                                    <td>
                                                                        <div class="appointment-actions">
                                                                            <sec:authorize
                                                                                access="hasAnyRole('RECEPTIONIST', 'ADMIN')">
                                                                                <button class="btn-outline-primary"
                                                                                    onclick="showAppointmentDetails('${appointment.id}')"
                                                                                    ${appointment.status=='CANCELLED' ||
                                                                                    appointment.status=='NO_SHOW' ||
                                                                                    appointment.status=='COMPLETED'
                                                                                    ? 'disabled' : '' }
                                                                                    data-bs-toggle="tooltip"
                                                                                    data-bs-placement="top"
                                                                                    data-bs-custom-class="custom-tooltip"
                                                                                    title="${appointment.status == 'CANCELLED' || appointment.status == 'NO_SHOW' || appointment.status == 'COMPLETED' ? 'Cannot transition from terminal status' : 'Update appointment status'}">
                                                                                    <i class="fas fa-eye"></i> Details
                                                                                </button>

                                                                                <!-- Reschedule button -->
                                                                                <fmt:parseDate
                                                                                    value="${appointment.appointmentDateTime}"
                                                                                    pattern="yyyy-MM-dd'T'HH:mm"
                                                                                    var="parsedDate" type="both" />
                                                                                <fmt:formatDate value="${parsedDate}"
                                                                                    pattern="dd/MM/yyyy"
                                                                                    var="formattedDate" />
                                                                                <fmt:formatDate value="${parsedDate}"
                                                                                    pattern="hh:mm a"
                                                                                    var="formattedTime" />
                                                                                <button class="btn-outline-warning"
                                                                                    onclick="showRescheduleModal('${appointment.id}', '${formattedDate} ${formattedTime}', '${appointment.appointmentDateTime}')"
                                                                                    ${appointment.status=='CANCELLED' ||
                                                                                    appointment.status=='NO_SHOW' ||
                                                                                    appointment.status=='COMPLETED'
                                                                                    ? 'disabled' : '' }
                                                                                    data-bs-toggle="tooltip"
                                                                                    title="Reschedule appointment">
                                                                                    <i class="fas fa-calendar-alt"></i>
                                                                                    Reschedule
                                                                                    <c:if
                                                                                        test="${appointment.rescheduledCount > 0}">
                                                                                        <span
                                                                                            class="reschedule-count">(${appointment.rescheduledCount}/3)</span>
                                                                                    </c:if>
                                                                                </button>

                                                                                <!-- Reschedule history button -->
                                                                                <c:if
                                                                                    test="${appointment.rescheduledCount > 0}">
                                                                                    <button
                                                                                        class="btn-outline-info btn-sm"
                                                                                        onclick="showRescheduleHistory('${appointment.id}')"
                                                                                        data-bs-toggle="tooltip"
                                                                                        title="View reschedule history">
                                                                                        <i class="fas fa-history"></i>
                                                                                        History
                                                                                    </button>
                                                                                </c:if>
                                                                            </sec:authorize>
                                                                            <sec:authorize
                                                                                access="hasRole('DOCTOR') or hasRole('OPD_DOCTOR')">
                                                                                <span
                                                                                    style="color: #6c757d; font-style: italic; font-size: 0.9em;">Status
                                                                                    updates disabled for Doctor
                                                                                    Role</span>
                                                                            </sec:authorize>

                                                                            <!-- Reschedule status indicator -->
                                                                            <c:if
                                                                                test="${appointment.rescheduledCount > 0}">
                                                                                <div class="reschedule-status">
                                                                                    <span class="reschedule-badge">
                                                                                        <i class="fas fa-history"></i>
                                                                                        Rescheduled
                                                                                        ${appointment.rescheduledCount}x
                                                                                    </span>
                                                                                </div>
                                                                            </c:if>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <!-- Pagination Controls (List view only) -->
                                        <c:if test="${totalPages > 1 or not empty appointments}">
                                            <div class="pagination-container">
                                                <div class="pagination-info">
                                                    Showing ${(currentPage * pageSize) + 1} to ${(currentPage *
                                                    pageSize) + fn:length(appointments)} of ${totalItems} appointments
                                                </div>

                                                <div class="pagination-controls">
                                                    <!-- Page Size Selector -->
                                                    <div class="page-size-selector">
                                                        <label for="pageSize">Show:</label>
                                                        <select id="pageSize" onchange="changePageSize(this.value)">
                                                            <option value="10" ${pageSize==10 ? 'selected' : '' }>10
                                                            </option>
                                                            <option value="20" ${pageSize==20 ? 'selected' : '' }>20
                                                            </option>
                                                            <option value="50" ${pageSize==50 ? 'selected' : '' }>50
                                                            </option>
                                                            <option value="100" ${pageSize==100 ? 'selected' : '' }>100
                                                            </option>
                                                        </select>
                                                    </div>

                                                    <!-- Sort Controls (only in list view) -->
                                                    <div class="sort-controls" id="listSortControls">
                                                        <label for="sort">Sort by:</label>
                                                        <select id="sort" onchange="changeSort(this.value)">
                                                            <option value="appointmentDateTime"
                                                                ${sort=='appointmentDateTime' ? 'selected' : '' }>
                                                                Appointment Time</option>
                                                            <option value="patientName" ${sort=='patientName'
                                                                ? 'selected' : '' }>Patient Name</option>
                                                            <option value="status" ${sort=='status' ? 'selected' : '' }>
                                                                Status</option>
                                                            <option value="doctor.firstName" ${sort=='doctor.firstName'
                                                                ? 'selected' : '' }>Doctor</option>
                                                        </select>
                                                        <select id="direction" onchange="changeDirection(this.value)">
                                                            <option value="asc" ${direction=='asc' ? 'selected' : '' }>
                                                                Asc</option>
                                                            <option value="desc" ${direction=='desc' ? 'selected' : ''}>Desc</option>
                                                        </select>
                                                    </div>

                                                    <!-- Navigation Buttons -->
                                                    <c:if test="${currentPage > 0}">
                                                        <a href="javascript:void(0)" onclick="goToPage(${currentPage - 1})" class="pagination-button">
                                                            <i class="fas fa-chevron-left"></i> Previous
                                                        </a>
                                                    </c:if>

                                                    <c:forEach begin="0" end="${totalPages - 1}" var="pageNum">
                                                        <c:choose>
                                                            <c:when test="${pageNum == currentPage}">
                                                                <span class="pagination-button active">${pageNum + 1}</span>
                                                            </c:when>
                                                            <c:when test="${pageNum == 0}">
                                                                <a href="javascript:void(0)" onclick="goToPage(${pageNum})" class="pagination-button">${pageNum + 1}</a>
                                                            </c:when>
                                                            <c:when test="${pageNum == totalPages - 1}">
                                                                <a href="javascript:void(0)" onclick="goToPage(${pageNum})" class="pagination-button">${pageNum + 1}</a>
                                                            </c:when>
                                                            <c:when test="${pageNum >= currentPage - 2 and pageNum <= currentPage + 2}">
                                                                <a href="javascript:void(0)" onclick="goToPage(${pageNum})" class="pagination-button">${pageNum + 1}</a>
                                                            </c:when>
                                                            <c:when test="${pageNum == currentPage - 3}">
                                                                <span class="pagination-button">...</span>
                                                            </c:when>
                                                            <c:when test="${pageNum == currentPage + 3}">
                                                                <span class="pagination-button">...</span>
                                                            </c:when>
                                                        </c:choose>
                                                    </c:forEach>

                                                    <c:if test="${currentPage < totalPages - 1}">
                                                        <a href="javascript:void(0)" onclick="goToPage(${currentPage + 1})" class="pagination-button">
                                                            Next <i class="fas fa-chevron-right"></i>
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Create Appointment Modal -->
                        <sec:authorize access="hasAnyRole('RECEPTIONIST', 'ADMIN')">
                            <div class="modal fade" id="createAppointmentModal" tabindex="-1"
                                aria-labelledby="createAppointmentModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="createAppointmentModalLabel">
                                                <i class="fas fa-plus-circle"></i> Create New Appointment
                                            </h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <form id="createAppointmentForm"
                                                action="${pageContext.request.contextPath}/appointments/create"
                                                method="post">
                                                <input type="hidden" name="${_csrf.parameterName}"
                                                    value="${_csrf.token}" />
                                                <div class="form-group">
                                                    <label for="patientName">Patient Name</label>
                                                    <input type="text" class="form-control" id="patientName"
                                                        name="patientName" required>
                                                    <c:if test="${not empty patientNameError}">
                                                        <div class="text-danger">${patientNameError}</div>
                                                    </c:if>
                                                </div>
                                                <div class="form-group">
                                                    <label for="patientMobile">Mobile Number</label>
                                                    <input type="tel" class="form-control" id="patientMobile"
                                                        name="patientMobile" pattern="[0-9]{10}" required>
                                                    <c:if test="${not empty patientMobileError}">
                                                        <div class="text-danger">${patientMobileError}</div>
                                                    </c:if>
                                                </div>
                                                <div class="form-group">
                                                    <label for="appointmentDateTime">Appointment Date & Time</label>
                                                    <input type="datetime-local" class="form-control"
                                                        id="appointmentDateTime" name="appointmentDateTime" required>
                                                    <c:if test="${not empty appointmentDateTimeError}">
                                                        <div class="text-danger">${appointmentDateTimeError}</div>
                                                    </c:if>
                                                </div>
                                                <div class="form-group">
                                                    <label for="doctorId">Assign Doctor (Optional)</label>
                                                    <select class="form-control" id="doctorId" name="doctorId">
                                                        <option value="">Select a doctor (optional)</option>
                                                        <c:forEach items="${clinicDoctors}" var="doctor">
                                                            <option value="${doctor.id}">
                                                                Dr. ${doctor.firstName} ${doctor.lastName}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal">Cancel</button>
                                                    <button type="submit" class="btn btn-primary" id="createAppointmentBtn">
                                                        <span id="createAppointmentBtnText">Create Appointment</span>
                                                        <span id="createAppointmentBtnLoader" class="spinner-border spinner-border-sm" role="status" aria-hidden="true" style="display: none;"></span>
                                                        <span id="createAppointmentBtnLoadingText" style="display: none;">Creating...</span>
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </sec:authorize>

                        <!-- Appointment Status Update Modal -->
                        <div class="modal fade" id="statusUpdateModal" tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Update Appointment Status</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div id="statusUpdateError" class="alert alert-danger" style="display: none;">
                                        </div>
                                        <div class="form-group">
                                            <label for="statusSelect">Select New Status:</label>
                                            <select id="statusSelect" class="form-control"
                                                onchange="handleStatusChange()">
                                                <c:forEach items="${statuses}" var="status">
                                                    <option value="${status}">${status}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div id="patientRegistrationGroup" class="form-group"
                                            style="display: none; margin-top: 15px;">
                                            <label for="patientRegistrationNumber">Patient Registration Number:</label>
                                            <input type="text" id="patientRegistrationNumber" class="form-control"
                                                placeholder="Enter patient registration number">
                                            <small class="text-muted">Required for completing the appointment</small>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Cancel</button>
                                        <button type="button" class="btn btn-primary" onclick="updateStatus()">Update
                                            Status</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                        <script>
                            // Appointments for calendar view - use server-generated JSON
                            var appointmentsData = ${appointmentsJson};
                            
                            // Debug: Log the first few appointments to see the data structure
                            console.log('Appointments data sample:', appointmentsData.slice(0, 3));
                            
                            // Add a global function to debug appointments data
                            window.debugAppointments = function() {
                                console.log('All appointments data:', appointmentsData);
                                appointmentsData.forEach(function(apt, index) {
                                    console.log('Appointment ' + (index + 1) + ':', {
                                        id: apt.id,
                                        patientName: apt.patientName,
                                        patientId: apt.patientId,
                                        isRegistered: apt.isRegistered,
                                        hasPatient: apt.hasPatient
                                    });
                                });
                            };

                            // Global variable for the modal
                            var createAppointmentModal = null;

                            // Function to open modal - defined globally
                            function openCreateAppointmentModal() {
                                if (createAppointmentModal) {
                                    createAppointmentModal.show();
                                } else {
                                    console.error('Create appointment modal not initialized');
                                }
                            }

                            // Function to show appointment info for unregistered patients
                            function showAppointmentInfo(event) {
                                var patientInfo = event.patientName || 'Unknown Patient';
                                var doctorInfo = event.doctorName || 'No Doctor Assigned';
                                var timeInfo = event.start ? new Date(event.start).toLocaleString() : 'No Time Set';
                                var notesInfo = event.notes || 'No notes';
                                
                                var message = 'Appointment Details:\n\n' +
                                              'Patient: ' + patientInfo + '\n' +
                                              'Doctor: ' + doctorInfo + '\n' +
                                              'Time: ' + timeInfo + '\n' +
                                              'Notes: ' + notesInfo + '\n\n' +
                                              'Note: This patient is not registered in the system.';
                                
                                alert(message);
                            }

                            document.addEventListener('DOMContentLoaded', function () {
                                console.log('DOM Content Loaded');
                                initCalendarToggle();
                                initFullCalendar();

                                // Initialize Bootstrap modal only if element exists
                                var createAppointmentModalElement = document.getElementById('createAppointmentModal');
                                if (createAppointmentModalElement) {
                                    createAppointmentModal = new bootstrap.Modal(createAppointmentModalElement);
                                }

                                // Initialize Flatpickr
                                console.log('Initializing flatpickr with selectedDate:', "${selectedDate}");
                                var datePicker = flatpickr("#appointmentDate", {
                                    dateFormat: "d-m-Y",
                                    defaultDate: "${selectedDate}",
                                    onChange: function (selectedDates, dateStr) {
                                        // Convert DD-MM-YYYY to YYYY-MM-DD for the URL
                                        var parts = dateStr.split('-');
                                        var formattedDate = parts[2] + '-' + parts[1] + '-' + parts[0];
                                        window.location.href = '${pageContext.request.contextPath}/appointments/management?date=' + formattedDate;
                                    },
                                    theme: "material_blue",
                                    disableMobile: false,
                                    animate: true,
                                    monthSelectorType: "static",
                                    yearSelectorType: "static",
                                    showMonths: 1,
                                    enableTime: false,
                                    time_24hr: false,
                                    locale: {
                                        firstDayOfWeek: 1
                                    }
                                });

                                // Disable/enable date picker based on My Appointments filter
                                var myAppointmentsState = document.getElementById('myAppointmentsState').value === 'true';
                                var datePickerContainer = document.querySelector('.date-picker-container');
                                var datePickerInput = document.getElementById('appointmentDate');

                                if (myAppointmentsState) {
                                    // Disable the date picker
                                    if (datePicker && typeof datePicker.disable === 'function') {
                                        try {
                                            datePicker.disable();
                                        } catch (error) {
                                            console.warn('Flatpickr disable method not available, using fallback:', error);
                                            if (datePickerInput) {
                                                datePickerInput.disabled = true;
                                                datePickerInput.style.opacity = '0.6';
                                                datePickerInput.style.cursor = 'not-allowed';
                                            }
                                        }
                                    } else if (datePickerInput) {
                                        datePickerInput.disabled = true;
                                        datePickerInput.style.opacity = '0.6';
                                        datePickerInput.style.cursor = 'not-allowed';
                                    }
                                    if (datePickerContainer) {
                                        datePickerContainer.classList.add('disabled');
                                    }
                                } else {
                                    // Enable the date picker
                                    if (datePicker && typeof datePicker.enable === 'function') {
                                        try {
                                            datePicker.enable();
                                        } catch (error) {
                                            console.warn('Flatpickr enable method not available, using fallback:', error);
                                            if (datePickerInput) {
                                                datePickerInput.disabled = false;
                                                datePickerInput.style.opacity = '1';
                                                datePickerInput.style.cursor = 'pointer';
                                            }
                                        }
                                    } else if (datePickerInput) {
                                        datePickerInput.disabled = false;
                                        datePickerInput.style.opacity = '1';
                                        datePickerInput.style.cursor = 'pointer';
                                    }
                                    if (datePickerContainer) {
                                        datePickerContainer.classList.remove('disabled');
                                    }
                                }

                                // Form validation
                                var form = document.getElementById('createAppointmentForm');
                                var mobileInput = document.getElementById('patientMobile');

                                if (form) {
                                    // Real-time mobile number validation
                                    if (mobileInput) {
                                        mobileInput.addEventListener('input', function (e) {
                                            // Remove any non-digit characters
                                            var value = e.target.value.replace(/\D/g, '');

                                            // Limit to 10 digits
                                            if (value.length > 10) {
                                                value = value.substring(0, 10);
                                            }

                                            // Update the input value
                                            e.target.value = value;

                                            // Validate and show feedback
                                            validateMobileNumber(value);
                                        });

                                        mobileInput.addEventListener('blur', function (e) {
                                            validateMobileNumber(e.target.value);
                                        });
                                    }

                                    form.addEventListener('submit', function (e) {
                                        var mobile = mobileInput.value;
                                        if (!/^\d{10}$/.test(mobile)) {
                                            e.preventDefault();
                                            showMobileError('Please enter a valid 10-digit mobile number');
                                            mobileInput.focus();
                                            return false;
                                        }

                                        // Clear any error messages if validation passes
                                        clearMobileError();
                                    });
                                }

                                // Mobile number validation function
                                function validateMobileNumber(value) {
                                    var mobileInput = document.getElementById('patientMobile');
                                    var errorDiv = document.getElementById('mobileError');

                                    if (!errorDiv) {
                                        // Create error div if it doesn't exist
                                        var newErrorDiv = document.createElement('div');
                                        newErrorDiv.id = 'mobileError';
                                        newErrorDiv.className = 'text-danger mt-1';
                                        mobileInput.parentNode.appendChild(newErrorDiv);
                                    }

                                    if (value.length === 0) {
                                        clearMobileError();
                                        mobileInput.classList.remove('is-valid', 'is-invalid');
                                    } else if (value.length < 10) {
                                        showMobileError('Please enter ' + (10 - value.length) + ' more digit' + ((10 - value.length === 1) ? '' : 's'));
                                        mobileInput.classList.remove('is-valid');
                                        mobileInput.classList.add('is-invalid');
                                    } else if (value.length === 10) {
                                        clearMobileError();
                                        mobileInput.classList.remove('is-invalid');
                                        mobileInput.classList.add('is-valid');
                                    } else {
                                        showMobileError('Mobile number should be exactly 10 digits');
                                        mobileInput.classList.remove('is-valid');
                                        mobileInput.classList.add('is-invalid');
                                    }
                                }

                                function showMobileError(message) {
                                    var errorDiv = document.getElementById('mobileError');
                                    if (errorDiv) {
                                        errorDiv.textContent = message;
                                        errorDiv.style.display = 'block';
                                    }
                                }

                                function clearMobileError() {
                                    var errorDiv = document.getElementById('mobileError');
                                    if (errorDiv) {
                                        errorDiv.textContent = '';
                                        errorDiv.style.display = 'none';
                                    }
                                }

                                // Initialize tooltips
                                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                                var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                                    return new bootstrap.Tooltip(tooltipTriggerEl);
                                });
                            });

                            var currentAppointmentId = null;

                            function showAppointmentDetails(appointmentId) {
                                if (!appointmentId) {
                                    console.error('No appointment ID provided');
                                    return;
                                }
                                currentAppointmentId = appointmentId;
                                // Hide any previous error message
                                document.getElementById('statusUpdateError').style.display = 'none';
                                var modal = new bootstrap.Modal(document.getElementById('statusUpdateModal'));
                                modal.show();
                            }

                            function initCalendarToggle() {
                                var calendarViewBtn = document.getElementById('calendarViewBtn');
                                var listViewBtn = document.getElementById('listViewBtn');
                                var calendarView = document.getElementById('calendarView');
                                var listView = document.getElementById('listView');
                                var listSortControls = document.getElementById('listSortControls');
                                var calendarViewToggle = document.getElementById('calendarViewToggle');
                                var doctorFilterContainer = document.getElementById('doctorFilterContainer');
                                var myAppointmentsStateElement = document.getElementById('myAppointmentsState');
                                var myAppointmentsEffective = myAppointmentsStateElement && myAppointmentsStateElement.value === 'true';

                                if (doctorFilterContainer) {
                                    doctorFilterContainer.style.display = myAppointmentsEffective ? 'none' : '';
                                }
                                if (!calendarViewBtn || !listViewBtn || !calendarView || !listView) return;

                                calendarViewBtn.addEventListener('click', function() {
                                    calendarView.style.display = 'block';
                                    listView.style.display = 'none';
                                    if (listSortControls) listSortControls.style.display = 'none';
                                    if (calendarViewToggle) calendarViewToggle.style.display = 'flex';

                                    calendarViewBtn.className = 'btn btn-primary';
                                    listViewBtn.className = 'btn btn-secondary';

                                    if (renderDayCalendar) renderDayCalendar();
                                });

                                listViewBtn.addEventListener('click', function() {
                                    calendarView.style.display = 'none';
                                    listView.style.display = 'block';
                                    if (listSortControls) listSortControls.style.display = '';
                                    if (calendarViewToggle) calendarViewToggle.style.display = 'none';

                                    calendarViewBtn.className = 'btn btn-secondary';
                                    listViewBtn.className = 'btn btn-primary';
                                });

                                // Initialize calendar view toggle buttons
                                initCalendarViewToggle();
                            }

                            function initCalendarViewToggle() {
                                var dayViewBtn = document.getElementById('dayViewBtn');
                                var weekViewBtn = document.getElementById('weekViewBtn');
                                var monthViewBtn = document.getElementById('monthViewBtn');

                                if (!dayViewBtn || !weekViewBtn || !monthViewBtn) return;

                                dayViewBtn.addEventListener('click', function() { changeCalendarView('day'); });
                                weekViewBtn.addEventListener('click', function() { changeCalendarView('week'); });
                                monthViewBtn.addEventListener('click', function() { changeCalendarView('month'); });
                            }

                            function changeCalendarView(newView) {
                                var calendarEl = $('#appointmentsCalendar');
                                if (!calendarEl.length) return;

                                // Get current date from calendar or URL
                                var currentDate = calendarEl.fullCalendar('getDate');
                                var year = currentDate.year();
                                var month = String(currentDate.month() + 1);
                                if (month.length === 1) month = '0' + month;
                                var day = String(currentDate.date());
                                if (day.length === 1) day = '0' + day;
                                var dateString = year + '-' + month + '-' + day;
                                
                                // Reload the page with the new view and current date to fetch proper data range
                                var url = new URL(window.location);
                                url.searchParams.set('view', newView);
                                url.searchParams.set('date', dateString);
                                window.location.href = url.toString();
                            }
                            
                            function updateViewButtonStates(activeView) {
                                var dayViewBtn = document.getElementById('dayViewBtn');
                                var weekViewBtn = document.getElementById('weekViewBtn');
                                var monthViewBtn = document.getElementById('monthViewBtn');
                                
                                // Reset all buttons
                                if (dayViewBtn) dayViewBtn.className = 'btn btn-outline-primary';
                                if (weekViewBtn) weekViewBtn.className = 'btn btn-outline-primary';
                                if (monthViewBtn) monthViewBtn.className = 'btn btn-outline-primary';
                                
                                // Set active button
                                switch(activeView) {
                                    case 'day':
                                        if (dayViewBtn) dayViewBtn.className = 'btn btn-primary';
                                        break;
                                    case 'week':
                                        if (weekViewBtn) weekViewBtn.className = 'btn btn-primary';
                                        break;
                                    case 'month':
                                        if (monthViewBtn) monthViewBtn.className = 'btn btn-primary';
                                        break;
                                }
                            }

                            function getCurrentDateFromCalendar() {
                                try {
                                    var calendarEl = $('#appointmentsCalendar');
                                    if (calendarEl.length) {
                                        var currentDate = calendarEl.fullCalendar('getDate');
                                        return currentDate.format('YYYY-MM-DD');
                                    }
                                } catch (e) {
                                    console.warn('Could not get current date from calendar:', e);
                                }
                                return null;
                            }

                            function updateNavigationLabels(view) {
                                var prevBtn = document.getElementById('prevDayBtn');
                                var nextBtn = document.getElementById('nextDayBtn');

                                if (!prevBtn || !nextBtn) return;

                                switch (view) {
                                    case 'week':
                                        prevBtn.title = 'Previous Week';
                                        nextBtn.title = 'Next Week';
                                        break;
                                    case 'month':
                                        prevBtn.title = 'Previous Month';
                                        nextBtn.title = 'Next Month';
                                        break;
                                    default:
                                        prevBtn.title = 'Previous Day';
                                        nextBtn.title = 'Next Day';
                                }
                            }
                            
                            function updateDateLabel(view) {
                                var label = document.getElementById('calendarDateLabel');
                                if (!label || !view) return;
                                
                                var viewName = view.name;
                                var start = view.start;
                                var end = view.end;
                                
                                try {
                                    if (viewName === 'agendaDay') {
                                        label.textContent = start.format('dddd, MMMM D, YYYY');
                                    } else if (viewName === 'agendaWeek') {
                                        var startStr = start.format('MMM D');
                                        var endStr = end.clone().subtract(1, 'day').format('MMM D, YYYY');
                                        label.textContent = startStr + ' - ' + endStr;
                                    } else if (viewName === 'month') {
                                        label.textContent = start.format('MMMM YYYY');
                                    }
                                } catch (e) {
                                    console.warn('Error updating date label:', e);
                                }
                            }

                            function initFullCalendar() {
                                var calendarEl = $('#appointmentsCalendar');
                                var label = document.getElementById('calendarDateLabel');
                                if (!calendarEl.length) return;
                                // Map server events to FullCalendar v3
                                var allEvents = (appointmentsData || []).map(function (e) {
                                    // Use the isRegistered flag directly from JSP logic
                                    var isRegistered = e.isRegistered === true;
                                    var patientIcon = isRegistered ? '✓' : '⚠';
                                    var patientTitle = isRegistered ? 'Registered Patient' : 'Unregistered Patient';
                                    
                                    console.log('Appointment', e.id, '- isRegistered:', isRegistered, 'patientId:', e.patientId);
                                    
                                    return {
                                        id: e.id,
                                        title: patientIcon + ' ' + (e.patientName ? e.patientName : 'Unknown') + (e.doctorName ? (' \u2022 Dr. ' + e.doctorName) : ''),
                                        start: e.start,
                                        allDay: false,
                                        className: ['appt-' + String(e.status || 'SCHEDULED').toLowerCase(), isRegistered ? 'registered-patient' : 'unregistered-patient'],
                                        notes: e.notes || '',
                                        patientName: e.patientName || '',
                                        patientId: e.patientId || null,
                                        doctorName: e.doctorName || '',
                                        isRegistered: isRegistered,
                                        patientTitle: patientTitle
                                    };
                                });
                                var events = allEvents.slice();
                                // Set fixed time window from 8 AM to 11:59 PM
                                var minHour = 8;
                                var maxHour = 24;
                                // Determine the view based on server-side view parameter
                                var currentView = '${currentView}' || 'day';
                                var calendarView = 'agendaDay';
                                switch (currentView) {
                                    case 'week':
                                        calendarView = 'agendaWeek';
                                        break;
                                    case 'month':
                                        calendarView = 'month';
                                        break;
                                    default:
                                        calendarView = 'agendaDay';
                                }

                                calendarEl.fullCalendar({
                                    header: { left: '', center: '', right: '' },
                                    defaultView: calendarView,
                                    allDaySlot: false,
                                    slotDuration: '00:30:00',
                                    slotLabelFormat: 'h(:mm)a',
                                    timeFormat: 'h:mma',
                                    minTime: (minHour < 10 ? '0' + minHour : '' + minHour) + ':00:00',
                                    maxTime: (maxHour < 10 ? '0' + maxHour : '' + maxHour) + ':00:00',
                                    height: 'auto',
                                    contentHeight: 'auto',
                                    nowIndicator: true,
                                    events: events,
                                    firstDay: 1, // Start week on Monday
                                    weekNumbers: true,
                                    viewRender: function(view, element) {
                                        // Update the date label when view changes
                                        updateDateLabel(view);
                                    },
                                    eventRender: function (event, element) {
                                        // Color by status
                                          var status = (event.className && event.className[0] || '').replace('appt-', '');
                                        var colors = { 'scheduled': '#1976d2', 'checked_in': '#2e7d32', 'in_progress': '#f57c00', 'completed': '#6c63ff', 'cancelled': '#c62828' };
                                        element.css({ borderLeft: '4px solid ' + (colors[status] || '#1976d2') });
                                        // Deterministic background color per appointment for visual distinction
                                        try {
                                            var palette = ['#e3f2fd', '#e8f5e9', '#fff3e0', '#ede7f6', '#e0f7fa', '#f3e5f5', '#f1f8e9', '#fffde7', '#e8eaf6', '#fce4ec'];
                                            function strHash(s) { var h = 0, i = 0; for (i = 0; i < s.length; i++) { h = ((h << 5) - h) + s.charCodeAt(i); h |= 0; } return Math.abs(h); }
                                            var key = (event.id != null ? String(event.id) : (event.patientName || '') + '|' + (event.start || ''));
                                            var idx = strHash(key) % palette.length;
                                            element.css('background-color', palette[idx]);
                                            element.css('color', '#2c3e50');
                                        } catch (e) { }
                                        // Tooltip with labels and notes (native title)
                                        var timeStr = (window.moment ? window.moment(event.start).format('h:mm A') : '');
                                        var registrationStatus = event.isRegistered ? 'Registered Patient (Click to view details)' : 'Unregistered Patient';
                                        var tip = (timeStr ? ('Time: ' + timeStr + '\n') : '') + 
                                                 'Patient: ' + (event.patientName || '-') + '\n' + 
                                                 'Doctor: ' + (event.doctorName || '-') + '\n' +
                                                 'Status: ' + registrationStatus;
                                        if (event.notes) { tip += '\nNotes: ' + event.notes; }
                                        element.attr('title', tip);
                                    }
                                    , eventClick: function (event) {
                                        try {
                                            if (!event) return;
                                            
                                            // Check if this appointment has a registered patient
                                            if (event.isRegistered === true && event.patientId) {
                                                // Navigate to patient details page
                                                var patientDetailsUrl = '${pageContext.request.contextPath}/patients/details/' + event.patientId;
                                                window.open(patientDetailsUrl, '_blank');
                                            } else {
                                                // Show appointment details for unregistered patients
                                                showAppointmentInfo(event);
                                            }
                                        } catch (e) { console.warn('Failed to handle calendar event click:', e); }
                                    }
                                });
                                // Set date label and navigate to date
                                try {
                                    var currentView = '${currentView}' || 'day';
                                    var selectedDateStr = '${selectedDate}';

                                    if (currentView === 'day') {
                                        // For day view, parse dd-MM-yyyy format
                                        var parts = selectedDateStr.split('-');
                                        if (parts.length === 3) {
                                            var dd = parts[0];
                                            var mm = parts[1];
                                            var yyyy = parts[2];
                                            var iso = yyyy + '-' + mm + '-' + dd;
                                            calendarEl.fullCalendar('gotoDate', iso);
                                            if (label) label.textContent = new Date(iso).toDateString();
                                        }
                                    } else {
                                        // For week/month views, the selectedDate is already formatted appropriately
                                        if (label) label.textContent = selectedDateStr;

                                        // Try to extract a date to navigate to
                                        if (currentView === 'week' && selectedDateStr.includes(' - ')) {
                                            var startDateStr = selectedDateStr.split(' - ')[0];
                                            var parts = startDateStr.split('-');
                                            if (parts.length === 3) {
                                                var iso = parts[2] + '-' + parts[1] + '-' + parts[0];
                                                calendarEl.fullCalendar('gotoDate', iso);
                                            }
                                        } else if (currentView === 'month') {
                                            // For month view, try to parse "Month Year" format
                                            var today = new Date();
                                            var currentMonth = today.getMonth();
                                            var currentYear = today.getFullYear();
                                            calendarEl.fullCalendar('gotoDate', new Date(currentYear, currentMonth, 1));
                                        }
                                    }
                                } catch (e) {
                                    console.warn('Error setting calendar date:', e);
                                }
                                // Nav buttons - update labels based on view
                                updateNavigationLabels(currentView);
                                $('#prevDayBtn').on('click', function () { calendarEl.fullCalendar('prev'); syncUrlWithCalendar(); });
                                $('#nextDayBtn').on('click', function () { calendarEl.fullCalendar('next'); syncUrlWithCalendar(); });
                                $('#todayBtn').on('click', function () { calendarEl.fullCalendar('today'); syncUrlWithCalendar(); });
                                // Populate doctor filter
                                try {
                                    var uniqueDoctors = Array.from(new Set(allEvents.map(function (e) { return e.doctorName || ''; }))).filter(Boolean).sort();
                                    var sel = document.getElementById('doctorFilter');
                                    if (sel) {
                                        uniqueDoctors.forEach(function (name) {
                                            var opt = document.createElement('option');
                                            opt.value = name;
                                            opt.textContent = name;
                                            sel.appendChild(opt);
                                        });
                                        sel.addEventListener('change', function () {
                                            var selected = sel.value;
                                            var filtered = selected ? allEvents.filter(function (e) { return e.doctorName === selected; }) : allEvents.slice();
                                            calendarEl.fullCalendar('removeEvents');
                                            calendarEl.fullCalendar('addEventSource', filtered);
                                            calendarEl.fullCalendar('rerenderEvents');
                                        });
                                    }
                                } catch (e) { console.warn('Doctor filter setup failed:', e); }
                                function syncUrlWithCalendar() {
                                    var m = calendarEl.fullCalendar('getDate');
                                    var y = m.year();
                                    var mo = String(m.month() + 1);
                                    if (mo.length === 1) mo = '0' + mo;
                                    var d = String(m.date());
                                    if (d.length === 1) d = '0' + d;
                                    var currentView = '${currentView}' || 'day';
                                    window.location.href = '${pageContext.request.contextPath}/appointments/management?date=' + y + '-' + mo + '-' + d + '&view=' + currentView;
                                }
                            }

                            function handleStatusChange() {
                                var status = document.getElementById('statusSelect').value;
                                var patientGroup = document.getElementById('patientRegistrationGroup');

                                if (status === 'COMPLETED') {
                                    patientGroup.style.display = 'block';
                                } else {
                                    patientGroup.style.display = 'none';
                                }
                            }

                            function updateStatus() {
                                if (!currentAppointmentId) {
                                    console.error('No appointment ID available');
                                    return;
                                }

                                var newStatus = document.getElementById('statusSelect').value;
                                var patientRegistrationNumber = document.getElementById('patientRegistrationNumber').value;

                                // Validate patient registration number for COMPLETED status
                                if (newStatus === 'COMPLETED' && !patientRegistrationNumber) {
                                    var errorDiv = document.getElementById('statusUpdateError');
                                    errorDiv.textContent = 'Please enter patient registration number';
                                    errorDiv.style.display = 'block';
                                    return;
                                }

                                var url = '${pageContext.request.contextPath}/appointments/management/update-status';

                                fetch(url, {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/json',
                                        '${_csrf.headerName}': '${_csrf.token}'
                                    },
                                    body: JSON.stringify({
                                        id: currentAppointmentId,
                                        status: newStatus,
                                        patientRegistrationNumber: patientRegistrationNumber
                                    })
                                })
                                    .then(function(response) {
                                        if (response.ok) {
                                            // Close modal and refresh page
                                            var modal = bootstrap.Modal.getInstance(document.getElementById('statusUpdateModal'));
                                            modal.hide();
                                            window.location.reload();
                                        } else {
                                            // Read response as text first, then try to parse as JSON
                                            return response.text().then(function(text) {
                                                console.error('Response text:', text);
                                                var errorDiv = document.getElementById('statusUpdateError');
                                                var errorMessage = 'Failed to update status';
                                                
                                                try {
                                                    var data = JSON.parse(text);
                                                    console.error('Server error response:', data);
                                                    errorMessage = data.message || errorMessage;
                                                } catch (parseError) {
                                                    console.error('Failed to parse JSON, using raw response');
                                                    errorMessage = 'Server error: ' + (text.length > 100 ? text.substring(0, 100) + '...' : text);
                                                }
                                                
                                                errorDiv.textContent = errorMessage;
                                                errorDiv.style.display = 'block';
                                                throw new Error(errorMessage);
                                            });
                                        }
                                    })
                                    .catch(function(error) {
                                        console.error('Error updating status:', error);
                                        var errorDiv = document.getElementById('statusUpdateError');
                                        errorDiv.textContent = error.message;
                                        errorDiv.style.display = 'block';
                                    });
                            }

                            function filterAppointmentsByDate(date) {
                                console.log('Filtering appointments for date:', date);

                                if (!date) {
                                    // If no date is selected, use today's date
                                    var today = new Date();
                                    var year = today.getFullYear();
                                    var month = String(today.getMonth() + 1);
                                    if (month.length === 1) month = '0' + month;
                                    var day = String(today.getDate());
                                    if (day.length === 1) day = '0' + day;
                                    date = year + '-' + month + '-' + day;
                                    console.log('No date provided, using today:', date);
                                    document.getElementById('appointmentDate').value = date;
                                }

                                // Update URL with selected date
                                var url = new URL(window.location.href);
                                url.searchParams.set('date', date);
                                console.log('Updating URL to:', url.toString());
                                window.history.pushState({}, '', url);

                                // Fetch appointments for selected date
                                var fetchUrl = new URL(window.location.pathname, window.location.origin);
                                fetchUrl.searchParams.set('date', date);
                                console.log('Fetching appointments from:', fetchUrl.toString());

                                fetch(fetchUrl.toString(), {
                                    headers: {
                                        'X-Requested-With': 'XMLHttpRequest'
                                    }
                                })
                                    .then(function(response) {
                                        console.log('Received response:', response.status);
                                        return response.text();
                                    })
                                    .then(function(html) {
                                        console.log('Received HTML response');
                                        // Update the appointments table
                                        var parser = new DOMParser();
                                        var doc = parser.parseFromString(html, 'text/html');
                                        var newTable = doc.querySelector('.appointments-table');
                                        var currentTable = document.querySelector('.appointments-table');
                                        var noAppointmentsDiv = document.querySelector('.text-center');

                                        if (newTable) {
                                            if (currentTable) {
                                                console.log('Updating appointments table');
                                                currentTable.innerHTML = newTable.innerHTML;
                                            }
                                        } else if (doc.querySelector('.text-center')) {
                                            // Handle no appointments case
                                            if (currentTable) {
                                                currentTable.style.display = 'none';
                                            }
                                            if (!noAppointmentsDiv) {
                                                var cardBody = document.querySelector('.card-body');
                                                var noAppointmentsHtml = doc.querySelector('.text-center').outerHTML;
                                                cardBody.insertAdjacentHTML('beforeend', noAppointmentsHtml);
                                            }
                                        }

                                        // Reinitialize tooltips
                                        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                                        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                                            return new bootstrap.Tooltip(tooltipTriggerEl);
                                        });
                                    })
                                    .catch(function(error) {
                                        console.error('Error fetching appointments:', error);
                                        alert('Failed to fetch appointments. Please try again.');
                                    });
                            }

                            function toggleMyAppointments() {
                                var url = new URL(window.location.href);
                                var stateEl = document.getElementById('myAppointmentsState');
                                var currentEffective = stateEl ? (stateEl.value === 'true') : (url.searchParams.get('myAppointments') === 'true');
                                var newMyAppointments = !currentEffective;
                                if (newMyAppointments) {
                                    url.searchParams.set('myAppointments', 'true');
                                    url.searchParams.delete('date');
                                } else {
                                    // Explicitly set to false so we override the server's default for doctors
                                    url.searchParams.set('myAppointments', 'false');
                                }
                                window.location.href = url.pathname + '?' + url.searchParams.toString();
                            }

                            // Pagination functions
                            function goToPage(page) {
                                var urlParams = new URLSearchParams(window.location.search);
                                urlParams.set('page', page);
                                window.location.href = window.location.pathname + '?' + urlParams.toString();
                            }

                            function changePageSize(size) {
                                var urlParams = new URLSearchParams(window.location.search);
                                urlParams.set('pageSize', size);
                                urlParams.set('page', '0'); // Reset to first page when changing size
                                window.location.href = window.location.pathname + '?' + urlParams.toString();
                            }

                            function changeSort(sort) {
                                var urlParams = new URLSearchParams(window.location.search);
                                urlParams.set('sort', sort);
                                urlParams.set('page', '0'); // Reset to first page when changing sort
                                window.location.href = window.location.pathname + '?' + urlParams.toString();
                            }

                            function changeDirection(direction) {
                                var urlParams = new URLSearchParams(window.location.search);
                                urlParams.set('direction', direction);
                                urlParams.set('page', '0'); // Reset to first page when changing direction
                                window.location.href = window.location.pathname + '?' + urlParams.toString();
                            }

                            // Reschedule functions
                            function showRescheduleModal(appointmentId, formattedDateTime, rawDateTime) {
                                document.getElementById('rescheduleAppointmentId').value = appointmentId;
                                document.getElementById('currentDateTime').textContent = formattedDateTime;
                                document.getElementById('rescheduleModal').style.display = 'block';

                                // Initialize flatpickr for new date/time
                                flatpickr("#newAppointmentDateTime", {
                                    enableTime: true,
                                    dateFormat: "Y-m-d H:i:S",
                                    time_24hr: false,
                                    minDate: "today",
                                    minTime: "00:00",
                                    maxTime: "23:59",
                                    defaultHour: new Date().getHours(),
                                    defaultMinute: new Date().getMinutes(),
                                    defaultSeconds: 0
                                });
                            }

                            function closeRescheduleModal() {
                                document.getElementById('rescheduleModal').style.display = 'none';
                                document.getElementById('rescheduleForm').reset();
                                document.getElementById('rescheduleError').style.display = 'none';
                            }

                            function submitReschedule() {
                                var appointmentId = document.getElementById('rescheduleAppointmentId').value;
                                var newDateTime = document.getElementById('newAppointmentDateTime').value;
                                var reason = document.getElementById('rescheduleReason').value;
                                var additionalNotes = document.getElementById('additionalNotes').value;

                                if (!newDateTime || !reason) {
                                    document.getElementById('rescheduleError').textContent = 'Please fill in all required fields';
                                    document.getElementById('rescheduleError').style.display = 'block';
                                    return;
                                }

                                // Convert the date/time format from "YYYY-MM-DD HH:mm:SS" to "YYYY-MM-DDTHH:mm:SS" for LocalDateTime
                                var formattedDateTime = newDateTime.replace(' ', 'T');

                                var data = {
                                    appointmentId: parseInt(appointmentId),
                                    newAppointmentDateTime: formattedDateTime,
                                    reason: reason,
                                    additionalNotes: additionalNotes
                                };

                                fetch('${pageContext.request.contextPath}/appointments/reschedule', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/json',
                                        '${_csrf.headerName}': '${_csrf.token}'
                                    },
                                    body: JSON.stringify(data)
                                })
                                    .then(function(response) { return response.json(); })
                                    .then(function(data) {
                                        if (data.success) {
                                            closeRescheduleModal();
                                            window.location.reload();
                                        } else {
                                            document.getElementById('rescheduleError').textContent = data.message;
                                            document.getElementById('rescheduleError').style.display = 'block';
                                        }
                                    })
                                    .catch(function(error) {
                                        console.error('Error rescheduling appointment:', error);
                                        document.getElementById('rescheduleError').textContent = 'An error occurred while rescheduling the appointment';
                                        document.getElementById('rescheduleError').style.display = 'block';
                                    });
                            }

                            function showRescheduleHistory(appointmentId) {
                                console.log('Fetching history for appointment:', appointmentId);
                                fetch('${pageContext.request.contextPath}/appointments/' + appointmentId + '/history')
                                    .then(function(res) {
                                        console.log('Response status:', res.status);
                                        if (!res.ok) {
                                            throw new Error('HTTP error! status: ' + res.status);
                                        }
                                        return res.json();
                                    })
                                    .then(function(history) {
                                        console.log('Received history:', history);
                                        var html = '<ul class="reschedule-history-list">';
                                        history.filter(function(h) { return h.action === 'RESCHEDULED'; }).forEach(function(item) {
                                            html += '<li>' +
                                                '<strong>Reschedule #' + item.rescheduleNumber + ':</strong>' +
                                                '<br>From: <span>' + item.oldValue + '</span>' +
                                                '<br>To: <span>' + item.newValue + '</span>' +
                                                '<br>By: <span>' + (item.changedBy ? item.changedBy.firstName + ' ' + item.changedBy.lastName : 'Unknown') + '</span>' +
                                                '<br>At: <span>' + item.changedAt + '</span>' +
                                                '<br>Reason: <span>' + item.notes + '</span>' +
                                                '</li>';
                                        });
                                        html += '</ul>';
                                        document.getElementById('rescheduleHistoryContent').innerHTML = html;
                                        document.getElementById('rescheduleHistoryModal').style.display = 'block';
                                    })
                                    .catch(function(error) {
                                        console.error('Error fetching reschedule history:', error);
                                        alert('Failed to load reschedule history');
                                    });
                            }

                            function closeRescheduleHistoryModal() {
                                document.getElementById('rescheduleHistoryModal').style.display = 'none';
                            }
                        </script>

                        <!-- Reschedule Modal -->
                        <div id="rescheduleModal" class="modal" style="display: none;">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Reschedule Appointment</h5>
                                        <button type="button" class="btn-close"
                                            onclick="closeRescheduleModal()"></button>
                                    </div>
                                    <div class="modal-body">
                                        <form id="rescheduleForm">
                                            <input type="hidden" id="rescheduleAppointmentId">

                                            <div class="form-group">
                                                <label>Current Date & Time:</label>
                                                <div id="currentDateTime" class="form-control"
                                                    style="background-color: #f8f9fa;"></div>
                                            </div>

                                            <div class="form-group">
                                                <label for="newAppointmentDateTime">New Date & Time: <span
                                                        class="text-danger">*</span></label>
                                                <input type="text" id="newAppointmentDateTime" class="form-control"
                                                    required>
                                            </div>

                                            <div class="form-group">
                                                <label for="rescheduleReason">Reason for Reschedule: <span
                                                        class="text-danger">*</span></label>
                                                <select id="rescheduleReason" class="form-control" required>
                                                    <option value="">Select a reason</option>
                                                    <option value="Patient Request">Patient Request</option>
                                                    <option value="Doctor Unavailable">Doctor Unavailable</option>
                                                    <option value="Emergency">Emergency</option>
                                                    <option value="Clinic Schedule Conflict">Clinic Schedule Conflict
                                                    </option>
                                                    <option value="Weather">Weather</option>
                                                    <option value="Technical Issues">Technical Issues</option>
                                                    <option value="Other">Other</option>
                                                </select>
                                            </div>

                                            <div class="form-group">
                                                <label for="additionalNotes">Additional Notes:</label>
                                                <textarea id="additionalNotes" class="form-control" rows="3"
                                                    placeholder="Optional additional details..."></textarea>
                                            </div>

                                            <div id="rescheduleError" class="text-danger" style="display: none;"></div>
                                        </form>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            onclick="closeRescheduleModal()">Cancel</button>
                                        <button type="button" class="btn btn-warning"
                                            onclick="submitReschedule()">Reschedule</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Reschedule History Modal -->
                        <div id="rescheduleHistoryModal" class="modal" style="display: none;">
                            <div class="modal-dialog modal-lg modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Reschedule History</h5>
                                        <button type="button" class="btn-close"
                                            onclick="closeRescheduleHistoryModal()"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div id="rescheduleHistoryContent">
                                            <!-- Content will be loaded dynamically -->
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            onclick="closeRescheduleHistoryModal()">Close</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script>
                            // Add form submission handler for Create Appointment form
                            document.addEventListener('DOMContentLoaded', function() {
                                const createAppointmentForm = document.getElementById('createAppointmentForm');
                                const createAppointmentBtn = document.getElementById('createAppointmentBtn');
                                const btnText = document.getElementById('createAppointmentBtnText');
                                const btnLoader = document.getElementById('createAppointmentBtnLoader');
                                const btnLoadingText = document.getElementById('createAppointmentBtnLoadingText');

                                if (createAppointmentForm && createAppointmentBtn) {
                                    createAppointmentForm.addEventListener('submit', function(e) {
                                        // Show loading state
                                        createAppointmentBtn.disabled = true;
                                        btnText.style.display = 'none';
                                        btnLoader.style.display = 'inline-block';
                                        btnLoadingText.style.display = 'inline';
                                    });
                                }
                            });
                        </script>
                    </body>

                    </html>