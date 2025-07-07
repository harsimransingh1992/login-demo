<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Schedule Appointment | PeriDesk</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <style>
        .appointment-form {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .form-title {
            color: #2c3e50;
            margin-bottom: 2rem;
            text-align: center;
        }
        .form-group {
            margin-bottom: 1.5rem;
        }
        .btn-schedule {
            background-color: #3498db;
            color: white;
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-schedule:hover {
            background-color: #2980b9;
            transform: translateY(-2px);
        }
        .flatpickr-input {
            width: 100%;
            padding: 0.5rem;
            border: 1px solid #ced4da;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="appointment-form">
            <h2 class="form-title">Schedule New Appointment</h2>
            
            <form:form action="/appointments/create" method="POST" modelAttribute="appointment">
                <div class="form-group">
                    <label for="doctor">Select Doctor</label>
                    <form:select path="doctor.id" class="form-control" required="true">
                        <form:option value="" label="-- Select Doctor --" />
                        <form:options items="${doctors}" itemValue="id" itemLabel="fullName" />
                    </form:select>
                </div>

                <div class="form-group">
                    <label for="patient">Select Patient</label>
                    <form:select path="patient.id" class="form-control" required="true">
                        <form:option value="" label="-- Select Patient --" />
                        <form:options items="${patients}" itemValue="id" itemLabel="fullName" />
                    </form:select>
                </div>

                <div class="form-group">
                    <label for="appointmentDateTime">Appointment Date & Time</label>
                    <form:input path="appointmentDateTime" type="text" class="form-control flatpickr-input" 
                              required="true" placeholder="Select date and time" />
                </div>

                <div class="form-group">
                    <label for="clinic">Select Clinic</label>
                    <form:select path="clinic.id" class="form-control" required="true">
                        <form:option value="" label="-- Select Clinic --" />
                        <form:options items="${clinics}" itemValue="id" itemLabel="clinicName" />
                    </form:select>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-schedule">
                        <i class="fas fa-calendar-plus mr-2"></i>Schedule Appointment
                    </button>
                </div>
            </form:form>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script>
        $(document).ready(function() {
            flatpickr(".flatpickr-input", {
                enableTime: true,
                dateFormat: "Y-m-d H:i",
                minDate: "today",
                time_24hr: true,
                minuteIncrement: 30,
                disableMobile: "true"
            });
        });
    </script>
</body>
</html> 