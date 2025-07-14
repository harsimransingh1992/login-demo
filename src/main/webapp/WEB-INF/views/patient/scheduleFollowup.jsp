<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html>
<head>
    <title>Schedule Follow-up - PeriDesk</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
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
        
        .form-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
            padding: 25px;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .form-title {
            font-size: 1.4rem;
            color: #2c3e50;
            margin-bottom: 25px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            font-weight: 500;
            margin-bottom: 8px;
            color: #2c3e50;
        }
        
        input[type="date"],
        input[type="time"],
        textarea,
        select {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.9rem;
            color: #2c3e50;
            box-sizing: border-box;
        }
        
        select {
            background-color: white;
            cursor: pointer;
        }
        
        select:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }
        
        textarea {
            min-height: 120px;
            resize: vertical;
        }
        
        .procedure-info {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
        }
        
        .procedure-info p {
            margin: 5px 0;
        }
        
        .info-label {
            font-weight: 500;
            color: #7f8c8d;
            margin-right: 5px;
        }
        
        .info-value {
            font-weight: 600;
            color: #2c3e50;
        }
        
        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 30px;
            justify-content: flex-end;
        }
        
        @media (max-width: 768px) {
            .main-content {
                padding: 20px;
            }
            
            .welcome-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .form-actions {
                flex-direction: column;
                gap: 10px;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <jsp:include page="/WEB-INF/views/common/menu.jsp" />
        
        <div class="main-content">
            <div class="welcome-header">
                <h1 class="welcome-message">Schedule Follow-up</h1>
                <a href="${pageContext.request.contextPath}/patients/examination/${examinationId}/lifecycle" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i> Back to Examination
                </a>
            </div>
            
            <div class="form-container">
                <h2 class="form-title">Schedule Follow-up Appointment</h2>
                
                <div class="procedure-info">
                    <p><span class="info-label">Patient:</span> <span class="info-value">${patientName}</span></p>
                    <p><span class="info-label">Examination ID:</span> <span class="info-value">${examinationId}</span></p>
                    <c:if test="${examination.procedure != null}">
                        <p><span class="info-label">Procedure:</span> <span class="info-value">${examination.procedure.procedureName}</span></p>
                    </c:if>
                    <c:if test="${examination.assignedDoctor != null}">
                        <p><span class="info-label">Assigned Doctor:</span> <span class="info-value">${examination.assignedDoctor.firstName} ${examination.assignedDoctor.lastName}</span></p>
                    </c:if>
                </div>
                
                <form action="${pageContext.request.contextPath}/patients/examination/${examinationId}/schedule-followup" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    
                    <div class="form-group">
                        <label for="doctorId">Doctor (Optional - will use assigned doctor if not selected)</label>
                        <select id="doctorId" name="doctorId" class="form-control">
                            <option value="">Use Assigned Doctor</option>
                            <c:forEach items="${doctors}" var="doctor">
                                <option value="${doctor.id}">${doctor.firstName} ${doctor.lastName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="followupDate">Follow-up Date</label>
                        <input type="date" id="followupDate" name="followupDate" required min="${LocalDate.now()}" />
                    </div>
                    
                    <div class="form-group">
                        <label for="followupTime">Time</label>
                        <input type="time" id="followupTime" name="followupTime" required />
                    </div>
                    
                    <div class="form-group">
                        <label for="followupNotes">Notes</label>
                        <textarea id="followupNotes" name="followupNotes" placeholder="Enter any notes about this follow-up..."></textarea>
                    </div>
                    
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/patients/examination/${examinationId}/lifecycle" class="btn btn-secondary">Cancel</a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-calendar-check"></i> Schedule Follow-up
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        // Set default date to tomorrow
        window.onload = function() {
            const today = new Date();
            const tomorrow = new Date(today);
            tomorrow.setDate(tomorrow.getDate() + 1);
            
            const dateInput = document.getElementById('followupDate');
            dateInput.valueAsDate = tomorrow;
            
            // Set default time to 10:00 AM
            document.getElementById('followupTime').value = '10:00';
        };
    </script>
</body>
</html> 