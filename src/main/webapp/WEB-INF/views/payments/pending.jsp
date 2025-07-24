<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>Patient Payment Collection - PeriDesk</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    
    <!-- Include common menu styles -->
    <jsp:include page="/WEB-INF/views/common/menuStyles.jsp" />
    
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .welcome-container {
            display: flex;
            min-height: 100vh;
        }
        
        .main-content {
            flex: 1;
            padding: 30px;
            background: #f8f9fa;
        }
        
        .payments-header {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .payments-title {
            font-size: 2.2rem;
            font-weight: 700;
            color: #2c3e50;
            margin: 0 0 25px 0;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .search-section {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
        }
        
        .search-form {
            display: flex;
            gap: 15px;
            align-items: center;
            max-width: 600px;
        }
        
        .search-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .form-group {
            flex: 3;
            margin: 0;
        }
        
        .form-group label {
            display: none;
        }
        
        .search-input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
            height: 48px;
            box-sizing: border-box;
            margin: 0;
        }
        
        .search-input:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
        }
        
        .search-btn {
            flex: 1;
            padding: 12px 16px;
            font-size: 0.9rem;
            height: 48px;
            box-sizing: border-box;
            margin: 0;
        }
        
        .patient-info {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            display: none;
        }
        
        .patient-info.show {
            display: block;
        }
        
        .patient-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f1f3f4;
        }
        
        .patient-name {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2c3e50;
        }
        
        .patient-meta {
            display: flex;
            gap: 20px;
            color: #7f8c8d;
            font-size: 0.95rem;
            }
            
        .examinations-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
            
        .section-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            }
            
        .examinations-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 20px;
        }
        
        .examination-card {
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 15px;
            transition: all 0.3s ease;
            margin-bottom: 10px;
        }
        
        .examination-card:hover {
            border-color: #3498db;
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.1);
        }
        
        .examination-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .examination-title {
            font-weight: 600;
            color: #2c3e50;
            font-size: 1rem;
        }
        
        .payment-status {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-partial {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .status-completed {
            background: #d4edda;
            color: #155724;
        }
        
        .examination-details {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .detail-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
        }
        
        .detail-label {
            color: #7f8c8d;
            font-weight: 500;
        }
        
        .detail-value {
            font-weight: 600;
            color: #2c3e50;
        }
        
        .payment-actions {
            display: flex;
            gap: 8px;
            justify-content: flex-end;
        }
        
        .btn-success {
            background: linear-gradient(135deg, #2ecc71, #27ae60);
            color: white;
        }
        
        .btn-success:hover {
            background: linear-gradient(135deg, #27ae60, #229954);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(46, 204, 113, 0.3);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .btn-info {
            background: linear-gradient(135deg, #17a2b8, #138496);
            color: white;
        }
        
        .btn-info:hover {
            background: linear-gradient(135deg, #138496, #117a8b);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(23, 162, 184, 0.3);
        }
        
        .no-records {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
        }
        
        .no-records i {
            font-size: 3rem;
            margin-bottom: 20px;
            color: #bdc3c7;
        }
        
        .payment-form {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            z-index: 1000;
            display: none;
            max-width: 500px;
            width: 90%;
        }
        
        .payment-form.show {
            display: block;
        }
        
        .payment-summary {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
        }
        
        .summary-label {
            font-weight: 500;
            color: #7f8c8d;
        }
        
        .summary-value {
            font-weight: 600;
            color: #2c3e50;
        }
        
        .payment-form-row {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .payment-mode-select {
            padding: 12px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 1rem;
        }
        
        .payment-amount-input {
            padding: 12px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .payment-amount-input.error {
            border-color: #e74c3c;
            background-color: #fdf2f2;
            box-shadow: 0 0 0 3px rgba(231, 76, 60, 0.1);
        }
        
        .payment-amount-input.valid {
            border-color: #27ae60;
            background-color: #f0f9f0;
            box-shadow: 0 0 0 3px rgba(39, 174, 96, 0.1);
        }
        
        .amount-error {
            color: #e74c3c;
            font-size: 0.85rem;
            margin-top: 5px;
            display: none;
            font-weight: 500;
        }
        
        .amount-error.show {
            display: block;
        }
        
        .payment-notes {
            padding: 12px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 1rem;
            resize: vertical;
        }
        
        .payment-form-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }
        
        .btn-cancel {
            background: #6c757d;
            color: white;
        }
        
        .overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 999;
            display: none;
        }
        
        .overlay.show {
            display: block;
        }
        
        .payment-history-modal {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            border-radius: 20px;
            padding: 0;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            z-index: 1001;
            display: none;
            max-width: 900px;
            width: 95%;
            max-height: 85vh;
            overflow-y: auto;
            border: 1px solid #e9ecef;
        }
        
        .payment-history-modal.show {
            display: block;
            animation: modalSlideIn 0.3s ease-out;
        }
        
        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translate(-50%, -60%);
            }
            to {
                opacity: 1;
                transform: translate(-50%, -50%);
            }
        }
        
        .payment-history-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            padding: 30px 30px 20px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px 20px 0 0;
        }
        
        .header-content {
            flex: 1;
        }
        
        .payment-history-title {
            font-size: 1.8rem;
            font-weight: 700;
            margin: 0 0 8px 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .payment-history-subtitle {
            font-size: 0.95rem;
            opacity: 0.9;
            margin: 0;
            font-weight: 400;
        }
        
        .payment-history-close {
            background: rgba(255,255,255,0.2);
            border: none;
            font-size: 1.2rem;
            color: white;
            cursor: pointer;
            padding: 10px;
            border-radius: 50%;
            transition: all 0.3s ease;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .payment-history-close:hover {
            background: rgba(255,255,255,0.3);
            transform: scale(1.1);
        }
        
        .examination-summary {
            padding: 30px;
            background: #f8f9fa;
        }
        
        .summary-header {
            margin-bottom: 25px;
        }
        
        .summary-header h3 {
            font-size: 1.3rem;
            font-weight: 600;
            color: #2c3e50;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .examination-summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .summary-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            border: 1px solid #e9ecef;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .summary-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
        }
        
        .summary-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
            flex-shrink: 0;
        }
        
        .summary-content {
            flex: 1;
        }
        
        .summary-label {
            display: block;
            font-size: 0.85rem;
            color: #7f8c8d;
            font-weight: 500;
            margin-bottom: 4px;
        }
        
        .summary-value {
            display: block;
            font-size: 1.1rem;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .payment-overview {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            border: 1px solid #e9ecef;
        }
        
        .overview-header {
            margin-bottom: 20px;
        }
        
        .overview-header h3 {
            font-size: 1.2rem;
            font-weight: 600;
            color: #2c3e50;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .overview-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .overview-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            border-left: 4px solid;
        }
        
        .overview-card.total {
            border-left-color: #3498db;
        }
        
        .overview-card.paid {
            border-left-color: #2ecc71;
        }
        
        .overview-card.remaining {
            border-left-color: #f39c12;
        }
        
        .overview-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1rem;
        }
        
        .overview-card.total .overview-icon {
            background: #3498db;
        }
        
        .overview-card.paid .overview-icon {
            background: #2ecc71;
        }
        
        .overview-card.remaining .overview-icon {
            background: #f39c12;
        }
        
        .overview-content {
            flex: 1;
        }
        
        .overview-label {
            display: block;
            font-size: 0.85rem;
            color: #7f8c8d;
            font-weight: 500;
            margin-bottom: 4px;
        }
        
        .overview-value {
            display: block;
            font-size: 1.3rem;
            font-weight: 700;
            color: #2c3e50;
        }
        
        .payment-progress-section {
            margin-top: 20px;
        }
        
        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .progress-label {
            font-weight: 600;
            color: #2c3e50;
        }
        
        .progress-percentage {
            font-weight: 700;
            color: #2ecc71;
            font-size: 1.1rem;
        }
        
        .payment-progress {
            background: #e9ecef;
            border-radius: 15px;
            height: 12px;
            margin-bottom: 8px;
            overflow: hidden;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .payment-progress-bar {
            height: 100%;
            background: linear-gradient(90deg, #2ecc71, #27ae60);
            transition: width 0.8s ease;
            border-radius: 15px;
            position: relative;
        }
        
        .payment-progress-bar::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            animation: shimmer 2s infinite;
        }
        
        @keyframes shimmer {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }
        
        .progress-status {
            font-size: 0.9rem;
            color: #7f8c8d;
            text-align: center;
            font-weight: 500;
        }
        
        .payment-history-section {
            padding: 30px;
        }
        
        .history-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }
        
        .history-header h3 {
            font-size: 1.3rem;
            font-weight: 600;
            color: #2c3e50;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .history-stats {
            display: flex;
            gap: 15px;
        }
        
        .stat-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
            color: #7f8c8d;
            font-weight: 500;
        }
        
        .payment-history-content {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            border: 1px solid #e9ecef;
        }
        
        .payment-history-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .payment-history-table th {
            background: #f8f9fa;
            padding: 15px 20px;
            text-align: left;
            font-weight: 600;
            color: #2c3e50;
            border-bottom: 2px solid #e9ecef;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .payment-history-table th i {
            color: #7f8c8d;
        }
        
        .payment-history-table td {
            padding: 15px 20px;
            border-bottom: 1px solid #f1f3f4;
            color: #2c3e50;
        }
        
        .payment-history-table tr:hover {
            background: #f8f9fa;
        }
        
        .payment-history-table tr:last-child td {
            border-bottom: none;
        }
        
        .payment-mode-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .payment-mode-cash {
            background: #d4edda;
            color: #155724;
        }
        
        .payment-mode-card {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .payment-mode-upi {
            background: #fff3cd;
            color: #856404;
        }
        
        .payment-mode-net-banking {
            background: #f8d7da;
            color: #721c24;
        }
        
        .payment-mode-insurance {
            background: #e2e3e5;
            color: #383d41;
        }
        
        .payment-mode-emi {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .no-payments {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
        }
        
        .no-payments-icon {
            width: 80px;
            height: 80px;
            background: #f8f9fa;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            color: #bdc3c7;
            font-size: 2rem;
        }
        
        .no-payments h4 {
            font-size: 1.2rem;
            font-weight: 600;
            color: #2c3e50;
            margin: 0 0 10px 0;
        }
        
        .no-payments p {
            font-size: 0.95rem;
            margin: 0;
            opacity: 0.8;
        }
        
        .no-records p {
            font-size: 0.95rem;
            margin: 0;
            opacity: 0.8;
        }
        
        .today-pending-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .section-header .section-title {
            margin: 0;
            font-size: 1.3rem;
            font-weight: 600;
            color: #2c3e50;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .today-pending-content {
            min-height: 100px;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .table thead th {
            background: #f8f9fa;
            color: #2c3e50;
            font-weight: 600;
            padding: 15px 12px;
            text-align: left;
            border-bottom: 2px solid #e9ecef;
            font-size: 0.9rem;
        }
        
        .table tbody td {
            padding: 12px;
            border-bottom: 1px solid #f1f3f4;
            color: #2c3e50;
            font-size: 0.9rem;
        }
        
        .table tbody tr:hover {
            background: #f8f9fa;
        }
        
        .table tbody tr:last-child td {
            border-bottom: none;
        }
        
        .text-center {
            text-align: center;
        }
        
        .text-danger {
            color: #e74c3c;
        }
        
        .table .btn {
            padding: 6px 12px;
            font-size: 0.8rem;
            margin: 2px;
        }
        
        .table .btn-success {
            background: linear-gradient(135deg, #2ecc71, #27ae60);
            color: white;
            border: none;
        }
        
        .table .btn-success:hover {
            background: linear-gradient(135deg, #27ae60, #229954);
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(46, 204, 113, 0.3);
        }
        
        .examination-id {
            font-weight: 600;
            color: #3498db;
            font-family: 'Courier New', monospace;
            background: #f8f9fa;
            padding: 4px 8px;
            border-radius: 4px;
            border: 1px solid #e9ecef;
        }
        
        .examination-id-link {
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        
        .examination-id-link:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(52, 152, 219, 0.3);
        }
        
        .examination-id-link:hover .examination-id {
            background: #3498db;
            color: white;
            border-color: #3498db;
        }
        
        .loading-spinner {
            text-align: center;
            padding: 40px 20px;
            color: #7f8c8d;
        }
        
        .loading-spinner i {
            font-size: 2rem;
            margin-bottom: 15px;
            color: #3498db;
        }
        
        .today-pending-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 20px;
        }
        
        .today-pending-card {
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 15px;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }
        
        .today-pending-card:hover {
            border-color: #3498db;
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.1);
            background: white;
        }
        
        .today-pending-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 12px;
        }
        
        .today-pending-title {
            font-weight: 600;
            color: #2c3e50;
            font-size: 1rem;
        }
        
        .today-pending-patient {
            font-size: 0.85rem;
            color: #7f8c8d;
            margin-bottom: 3px;
        }
        
        .today-pending-details {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 10px;
        }
        
        .no-today-pending {
            text-align: center;
            padding: 40px 20px;
            color: #7f8c8d;
        }
        
        .no-today-pending i {
            font-size: 2.5rem;
            margin-bottom: 15px;
            color: #bdc3c7;
        }
        
        .no-today-pending h4 {
            font-size: 1.1rem;
            font-weight: 600;
            color: #2c3e50;
            margin: 0 0 10px 0;
        }
        
        .no-today-pending p {
            font-size: 0.9rem;
            margin: 0;
            opacity: 0.8;
        }
        
        @media (max-width: 768px) {
            .search-form {
                flex-direction: column;
            }
            
            .examinations-grid {
                grid-template-columns: 1fr;
            }
            
            .examination-details {
                grid-template-columns: 1fr;
            }
            
            .payment-history-modal {
                width: 98%;
                max-height: 90vh;
                border-radius: 15px;
            }
            
            .payment-history-header {
                padding: 20px 20px 15px 20px;
                flex-direction: column;
            gap: 15px;
                align-items: stretch;
            }
            
            .header-content {
                text-align: center;
            }
            
            .payment-history-title {
                font-size: 1.5rem;
                justify-content: center;
            }
            
            .payment-history-close {
                align-self: flex-end;
                margin-top: -40px;
            }
            
            .examination-summary {
                padding: 20px;
            }
            
            .examination-summary-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .summary-card {
                padding: 15px;
            }
            
            .summary-icon {
                width: 40px;
                height: 40px;
                font-size: 1rem;
        }
        
            .payment-overview {
                padding: 20px;
            }
            
            .overview-cards {
                grid-template-columns: 1fr;
                gap: 12px;
            }
            
            .overview-card {
                padding: 15px;
            }
            
            .overview-icon {
                width: 35px;
                height: 35px;
                font-size: 0.9rem;
            }
            
            .overview-value {
                font-size: 1.1rem;
            }
            
            .payment-history-section {
                padding: 20px;
            }
            
            .history-header {
                flex-direction: column;
                gap: 15px;
                align-items: stretch;
            }
            
            .history-header h3 {
                text-align: center;
                justify-content: center;
            }
            
            .history-stats {
                justify-content: center;
            }
            
            .payment-history-table {
                font-size: 0.85rem;
            }
            
            .payment-history-table th,
            .payment-history-table td {
                padding: 10px 12px;
        }
        
            .payment-history-table th {
                flex-direction: column;
                gap: 4px;
                text-align: center;
            }
            
            .payment-mode-badge {
                padding: 4px 8px;
                font-size: 0.75rem;
        }
        
            .no-payments {
                padding: 40px 15px;
            }
            
            .no-payments-icon {
                width: 60px;
                height: 60px;
                font-size: 1.5rem;
            }
        }
        
        @media (max-width: 480px) {
            .payment-history-modal {
                width: 100%;
                height: 100vh;
                max-height: 100vh;
                border-radius: 0;
                transform: none;
                top: 0;
                left: 0;
            }
            
            .payment-history-modal.show {
                animation: modalSlideUp 0.3s ease-out;
            }
            
            @keyframes modalSlideUp {
                from {
                    opacity: 0;
                    transform: translateY(100%);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            
            .payment-history-header {
                border-radius: 0;
            }
            
            .examination-summary-grid {
                grid-template-columns: 1fr;
            }
            
            .overview-cards {
                grid-template-columns: 1fr;
        }
        
            .payment-history-table {
                font-size: 0.8rem;
            }
            
            .payment-history-table th,
            .payment-history-table td {
                padding: 8px 10px;
            }
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        <div class="main-content">
            <div class="payments-header">
                <h1 class="payments-title">
                    <i class="fas fa-credit-card"></i>
                    Patient Payment Collection
                </h1>
                <p style="color: #7f8c8d; margin: 0;">Search for patients and collect payments for their examinations</p>
            </div>
            
            <div class="search-section">
                <label for="registrationCode" class="search-label">Patient Registration Code</label>
                <form class="search-form" id="patientSearchForm" onsubmit="return false;">
                    <input type="text" id="registrationCode" name="registrationCode" class="search-input" 
                           placeholder="Enter registration code" required>
                    <button type="button" class="btn btn-primary search-btn" onclick="handleSearch()">
                        <i class="fas fa-search"></i>
                        Search Patient
                    </button>
                </form>
            </div>

            <div class="filter-section" style="margin-bottom: 30px; background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.05);">
                <form id="paymentFilterForm" class="search-form" method="get" action="">
                    <div class="form-group">
                        <label for="startDate" class="search-label">Start Date</label>
                        <input type="date" id="startDate" name="startDate" class="search-input" required>
                    </div>
                    <div class="form-group">
                        <label for="endDate" class="search-label">End Date</label>
                        <input type="date" id="endDate" name="endDate" class="search-input" required>
                    </div>
                    <div class="form-group">
                        <label class="search-label">Type</label>
                        <select id="paymentType" name="paymentType" class="search-input">
                            <option value="pending">Pending Only</option>
                            <option value="all">All Collected</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary search-btn">
                        <i class="fas fa-filter"></i> Filter
                    </button>
                </form>
            </div>

            <div class="today-pending-section">
                <div class="section-header">
                    <h2 class="section-title">
                        <i class="fas fa-calendar-day"></i>
                        Today's Pending Payments
                    </h2>
                </div>
                <div class="today-pending-content" id="todayPendingContent">
                    <table class="table table-striped" id="todayPendingTable">
                        <thead>
                            <tr>
                                <th>Examination ID</th>
                                <th>Registration Code</th>
                                <th>Patient Name</th>
                                <th>Phone Number</th>
                                <th>Procedure</th>
                                <th>Total Amount</th>
                                <th>Paid Amount</th>
                                <th>Remaining Amount</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="9" class="text-center">
                                    <div class="loading-spinner" id="todayLoadingSpinner">
                                        <i class="fas fa-spinner fa-spin"></i>
                                        Loading today's pending payments...
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="patient-info" id="patientInfo">
                <div class="patient-header">
                    <div>
                        <div class="patient-name" id="patientName"></div>
                        <div class="patient-meta" id="patientMeta"></div>
                        </div>
                                            </div>
            </div>

            <div class="examinations-section" id="examinationsSection" style="display: none;">
                <h2 class="section-title">
                    <i class="fas fa-stethoscope"></i>
                    Examinations & Payments
                </h2>
                <div class="examinations-grid" id="examinationsGrid">
                    <!-- Examinations will be loaded here -->
        </div>
    </div>

            <div class="no-records" id="noRecords">
                <i class="fas fa-search"></i>
                <p>Search for a patient by registration code to view their examinations and collect payments.</p>
            </div>
        </div>
    </div>

    <div class="overlay" id="overlay"></div>
    
    <div class="payment-form" id="paymentForm">
        <h3 style="margin-top: 0; color: #2c3e50;">Collect Payment</h3>
        <div class="payment-summary" id="paymentSummary">
            <!-- Payment summary will be populated here -->
        </div>
                    <div class="payment-form-row">
            <select class="payment-mode-select" name="paymentMode" required>
                <option value="">Select Payment Mode</option>
                            <option value="CASH">Cash</option>
                            <option value="CARD">Card</option>
                            <option value="UPI">UPI</option>
                            <option value="NET_BANKING">Net Banking</option>
                            <option value="INSURANCE">Insurance</option>
                            <option value="EMI">EMI</option>
                        </select>
            <input type="number" class="payment-amount-input" name="paymentAmount" 
                   placeholder="Enter payment amount" step="0.01" required>
            <div class="amount-error" id="amountError"></div>
            <textarea class="payment-notes" name="paymentNotes" 
                      placeholder="Payment notes (optional)" rows="3"></textarea>
                    </div>
                    <div class="payment-form-actions">
            <button type="button" class="btn btn-cancel" onclick="hidePaymentForm()">
                <i class="fas fa-times"></i>
                Cancel
                        </button>
            <button type="button" class="btn btn-success" onclick="collectPayment()">
                <i class="fas fa-check"></i>
                Confirm Payment
                        </button>
                    </div>
    </div>

    <!-- Payment History Modal -->
    <div class="payment-history-modal" id="paymentHistoryModal">
        <div class="payment-history-header">
            <div class="header-content">
                <h2 class="payment-history-title">
                    <i class="fas fa-receipt"></i>
                    Payment History
                </h2>
                <p class="payment-history-subtitle">Detailed payment information for this examination</p>
            </div>
            <button class="payment-history-close" onclick="hidePaymentHistory()" title="Close">
                <i class="fas fa-times"></i>
            </button>
        </div>
        
        <div class="examination-summary" id="examinationSummary">
            <div class="summary-header">
                <h3><i class="fas fa-stethoscope"></i> Examination Details</h3>
            </div>
            <div class="examination-summary-grid">
                <div class="summary-card">
                    <div class="summary-icon">
                        <i class="fas fa-calendar-alt"></i>
                    </div>
                    <div class="summary-content">
                        <span class="summary-label">Examination Date</span>
                        <span class="summary-value" id="examinationDate"></span>
                    </div>
                </div>
                <div class="summary-card">
                    <div class="summary-icon">
                        <i class="fas fa-hospital"></i>
                    </div>
                    <div class="summary-content">
                        <span class="summary-label">Treating Clinic</span>
                        <span class="summary-value" id="clinicName"></span>
                    </div>
                </div>
                <div class="summary-card">
                    <div class="summary-icon">
                        <i class="fas fa-tooth"></i>
                    </div>
                    <div class="summary-content">
                        <span class="summary-label">Tooth Number</span>
                        <span class="summary-value" id="toothNumber"></span>
                    </div>
                </div>
                <div class="summary-card">
                    <div class="summary-icon">
                        <i class="fas fa-procedures"></i>
                    </div>
                    <div class="summary-content">
                        <span class="summary-label">Procedure</span>
                        <span class="summary-value" id="procedureName"></span>
                    </div>
                </div>
            </div>
            
            <div class="payment-overview">
                <div class="overview-header">
                    <h3><i class="fas fa-chart-pie"></i> Payment Overview</h3>
                </div>
                <div class="overview-cards">
                    <div class="overview-card total">
                        <div class="overview-icon">
                            <i class="fas fa-money-bill-wave"></i>
                        </div>
                        <div class="overview-content">
                            <span class="overview-label">Total Amount</span>
                            <span class="overview-value" id="totalAmount"></span>
                        </div>
                    </div>
                    <div class="overview-card paid">
                        <div class="overview-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="overview-content">
                            <span class="overview-label">Paid Amount</span>
                            <span class="overview-value" id="paidAmount"></span>
                        </div>
                    </div>
                    <div class="overview-card remaining">
                        <div class="overview-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="overview-content">
                            <span class="overview-label">Remaining</span>
                            <span class="overview-value" id="remainingAmount"></span>
                        </div>
                    </div>
                </div>
                
                <div class="payment-progress-section">
                    <div class="progress-header">
                        <span class="progress-label">Payment Progress</span>
                        <span class="progress-percentage" id="progressPercentage">0%</span>
                    </div>
                    <div class="payment-progress">
                        <div id="paymentProgress" class="payment-progress-bar"></div>
                    </div>
                    <div class="progress-status" id="progressStatus">No payments made</div>
                </div>
            </div>
        </div>
        
        <div class="payment-history-section">
            <div class="history-header">
                <h3><i class="fas fa-history"></i> Payment History</h3>
                <div class="history-stats">
                    <span class="stat-item">
                        <i class="fas fa-list"></i>
                        <span id="paymentCount">0</span> payments
                    </span>
                </div>
            </div>
            
            <div class="payment-history-content">
                <table class="payment-history-table" id="paymentHistoryTable">
                    <thead>
                        <tr>
                            <th><i class="fas fa-calendar"></i> Date & Time</th>
                            <th><i class="fas fa-credit-card"></i> Payment Mode</th>
                            <th><i class="fas fa-rupee-sign"></i> Amount</th>
                            <th><i class="fas fa-sticky-note"></i> Notes</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Payment history rows will be dynamically added here -->
                    </tbody>
                </table>
                
                <div class="no-payments" id="noPayments">
                    <div class="no-payments-icon">
                        <i class="fas fa-inbox"></i>
                    </div>
                    <h4>No Payments Found</h4>
                    <p>No payment records have been made for this examination yet.</p>
                </div>
            </div>
        </div>
    </div>

    <script>
        let currentExaminationId = null;
        let currentPatient = null;
        
        function handleSearch() {
            const registrationCode = document.getElementById('registrationCode').value.trim();
            if (!registrationCode) {
                alert('Please enter a registration code');
                return;
            }
            
            // Validate that registration code starts with "SDC"
            if (!registrationCode.toUpperCase().startsWith('SDC')) {
                alert('Registration code must start with "SDC"');
                return;
            }
            
            searchPatient(registrationCode);
        }
        
        // Also handle Enter key press
        document.getElementById('registrationCode').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                handleSearch();
        }
        });
        
        function searchPatient(registrationCode) {
            fetch('${pageContext.request.contextPath}/payments/search-patient?registrationCode=' + encodeURIComponent(registrationCode))
                .then(response => response.json())
                .then(data => {
                    console.log('Search response:', data);
                    if (data.success) {
                        displayPatientInfo(data.patient);
                        displayExaminations(data.examinations);
                    } else {
                        alert('Patient not found: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error searching for patient');
                });
        }
        
        function displayPatientInfo(patient) {
            console.log('Displaying patient info:', patient);
            console.log('Patient firstName:', patient.firstName);
            console.log('Patient lastName:', patient.lastName);
            console.log('Patient registrationCode:', patient.registrationCode);
            console.log('Patient phoneNumber:', patient.phoneNumber);
            console.log('Patient age:', patient.age);
            
            currentPatient = patient;
            document.getElementById('patientName').textContent = patient.firstName + ' ' + patient.lastName;
            document.getElementById('patientMeta').innerHTML = 
                '<span><i class="fas fa-id-card"></i> ' + patient.registrationCode + '</span>' +
                '<span><i class="fas fa-phone"></i> ' + patient.phoneNumber + '</span>' +
                '<span><i class="fas fa-birthday-cake"></i> Age: ' + patient.age + '</span>';
            document.getElementById('patientInfo').classList.add('show');
            console.log('Patient info section should now be visible');
            console.log('Patient info element:', document.getElementById('patientInfo'));
            console.log('Patient name element:', document.getElementById('patientName'));
            console.log('Patient meta element:', document.getElementById('patientMeta'));
        }
        
        function displayExaminations(examinations) {
            const grid = document.getElementById('examinationsGrid');
            const section = document.getElementById('examinationsSection');
            const noRecords = document.getElementById('noRecords');
            
            if (examinations.length === 0) {
                section.style.display = 'none';
                noRecords.style.display = 'block';
                noRecords.innerHTML = '<i class="fas fa-info-circle"></i><p>No examinations found for this patient.</p>';
                return;
            }

            section.style.display = 'block';
            noRecords.style.display = 'none';
            
            grid.innerHTML = examinations.map(exam => {
                const totalPaid = exam.totalPaidAmount || 0;
                const remaining = (exam.totalProcedureAmount || 0) - totalPaid;
                const status = getPaymentStatus(remaining, exam.totalProcedureAmount);
                
                let actionButton = '';
                if (remaining > 0) {
                    actionButton = '<button class="btn btn-success" onclick="showPaymentForm(' + exam.id + ', ' + remaining + ')">' +
                        '<i class="fas fa-money-bill-wave"></i>' +
                        'Collect Payment' +
                        '</button>';
                } else {
                    actionButton = '<span class="btn btn-secondary" style="cursor: default;">' +
                        '<i class="fas fa-check"></i>' +
                        'Payment Complete' +
                        '</span>';
                }
                
                // Add payment history button (new functionality)
                let historyButton = '<button class="btn btn-info" onclick="viewPaymentHistory(' + exam.id + ')">' +
                    '<i class="fas fa-history"></i>' +
                    'Payment History' +
                    '</button>';
                
                return '<div class="examination-card">' +
                    '<div class="examination-header">' +
                        '<div class="examination-title">' +
                            'Tooth ' + exam.toothNumber + ' - ' + (exam.procedure ? exam.procedure.procedureName : 'No Procedure') +
                        '</div>' +
                        '<span class="payment-status status-' + status.toLowerCase() + '">' + status + '</span>' +
                    '</div>' +
                    '<div class="examination-details">' +
                        '<div class="detail-item">' +
                            '<span class="detail-label">Date:</span>' +
                            '<span class="detail-value">' + formatDate(exam.examinationDate) + '</span>' +
                        '</div>' +
                        '<div class="detail-item">' +
                            '<span class="detail-label">Total:</span>' +
                            '<span class="detail-value">₹' + (exam.totalProcedureAmount || 0) + '</span>' +
                        '</div>' +
                        '<div class="detail-item">' +
                            '<span class="detail-label">Paid:</span>' +
                            '<span class="detail-value">₹' + totalPaid + '</span>' +
                        '</div>' +
                        '<div class="detail-item">' +
                            '<span class="detail-label">Remaining:</span>' +
                            '<span class="detail-value">₹' + remaining + '</span>' +
                        '</div>' +
                    '</div>' +
                    '<div class="payment-actions">' +
                        actionButton +
                        historyButton +
                    '</div>' +
                '</div>';
            }).join('');
        }
        
        function getPaymentStatus(remaining, total) {
            if (remaining <= 0) return 'COMPLETED';
            if (remaining < total) return 'PARTIAL';
            return 'PENDING';
        }
        
        function formatDate(dateString) {
            if (!dateString) {
                return 'N/A';
            }
            
            console.log('Raw date string:', dateString, 'Type:', typeof dateString);
            
            let date;
            
            // If it's already a Date object
            if (dateString instanceof Date) {
                date = dateString;
            } else if (typeof dateString === 'string') {
                // Handle different date formats
                if (dateString.includes('T') && dateString.includes('Z')) {
                    // ISO format with UTC: "2024-01-15T10:30:00Z"
                    date = new Date(dateString);
                } else if (dateString.includes('T')) {
                    // ISO format without timezone: "2024-01-15T10:30:00"
                    date = new Date(dateString);
                } else if (dateString.includes('-') && dateString.includes(':')) {
                    // Format: "2024-01-15 10:30:00" (IST format from server)
                    date = new Date(dateString.replace(' ', 'T'));
                } else {
                    // Try direct parsing
                    date = new Date(dateString);
                }
            } else {
                // Try direct parsing for other types
                date = new Date(dateString);
            }
            
            console.log('Parsed date object:', date);
            console.log('Is valid date:', !isNaN(date.getTime()));
            
            // Check if date is valid
            if (isNaN(date.getTime())) {
                console.error('Invalid date string:', dateString);
                return 'Invalid Date';
            }
            
            // Since the date is already in IST, use it directly
            console.log('Using date directly:', date);
            
            // Format as DD/MM/YYYY HH:MM AM/PM
            const day = date.getDate();
            const month = date.getMonth() + 1;
            const year = date.getFullYear();
            const hours = date.getHours();
            const minutes = date.getMinutes();
            
            console.log('Raw extracted values:', {
                day: day,
                month: month,
                year: year,
                hours: hours,
                minutes: minutes
            });
            
            // Check for NaN values
            if (isNaN(day) || isNaN(month) || isNaN(year) || isNaN(hours) || isNaN(minutes)) {
                console.error('NaN values detected in date extraction');
                return 'Invalid Date';
            }
            
            const dayStr = String(day).padStart(2, '0');
            const monthStr = String(month).padStart(2, '0');
            const yearStr = String(year);
            const minutesStr = String(minutes).padStart(2, '0');
            const ampm = hours >= 12 ? 'PM' : 'AM';
            const displayHours = hours % 12 || 12;
            
            console.log('Formatted values:', {
                dayStr: dayStr,
                monthStr: monthStr,
                yearStr: yearStr,
                minutesStr: minutesStr,
                ampm: ampm,
                displayHours: displayHours
            });
            
            const result = dayStr + '/' + monthStr + '/' + yearStr + ' ' + displayHours + ':' + minutesStr + ' ' + ampm;
            console.log('Final formatted result:', result);
            
            return result;
        }
        
        function showPaymentFormFromToday(examinationId, remainingAmount, patientInfo) {
            showPaymentForm(examinationId, remainingAmount, patientInfo);
        }
        
        function showPaymentForm(examinationId, remainingAmount, patientInfo = null) {
            currentExaminationId = examinationId;
            
            // If patientInfo is provided (from today's pending payments), use it
            // Otherwise, use the currentPatient from search
            const patient = patientInfo || currentPatient;
            
            if (!patient) {
                alert('Patient information not available');
                return;
            }
            
            document.getElementById('paymentSummary').innerHTML = 
                '<div class="summary-row">' +
                    '<span class="summary-label">Patient</span>' +
                    '<span class="summary-value">' + patient.firstName + ' ' + patient.lastName + '</span>' +
                '</div>' +
                '<div class="summary-row">' +
                    '<span class="summary-label">Registration Code</span>' +
                    '<span class="summary-value">' + patient.registrationCode + '</span>' +
                '</div>' +
                '<div class="summary-row">' +
                    '<span class="summary-label">Remaining Amount</span>' +
                    '<span class="summary-value">₹' + remainingAmount + '</span>' +
                '</div>';
            
            const amountInput = document.querySelector('input[name="paymentAmount"]');
            const amountError = document.getElementById('amountError');
            
            // Clear previous validation states
            amountInput.classList.remove('error', 'valid');
            amountError.classList.remove('show');
            amountError.textContent = '';
            
            // Set max value and placeholder
            amountInput.max = remainingAmount;
            amountInput.placeholder = 'Enter amount (max ₹' + remainingAmount + ')';
            
            // Add validation event listeners
            amountInput.addEventListener('input', function() {
                validatePaymentAmount(this, remainingAmount);
            });
            
            amountInput.addEventListener('blur', function() {
                validatePaymentAmount(this, remainingAmount);
            });
            
            document.getElementById('overlay').classList.add('show');
            document.getElementById('paymentForm').classList.add('show');
        }
        
        function validatePaymentAmount(input, maxAmount) {
            const amount = parseFloat(input.value) || 0;
            const amountError = document.getElementById('amountError');
            
            // Clear previous states
            input.classList.remove('error', 'valid');
            amountError.classList.remove('show');
            amountError.textContent = '';
            
            if (amount <= 0) {
                input.classList.add('error');
                amountError.textContent = 'Please enter a valid amount greater than 0';
                amountError.classList.add('show');
                return false;
            } else if (amount > maxAmount) {
                input.classList.add('error');
                amountError.textContent = 'Amount cannot exceed remaining amount of ₹' + maxAmount;
                amountError.classList.add('show');
                return false;
            } else {
                input.classList.add('valid');
                return true;
            }
        }
        
        function hidePaymentForm() {
            document.getElementById('overlay').classList.remove('show');
            document.getElementById('paymentForm').classList.remove('show');
            currentExaminationId = null;
        }
        
        function collectPayment() {
            const form = document.getElementById('paymentForm');
            const paymentMode = form.querySelector('select[name="paymentMode"]').value;
            const amountInput = form.querySelector('input[name="paymentAmount"]');
            const amount = parseFloat(amountInput.value);
            const notes = form.querySelector('textarea[name="paymentNotes"]').value;
            
            // Validate payment mode
            if (!paymentMode) {
                alert('Please select a payment mode.');
                return;
            }
            
            // Validate payment amount
            if (!amount || amount <= 0) {
                alert('Please enter a valid payment amount.');
                amountInput.focus();
                return;
            }
            
            // Get the remaining amount from the payment summary
            const summaryText = document.getElementById('paymentSummary').textContent;
            const remainingMatch = summaryText.match(/₹(\d+(?:\.\d{2})?)/);
            const remainingAmount = remainingMatch ? parseFloat(remainingMatch[1]) : 0;
            
            // Validate against remaining amount
            if (amount > remainingAmount) {
                alert('Payment amount cannot exceed the remaining amount of ₹' + remainingAmount);
                amountInput.focus();
                return;
            }
            
            const requestData = {
                examinationId: currentExaminationId,
                paymentMode: paymentMode,
                notes: notes,
                paymentDetails: {
                    amount: amount
                }
            };

            fetch('${pageContext.request.contextPath}/payments/collect', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector("meta[name='_csrf']").content
                },
                body: JSON.stringify(requestData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Payment collected successfully!');
                    hidePaymentForm();
                    
                    // Refresh the patient data if we have currentPatient (from search)
                    if (currentPatient && currentPatient.registrationCode) {
                        searchPatient(currentPatient.registrationCode);
                    }
                    
                    // Refresh today's pending payments
                    loadTodayPendingPayments();
                } else {
                    alert('Error: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error collecting payment');
            });
        }
        
        // Close modal when clicking overlay
        document.getElementById('overlay').addEventListener('click', hidePaymentForm);
        
        // Payment History Functions (New functionality)
        function viewPaymentHistory(examinationId) {
            console.log('Loading payment history for examination:', examinationId);
            
            // Show the modal first
            document.getElementById('paymentHistoryModal').classList.add('show');
            
            // Load payment history data
            fetch('${pageContext.request.contextPath}/payments/payment-history/' + examinationId)
                .then(response => response.json())
            .then(data => {
                    console.log('Payment history response:', data);
                if (data.success) {
                        displayPaymentHistory(data);
                } else {
                    alert('Error: ' + data.message);
                        hidePaymentHistory();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                    alert('Error loading payment history');
                    hidePaymentHistory();
                });
        }
        
        function displayPaymentHistory(data) {
            const examination = data.examination;
            const payments = data.payments;
            const summary = data.summary;
            
            // Update examination summary
            document.getElementById('examinationDate').textContent = formatDate(examination.examinationDate);
            document.getElementById('clinicName').textContent = examination.clinic ? examination.clinic.clinicName : 'N/A';
            document.getElementById('toothNumber').textContent = examination.toothNumber || 'N/A';
            document.getElementById('procedureName').textContent = examination.procedure ? examination.procedure.procedureName : 'No Procedure';
            
            // Update payment overview
            document.getElementById('totalAmount').textContent = '₹' + (examination.totalProcedureAmount || 0);
            document.getElementById('paidAmount').textContent = '₹' + summary.totalPaid;
            document.getElementById('remainingAmount').textContent = '₹' + summary.remaining;
            
            // Update progress bar and status
            const progressPercentage = examination.totalProcedureAmount > 0 ? 
                Math.round((summary.totalPaid / examination.totalProcedureAmount) * 100) : 0;
            document.getElementById('paymentProgress').style.width = progressPercentage + '%';
            document.getElementById('progressPercentage').textContent = progressPercentage + '%';
            
            // Update progress status
            let statusText = '';
            let statusColor = '';
            if (progressPercentage === 0) {
                statusText = 'No payments made yet';
                statusColor = '#e74c3c';
            } else if (progressPercentage === 100) {
                statusText = 'Payment completed';
                statusColor = '#27ae60';
            } else if (progressPercentage >= 50) {
                statusText = 'Payment partially completed';
                statusColor = '#f39c12';
            } else {
                statusText = 'Payment in progress';
                statusColor = '#3498db';
            }
            
            const progressStatus = document.getElementById('progressStatus');
            progressStatus.textContent = statusText;
            progressStatus.style.color = statusColor;
            
            // Update payment count
            document.getElementById('paymentCount').textContent = payments.length;
            
            // Update payment history table
            const tableBody = document.getElementById('paymentHistoryTable');
            const noPayments = document.getElementById('noPayments');
            
            if (payments.length === 0) {
                tableBody.innerHTML = '';
                noPayments.style.display = 'block';
            } else {
                noPayments.style.display = 'none';
                tableBody.innerHTML = payments.map(payment => {
                    const paymentModeClass = 'payment-mode-' + payment.paymentMode.toLowerCase().replace('_', '-');
                    const paymentDate = formatDate(payment.paymentDate);
                    const paymentAmount = '₹' + payment.amount;
                    const paymentNotes = payment.notes || '-';
                    
                    return '<tr>' +
                        '<td>' + paymentDate + '</td>' +
                        '<td><span class="payment-mode-badge ' + paymentModeClass + '">' + payment.paymentMode + '</span></td>' +
                        '<td><strong>' + paymentAmount + '</strong></td>' +
                        '<td>' + paymentNotes + '</td>' +
                        '</tr>';
                }).join('');
            }
        }
        
        function hidePaymentHistory() {
            document.getElementById('paymentHistoryModal').classList.remove('show');
        }
        
        // Close payment history modal when clicking outside
        document.getElementById('paymentHistoryModal').addEventListener('click', function(e) {
            if (e.target === this) {
                hidePaymentHistory();
            }
        });
        
        // Close payment history modal with ESC key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                hidePaymentHistory();
            }
        });
        
        // Today's Pending Payments Functions
        function loadTodayPendingPayments() {
            $.ajax({
                url: '/payments/today-pending',
                method: 'GET',
                success: function(response) {
                    if (response.success) {
                        const examinations = response.examinations || [];
                        const tbody = $('#todayPendingTable tbody');
                        tbody.empty();
                        
                        if (examinations.length === 0) {
                            tbody.append('<tr><td colspan="9" class="text-center">No pending payments for today</td></tr>');
                        } else {
                            examinations.forEach(function(exam) {
                                const row = '<tr>' +
                                    '<td><a href="${pageContext.request.contextPath}/patients/examination/' + exam.id + '" class="examination-id-link"><span class="examination-id">' + exam.id + '</span></a></td>' +
                                    '<td>' + (exam.patient ? exam.patient.registrationCode : 'N/A') + '</td>' +
                                    '<td>' + (exam.patient ? exam.patient.firstName + ' ' + exam.patient.lastName : 'N/A') + '</td>' +
                                    '<td>' + (exam.patient ? exam.patient.phoneNumber : 'N/A') + '</td>' +
                                    '<td>' + (exam.procedure ? exam.procedure.procedureName : 'N/A') + '</td>' +
                                    '<td>₹' + (exam.totalProcedureAmount || 0) + '</td>' +
                                    '<td>₹' + (exam.totalPaidAmount || 0) + '</td>' +
                                    '<td>₹' + (exam.remainingAmount || 0) + '</td>' +
                                    '<td>' +
                                        '<button class="btn btn-success collect-payment-btn" ' +
                                        'data-examination-id="' + exam.id + '" ' +
                                        'data-remaining-amount="' + exam.remainingAmount + '" ' +
                                        'data-patient-firstname="' + (exam.patient ? exam.patient.firstName : '') + '" ' +
                                        'data-patient-lastname="' + (exam.patient ? exam.patient.lastName : '') + '" ' +
                                        'data-patient-registration="' + (exam.patient ? exam.patient.registrationCode : '') + '" ' +
                                        'data-patient-phone="' + (exam.patient ? exam.patient.phoneNumber : '') + '">' +
                                            '<i class="fas fa-money-bill-wave"></i>' +
                                            'Collect Payment' +
                                        '</button>' +
                                    '</td>' +
                                    '</tr>';
                                tbody.append(row);
                            });
                        }
                    } else {
                        $('#todayPendingTable tbody').html('<tr><td colspan="9" class="text-center text-danger">Error loading data</td></tr>');
                    }
                },
                error: function(xhr, status, error) {
                    $('#todayPendingTable tbody').html('<tr><td colspan="9" class="text-center text-danger">Error loading data</td></tr>');
                }
            });
        }
        
        // Initialize today's pending payments on page load
        document.addEventListener('DOMContentLoaded', function() {
            loadTodayPendingPayments();
            
            // Add event delegation for collect payment buttons
            document.addEventListener('click', function(e) {
                if (e.target.closest('.collect-payment-btn')) {
                    const button = e.target.closest('.collect-payment-btn');
                    const examinationId = button.getAttribute('data-examination-id');
                    const remainingAmount = parseFloat(button.getAttribute('data-remaining-amount'));
                    const patientFirstName = button.getAttribute('data-patient-firstname');
                    const patientLastName = button.getAttribute('data-patient-lastname');
                    const patientRegistration = button.getAttribute('data-patient-registration');
                    const patientPhone = button.getAttribute('data-patient-phone');
                    
                    const patientInfo = {
                        firstName: patientFirstName,
                        lastName: patientLastName,
                        registrationCode: patientRegistration,
                        phoneNumber: patientPhone
                    };
                    
                    showPaymentFormFromToday(examinationId, remainingAmount, patientInfo);
                }
            });
        });
    </script>
</body>
</html> 