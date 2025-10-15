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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/color-code-component.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/chairside-note-component.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-ui-timepicker-addon/1.6.3/jquery-ui-timepicker-addon.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/patient/print.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-ui-timepicker-addon/1.6.3/jquery-ui-timepicker-addon.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    <script src="${pageContext.request.contextPath}/js/color-code-component.js"></script>
    <script src="${pageContext.request.contextPath}/js/chairside-note-component.js"></script>
    <script src="${pageContext.request.contextPath}/js/imageCompression.js"></script>
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
    <script>
        function joinUrl(base, path) {
            if (!base || base === '/') return path;
            if (base.endsWith('/') && path.startsWith('/')) return base.replace(/\/+$/, '') + path;
            if (!base.endsWith('/') && !path.startsWith('/')) return base + '/' + path;
            return base + path;
        }

        function duplicateExaminationFromEl(btn){
            let examId = btn.getAttribute('data-exam-id');
            if (!examId) {
                const tr = btn.closest('tr');
                if (tr) {
                    const idCell = tr.querySelector('.exam-id-col');
                    if (idCell) {
                        examId = String(idCell.textContent || '').trim();
                    }
                }
            }
            if (!examId) {
                alert('Could not determine examination ID for duplication.');
                return;
            }
            
            // Fetch examination details to populate modal
            fetch(joinUrl(contextPath, '/patients/examination/' + examId + '/details'), {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    // Show the modal first
                    document.getElementById('duplicateExaminationModal').style.display = 'block';
                    
                    // Wait a moment for the modal to render, then update content
                    setTimeout(() => {
                        // Update modal content with examination details
                        const attachmentCount = document.getElementById('attachmentCount');
                        const treatingDoctorName = document.getElementById('treatingDoctorName');
                        const procedureName = document.getElementById('procedureName');
                        
                        // Reset checkboxes to enabled and unchecked state by default
                        document.getElementById('duplicateAttachments').disabled = false;
                        document.getElementById('duplicateAttachments').checked = false;
                        document.getElementById('duplicateTreatingDoctor').disabled = false;
                        document.getElementById('duplicateTreatingDoctor').checked = false;
                        document.getElementById('duplicateProcedure').disabled = false;
                        document.getElementById('duplicateProcedure').checked = false;
                        
                        // Set attachment count
                        if (data.attachmentCount > 0) {
                            const countText = '(' + data.attachmentCount + ' files)';
                            attachmentCount.textContent = countText;
                        } else {
                            attachmentCount.textContent = '(No attachments)';
                            document.getElementById('duplicateAttachments').checked = false;
                            document.getElementById('duplicateAttachments').disabled = true;
                        }
                        
                        // Set treating doctor name
                        if (data.treatingDoctorName && data.treatingDoctorName.trim() !== '') {
                            treatingDoctorName.textContent = data.treatingDoctorName;
                        } else {
                            treatingDoctorName.textContent = '(Not assigned)';
                            document.getElementById('duplicateTreatingDoctor').checked = false;
                            document.getElementById('duplicateTreatingDoctor').disabled = true;
                        }
                        
                        // Set procedure name
                        if (data.procedureName && data.procedureName.trim()) {
                            procedureName.textContent = data.procedureName;
                        } else {
                            procedureName.textContent = 'Not assigned';
                            document.getElementById('duplicateProcedure').checked = false;
                            document.getElementById('duplicateProcedure').disabled = true;
                        }
                        
                        // Set procedure price
                        const procedurePrice = document.getElementById('procedurePrice');
                        if (data.procedurePrice && data.procedurePrice > 0) {
                            const priceText = '(₹' + data.procedurePrice + ')';
                            procedurePrice.textContent = priceText;
                        } else {
                            procedurePrice.textContent = '';
                        }
                        
                        // Store examination ID for later use
                        document.getElementById('duplicateExaminationModal').setAttribute('data-examination-id', examId);
                    }, 100);
                } else {
                    // Fallback to old behavior if details endpoint doesn't exist
                    duplicateExamination(examId);
                }
            })
            .catch(error => {
                // Fallback to old behavior if there's an error
                duplicateExamination(examId);
            });
        }

        async function duplicateExamination(examId) {
            try {
                const token = document.querySelector('meta[name="_csrf"]').content;
                const url = joinUrl(contextPath, '/patients/examination/' + encodeURIComponent(examId) + '/duplicate');
                const res = await fetch(url, {
                    method: 'POST',
                    headers: { 'X-CSRF-TOKEN': token }
                });
                const text = await res.text();
                let result;
                try { result = JSON.parse(text); } catch (_) { result = { success: res.ok, message: text }; }
                if (result.success) {
                    // Reload patient details to show new examination
                    window.location.reload();
                } else {
                    alert('Error: ' + (result.message || 'Failed to duplicate'));
                }
            } catch (e) {
                alert('Error: ' + e.message);
            }
        }

        // Clinical File Creation Functions
        function formatDateTime12Hour(dateTimeStr) {
            try {
                const date = new Date(dateTimeStr);
                const day = String(date.getDate()).padStart(2, '0');
                const month = String(date.getMonth() + 1).padStart(2, '0');
                const year = date.getFullYear();
                
                let hours = date.getHours();
                const minutes = String(date.getMinutes()).padStart(2, '0');
                const ampm = hours >= 12 ? 'PM' : 'AM';
                
                hours = hours % 12;
                hours = hours ? hours : 12; // the hour '0' should be '12'
                
                return day + '/' + month + '/' + year + ' ' + hours + ':' + minutes + ' ' + ampm;
            } catch (e) {
                // Fallback to original format if parsing fails
                return dateTimeStr;
            }
        }

        function showCreateFileModal() {
            populateExaminationSelection();
            document.getElementById('createFileModal').style.display = 'block';
        }

        function closeCreateFileModal() {
            document.getElementById('createFileModal').style.display = 'none';
            document.getElementById('createFileForm').reset();
        }

        function populateExaminationSelection() {
            const tableBody = document.getElementById('examinationSelectionTable');
            
            // Get all examination rows from the main table
            const examinationRows = document.querySelectorAll('#examinationHistoryTable tbody tr');
            let html = '';
            let totalCount = 0;

            examinationRows.forEach(row => {
                const examId = row.querySelector('.exam-id-col').textContent.trim();
                const toothCell = row.querySelector('[data-tooth]');
                const dateCell = row.querySelector('[data-date]');
                const procedureCell = row.querySelector('td:nth-child(5)');
                const doctorCell = row.querySelector('td:nth-child(8)');
                const statusCell = row.querySelector('td:nth-child(4)');

                if (toothCell && dateCell) {
                    const tooth = toothCell.getAttribute('data-tooth');
                    const dateStr = dateCell.getAttribute('data-date');
                    
                    // Check if this examination is already part of a clinical file
                    // We'll need to check this from the backend, but for now we'll show all examinations
                    // TODO: Add backend check for clinical file attachment
                    
                    totalCount++;
                    const toothDisplay = tooth === 'GENERAL_CONSULTATION' ? 'General Consultation' : tooth.replace('TOOTH_', '');
                    const procedure = procedureCell ? procedureCell.textContent.trim() : 'No procedure';
                    const doctor = doctorCell ? doctorCell.textContent.trim() : 'Not Assigned';
                    const status = statusCell ? statusCell.textContent.trim() : 'Unknown';
                    
                    // Format date and time in 12-hour format
                    const formattedDateTime = formatDateTime12Hour(dateStr);
                    
                    // Get status class
                    const statusClass = getStatusClass(status);
                    
                    html += '<tr>' +
                        '<td><input type="checkbox" name="selectedExaminations" value="' + examId + '" class="exam-checkbox"></td>' +
                        '<td>' + toothDisplay + '</td>' +
                        '<td>' + formattedDateTime + '</td>' +
                        '<td>' + procedure + '</td>' +
                        '<td>' + doctor + '</td>' +
                        '<td><span class="status-badge ' + statusClass + '">' + status + '</span></td>' +
                        '</tr>';
                }
            });

            if (totalCount === 0) {
                html = '<tr><td colspan="6" class="text-center text-muted">No examinations found for this patient</td></tr>';
            }

            tableBody.innerHTML = html;
            document.getElementById('totalCount').textContent = totalCount;
            updateSelectedCount();
            
            // Generate auto file name
            generateAutoFileName();
        }

        function generateAutoFileName() {
            const patientName = "${fn:escapeXml(patient.firstName)} ${fn:escapeXml(patient.lastName)}";
            const today = new Date();
            const dateStr = today.toLocaleDateString('en-GB'); // DD/MM/YYYY format
            const timeStr = today.toLocaleTimeString('en-US', { 
                hour12: false, 
                hour: '2-digit', 
                minute: '2-digit' 
            });
            
            // Get selected examinations count for counter
            const selectedCount = document.querySelectorAll('.exam-checkbox:checked').length;
            const totalCount = document.getElementById('totalCount').textContent;
            
            // Generate file name: PatientName_Date_Time_Examinations
            const fileName = patientName + '_ClinicalFile_' + dateStr.replace(/\//g, '-') + '_' + timeStr.replace(':', '-') + '_' + (selectedCount || totalCount) + 'Exams';
            
            document.getElementById('fileTitle').value = fileName;
        }

        function getStatusClass(status) {
            switch(status.toLowerCase()) {
                case 'open': return 'status-open';
                case 'in progress': return 'status-in-progress';
                case 'completed': return 'status-completed';
                case 'closed': return 'status-closed';
                default: return 'status-closed';
            }
        }

        function updateSelectedCount() {
            const selectedCheckboxes = document.querySelectorAll('.exam-checkbox:checked');
            const selectedCount = selectedCheckboxes.length;
            document.getElementById('selectedCount').textContent = selectedCount;
            
            // Update auto file name when selection changes
            generateAutoFileName();
        }

                function toggleSelectAll() {
            const selectAllCheckbox = document.getElementById('selectAll');
            const examCheckboxes = document.querySelectorAll('.exam-checkbox');

            examCheckboxes.forEach(checkbox => {
                checkbox.checked = selectAllCheckbox.checked;
            });
            updateSelectedCount();
        }

        // Step navigation functions
        function nextStep() {
            const step1 = document.getElementById('step1');
            const step2 = document.getElementById('step2');
            const stepIndicator1 = document.querySelector('.step[data-step="1"]');
            const stepIndicator2 = document.querySelector('.step[data-step="2"]');

            // Hide step 1, show step 2
            step1.classList.remove('active');
            step2.classList.add('active');
            stepIndicator1.classList.remove('active');
            stepIndicator2.classList.add('active');
        }

        function prevStep() {
            const step1 = document.getElementById('step1');
            const step2 = document.getElementById('step2');
            const stepIndicator1 = document.querySelector('.step[data-step="1"]');
            const stepIndicator2 = document.querySelector('.step[data-step="2"]');

            // Hide step 2, show step 1
            step2.classList.remove('active');
            step1.classList.add('active');
            stepIndicator2.classList.remove('active');
            stepIndicator1.classList.add('active');
        }

        // Handle form submission
        // Add event listener for checkbox changes to update count
        document.addEventListener('change', function(e) {
            if (e.target.classList.contains('exam-checkbox')) {
                updateSelectedCount();
            }
            if (e.target.classList.contains('examination-checkbox')) {
                updateTableSelectionCount();
            }
        });

        // Table examination selection functions
        function toggleSelectAllExaminations() {
            const selectAllCheckbox = document.getElementById('selectAllExaminations');
            const examinationCheckboxes = document.querySelectorAll('.examination-checkbox');

            examinationCheckboxes.forEach(checkbox => {
                checkbox.checked = selectAllCheckbox.checked;
            });
            updateTableSelectionCount();
        }

        function updateTableSelectionCount() {
            const selectedCheckboxes = document.querySelectorAll('.examination-checkbox:checked');
            const selectedCount = selectedCheckboxes.length;
            const selectedCountDisplay = document.getElementById('selectedCountDisplay');
            const bulkUploadBtn = document.getElementById('bulkUploadSelectedBtn');
            const bulkAssignBtn = document.getElementById('bulkAssignDoctorBtn');
            const bulkSendForPaymentBtn = document.getElementById('bulkSendForPaymentBtn');
            const selectedCountSpan = document.getElementById('selectedExaminationCount');

            selectedCountSpan.textContent = selectedCount;

            if (selectedCount > 0) {
                selectedCountDisplay.style.display = 'inline';
                if (bulkUploadBtn) bulkUploadBtn.style.display = 'inline-block';
                if (bulkAssignBtn) bulkAssignBtn.style.display = 'inline-block';
                if (bulkSendForPaymentBtn) bulkSendForPaymentBtn.style.display = 'inline-block';
            } else {
                selectedCountDisplay.style.display = 'none';
                if (bulkUploadBtn) bulkUploadBtn.style.display = 'none';
                if (bulkAssignBtn) bulkAssignBtn.style.display = 'none';
                if (bulkSendForPaymentBtn) bulkSendForPaymentBtn.style.display = 'none';
            }
        }

        function createClinicalFileFromTable() {
            const selectedCheckboxes = document.querySelectorAll('.examination-checkbox:checked');
            const selectedExaminationIds = Array.from(selectedCheckboxes).map(checkbox => checkbox.value);

            if (selectedExaminationIds.length === 0) {
                showAlertModal('Please select at least one examination to create a clinical file.', 'warning');
                return;
            }

            // Generate auto file name
            const patientName = "${fn:escapeXml(patient.firstName)} ${fn:escapeXml(patient.lastName)}";
            const today = new Date();
            const dateStr = today.toLocaleDateString('en-GB');
            const timeStr = today.toLocaleTimeString('en-US', { 
                hour12: false, 
                hour: '2-digit', 
                minute: '2-digit' 
            });
            
            const fileName = patientName + '_ClinicalFile_' + dateStr.replace(/\//g, '-') + '_' + timeStr.replace(':', '-') + '_' + selectedExaminationIds.length + 'Exams';

            const formData = {
                title: fileName,
                status: 'ACTIVE',
                notes: 'Clinical file created from examination table',
                patientId: '${patient.id}',
                examinationIds: selectedExaminationIds
            };

            // Show confirmation modal
            showConfirmationModal(
                'Create Clinical File',
                'Are you sure you want to create a clinical file with <strong>' + selectedExaminationIds.length + ' selected examinations</strong>?<br><br><strong>File Name:</strong> ' + fileName,
                'Create File',
                'Cancel',
                () => createClinicalFile(formData)
            );
        }

        function createClinicalFile(formData) {
            try {
                const token = document.querySelector('meta[name="_csrf"]').content;
                fetch(joinUrl(contextPath, '/clinical-files/create-with-examinations'), {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': token
                    },
                    body: JSON.stringify(formData)
                })
                .then(response => response.json())
                .then(result => {
                    if (result.success) {
                        showAlertModal('Clinical file created successfully!', 'success');
                        // Optionally redirect to the created file after a short delay
                        setTimeout(() => {
                            window.location.href = joinUrl(contextPath, '/clinical-files/' + result.file.id);
                        }, 1500);
                    } else {
                        showAlertModal('Error: ' + (result.message || 'Failed to create clinical file'), 'error');
                    }
                })
                .catch(error => {
                    showAlertModal('An error occurred while creating the clinical file.', 'error');
                });
            } catch (error) {
                showAlertModal('An error occurred while creating the clinical file.', 'error');
            }
        }

        const createFileForm = document.getElementById('createFileForm');
        if (createFileForm) {
            createFileForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const selectedExaminations = Array.from(document.querySelectorAll('.exam-checkbox:checked'))
                .map(checkbox => checkbox.value);
            
            if (selectedExaminations.length === 0) {
                alert('Please select at least one examination to include in the clinical file.');
                return;
            }

            const formData = {
                title: document.getElementById('fileTitle').value,
                status: document.getElementById('fileStatus').value,
                notes: document.getElementById('fileNotes').value,
                patientId: '${patient.id}',
                examinationIds: selectedExaminations
            };

            try {
                const token = document.querySelector('meta[name="_csrf"]').content;
                const response = await fetch(joinUrl(contextPath, '/clinical-files/create-with-examinations'), {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': token
                    },
                    body: JSON.stringify(formData)
                });

                const result = await response.json();
                
                if (result.success) {
                    alert('Clinical file created successfully!');
                    closeCreateFileModal();
                    // Optionally redirect to the created file
                    window.location.href = joinUrl(contextPath, '/clinical-files/' + result.file.id);
                } else {
                    alert('Error: ' + (result.message || 'Failed to create clinical file'));
                }
            } catch (error) {
                alert('An error occurred while creating the clinical file.');
            }
        });
        }

        // Modal Functions
        let alertOnCloseCallback = null;

        function showAlertModal(message, type = 'info', onClose = null) {
            const modal = document.getElementById('alertModal');
            const title = document.getElementById('alertTitle');
            const messageEl = document.getElementById('alertMessage');
            const icon = document.getElementById('alertIcon');

            // Set onClose callback if provided
            alertOnCloseCallback = typeof onClose === 'function' ? onClose : null;

            // Set title based on type
            switch(type) {
                case 'success':
                    title.textContent = 'Success';
                    icon.innerHTML = '<i class="fas fa-check-circle"></i>';
                    icon.className = 'alert-icon success';
                    break;
                case 'warning':
                    title.textContent = 'Warning';
                    icon.innerHTML = '<i class="fas fa-exclamation-triangle"></i>';
                    icon.className = 'alert-icon warning';
                    break;
                case 'error':
                    title.textContent = 'Error';
                    icon.innerHTML = '<i class="fas fa-times-circle"></i>';
                    icon.className = 'alert-icon error';
                    break;
                default:
                    title.textContent = 'Information';
                    icon.innerHTML = '<i class="fas fa-info-circle"></i>';
                    icon.className = 'alert-icon info';
            }

            messageEl.textContent = message;
            modal.style.display = 'block';
        }

        function closeAlertModal() {
            document.getElementById('alertModal').style.display = 'none';
            if (typeof alertOnCloseCallback === 'function') {
                const cb = alertOnCloseCallback;
                // Clear before calling to avoid re-entry issues
                alertOnCloseCallback = null;
                try { cb(); } catch (e) { /* ignore */ }
            }
        }

        function showConfirmationModal(title, message, confirmText = 'Confirm', cancelText = 'Cancel', onConfirm) {
            const modal = document.getElementById('confirmationModal');
            const titleEl = document.getElementById('confirmationTitle');
            const messageEl = document.getElementById('confirmationMessage');
            const confirmBtn = document.getElementById('confirmBtn');

            titleEl.textContent = title;
            messageEl.innerHTML = message;
            confirmBtn.textContent = confirmText;

            // Remove existing event listeners
            const newConfirmBtn = confirmBtn.cloneNode(true);
            confirmBtn.parentNode.replaceChild(newConfirmBtn, confirmBtn);

            // Add new event listener
            newConfirmBtn.addEventListener('click', () => {
                closeConfirmationModal();
                if (onConfirm) onConfirm();
            });

            modal.style.display = 'block';
        }

        function closeConfirmationModal() {
            document.getElementById('confirmationModal').style.display = 'none';
        }

        // Close modals when clicking outside
        window.onclick = function(event) {
            const alertModal = document.getElementById('alertModal');
            const confirmationModal = document.getElementById('confirmationModal');
            
            if (event.target === alertModal) {
                closeAlertModal();
            }
            if (event.target === confirmationModal) {
                closeConfirmationModal();
            }
        }


    </script>
    
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

        /* Blinking Payment Button - Enhanced and Stable */
        .blinking-payment-btn {
            animation: blinkPayment 2s ease-in-out infinite;
            position: relative;
            padding: 6px 12px !important;
            font-size: 12px !important;
            font-weight: 700 !important;
            border-radius: 5px !important;
            border: 1px solid #28a745 !important;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%) !important;
            color: white !important;
            text-transform: uppercase !important;
            letter-spacing: 0.5px !important;
            box-shadow: 0 3px 10px rgba(40, 167, 69, 0.4);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            overflow: hidden;
            white-space: nowrap;
            margin-left: auto;
        }

        .blinking-payment-btn:hover {
            transform: translateY(-1px) scale(1.01);
            box-shadow: 0 6px 15px rgba(40, 167, 69, 0.5);
            background: linear-gradient(135deg, #20c997 0%, #17a2b8 100%) !important;
        }

        .blinking-payment-btn .payment-text {
            display: inline-block;
            font-weight: 700;
            white-space: nowrap;
            position: relative;
            z-index: 2;
        }

        @keyframes blinkPayment {
            0%, 50% {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%) !important;
                border-color: #28a745 !important;
                box-shadow: 0 3px 10px rgba(40, 167, 69, 0.4);
            }
            25%, 75% {
                background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%) !important;
                border-color: #ffc107 !important;
                box-shadow: 0 3px 10px rgba(255, 193, 7, 0.5);
            }
        }

        .pending-payment-section {
            background: #fff8e1;
            border: 1px solid #ffcc02;
            border-radius: 8px;
            padding: 15px;
            margin: 15px 0;
            box-shadow: 0 1px 5px rgba(255, 193, 7, 0.1);
        }

        .pending-payment-section h4 {
            color: #856404;
            margin-bottom: 10px;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .pending-payment-section p {
            font-size: 0.9rem;
            margin-bottom: 10px;
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
        
        /* Customer Ledger Color Coding */
        .ledger-capture-row {
            background-color: rgba(40, 167, 69, 0.05);
            border-left: 3px solid #28a745;
        }
        
        .ledger-refund-row {
            background-color: rgba(220, 53, 69, 0.05);
            border-left: 3px solid #dc3545;
        }
        
        .ledger-capture-row:hover {
            background-color: rgba(40, 167, 69, 0.1);
        }
        
        .ledger-refund-row:hover {
            background-color: rgba(220, 53, 69, 0.1);
        }
        
        /* Additional styles for patient details page */
        .patient-details-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
            padding: 15px;
            margin-bottom: 12px;
        }
        
        .patient-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .patient-header h2 {
            margin: 0;
            color: #2c3e50;
            font-size: 1.5rem;
        }
        
        .patient-actions {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
            align-items: center;
            justify-content: flex-start;
            margin-top: 10px;
            padding: 8px;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            border-radius: 6px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
        }
        
        .patient-actions .btn {
            font-size: 12px;
            font-weight: 600;
            padding: 5px 9px;
            border-radius: 4px;
            border: 1px solid transparent;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 3px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            white-space: nowrap;
            line-height: 1.2;
            position: relative;
            overflow: hidden;
        }
        
        .patient-actions .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }
        
        .patient-actions .btn:hover::before {
            left: 100%;
        }
        
        .patient-actions .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        
        .patient-actions .btn-sm {
            font-size: 11px;
            padding: 4px 8px;
        }
        
        .patient-actions .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
            border-color: #6c757d;
            color: white;
            box-shadow: 0 2px 6px rgba(108, 117, 125, 0.3);
        }

        .patient-actions .btn-secondary:hover {
            background: linear-gradient(135deg, #5a6268 0%, #495057 100%);
            border-color: #545b62;
            color: white;
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.4);
        }

        .patient-actions .btn-primary {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            border-color: #007bff;
            color: white;
            box-shadow: 0 2px 6px rgba(0, 123, 255, 0.3);
        }

        .patient-actions .btn-primary:hover {
            background: linear-gradient(135deg, #0056b3 0%, #004085 100%);
            border-color: #004085;
            color: white;
            box-shadow: 0 4px 12px rgba(0, 123, 255, 0.4);
        }

        .patient-actions .btn-info {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            border-color: #17a2b8;
            color: white;
            box-shadow: 0 2px 6px rgba(23, 162, 184, 0.3);
        }

        .patient-actions .btn-info:hover {
            background: linear-gradient(135deg, #138496 0%, #117a8b 100%);
            border-color: #117a8b;
            color: white;
            box-shadow: 0 4px 12px rgba(23, 162, 184, 0.4);
        }
        
        /* Responsive Design for Patient Actions */
        @media (max-width: 768px) {
            .patient-actions {
                flex-direction: column;
                gap: 10px;
                padding: 15px;
                margin-top: 15px;
            }
            
            .patient-actions .btn {
                width: 100%;
                justify-content: center;
                padding: 12px 16px;
            }
            
            .blinking-payment-btn {
                padding: 16px 24px !important;
                font-size: 18px !important;
            }
        }
        
        @media (max-width: 480px) {
            .patient-actions {
                padding: 12px;
                gap: 8px;
            }
            
            .patient-actions .btn {
                font-size: 0.8rem;
                padding: 10px 14px;
            }
            
            .patient-actions .btn-sm {
                font-size: 0.75rem;
                padding: 8px 12px;
            }
        }
        
        .patient-info {
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 12px;
        }
        
        .info-section {
            margin-bottom: 12px;
        }
        
        .info-section h3 {
            color: #3498db;
            font-size: 1rem;
            margin-bottom: 10px;
            font-weight: 600;
            border-bottom: 1px solid #f0f0f0;
            padding-bottom: 6px;
        }
        
        .info-item {
            margin-bottom: 8px;
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
            margin-top: 15px;
        }
        
        /* Quick Add Examination Button Styles */
        .quick-add-examination-section {
            margin: 20px 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }
        
        .quick-add-container {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 10px;
        }
        
        .quick-add-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 12px;
            padding: 20px 40px;
            color: white;
            font-size: 1.1rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            min-width: 280px;
            cursor: pointer;
        }
        
        .quick-add-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(102, 126, 234, 0.4);
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
        }
        
        .quick-add-btn:active {
            transform: translateY(-1px);
        }
        
        .quick-add-btn i {
            font-size: 2rem;
            margin-bottom: 5px;
        }
        
        .btn-text {
            font-size: 1.2rem;
            font-weight: 700;
        }
        
        .btn-subtitle {
            font-size: 0.85rem;
            opacity: 0.9;
            font-weight: 400;
            text-transform: none;
            letter-spacing: normal;
        }
        
        @media (max-width: 768px) {
            .quick-add-btn {
                min-width: 250px;
                padding: 18px 30px;
            }
            
            .btn-text {
                font-size: 1.1rem;
            }
        }
        
        /* Quick Add Modal Styles */
        .quick-add-modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            overflow-y: auto;
        }
        
        .quick-add-modal .modal-content {
            background-color: #fefefe;
            margin: 2% auto;
            padding: 30px;
            border: none;
            border-radius: 12px;
            width: 90%;
            max-width: 800px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        
        .tooth-selection-section .tooth-grid {
            margin: 20px 0;
        }
        
        .jaw-section {
            margin-bottom: 25px;
        }
        
        .jaw-section h4 {
            color: #2c3e50;
            margin-bottom: 10px;
            font-size: 1.1rem;
        }
        
        .teeth-row {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            justify-content: center;
            margin-bottom: 15px;
        }
        
        .tooth-selector {
            width: 45px;
            height: 45px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: white;
            font-weight: 600;
            color: #666;
        }
        
        .tooth-selector:hover {
            border-color: #3498db;
            background: #f8f9fa;
            transform: translateY(-2px);
        }
        
        .tooth-selector.selected {
            background: linear-gradient(135deg, #3498db, #2980b9);
            border-color: #2980b9;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
        }
        
        .tooth-number {
            font-size: 0.9rem;
        }
        
        .selected-teeth-info {
            margin-top: 15px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            text-align: center;
        }
        
        .selected-teeth-list {
            margin-top: 10px;
            font-size: 0.9rem;
            color: #666;
        }
        
        /* Compact Tooth Selection Styles for Duplicate Modal */
        .tooth-selection-container {
            margin: 15px 0;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
        }
        
        .compact-dental-chart {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }
        
        .compact-teeth-row {
            display: flex;
            gap: 5px;
            justify-content: center;
        }
        
        .compact-tooth {
            width: 35px;
            height: 35px;
            border: 2px solid #ddd;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            font-weight: 600;
            cursor: pointer;
            background: white;
            transition: all 0.2s ease;
            color: #666;
        }
        
        .compact-tooth:hover {
            border-color: #3498db;
            background: #e3f2fd;
            transform: translateY(-1px);
        }
        
        .compact-tooth.selected {
            background: #3498db;
            border-color: #2980b9;
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(52, 152, 219, 0.3);
        }
        
        .section-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
            display: block;
        }
        
        .selected-count {
            font-weight: 600;
            color: #2c3e50;
        }
        
        .selected-teeth-list {
            margin-top: 10px;
            font-size: 0.9rem;
            color: #666;
        }
        
        .autocomplete-container {
            position: relative;
        }
        
        .autocomplete-dropdown {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            border: 1px solid #e0e0e0;
            border-top: none;
            border-radius: 0 0 8px 8px;
            max-height: 200px;
            overflow-y: auto;
            z-index: 1001;
            display: none;
        }
        
        .autocomplete-item {
            padding: 12px 15px;
            cursor: pointer;
            border-bottom: 1px solid #f0f0f0;
            transition: background-color 0.2s ease;
        }
        
        .autocomplete-item:hover,
        .autocomplete-item.highlighted {
            background-color: #f8f9fa;
        }
        
        .autocomplete-item:last-child {
            border-bottom: none;
        }
        
        .procedure-name {
            font-weight: 600;
            color: #2c3e50;
        }
        
        .procedure-price {
            font-size: 0.9rem;
            color: #27ae60;
            margin-top: 2px;
        }
        
        .selected-procedure-info {
            margin-top: 15px;
        }
        
        .selected-procedure-info .procedure-card {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #3498db;
        }
        
        .selected-procedure-info h4 {
            margin: 0 0 5px 0;
            color: #2c3e50;
            font-size: 1.1rem;
        }
        
        .selected-procedure-info .procedure-price {
            margin: 0;
            font-size: 1.1rem;
            font-weight: 600;
            color: #27ae60;
        }
        
        .summary-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
        }
        
        .summary-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        
        .summary-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .summary-item:last-child {
            border-bottom: none;
        }
        
        .summary-label {
            font-weight: 600;
            color: #2c3e50;
        }
        
        .summary-value {
            font-weight: 600;
            color: #3498db;
        }
        
        .form-section {
            margin-bottom: 25px;
        }
        
        .form-section h3 {
            color: #2c3e50;
            margin-bottom: 10px;
            font-size: 1.2rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .section-description {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 15px;
        }
        
        @media (max-width: 768px) {
            .quick-add-modal .modal-content {
                width: 95%;
                margin: 5% auto;
                padding: 20px;
            }
            
            .teeth-row {
                gap: 6px;
            }
            
            .tooth-selector {
                width: 40px;
                height: 40px;
            }
            
            .summary-content {
                grid-template-columns: 1fr;
            }
        }
        
        .sort-controls {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
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
            padding: 10px 12px;
            text-align: left;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .table td {
            padding: 8px 12px;
            border-bottom: 1px solid #e0e0e0;
            color: #4b5563;
        }

        /* Align action buttons neatly */
        .action-buttons {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            white-space: nowrap;
        }

        /* Instant tooltips */
        .has-tooltip {
            position: relative;
        }
        .has-tooltip::after {
            content: attr(data-tooltip);
            position: absolute;
            bottom: 100%;
            left: 50%;
            transform: translateX(-50%);
            background: #2c3e50;
            color: #fff;
            padding: 6px 8px;
            border-radius: 4px;
            font-size: 12px;
            white-space: nowrap;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.05s ease;
            margin-bottom: 6px;
            z-index: 10;
        }
        .has-tooltip::before {
            content: '';
            position: absolute;
            bottom: 100%;
            left: 50%;
            transform: translateX(-50%);
            border-width: 6px;
            border-style: solid;
            border-color: transparent transparent #2c3e50 transparent;
            opacity: 0;
            transition: opacity 0.05s ease;
            margin-bottom: -6px;
            z-index: 10;
        }
        .has-tooltip:hover::after,
        .has-tooltip:hover::before {
            opacity: 1;
        }

        /* Avoid overlap: only show parent tooltip when not hovering on a child */
        .parent-tooltips {
            position: relative;
        }
        .parent-tooltips:hover::after,
        .parent-tooltips:hover::before {
            opacity: 1;
        }
        /* Hide parent tooltip if any child with tooltip is hovered */
        .parent-tooltips:hover:has(.has-tooltip:hover)::after,
        .parent-tooltips:hover:has(.has-tooltip:hover)::before {
            opacity: 0;
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
        
        .file-id-badge {
            background: #3498db;
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .no-file {
            color: #6c757d;
            font-style: italic;
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
        
        /* Procedure column styling */
        .procedure-name {
            font-weight: 500;
            color: #2c3e50;
            display: block;
        }
        
        .procedure-price {
            color: #27ae60;
            font-weight: 500;
            font-size: 0.85rem;
        }
        
        /* Dental Chart section styles */
        .dental-chart-section {
            margin-top: 30px;
        }
        
        /* General Consultation Section styles */
        .general-consultation-section {
            margin-bottom: 30px;
        }
        
        .consultation-card {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 25px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.2);
        }
        
        .consultation-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.3);
        }
        
        .consultation-icon {
            font-size: 2.5rem;
            opacity: 0.9;
        }
        
        .consultation-content h3 {
            margin: 0 0 8px 0;
            font-size: 1.3rem;
            font-weight: 600;
        }
        
        .consultation-content p {
            margin: 0;
            opacity: 0.9;
            font-size: 0.95rem;
        }
        

        
        .form-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #eee;
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
        
        /* View Notes Link Styles */
        .view-notes-link {
            color: #3498db;
            text-decoration: none;
            font-weight: 500;
            padding: 4px 8px;
            border-radius: 4px;
            background: rgba(52, 152, 219, 0.1);
            transition: all 0.2s ease;
            font-size: 0.85rem;
        }
        
        .view-notes-link:hover {
            background: rgba(52, 152, 219, 0.2);
            color: #2980b9;
            text-decoration: none;
        }
        
        /* Notes Popup Modal Styles */
        .notes-modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(2px);
        }
        
        .notes-modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 0;
            border-radius: 12px;
            width: 90%;
            max-width: 600px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            animation: modalSlideIn 0.3s ease-out;
        }
        
        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .notes-modal-header {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            padding: 20px;
            border-radius: 12px 12px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .notes-modal-title {
            margin: 0;
            font-size: 1.2rem;
            font-weight: 600;
        }
        
        .notes-modal-close {
            color: white;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            line-height: 1;
            transition: opacity 0.2s ease;
        }
        
        .notes-modal-close:hover {
            opacity: 0.7;
        }
        
        .notes-modal-body {
            padding: 25px;
            max-height: 400px;
            overflow-y: auto;
        }
        
        .notes-content {
            font-size: 1rem;
            line-height: 1.6;
            color: #2c3e50;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        
        .notes-modal-footer {
            padding: 15px 25px;
            border-top: 1px solid #e9ecef;
            text-align: right;
        }
        
        .btn-close-modal {
            background: #6c757d;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: background-color 0.2s ease;
        }
        
        .btn-close-modal:hover {
            background: #5a6268;
        }
        

        
        /* Color Code Strip Styles */
        .color-code-strip {
            width: 100%;
            height: 8px;
            border-radius: 4px 4px 0 0;
            margin-bottom: 0;
            position: relative;
        }
        
        .color-code-strip.code-blue {
            background: linear-gradient(90deg, #0066CC, #0052a3);
        }
        
        .color-code-strip.code-yellow {
            background: linear-gradient(90deg, #FFD700, #FFC107);
        }
        
        .color-code-strip.no-code {
            background: linear-gradient(90deg, #E0E0E0, #BDBDBD);
        }
        
        /* Chairside Note Floating Button */
        .chairside-note-fab {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #3498db, #2980b9);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 4px 20px rgba(52, 152, 219, 0.3);
            transition: all 0.3s ease;
            z-index: 1000;
            color: white;
            font-size: 1.5rem;
        }
        
        .chairside-note-fab:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 25px rgba(52, 152, 219, 0.4);
        }
        
        .chairside-note-fab .fab-tooltip {
            position: absolute;
            right: 70px;
            background: #2c3e50;
            color: white;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 0.8rem;
            white-space: nowrap;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            pointer-events: none;
        }
        
        .chairside-note-fab:hover .fab-tooltip {
            opacity: 1;
            visibility: visible;
        }
        
        /* Chairside Note Modal */
        .chairside-note-modal {
            display: none;
            position: fixed;
            z-index: 2000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(5px);
        }
        
        .chairside-note-modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 0;
            border-radius: 12px;
            width: 95%;
            max-width: 800px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            animation: modalSlideIn 0.3s ease;
        }
        
        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .chairside-note-modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 25px;
            border-bottom: 1px solid #e9ecef;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 12px 12px 0 0;
        }
        
        .chairside-note-modal-header h3 {
            margin: 0;
            color: #2c3e50;
            font-size: 1.3rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .chairside-note-modal-close {
            color: #6c757d;
            font-size: 1.5rem;
            font-weight: bold;
            cursor: pointer;
            transition: color 0.3s ease;
        }
        
        .chairside-note-modal-close:hover {
            color: #dc3545;
        }
        
        .chairside-note-modal-body {
            padding: 25px;
        }
        
        .chairside-note-modal-body .form-control {
            width: 100%;
            min-height: 200px;
            resize: vertical;
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
            line-height: 1.5;
        }
        
        .chairside-note-modal-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 24px 32px;
            border-top: 1px solid #e9ecef;
            background: linear-gradient(135deg, #f8f9fa, #ffffff);
            border-radius: 0 0 12px 12px;
        }
        
        .footer-left {
            display: flex;
            align-items: center;
        }
        
        .footer-right {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .chairside-note-modal-footer .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 10px 20px;
            font-weight: 500;
            font-size: 14px;
            border-radius: 8px;
            border: 2px solid transparent;
            transition: all 0.3s ease;
            cursor: pointer;
            text-decoration: none;
            min-width: 100px;
            height: 40px;
        }
        
        .chairside-note-modal-footer .btn-outline-danger {
            background: transparent;
            color: #dc3545;
            border-color: #dc3545;
        }
        
        .chairside-note-modal-footer .btn-outline-danger:hover {
            background: #dc3545;
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
        }
        
        .chairside-note-modal-footer .btn-outline-secondary {
            background: transparent;
            color: #6c757d;
            border-color: #6c757d;
        }
        
        .chairside-note-modal-footer .btn-outline-secondary:hover {
            background: #6c757d;
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.3);
        }
        
        .chairside-note-modal-footer .btn-primary {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            border-color: #007bff;
            min-width: 120px;
            font-weight: 600;
        }
        
        .chairside-note-modal-footer .btn-primary:hover {
            background: linear-gradient(135deg, #0056b3, #004085);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
        }
        
        .btn-danger:hover {
            background: linear-gradient(135deg, #c82333, #a71e2a);
            transform: translateY(-1px);
        }
        
        .form-text {
            margin-top: 8px;
            font-size: 0.85rem;
            color: #6c757d;
        }
        
        .form-text i {
            margin-right: 5px;
        }

                /* Clinical File Modal Styles */
        .file-actions {
            margin-left: auto;
        }

        .file-actions .btn {
            margin-left: 10px;
        }

        /* Step Indicator */
        .step-indicator {
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 20px 0;
            gap: 15px;
        }

        .step {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 5px;
            opacity: 0.5;
            transition: all 0.3s ease;
        }

        .step.active {
            opacity: 1;
        }

        .step-number {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: #e9ecef;
            color: #6c757d;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .step.active .step-number {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }

        .step-label {
            font-size: 0.8rem;
            font-weight: 500;
            color: #6c757d;
        }

        .step.active .step-label {
            color: #495057;
        }

        .step-line {
            width: 40px;
            height: 2px;
            background: #e9ecef;
            border-radius: 1px;
        }

        /* Form Steps */
        .form-step {
            display: none;
        }

        .form-step.active {
            display: block;
        }

        /* Section Headers */
        .section-header-with-counter {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .section-header-with-counter h3 {
            margin: 0;
            color: #2c3e50;
            font-size: 1.2rem;
            font-weight: 600;
        }

        .section-header-with-counter h3 i {
            color: #3498db;
            margin-right: 8px;
        }

        .selection-counter {
            background: #e3f2fd;
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            color: #1976d2;
            font-weight: 500;
        }

        /* Info Alert */
        .info-alert {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 6px;
            border-left: 4px solid #3498db;
            margin-bottom: 20px;
        }

        .info-alert i {
            color: #3498db;
            font-size: 1.1rem;
            margin-top: 2px;
        }

        .info-content strong {
            display: block;
            margin-bottom: 5px;
            color: #2c3e50;
            font-size: 0.9rem;
        }

        .info-content p {
            margin: 0;
            color: #6c757d;
            font-size: 0.85rem;
        }

        /* Examination Selection */
        .examination-selection {
            margin-top: 15px;
        }

        .select-all-container {
            margin-bottom: 15px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 4px;
        }

        .select-all-checkbox {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            font-weight: 500;
            color: #495057;
            margin: 0;
        }

        .select-all-checkbox input[type="checkbox"] {
            display: none;
        }

        .checkmark {
            width: 18px;
            height: 18px;
            border: 2px solid #dee2e6;
            border-radius: 3px;
            position: relative;
            transition: all 0.3s ease;
        }

        .select-all-checkbox input[type="checkbox"]:checked + .checkmark {
            background: #3498db;
            border-color: #3498db;
        }

        .select-all-checkbox input[type="checkbox"]:checked + .checkmark::after {
            content: '✓';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: white;
            font-size: 11px;
            font-weight: bold;
        }

        /* Examination Table */
        .examination-table-container {
            max-height: 300px;
            overflow-y: auto;
            border: 1px solid #dee2e6;
            border-radius: 4px;
        }

        .examination-table {
            margin-bottom: 0;
        }

        .examination-table th {
            background-color: #f8f9fa;
            position: sticky;
            top: 0;
            z-index: 1;
            font-weight: 600;
            color: #495057;
        }

        .examination-table td {
            vertical-align: middle;
        }

        .exam-checkbox {
            margin: 0;
        }

        .status-badge {
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            color: white;
            text-transform: uppercase;
        }

        .status-open { background-color: #28a745; }
        .status-in-progress { background-color: #ffc107; color: #212529; }
        .status-completed { background-color: #17a2b8; }
        .status-closed { background-color: #6c757d; }

        /* Table Header Actions */
        .table-header-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .clinical-file-actions-row {
            margin-top: 10px;
            padding: 8px 0;
            border-top: 1px solid #e9ecef;
            display: flex;
            justify-content: flex-end;
        }

        .clinical-file-actions {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .table-header-actions {
            margin-bottom: 5px;
        }

        .selected-count {
            background: #e3f2fd;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            color: #1976d2;
            font-weight: 500;
        }

        /* Examination Checkbox Styles */
        .examination-checkbox {
            margin: 0;
            cursor: pointer;
        }

        .examination-row:hover {
            background-color: #f8f9fa;
        }

        .examination-row td:first-child {
            text-align: center;
        }

        /* Alert Modal Styles */
        .alert-modal {
            max-width: 500px !important;
        }

        .alert-content {
            display: flex;
            align-items: flex-start;
            gap: 15px;
            padding: 10px 0;
        }

        .alert-icon {
            font-size: 2rem;
            margin-top: 5px;
        }

        .alert-icon.success {
            color: #28a745;
        }

        .alert-icon.warning {
            color: #ffc107;
        }

        .alert-icon.error {
            color: #dc3545;
        }

        .alert-icon.info {
            color: #17a2b8;
        }

        /* Confirmation Modal Styles */
        .confirmation-modal {
            max-width: 600px !important;
        }

        .confirmation-content {
            display: flex;
            align-items: flex-start;
            gap: 15px;
            padding: 10px 0;
        }

        /* Duplicate Examination Modal Styles */
        .checkbox-container {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            cursor: pointer;
            position: relative;
            padding-left: 35px;
            user-select: none;
        }

        .checkbox-container input[type="checkbox"] {
            position: absolute;
            opacity: 0;
            cursor: pointer;
            height: 0;
            width: 0;
        }

        .checkmark {
            position: absolute;
            top: 0;
            left: 0;
            height: 20px;
            width: 20px;
            background-color: #eee;
            border: 2px solid #ddd;
            border-radius: 4px;
            transition: all 0.3s ease;
        }

        .checkbox-container:hover input ~ .checkmark {
            background-color: #ccc;
        }

        .checkbox-container input:checked ~ .checkmark {
            background-color: #007bff;
            border-color: #007bff;
        }

        .checkmark:after {
            content: "";
            position: absolute;
            display: none;
        }

        .checkbox-container input:checked ~ .checkmark:after {
            display: block;
        }

        .checkbox-container .checkmark:after {
            left: 6px;
            top: 2px;
            width: 6px;
            height: 10px;
            border: solid white;
            border-width: 0 3px 3px 0;
            transform: rotate(45deg);
        }

        .checkbox-label {
            font-weight: 500;
            color: #333;
        }

        .detail-count {
            color: #6c757d;
            font-size: 0.9em;
            font-weight: normal;
        }

        .detail-price {
            color: #28a745;
            font-size: 0.9em;
            font-weight: 600;
            margin-left: 8px;
        }

        .detail-name {
            color: #007bff;
            font-size: 0.9em;
            font-weight: normal;
        }

        .confirmation-icon {
            font-size: 2.5rem;
            color: #3498db;
            margin-top: 5px;
        }

        .confirmation-message {
            flex: 1;
            line-height: 1.6;
        }

        .confirmation-message strong {
            color: #2c3e50;
        }

        /* Clinical Files Section Styles */
        .clinical-files-section {
            margin-bottom: 30px;
        }

        .collapsible-header {
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .collapsible-header:hover {
            background-color: #f8f9fa;
        }

        .collapsible-header h2 {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
        }

        .file-count {
            font-size: 0.9rem;
            color: #6c757d;
            font-weight: normal;
        }

        .toggle-icon {
            margin-left: auto;
            transition: transform 0.3s ease;
        }

        .toggle-icon.rotated {
            transform: rotate(180deg);
        }

        .clinical-files-container {
            margin-top: 15px;
            border-top: 1px solid #e9ecef;
            padding-top: 15px;
        }

        .clinical-files-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .clinical-file-entry {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 16px;
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .clinical-file-entry:hover {
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            border-color: #3498db;
        }

        .file-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .file-main {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .file-number {
            font-weight: 700;
            color: #2c3e50;
            font-size: 1.1rem;
            min-width: 50px;
            background: #f8f9fa;
            padding: 4px 8px;
            border-radius: 6px;
            text-align: center;
            border: 2px solid #e9ecef;
        }

        .file-title {
            font-weight: 500;
            color: #2c3e50;
            flex: 1;
        }

        .file-status {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .status-active {
            background: #e8f5e8;
            color: #27ae60;
        }

        .status-closed {
            background: #fff3cd;
            color: #856404;
        }

        .status-archived {
            background: #f8d7da;
            color: #721c24;
        }

        .status-pending_review {
            background: #d1ecf1;
            color: #0c5460;
        }

        .file-details {
            display: flex;
            gap: 20px;
            font-size: 0.85rem;
            color: #6c757d;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .detail-item i {
            color: #3498db;
            width: 14px;
        }

        .file-actions {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .file-actions .btn {
            font-size: 0.8rem;
            padding: 6px 12px;
            white-space: nowrap;
        }

        /* Pagination Styles */
        .pagination-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }

        .pagination-info {
            font-size: 0.9rem;
            color: #6c757d;
        }

        .pagination-controls {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .pagination-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 12px;
            border: 1px solid #dee2e6;
            background: white;
            color: #495057;
            text-decoration: none;
            border-radius: 4px;
            font-size: 0.9rem;
            transition: all 0.2s ease;
            min-width: 40px;
        }

        .pagination-button:hover {
            background: #e9ecef;
            border-color: #adb5bd;
            color: #495057;
            text-decoration: none;
        }

        .pagination-button:disabled {
            background: #f8f9fa;
            color: #adb5bd;
            cursor: not-allowed;
            border-color: #dee2e6;
        }

        .pagination-button.active {
            background: #3498db;
            color: white;
            border-color: #3498db;
        }

        /* Layout optimization: arrange info sections side-by-side while responsive */
        .patient-details-container .patient-info {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px 24px;
        }
        @media (max-width: 992px) {
            .patient-details-container .patient-info {
                grid-template-columns: 1fr;
            }
        }

        /* Preserve section styling and improve readability */
        .patient-details-container .info-section {
            background: #ffffff;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 16px;
        }

        /* Align labels and values side-by-side within items */
        .patient-details-container .info-item {
            display: grid;
            grid-template-columns: 200px 1fr;
            align-items: center;
            column-gap: 12px;
            row-gap: 6px;
            padding: 6px 0;
            border-bottom: 1px dashed #f0f2f5;
        }
        .patient-details-container .info-item:last-child {
            border-bottom: none;
        }
        .patient-details-container .info-label {
            color: #6c757d;
        }
        .patient-details-container .info-value {
            color: #343a40;
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
            <!-- Color Code Strip -->
            <jsp:include page="/WEB-INF/views/common/color-code-component.jsp" />
            
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
                    <p class="patient-id">Registration Code: ${patient.registrationCode}</p>
                    
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
                    <!-- Pending Payment Button -->
                    <c:if test="${hasPendingPayments}">
                        <a href="${pageContext.request.contextPath}/payments/patient/${patient.id}" 
                           class="blinking-payment-btn btn btn-warning">
                            <i class="fas fa-credit-card"></i>
                            <span class="payment-text">Pending Payment</span>
                            <span class="payment-text-alt">Click to View</span>
                        </a>
                    </c:if>
                    
                    <a href="${pageContext.request.contextPath}/patients/edit/${patient.id}" class="btn btn-secondary">
                        <i class="fas fa-edit"></i> Edit
                    </a>
                    <button onclick="printRegistrationDetails()" class="btn btn-primary btn-sm">
                        <i class="fas fa-print"></i> Print Registration
                    </button>
                    <button onclick="openCustomerLedger()" class="btn btn-info btn-sm">
                        <i class="fas fa-file-invoice-dollar"></i> Customer Ledger
                    </button>
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
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty patient.occupation}">${fn:escapeXml(patient.occupation.displayName)}</c:when>
                                <c:otherwise>Not specified</c:otherwise>
                            </c:choose>
                        </span>
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
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty patient.email}">${fn:escapeXml(patient.email)}</c:when>
                                <c:otherwise>Not provided</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
                
                <div class="info-section">
                    <h3>Address Information</h3>
                    <div class="info-item">
                        <span class="info-label">Street Address</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty patient.streetAddress}">${fn:escapeXml(patient.streetAddress)}</c:when>
                                <c:otherwise>Not provided</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">State</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty patient.state}">${fn:escapeXml(patient.state)}</c:when>
                                <c:otherwise>Not provided</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">City</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty patient.city}">${fn:escapeXml(patient.city)}</c:when>
                                <c:otherwise>Not provided</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Pincode</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty patient.pincode}">${fn:escapeXml(patient.pincode)}</c:when>
                                <c:otherwise>Not provided</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
                
                <div class="info-section">
                    <h3>Medical Information</h3>
                    <div class="info-item">
                        <span class="info-label">Medical History</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty patient.medicalHistory}">${fn:escapeXml(patient.medicalHistory)}</c:when>
                                <c:otherwise>None reported</c:otherwise>
                            </c:choose>
                        </span>
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
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty patient.referralModel}">${fn:escapeXml(patient.referralModel.displayName)}</c:when>
                                <c:otherwise>Not specified</c:otherwise>
                            </c:choose>
                        </span>
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
                                    <i class="fas fa-user-plus"></i> ${patient.createdBy.firstName} ${patient.createdBy.lastName}
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
                                    <i class="fas fa-hospital"></i> ${patient.registeredClinic.clinicName}
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
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty patient.emergencyContactName}">${fn:escapeXml(patient.emergencyContactName)}</c:when>
                                <c:otherwise>Not provided</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Emergency Contact Phone</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty patient.emergencyContactPhoneNumber}">${fn:escapeXml(patient.emergencyContactPhoneNumber)}</c:when>
                                <c:otherwise>Not provided</c:otherwise>
                            </c:choose>
                        </span>
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
            
            <!-- General Consultation Section -->
            <div class="general-consultation-section" 
                 <c:if test="${currentUserRole == 'RECEPTIONIST' || !patient.checkedIn}">style="opacity: 0.6; pointer-events: none;"</c:if>>
                <div class="consultation-card" onclick="openGeneralConsultation()">
                    <div class="consultation-icon">
                        <i class="fas fa-stethoscope"></i>
                    </div>
                    <div class="consultation-content">
                        <h3>General Consultation</h3>
                        <p>Click here to add a general consultation record</p>
                    </div>
                </div>
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
        
        <!-- Clinical Files Section -->
        <div class="patient-details-container clinical-files-section">
            <div class="patient-header collapsible-header" onclick="toggleClinicalFiles()">
                <h2><i class="fas fa-folder-medical"></i> Clinical Files 
                    <span class="file-count">(
                        <c:choose>
                            <c:when test="${not empty clinicalFiles}">${fn:length(clinicalFiles)}</c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    )</span>
                    <i class="fas fa-chevron-down toggle-icon" id="clinicalFilesToggleIcon"></i>
                </h2>
            </div>
            
            <div class="clinical-files-container" id="clinicalFilesContainer" style="display: none;">
                <c:choose>
                    <c:when test="${not empty clinicalFiles}">
                        <div class="clinical-files-list">
                            <c:forEach items="${clinicalFiles}" var="file">
                                <div class="clinical-file-entry">
                                    <div class="file-info">
                                            <div class="file-main">
                                                <div class="file-number">${file.fileNumber}</div>
                                                <c:choose>
                                                    <c:when test="${not empty file.title}">
                                                        <div class="file-title">${fn:escapeXml(file.title)}</div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="file-title">Untitled File</div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:choose>
                                                    <c:when test="${not empty file.status}">
                                                        <c:set var="statusName" value="${file.status.name()}"/>
                                                        <div class="file-status status-${fn:toLowerCase(statusName)}">${statusName}</div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="file-status status-active">ACTIVE</div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        <div class="file-details">
                                            <span class="detail-item">
                                                <i class="fas fa-calendar"></i>
                                                <c:choose>
                                                    <c:when test="${not empty file.createdAtFormatted}">${fn:escapeXml(file.createdAtFormatted)}</c:when>
                                                    <c:otherwise>Not available</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span class="detail-item">
                                                <i class="fas fa-list"></i>
                                                <c:choose>
                                                    <c:when test="${not empty file.examinationCount}">${file.examinationCount}</c:when>
                                                    <c:otherwise>0</c:otherwise>
                                                </c:choose> examinations
                                            </span>
                                            <c:if test="${not empty file.totalAmount and file.totalAmount != null}">
                                                <span class="detail-item">
                                                    <i class="fas fa-rupee-sign"></i>
                                                    ₹${file.totalAmount}
                                                </span>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="file-actions">
                                        <a href="${pageContext.request.contextPath}/clinical-files/${file.id}" 
                                           class="btn btn-sm btn-primary">
                                            <i class="fas fa-eye"></i> View
                                        </a>
                                        <c:if test="${not empty file.status and file.status.name() == 'ACTIVE'}">
                                            <button type="button" class="btn btn-sm btn-warning" 
                                                    onclick="closeClinicalFile('${file.id}')">
                                                <i class="fas fa-lock"></i> Close
                                            </button>
                                        </c:if>
                                        <c:if test="${not empty file.status and file.status.name() == 'CLOSED'}">
                                            <button type="button" class="btn btn-sm btn-success" 
                                                    onclick="reopenClinicalFile('${file.id}')">
                                                <i class="fas fa-unlock"></i> Reopen
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="no-records-message">
                            <i class="fas fa-folder-open"></i> No clinical files found for this patient.
                        </div>
                    </c:otherwise>
                </c:choose>
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
                
                <div class="filter-group">
                    <label for="fileIdDropdown">Filter by File ID:</label>
                    <select id="fileIdDropdown" class="custom-select" onchange="filterByFileId(this.value)">
                        <option value="all">All Files</option>
                        <option value="no-file">No File</option>
                        <c:set var="fileIdsSeen" value="" />
                        <c:forEach items="${examinationHistory}" var="exam">
                            <c:if test="${not empty exam.clinicalFile}">
                                <c:set var="fileId" value="${exam.clinicalFile.id}" />
                                <c:if test="${!fn:contains(fileIdsSeen, fileId)}">
                                    <c:set var="fileIdsSeen" value="${fileIdsSeen}${fileId}," />
                                    <option value="${fileId}">File ${fileId}</option>
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
                
                <!-- Clinical File Creation - Only for OPD Doctors -->
                <sec:authorize access="hasRole('OPD_DOCTOR')">
                    <div class="file-actions">
                        <button type="button" class="btn btn-primary" disabled>
                            <i class="fas fa-folder-medical"></i> New Clinical File (Under Construction)
                        </button>
                    </div>
                </sec:authorize>
            </div>
            
                                <div class="table-info">
                        <div class="table-header-actions">
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
                        
                        <sec:authorize access="hasAnyRole('DOCTOR','OPD_DOCTOR','ADMIN','CLINIC_OWNER','RECEPTIONIST')">
                            <div class="clinical-file-actions-row">
                                <div class="clinical-file-actions">
                                    <span id="selectedCountDisplay" class="selected-count" style="display: none;">
                                        <span id="selectedExaminationCount">0</span> examinations selected
                                    </span>
                                    
                                    <button type="button" id="bulkUploadSelectedBtn" class="btn btn-secondary btn-sm" 
                                            onclick="openBulkUploadSelectedModal()" style="display: none;">
                                        <i class="fas fa-upload"></i> Bulk Upload to Selected
                                    </button>
                                    <button type="button" id="bulkAssignDoctorBtn" class="btn btn-secondary btn-sm" onclick="openBulkAssignDoctorModal()" style="display: none;">
                                        <i class="fas fa-user-md"></i> Assign Doctor to Selected
                                    </button>
                                    <button type="button" id="bulkSendForPaymentBtn" class="btn btn-secondary btn-sm" onclick="openBulkSendForPaymentModal()" style="display: none;">
                                        <i class="fas fa-file-invoice-dollar"></i> Send Selected for Payment
                                    </button>
                                    <input type="file" id="bulkSelectedInput" multiple accept="image/*,application/pdf" style="display: none;" />
                                </div>
                            </div>
                        </sec:authorize>
                    </div>

                    <div class="table-responsive">
                <!-- Debug: Authentication and gate checks -->
                <c:if test="${empty examinationHistory}">
                    <script>
                        console.log('[Exams] examinationHistory is EMPTY for this patient');
                    </script>
                </c:if>
                <script>
                    console.log('[Auth] user:', '<sec:authentication property="name"/>');
                    console.log('[Auth] authorities:', '<sec:authentication property="authorities"/>');
                    console.log('[Exams] debug script loaded');
                    document.addEventListener('DOMContentLoaded', function() {
                        try {
                            const hasSelectAll = !!document.getElementById('selectAllExaminations');
                            const rowCheckboxCount = document.querySelectorAll('.examination-checkbox').length;
                            console.log('[Exams] selectAll present:', hasSelectAll);
                            console.log('[Exams] row checkbox count:', rowCheckboxCount);
                        } catch (e) {
                            console.log('[Exams] DOM debug error:', e && e.message ? e.message : e);
                        }
                    });
                </script>
                <sec:authorize access="hasAnyRole('DOCTOR','OPD_DOCTOR','ADMIN')">
                    <script>console.log('[Gate] hasAnyRole(DOCTOR,OPD_DOCTOR,ADMIN): TRUE');</script>
                </sec:authorize>
                <sec:authorize access="!hasAnyRole('DOCTOR','OPD_DOCTOR','ADMIN')">
                    <script>console.log('[Gate] hasAnyRole(DOCTOR,OPD_DOCTOR,ADMIN): FALSE');</script>
                </sec:authorize>
                <sec:authorize access="hasAnyRole('DOCTOR','OPD_DOCTOR','ADMIN','CLINIC_OWNER','RECEPTIONIST')">
                    <script>console.log('[Gate] header roles allowed: TRUE');</script>
                </sec:authorize>
                <sec:authorize access="!hasAnyRole('DOCTOR','OPD_DOCTOR','ADMIN','CLINIC_OWNER','RECEPTIONIST')">
                    <script>console.log('[Gate] header roles allowed: FALSE');</script>
                </sec:authorize>
                <table id="examinationHistoryTable" class="table">
                            <thead>
                            <tr>
                                <th width="50">
                                    <sec:authorize access="hasAnyRole('DOCTOR','OPD_DOCTOR','ADMIN','CLINIC_OWNER','RECEPTIONIST')">
                                        <input type="checkbox" id="selectAllExaminations" onchange="toggleSelectAllExaminations()">
                                    </sec:authorize>
                                </th>
                                <th>Exam ID</th>
                                <th>File ID</th>
                                <th>Tooth</th>
                                <th>Examination Date</th>
                                <th>Treatment Start Date</th>
                                <th>Procedure</th>
                                <th>Procedure Status</th>
                                <th>Notes</th>
                                <th>Clinic</th>
                                <th>Treating Doctor</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                        <c:forEach items="${examinationHistory}" var="exam" varStatus="status">
                            <tr class="examination-row" onclick="openExaminationDetails('${exam.id}')">
                                <td>
                                    <sec:authorize access="hasAnyRole('DOCTOR','OPD_DOCTOR','ADMIN')">
                                        <input type="checkbox" class="examination-checkbox" value="${exam.id}" onclick="event.stopPropagation();">
                                    </sec:authorize>
                                </td>
                                <td class="exam-id-col">${exam.id}</td>
                                <td data-file-id="${not empty exam.clinicalFile ? exam.clinicalFile.id : ''}">
                                    <c:choose>
                                        <c:when test="${not empty exam.clinicalFile}">
                                            <span class="file-id-badge">${exam.clinicalFile.id}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-file">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td data-tooth="${exam.toothNumber}">
                                    <c:choose>
                                        <c:when test="${exam.toothNumber == 'GENERAL_CONSULTATION'}">
                                            General Consultation
                                        </c:when>
                                        <c:otherwise>
                                            ${exam.toothNumber.toString().replace('TOOTH_', '')}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                    <td data-date="${exam.examinationDate}">
                                    <c:set var="dateStr" value="${exam.examinationDate}" />
                                            <c:set var="datePart" value="${fn:substringBefore(dateStr, 'T')}" />
                                            <c:set var="timePart" value="${fn:substringBefore(fn:substringAfter(dateStr, 'T'), '.')}" />
                                            
                                            <c:set var="year" value="${fn:substring(datePart, 0, 4)}" />
                                            <c:set var="month" value="${fn:substring(datePart, 5, 7)}" />
                                            <c:set var="day" value="${fn:substring(datePart, 8, 10)}" />
                                            
                                            <c:set var="hourStr" value="${fn:substring(timePart, 0, 2)}" />
                                            <c:set var="minuteStr" value="${fn:substring(timePart, 3, 5)}" />
                                            <c:set var="hour" value="${fn:substring(hourStr, 0, 1) == '0' ? fn:substring(hourStr, 1, 2) : hourStr}" />
                                            <c:set var="hourNum" value="${fn:substring(hourStr, 0, 1) == '0' ? fn:substring(hourStr, 1, 2) : hourStr}" />
                                            <c:set var="ampm" value="${hourNum >= 12 ? 'PM' : 'AM'}" />
                                            <c:set var="displayHour" value="${hourNum >= 12 ? (hourNum - 12) : hourNum}" />
                                            <c:set var="displayHour" value="${displayHour == 0 ? 12 : displayHour}" />
                                            
                                    ${day}/${month}/${year} ${displayHour}:${minuteStr} ${ampm}
                                    </td>
                                <td>
                                    <c:set var="rawDate" value="${exam.treatmentStartingDate}"/>
                                    <c:choose>
                                        <c:when test="${not empty rawDate}">
                                            <fmt:parseDate value="${rawDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate"/>
                                            <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy hh:mm a"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="not-started">Not Started</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty exam.procedure}">
                                            <span class="procedure-name">${exam.procedure.procedureName}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-data">No procedure</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty exam.procedureStatus}">
                                            ${exam.procedureStatus.name()}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-data">No status</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty exam.examinationNotes}">
                                            <a href="#" class="view-notes-link" onclick="showNotesPopup('${fn:escapeXml(exam.examinationNotes)}', '${exam.id}'); return false;">
                                                VIEW
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-data">No notes</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td data-clinic-id="${not empty exam.examinationClinic ? exam.examinationClinic.clinicId : ''}">
                                    <c:choose>
                                        <c:when test="${not empty exam.examinationClinic}">
                                            <span class="clinic-code">${exam.examinationClinic.clinicId}</span>
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
                                    <div class="action-buttons has-tooltip parent-tooltips" data-tooltip="Actions">
                                        <a href="${pageContext.request.contextPath}/patients/examination/${exam.id}" 
                                           class="btn btn-sm has-tooltip" 
                                           data-tooltip="View"
                                           onclick="event.stopPropagation();">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <c:set var="canDup" value="${duplicateAllowed[exam.id]}"/>
                                        <c:set var="canDupAndCheckedIn" value="${canDup && patient.checkedIn}"/>
                                        <c:choose>
                                            <c:when test="${canDupAndCheckedIn}">
                                                <c:set var="dupTooltip" value="Duplicate"/>
                                            </c:when>
                                            <c:when test="${canDup}">
                                                <c:set var="dupTooltip" value="Patient must be checked in to duplicate"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="dupTooltip" value="Cannot duplicate"/>
                                            </c:otherwise>
                                        </c:choose>
                                        <button class="btn btn-sm has-tooltip" 
                                                data-tooltip="${dupTooltip}" 
                                                data-exam-id="${exam.id}"
                                                onclick="event.stopPropagation(); duplicateExaminationFromEl(this)"
                                                <c:if test="${!canDupAndCheckedIn}">disabled style="opacity:0.6; cursor:not-allowed;"</c:if>>
                                            <i class="fas fa-clone"></i>
                                        </button>
                                        
                                        <!-- Delete button - only show if user has canDeleteExamination permission -->
                                        <c:if test="${currentUser.canDeleteExamination}">
                                            <c:set var="canDelete" value="${exam.totalPaidAmount == 0}"/>
                                            <button class="btn btn-sm btn-danger has-tooltip" 
                                                    data-tooltip="${canDelete ? 'Delete Examination' : 'Cannot delete - payment collected'}" 
                                                    data-exam-id="${exam.id}"
                                                    data-tooth="${fn:escapeXml(exam.toothNumber)}"
                                                    data-exam-date="${fn:escapeXml(exam.examinationDate)}"
                                                    onclick="onDeleteExamClick(event, this)"
                                                    <c:if test="${!canDelete}">disabled style="opacity:0.6; cursor:not-allowed;"</c:if>>
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </c:if>

                                        <!-- Admin-only Purge button: force delete examination and payments -->
                                        <sec:authorize access="hasAnyRole('ADMIN','CLINIC_OWNER')">
                                            <button class="btn btn-sm btn-warning has-tooltip" 
                                                    data-tooltip="Admin Purge (force delete)" 
                                                    data-exam-id="${exam.id}"
                                                    data-tooth="${fn:escapeXml(exam.toothNumber)}"
                                                    data-exam-date="${fn:escapeXml(exam.examinationDate)}"
                                                    onclick="onPurgeExamClick(event, this)">
                                                <i class="fas fa-broom"></i>
                                            </button>
                                        </sec:authorize>
                                    </div>
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

            <!-- Pagination Controls -->
            <c:if test="${not empty examinationHistory and totalPages > 1}">
                <div class="pagination-container">
                    <div class="pagination-info">
                        Showing ${(currentPage * pageSize) + 1} to ${(currentPage * pageSize) + fn:length(examinationHistory)} of ${totalItems} examinations
                    </div>
                    <div class="pagination-controls">
                        <!-- Previous button -->
                        <c:if test="${currentPage > 0}">
                            <a href="?page=${currentPage - 1}&size=${pageSize}" class="pagination-button">
                                <i class="fas fa-chevron-left"></i> Previous
                            </a>
                        </c:if>
                        
                        <!-- Page numbers -->
                        <c:forEach begin="0" end="${totalPages - 1}" var="pageNum">
                            <c:choose>
                                <c:when test="${pageNum == currentPage}">
                                    <span class="pagination-button active">${pageNum + 1}</span>
                                </c:when>
                                <c:when test="${pageNum == 0 or pageNum == totalPages - 1 or (pageNum >= currentPage - 2 and pageNum <= currentPage + 2)}">
                                    <a href="?page=${pageNum}&size=${pageSize}" class="pagination-button">${pageNum + 1}</a>
                                </c:when>
                                <c:when test="${pageNum == currentPage - 3 or pageNum == currentPage + 3}">
                                    <span class="pagination-button">...</span>
                                </c:when>
                            </c:choose>
                        </c:forEach>
                        
                        <!-- Next button -->
                        <c:if test="${currentPage < totalPages - 1}">
                            <a href="?page=${currentPage + 1}&size=${pageSize}" class="pagination-button">
                                Next <i class="fas fa-chevron-right"></i>
                            </a>
                        </c:if>
                    </div>
                </div>
            </c:if>
                    </div>
    </div>

    <!-- Bulk Assign Doctor to Selected Examinations Modal -->
    <div id="bulkAssignDoctorModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Assign Doctor to Selected Examinations</h2>
                <span class="close" onclick="closeBulkAssignDoctorModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p class="text-muted">
                    Selected examinations: <strong><span id="bulkAssignSelectedCount">0</span></strong>
                </p>
                <div class="form-group">
                    <label for="bulkAssignDoctorSelect">Select Doctor</label>
                    <select id="bulkAssignDoctorSelect" class="form-control" required>
                        <option value="">-- Choose Doctor --</option>
                        <c:forEach var="doctor" items="${doctorDetails}">
                            <option value="${doctor.id}">${doctor.firstName} ${doctor.lastName}</option>
                        </c:forEach>
                    </select>
                </div>
                <small class="form-help">This assigns the selected doctor to all checked examinations.</small>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-sm" id="assignBulkDoctorBtn" onclick="assignDoctorToSelected()">
                    <i class="fas fa-user-check"></i> Assign to Selected
                </button>
                <button type="button" class="btn btn-secondary btn-sm" onclick="closeBulkAssignDoctorModal()">Cancel</button>
            </div>
        </div>
    </div>


    <!-- General Consultation Modal - Only show for non-receptionists -->
    <c:if test="${currentUserRole != 'RECEPTIONIST'}">
    <div id="consultationModal" class="modal consultation-modal">
        <div class="modal-content">
            <span class="close" onclick="closeConsultationModal()">&times;</span>
            <h2 style="margin: 0 0 15px 0; font-size: 1.2rem; color: #2c3e50;">General Consultation</h2>
            <form id="consultationForm" method="post" action="${pageContext.request.contextPath}/patients/tooth-examination/save">
                <input type="hidden" id="consultationExaminationId" name="id" value="">
                <input type="hidden" id="consultationPatientId" name="patientId" value="${patient.id}">
                <input type="hidden" id="consultationToothNumber" name="toothNumber" value="GENERAL_CONSULTATION">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <!-- Chief Complaints Section -->
                <div class="form-section chief-complaints-section">
                    <h3>Chief Complaints</h3>
                    <div class="form-group">
                        <label for="consultationChiefComplaints">Patient's Chief Complaints</label>
                        <textarea name="chiefComplaints" id="consultationChiefComplaints" rows="6" class="form-control" 
                                  placeholder="Enter the patient's chief complaints in detail..."></textarea>
                    </div>
                </div>

                <!-- Examination Notes Section -->
                <div class="form-section notes-section">
                    <h3>Consultation Notes</h3>
                    <div class="form-group">
                        <label for="consultationExaminationNotes">Examination Notes</label>
                        <textarea name="examinationNotes" id="consultationExaminationNotes" rows="6" class="form-control" 
                                  placeholder="Enter detailed consultation notes and findings..."></textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Save Consultation</button>
                    <button type="button" class="btn btn-secondary" onclick="closeConsultationModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>
    </c:if>

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
                <div class="form-section chief-complaints-section">
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

<!-- Notes Popup Modal -->
<div id="notesModal" class="notes-modal">
    <div class="notes-modal-content">
        <div class="notes-modal-header">
            <h3 class="notes-modal-title">Examination Notes</h3>
            <span class="notes-modal-close" onclick="closeNotesModal()">&times;</span>
        </div>
        <div class="notes-modal-body">
            <div id="notesContent" class="notes-content"></div>
        </div>
        <div class="notes-modal-footer">
            <button class="btn-close-modal" onclick="closeNotesModal()">Close</button>
        </div>
    </div>
</div>

<!-- Chairside Note Component -->
<jsp:include page="/WEB-INF/views/common/chairside-note-component.jsp" />

        <!-- Clinical File Creation Modal -->
        <div id="createFileModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2><i class="fas fa-folder-medical"></i> Create Clinical File</h2>
                    <span class="close" onclick="closeCreateFileModal()">&times;</span>
                </div>
                
                <div class="modal-body">
                    <form id="createFileForm">
                        <!-- Step Indicator -->
                        <div class="step-indicator">
                            <div class="step active" data-step="1">
                                <div class="step-number">1</div>
                                <div class="step-label">File Details</div>
                            </div>
                            <div class="step-line"></div>
                            <div class="step" data-step="2">
                                <div class="step-number">2</div>
                                <div class="step-label">Select Examinations</div>
                            </div>
                        </div>

                        <!-- Step 1: File Information -->
                        <div class="form-step active" id="step1">
                            <div class="form-section">
                                <h3><i class="fas fa-info-circle"></i> File Information</h3>
                                
                                <div class="form-group">
                                    <label for="fileTitle">
                                        <i class="fas fa-tag"></i>
                                        File Title
                                    </label>
                                    <input type="text" id="fileTitle" name="title" class="form-control" readonly
                                           placeholder="Auto-generated file name">
                                    <small class="form-help">File name is automatically generated based on patient, date, and selected examinations</small>
                                </div>
                                
                                <div class="form-grid">
                                    <div class="form-column">
                                        <div class="form-group">
                                            <label for="fileStatus">
                                                <i class="fas fa-toggle-on"></i>
                                                Status
                                            </label>
                                            <select id="fileStatus" name="status" class="form-control">
                                                <option value="ACTIVE">Active</option>
                                                <option value="PENDING_REVIEW">Pending Review</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-column">
                                        <div class="form-group">
                                            <label for="fileNotes">
                                                <i class="fas fa-sticky-note"></i>
                                                Notes
                                            </label>
                                            <textarea id="fileNotes" name="notes" class="form-control" rows="3"
                                                      placeholder="Any additional notes or observations..."></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-actions">
                                <button type="button" class="btn btn-primary" onclick="nextStep()">
                                    <i class="fas fa-arrow-right"></i>
                                    Next: Select Examinations
                                </button>
                                <button type="button" class="btn btn-secondary" onclick="closeCreateFileModal()">
                                    <i class="fas fa-times"></i>
                                    Cancel
                                </button>
                            </div>
                        </div>

                        <!-- Step 2: Examination Selection -->
                        <div class="form-step" id="step2">
                            <div class="form-section">
                                <div class="section-header-with-counter">
                                    <h3><i class="fas fa-list-check"></i> Select Examinations</h3>
                                    <div class="selection-counter">
                                        <span id="selectedCount">0</span> of <span id="totalCount">0</span> selected
                                    </div>
                                </div>
                                
                                <div class="info-alert">
                                    <i class="fas fa-info-circle"></i>
                                    <div class="info-content">
                                        <strong>Available Examinations</strong>
                                        <p>All patient examinations that are not already part of a clinical file are available for selection</p>
                                    </div>
                                </div>

                                <div class="examination-selection">
                                    <div class="select-all-container">
                                        <label class="select-all-checkbox">
                                            <input type="checkbox" id="selectAll" onchange="toggleSelectAll()">
                                            <span class="checkmark"></span>
                                            Select All Examinations
                                        </label>
                                    </div>
                                    
                                    <div class="examination-table-container">
                                        <table class="table table-hover examination-table">
                                            <thead>
                                                <tr>
                                                    <th width="50">Select</th>
                                                    <th>Tooth</th>
                                                    <th>Date & Time</th>
                                                    <th>Procedure</th>
                                                    <th>Doctor</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody id="examinationSelectionTable">
                                                <!-- Examinations will be populated here -->
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-actions">
                                <button type="button" class="btn btn-secondary" onclick="prevStep()">
                                    <i class="fas fa-arrow-left"></i>
                                    Back to File Details
                                </button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i>
                                    Create Clinical File
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

    <!-- Alert Modal -->
    <div id="alertModal" class="modal">
        <div class="modal-content alert-modal">
            <div class="modal-header">
                <h2 id="alertTitle">Alert</h2>
                <span class="close" onclick="closeAlertModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div class="alert-content">
                    <div id="alertIcon" class="alert-icon"></div>
                    <p id="alertMessage">This is an alert message.</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="closeAlertModal()">OK</button>
            </div>
        </div>
    </div>

    <!-- Confirmation Modal -->
    <div id="confirmationModal" class="modal">
        <div class="modal-content confirmation-modal">
            <div class="modal-header">
                <h2 id="confirmationTitle">Confirm Action</h2>
                <span class="close" onclick="closeConfirmationModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div class="confirmation-content">
                    <div class="confirmation-icon">
                        <i class="fas fa-question-circle"></i>
                    </div>
                    <div id="confirmationMessage" class="confirmation-message">
                        Are you sure you want to proceed?
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" id="confirmBtn" class="btn btn-primary">Confirm</button>
                <button type="button" class="btn btn-secondary" onclick="closeConfirmationModal()">Cancel</button>
            </div>
        </div>
    </div>

    <!-- Duplicate Examination Selection Modal -->
    <div id="duplicateExaminationModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Duplicate Examination</h2>
                <span class="close" onclick="closeDuplicateExaminationModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p>Select which details you want to duplicate:</p>
                
                <!-- Tooth Selection Section -->
                <div class="form-group">
                    <label class="section-label">Select Target Teeth:</label>
                    <div class="tooth-selection-container">
                        <div class="compact-dental-chart">
                            <!-- Upper Teeth -->
                            <div class="compact-teeth-row upper">
                                <div class="compact-tooth" data-tooth-number="18" onclick="toggleToothSelection(this, 18)">18</div>
                                <div class="compact-tooth" data-tooth-number="17" onclick="toggleToothSelection(this, 17)">17</div>
                                <div class="compact-tooth" data-tooth-number="16" onclick="toggleToothSelection(this, 16)">16</div>
                                <div class="compact-tooth" data-tooth-number="15" onclick="toggleToothSelection(this, 15)">15</div>
                                <div class="compact-tooth" data-tooth-number="14" onclick="toggleToothSelection(this, 14)">14</div>
                                <div class="compact-tooth" data-tooth-number="13" onclick="toggleToothSelection(this, 13)">13</div>
                                <div class="compact-tooth" data-tooth-number="12" onclick="toggleToothSelection(this, 12)">12</div>
                                <div class="compact-tooth" data-tooth-number="11" onclick="toggleToothSelection(this, 11)">11</div>
                                <div class="compact-tooth" data-tooth-number="21" onclick="toggleToothSelection(this, 21)">21</div>
                                <div class="compact-tooth" data-tooth-number="22" onclick="toggleToothSelection(this, 22)">22</div>
                                <div class="compact-tooth" data-tooth-number="23" onclick="toggleToothSelection(this, 23)">23</div>
                                <div class="compact-tooth" data-tooth-number="24" onclick="toggleToothSelection(this, 24)">24</div>
                                <div class="compact-tooth" data-tooth-number="25" onclick="toggleToothSelection(this, 25)">25</div>
                                <div class="compact-tooth" data-tooth-number="26" onclick="toggleToothSelection(this, 26)">26</div>
                                <div class="compact-tooth" data-tooth-number="27" onclick="toggleToothSelection(this, 27)">27</div>
                                <div class="compact-tooth" data-tooth-number="28" onclick="toggleToothSelection(this, 28)">28</div>
                            </div>
                            <!-- Lower Teeth -->
                            <div class="compact-teeth-row lower">
                                <div class="compact-tooth" data-tooth-number="48" onclick="toggleToothSelection(this, 48)">48</div>
                                <div class="compact-tooth" data-tooth-number="47" onclick="toggleToothSelection(this, 47)">47</div>
                                <div class="compact-tooth" data-tooth-number="46" onclick="toggleToothSelection(this, 46)">46</div>
                                <div class="compact-tooth" data-tooth-number="45" onclick="toggleToothSelection(this, 45)">45</div>
                                <div class="compact-tooth" data-tooth-number="44" onclick="toggleToothSelection(this, 44)">44</div>
                                <div class="compact-tooth" data-tooth-number="43" onclick="toggleToothSelection(this, 43)">43</div>
                                <div class="compact-tooth" data-tooth-number="42" onclick="toggleToothSelection(this, 42)">42</div>
                                <div class="compact-tooth" data-tooth-number="41" onclick="toggleToothSelection(this, 41)">41</div>
                                <div class="compact-tooth" data-tooth-number="31" onclick="toggleToothSelection(this, 31)">31</div>
                                <div class="compact-tooth" data-tooth-number="32" onclick="toggleToothSelection(this, 32)">32</div>
                                <div class="compact-tooth" data-tooth-number="33" onclick="toggleToothSelection(this, 33)">33</div>
                                <div class="compact-tooth" data-tooth-number="34" onclick="toggleToothSelection(this, 34)">34</div>
                                <div class="compact-tooth" data-tooth-number="35" onclick="toggleToothSelection(this, 35)">35</div>
                                <div class="compact-tooth" data-tooth-number="36" onclick="toggleToothSelection(this, 36)">36</div>
                                <div class="compact-tooth" data-tooth-number="37" onclick="toggleToothSelection(this, 37)">37</div>
                                <div class="compact-tooth" data-tooth-number="38" onclick="toggleToothSelection(this, 38)">38</div>
                            </div>
                        </div>
                        <div class="selected-teeth-info">
                            <span class="selected-count">Selected: <span id="selectedTeethCount">0</span> teeth</span>
                            <div class="selected-teeth-list" id="selectedTeethList"></div>
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="checkbox-container">
                        <input type="checkbox" id="duplicateAttachments">
                        <span class="checkmark"></span>
                        <span class="checkbox-label">
                            Attachments (Media Files)
                            <span id="attachmentCount" class="detail-count"></span>
                        </span>
                    </label>
                </div>
                <div class="form-group">
                    <label class="checkbox-container">
                        <input type="checkbox" id="duplicateTreatingDoctor">
                        <span class="checkmark"></span>
                        <span class="checkbox-label">
                            Treating Doctor
                            <span id="treatingDoctorName" class="detail-name"></span>
                        </span>
                    </label>
                </div>
                <div class="form-group">
                    <label class="checkbox-container">
                        <input type="checkbox" id="duplicateProcedure">
                        <span class="checkmark"></span>
                        <span class="checkbox-label">
                            Procedure
                            <span id="procedureName" class="detail-name"></span>
                            <span id="procedurePrice" class="detail-price"></span>
                        </span>
                    </label>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="confirmDuplicateBtn" onclick="confirmDuplicateExamination()">
                    <i class="fas fa-copy"></i>
                    <span class="btn-text">Duplicate Examination</span>
                    <span class="btn-loader" style="display: none;">
                        <i class="fas fa-spinner fa-spin"></i>
                        Duplicating...
                    </span>
                </button>
                <button type="button" class="btn btn-secondary" onclick="closeDuplicateExaminationModal()">Cancel</button>
            </div>
        </div>
    </div>

    <!-- Bulk Upload to Selected Examinations Modal -->
    <div id="bulkUploadSelectedModal" class="modal">
        <div class="modal-content image-upload-modal">
            <div class="modal-header">
                <h2>Bulk Upload to Selected Examinations</h2>
                <span class="close" onclick="closeBulkUploadSelectedModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div class="arch-upload-section">
                    <p class="text-muted">
                        Selected examinations: <strong><span id="bulkSelectedCount">0</span></strong>
                    </p>
                    <div class="file-upload-controls">
                        <button type="button" class="btn btn-secondary" onclick="document.getElementById('bulkSelectedInput').click()">
                            <i class="fas fa-file-upload"></i> Choose Files
                        </button>
                        <span class="help-text">You can upload images (JPG/PNG) or PDFs. Images will be compressed automatically.</span>
                    </div>
                    <div id="bulkSelectedFileList" class="file-list"></div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="uploadBulkSelectedBtn" onclick="uploadBulkFilesToSelected()">
                    <i class="fas fa-cloud-upload-alt"></i> Upload to Selected
                </button>
                <button type="button" class="btn btn-secondary" onclick="closeBulkUploadSelectedModal()">Cancel</button>
            </div>
        </div>
    </div>

    <!-- Bulk Send for Payment Modal -->
    <div id="bulkSendForPaymentModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Send Selected for Payment</h2>
                <span class="close" onclick="closeBulkSendForPaymentModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p class="text-muted">
                    Selected examinations: <strong><span id="bulkSendSelectedCount">0</span></strong>
                </p>
                <div class="validation-summary" id="bulkPaymentValidation" style="display: none; background: #fff3cd; border: 1px solid #ffe08a; border-radius: 6px; padding: 12px; margin-bottom: 12px;">
                    <div style="display:flex; align-items:center; gap:8px; margin-bottom:6px;">
                        <i class="fas fa-exclamation-triangle" style="color:#856404;"></i>
                        <strong style="color:#856404;">Some selected records cannot be sent for payment</strong>
                    </div>
                    <ul id="bulkPaymentValidationList" style="margin:0 0 6px 18px; padding:0;">
                    </ul>
                    <small style="color:#856404;">Only procedures with status <strong>OPEN</strong> can be sent for payment.</small>
                </div>
                <div class="progress-section" id="bulkPaymentProgress" style="display:none;">
                    <div style="margin-bottom:8px; color:#2c3e50;">
                        <i class="fas fa-spinner fa-spin"></i> Processing bulk update...
                    </div>
                    <div style="background:#ecf0f1; border-radius:4px; height:10px; overflow:hidden;">
                        <div id="bulkPaymentProgressBar" style="background:#3498db; width:0%; height:10px; transition: width 0.3s ease;"></div>
                    </div>
                </div>
                <div class="result-section" id="bulkPaymentResult" style="display:none; margin-top:12px;">
                    <div id="bulkPaymentResultSummary" style="margin-bottom:8px; color:#2c3e50;"></div>
                    <div id="bulkPaymentErrorContainer" style="display:none; background:#fdecea; border:1px solid #f5c6cb; border-radius:6px; padding:10px;">
                        <div style="display:flex; align-items:center; gap:8px; margin-bottom:6px; color:#721c24;">
                            <i class="fas fa-times-circle"></i>
                            <strong>Errors</strong>
                        </div>
                        <ul id="bulkPaymentErrorList" style="margin:0 0 6px 18px; padding:0; color:#721c24;"></ul>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-sm" id="confirmBulkSendForPaymentBtn" onclick="sendSelectedForPayment()">
                    <i class="fas fa-paper-plane"></i> Send for Payment
                </button>
                <button type="button" class="btn btn-secondary btn-sm" onclick="closeBulkSendForPaymentModal()">Cancel</button>
            </div>
        </div>
    </div>

    <script>
        // Clinical File Functions
        function toggleClinicalFiles() {
            const container = document.getElementById('clinicalFilesContainer');
            const icon = document.getElementById('clinicalFilesToggleIcon');
            
            if (container.style.display === 'none') {
                container.style.display = 'block';
                icon.classList.add('rotated');
            } else {
                container.style.display = 'none';
                icon.classList.remove('rotated');
            }
        }

        function closeClinicalFile(fileId) {
            showConfirmationModal(
                'Close Clinical File',
                'Are you sure you want to close this clinical file? This action cannot be undone.',
                'Close File',
                'Cancel',
                () => {
                    fetch(joinUrl(contextPath, '/clinical-files/' + fileId + '/close'), {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
                        }
                    })
                    .then(response => response.json())
                    .then(result => {
                        if (result.success) {
                            showAlertModal('Clinical file closed successfully!', 'success');
                            setTimeout(() => window.location.reload(), 1500);
                        } else {
                            showAlertModal('Error: ' + (result.message || 'Failed to close clinical file'), 'error');
                        }
                    })
                    .catch(error => {
                        showAlertModal('An error occurred while closing the clinical file.', 'error');
                    });
                }
            );
        }

        function reopenClinicalFile(fileId) {
            showConfirmationModal(
                'Reopen Clinical File',
                'Are you sure you want to reopen this clinical file?',
                'Reopen File',
                'Cancel',
                () => {
                    fetch(joinUrl(contextPath, '/clinical-files/' + fileId + '/reopen'), {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
                        }
                    })
                    .then(response => response.json())
                    .then(result => {
                        if (result.success) {
                            showAlertModal('Clinical file reopened successfully!', 'success');
                            setTimeout(() => window.location.reload(), 1500);
                        } else {
                            showAlertModal('Error: ' + (result.message || 'Failed to reopen clinical file'), 'error');
                        }
                    })
                    .catch(error => {
                        showAlertModal('An error occurred while reopening the clinical file.', 'error');
                    });
                }
            );
        }

        // Filter Functions
        function filterByDoctor(doctorId) {
            const rows = document.querySelectorAll('#examinationHistoryTable tbody tr');
            rows.forEach(row => {
                const doctorCell = row.querySelector('[data-doctor]');
                if (doctorCell) {
                    const rowDoctorId = doctorCell.getAttribute('data-doctor');
                    if (doctorId === 'all' || rowDoctorId === doctorId || 
                        (doctorId === 'unassigned' && (!rowDoctorId || rowDoctorId === ''))) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                }
            });
        }

        function filterByClinic(clinicId) {
            const rows = document.querySelectorAll('#examinationHistoryTable tbody tr');
            rows.forEach(row => {
                const clinicCell = row.querySelector('[data-clinic-id]');
                if (clinicCell) {
                    const rowClinicId = clinicCell.getAttribute('data-clinic-id');
                    if (clinicId === 'all' || rowClinicId === clinicId) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                }
            });
        }

        function filterByFileId(fileId) {
            const rows = document.querySelectorAll('#examinationHistoryTable tbody tr');
            rows.forEach(row => {
                const fileIdCell = row.querySelector('[data-file-id]');
                if (fileIdCell) {
                    const rowFileId = fileIdCell.getAttribute('data-file-id');
                    if (fileId === 'all' || 
                        (fileId === 'no-file' && (!rowFileId || rowFileId === '')) ||
                        rowFileId === fileId) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                }
            });
        }
    </script>
    
    <script>
        // Bulk Assign Doctor to Selected Examinations
        function openBulkAssignDoctorModal() {
            const selectedCheckboxes = document.querySelectorAll('.examination-checkbox:checked');
            if (selectedCheckboxes.length === 0) {
                showAlertModal('Please select at least one examination to assign a doctor.', 'warning');
                return;
            }
            // Count only examinations without an already assigned doctor
            let assignableCount = 0;
            selectedCheckboxes.forEach(cb => {
                const row = cb.closest('tr');
                const doctorCell = row ? row.querySelector('td[data-doctor]') : null;
                const hasAssigned = doctorCell && (doctorCell.getAttribute('data-doctor') || '').trim() !== '';
                if (!hasAssigned) assignableCount++;
            });
            const countEl = document.getElementById('bulkAssignSelectedCount');
            if (countEl) countEl.textContent = assignableCount;
            if (assignableCount === 0) {
                showAlertModal('All selected examinations already have a treating doctor assigned. No changes can be made via bulk assignment.', 'warning');
                return;
            }
            const select = document.getElementById('bulkAssignDoctorSelect');
            if (select) select.value = '';
            document.getElementById('bulkAssignDoctorModal').style.display = 'block';
        }

        function closeBulkAssignDoctorModal() {
            document.getElementById('bulkAssignDoctorModal').style.display = 'none';
            const select = document.getElementById('bulkAssignDoctorSelect');
            if (select) select.value = '';
        }

        async function assignDoctorToSelected() {
            const selectedCheckboxes = document.querySelectorAll('.examination-checkbox:checked');
            if (selectedCheckboxes.length === 0) {
                showAlertModal('Please select at least one examination.', 'warning');
                return;
            }
            const select = document.getElementById('bulkAssignDoctorSelect');
            const doctorId = select ? select.value : '';
            if (!doctorId) {
                showAlertModal('Please choose a doctor to assign.', 'warning');
                return;
            }

            // Split into eligible and blocked (already assigned) examinations
            const eligibleIds = [];
            const blockedIds = [];
            selectedCheckboxes.forEach(cb => {
                const row = cb.closest('tr');
                const doctorCell = row ? row.querySelector('td[data-doctor]') : null;
                const hasAssigned = doctorCell && (doctorCell.getAttribute('data-doctor') || '').trim() !== '';
                if (hasAssigned) {
                    blockedIds.push(Number(cb.value));
                } else {
                    eligibleIds.push(Number(cb.value));
                }
            });
            if (eligibleIds.length === 0) {
                showAlertModal('All selected examinations already have a treating doctor assigned and cannot be modified.', 'warning');
                return;
            }
            if (blockedIds.length > 0) {
                showAlertModal(blockedIds.length + ' selected examinations already have a treating doctor assigned and will be skipped.', 'info');
            }

            const btn = document.getElementById('assignBulkDoctorBtn');
            const originalHtml = btn ? btn.innerHTML : '';
            if (btn) {
                btn.disabled = true;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Assigning...';
            }

            try {
                const resp = await fetch(joinUrl(contextPath, '/patients/tooth-examination/assign-doctor-bulk'), {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
                    },
                    body: JSON.stringify({ examinationIds: eligibleIds, doctorId: Number(doctorId) })
                });
                let json = {};
                try { json = await resp.json(); } catch (e) {}
                if (resp.ok && json && (json.success === undefined || json.success)) {
                    const count = json.assignedCount || eligibleIds.length;
                    const failed = (json.failedIds && json.failedIds.length) ? json.failedIds.length : 0;
                    const skipped = blockedIds.length;
                    const parts = [];
                    parts.push(count + ' successful');
                    if (failed > 0) parts.push(failed + ' failed');
                    if (skipped > 0) parts.push(skipped + ' skipped (already assigned)');
                    const msg = 'Assignment completed: ' + parts.join(', ') + '.';
                    showAlertModal(msg, failed === 0 ? 'success' : 'warning');
                    closeBulkAssignDoctorModal();
                } else {
                    showAlertModal('Failed to assign doctor: ' + (json && json.message ? json.message : 'Unknown error'), 'error');
                }
            } catch (err) {
                showAlertModal('Error assigning doctor: ' + err.message, 'error');
            } finally {
                if (btn) {
                    btn.disabled = false;
                    btn.innerHTML = originalHtml;
                }
            }
        }
    </script>



    <script>
        // Close modal when clicking outside
        window.onclick = function(event) {
            const duplicateModal = document.getElementById('duplicateExaminationModal');
            if (event.target === duplicateModal) {
                closeDuplicateExaminationModal();
            }
        }

        // Duplicate Examination Modal Functions
        let selectedTeeth = [];
        
        function toggleToothSelection(element, toothNumber) {
            const index = selectedTeeth.indexOf(toothNumber);
            
            if (index > -1) {
                // Remove tooth from selection
                selectedTeeth.splice(index, 1);
                element.classList.remove('selected');
            } else {
                // Add tooth to selection
                selectedTeeth.push(toothNumber);
                element.classList.add('selected');
            }
            
            updateSelectedTeethDisplay();
        }
        
        function updateSelectedTeethDisplay() {
            const countElement = document.getElementById('selectedTeethCount');
            const listElement = document.getElementById('selectedTeethList');
            
            countElement.textContent = selectedTeeth.length;
            
            if (selectedTeeth.length > 0) {
                const sortedTeeth = selectedTeeth.sort((a, b) => a - b);
                listElement.textContent = 'Teeth: ' + sortedTeeth.join(', ');
            } else {
                listElement.textContent = '';
            }
        }
        
        function closeDuplicateExaminationModal() {
            document.getElementById('duplicateExaminationModal').style.display = 'none';
            
            // Reset checkboxes to unchecked and enable them
            document.getElementById('duplicateAttachments').checked = false;
            document.getElementById('duplicateAttachments').disabled = false;
            document.getElementById('duplicateTreatingDoctor').checked = false;
            document.getElementById('duplicateTreatingDoctor').disabled = false;
            document.getElementById('duplicateProcedure').checked = false;
            document.getElementById('duplicateProcedure').disabled = false;
            
            // Reset tooth selection
            selectedTeeth = [];
            document.querySelectorAll('.compact-tooth').forEach(tooth => {
                tooth.classList.remove('selected');
            });
            updateSelectedTeethDisplay();
            
            // Reset button state if it was in loading state
            resetDuplicateButton();
        }

        function confirmDuplicateExamination() {
            // Check if at least one tooth is selected
            if (selectedTeeth.length === 0) {
                showAlertModal('Please select at least one tooth to duplicate the examination to.', 'warning');
                return;
            }
            
            // Prevent multiple clicks by checking if already processing
            const confirmBtn = document.getElementById('confirmDuplicateBtn');
            if (confirmBtn.disabled) {
                return;
            }
            
            // Show loader and disable button
            confirmBtn.disabled = true;
            confirmBtn.querySelector('.btn-text').style.display = 'none';
            confirmBtn.querySelector('.btn-loader').style.display = 'inline';
            
            const modal = document.getElementById('duplicateExaminationModal');
            const examinationId = modal.getAttribute('data-examination-id');
            
            const duplicateAttachments = document.getElementById('duplicateAttachments').checked;
            const duplicateTreatingDoctor = document.getElementById('duplicateTreatingDoctor').checked;
            const duplicateProcedure = document.getElementById('duplicateProcedure').checked;
            
            // Call the new selective duplication endpoint with JSON data including selected teeth
            fetch(joinUrl(contextPath, '/patients/examination/' + examinationId + '/duplicate-selective'), {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
                },
                body: JSON.stringify({
                    'duplicateAttachments': duplicateAttachments,
                    'duplicateTreatingDoctor': duplicateTreatingDoctor,
                    'duplicateProcedure': duplicateProcedure,
                    'targetTeeth': selectedTeeth
                })
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    closeDuplicateExaminationModal();
                    showAlertModal(`Successfully duplicated examination to ${selectedTeeth.length} teeth.`, 'success');
                    setTimeout(() => {
                        window.location.reload();
                    }, 1500);
                } else {
                    showAlertModal('Error: ' + (result.message || 'Failed to duplicate examination'), 'error');
                    // Reset button state on error
                    resetDuplicateButton();
                }
            })
            .catch(error => {
                showAlertModal('An error occurred while duplicating the examination.', 'error');
                // Reset button state on error
                resetDuplicateButton();
            });
        }
        
        function resetDuplicateButton() {
            const confirmBtn = document.getElementById('confirmDuplicateBtn');
            confirmBtn.disabled = false;
            confirmBtn.querySelector('.btn-text').style.display = 'inline';
            confirmBtn.querySelector('.btn-loader').style.display = 'none';
        }
        
        // Delete examination functionality
        function onDeleteExamClick(event, button) {
            try {
                event.stopPropagation();
                if (button.disabled) { return false; }
                const examId = parseInt(button.dataset.examId, 10);
                const toothNumber = button.dataset.tooth || '';
                const examinationDate = button.dataset.examDate || '';
                confirmDeleteExamination(examId, toothNumber, examinationDate);
            } catch (e) {
                console.error('Delete click handler error:', e);
            }
        }

        function confirmDeleteExamination(examId, toothNumber, examinationDate) {
            const toothDisplay = toothNumber === 'GENERAL_CONSULTATION' ? 'General Consultation' : toothNumber.replace('TOOTH_', '');
            const formattedDate = formatDateTime12Hour(examinationDate);
            
            showConfirmationModal(
                'Delete Examination',
                `Are you sure you want to delete the examination for ${toothDisplay} on ${formattedDate}? This action cannot be undone.`,
                'Delete',
                'Cancel',
                function() {
                    deleteExamination(examId);
                }
            );
        }
        
        async function deleteExamination(examId) {
            try {
                const response = await fetch(joinUrl(contextPath, '/patients/examination/' + examId + '/delete'), {
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
                    }
                });
                
                const result = await response.json();
                
                if (result.success) {
                    showAlertModal('Examination deleted successfully.', 'success');
                    setTimeout(() => {
                        window.location.reload();
                    }, 1500);
                } else {
                    showAlertModal('Error: ' + (result.message || 'Failed to delete examination'), 'error');
                }
            } catch (error) {
                showAlertModal('An error occurred while deleting the examination.', 'error');
            }
        }

        // Admin-only purge examination functionality
        function onPurgeExamClick(event, button) {
            try {
                event.stopPropagation();
                const examId = parseInt(button.dataset.examId, 10);
                const toothNumber = button.dataset.tooth || '';
                const examinationDate = button.dataset.examDate || '';
                confirmPurgeExamination(examId, toothNumber, examinationDate);
            } catch (e) {
                console.error('Purge click handler error:', e);
            }
        }

        function confirmPurgeExamination(examId, toothNumber, examinationDate) {
            const toothDisplay = toothNumber === 'GENERAL_CONSULTATION' ? 'General Consultation' : toothNumber.replace('TOOTH_', '');
            const formattedDate = formatDateTime12Hour(examinationDate);

            showConfirmationModal(
                'Purge Examination',
                `This will permanently delete the examination for ${toothDisplay} on ${formattedDate}, including associated payments and related records. This action is admin-only and cannot be undone.`,
                'Purge',
                'Cancel',
                function() {
                    purgeExamination(examId);
                }
            );
        }

        async function purgeExamination(examId) {
            try {
                const response = await fetch(joinUrl(contextPath, '/patients/examination/' + examId + '/purge'), {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
                    }
                });

                const result = await response.json();

                if (result.success) {
                    showAlertModal('Examination purged successfully.', 'success');
                    setTimeout(() => {
                        window.location.reload();
                    }, 1500);
                } else {
                    showAlertModal('Error: ' + (result.message || 'Failed to purge examination'), 'error');
                }
            } catch (error) {
                showAlertModal('An error occurred while purging the examination.', 'error');
            }
        }
        
        // Print Registration Details Function
        function printRegistrationDetails() {
            // Show the print content temporarily
            const printContent = document.getElementById('printContent');
            const originalDisplay = printContent.style.display;
            
            // Make print content visible
            printContent.style.display = 'block';
            
            // Hide all other content
            const allElements = document.querySelectorAll('body > *:not(#printContent)');
            const originalStyles = [];
            
            allElements.forEach((element, index) => {
                originalStyles[index] = element.style.display;
                element.style.display = 'none';
            });
            
            // Print the page
            window.print();
            
            // Restore original styles
            printContent.style.display = originalDisplay;
            allElements.forEach((element, index) => {
                element.style.display = originalStyles[index];
            });
        }
        
        function formatCurrentDate() {
            const now = new Date();
            const options = { 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            };
            return now.toLocaleDateString('en-US', options);
        }
        
        // Customer Ledger functionality
        function openCustomerLedger() {
            const modal = document.getElementById('customerLedgerModal');
            modal.style.display = 'block';
            loadCustomerLedger();
        }
        
        function closeCustomerLedger() {
            const modal = document.getElementById('customerLedgerModal');
            modal.style.display = 'none';
        }
        
        function loadCustomerLedger() {
            const patientId = parseInt('${patient.id}', 10);
            const loadingDiv = document.getElementById('ledgerLoading');
            const contentDiv = document.getElementById('ledgerContent');
            const errorDiv = document.getElementById('ledgerError');
            
            console.log('=== CUSTOMER LEDGER DEBUG ===');
            console.log('Loading customer ledger for patient ID:', patientId);
            
            // Show loading state
            loadingDiv.style.display = 'block';
            contentDiv.style.display = 'none';
            errorDiv.style.display = 'none';
            
            fetch('/payment-management/patient/' + patientId + '/transactions')
                .then(response => {
                    console.log('API Response status:', response.status);
                    console.log('API Response headers:', response.headers);
                    return response.json();
                })
                .then(data => {
                    console.log('Raw API response data:', data);
                    console.log('Data type:', typeof data);
                    console.log('Data length:', data ? data.length : 'null/undefined');
                    
                    loadingDiv.style.display = 'none';
                    if (data && data.length > 0) {
                        console.log('Processing', data.length, 'transactions');
                        displayLedgerData(data);
                        contentDiv.style.display = 'block';
                    } else {
                        errorDiv.innerHTML = '<p>No payment transactions found for this patient.</p>';
                        errorDiv.style.display = 'block';
                    }
                })
                .catch(error => {
                    loadingDiv.style.display = 'none';
                    errorDiv.innerHTML = '<p>Error loading payment transactions. Please try again.</p>';
                    errorDiv.style.display = 'block';
                });
        }
        
        function displayLedgerData(transactions) {
            const tableBody = document.getElementById('ledgerTableBody');
            tableBody.innerHTML = '';
            
            let totalAmount = 0;
            let totalPaid = 0;
            let totalRefunded = 0;
            
            transactions.forEach((transaction, index) => {
                const row = document.createElement('tr');
                
                // Use the refund flag from backend instead of transaction type string comparison
                const isRefund = transaction.refund || false;
                const amount = parseFloat(transaction.amount || 0);
                
                // Ensure amount is a valid number
                const validAmount = isNaN(amount) ? 0 : amount;
                const absAmount = Math.abs(validAmount);
                
                // Calculate totals based on the actual amount (which should already be signed correctly)
                if (isRefund) {
                    totalRefunded += absAmount; // Track absolute refund amount
                } else {
                    totalPaid += absAmount; // Track absolute payment amount
                }
                
                const formattedDate = new Date(transaction.paymentDate).toLocaleDateString('en-IN');
                
                // Display transaction type clearly
                const displayTransactionType = isRefund ? 'REFUND' : 'CAPTURE';
                
                // Format amount display with proper sign
                const amountDisplay = isRefund ? '-₹' + absAmount.toFixed(2) : '₹' + absAmount.toFixed(2);
                
                console.log('Amount display string:', amountDisplay);
                console.log('Formatted date:', formattedDate);
                console.log('Display transaction type:', displayTransactionType);
                
                row.innerHTML = `
                    <td>${formattedDate}</td>
                    <td>${transaction.procedureName || 'N/A'}</td>
                    <td class="${isRefund ? 'text-danger' : 'text-success'}" style="font-weight: 600;">
                        ${amountDisplay}
                    </td>
                    <td><span class="badge badge-${isRefund ? 'danger' : 'success'}">${displayTransactionType}</span></td>
                    <td>${transaction.paymentMode || 'N/A'}</td>
                    <td>${transaction.refundReason || '-'}</td>
                    <td>${transaction.remarks || '-'}</td>
                `;
                
                // Add row-level color coding
                row.className = isRefund ? 'ledger-refund-row' : 'ledger-capture-row';
                
                console.log('Generated row HTML:', row.innerHTML);
                
                tableBody.appendChild(row);
            });
            
            // Update summary with correct calculations
            const netAmount = totalPaid - totalRefunded;
            
            console.log('=== SUMMARY CALCULATIONS ===');
            console.log('Total Paid:', totalPaid);
            console.log('Total Refunded:', totalRefunded);
            console.log('Net Amount:', netAmount);
            
            document.getElementById('totalPaid').textContent = '₹' + totalPaid.toFixed(2);
            document.getElementById('totalRefunded').textContent = '₹' + totalRefunded.toFixed(2);
            document.getElementById('netAmount').textContent = '₹' + netAmount.toFixed(2);
            
            console.log('Updated summary elements:');
            console.log('totalPaid element:', document.getElementById('totalPaid').textContent);
            console.log('totalRefunded element:', document.getElementById('totalRefunded').textContent);
            console.log('netAmount element:', document.getElementById('netAmount').textContent);
            
            // Apply color coding to net amount
            const netAmountElement = document.getElementById('netAmount');
            if (netAmount >= 0) {
                netAmountElement.className = 'text-success';
            } else {
                netAmountElement.className = 'text-danger';
            }
            
            console.log('Applied CSS class to net amount:', netAmountElement.className);
            console.log('=== END DISPLAY LEDGER DATA DEBUG ===');
        }
        
        function downloadLedgerCSV() {
            const patientId = parseInt('${patient.id}', 10);
            const patientName = "${fn:escapeXml(patient.firstName)} ${fn:escapeXml(patient.lastName)}";
            
            fetch('/payment-management/patient/' + patientId + '/transactions')
                .then(response => response.json())
                .then(data => {
                    if (data && data.length > 0) {
                        generateCSV(data, patientName);
                    } else {
                        alert('No data available to download.');
                    }
                })
                .catch(error => {
                    alert('Error downloading CSV. Please try again.');
                });
        }
        
        function generateCSV(transactions, patientName) {
            const headers = ['Date', 'Procedure', 'Amount', 'Transaction Type', 'Payment Mode', 'Refund Reason', 'Remarks'];
            let csvContent = headers.join(',') + '\n';
            
            transactions.forEach(transaction => {
                const formattedDate = new Date(transaction.paymentDate).toLocaleDateString('en-IN');
                
                // Use the refund flag to determine transaction type and amount display
                const isRefund = transaction.refund || false;
                const amount = parseFloat(transaction.amount || 0);
                const validAmount = isNaN(amount) ? 0 : amount;
                const absAmount = Math.abs(validAmount);
                const transactionType = isRefund ? 'REFUND' : 'CAPTURE';
                const csvAmountDisplay = isRefund ? `-${absAmount}` : `${absAmount}`;
                
                const row = [
                    formattedDate,
                    '"' + (transaction.procedureName || 'N/A').replace(/"/g, '""') + '"',
                    csvAmountDisplay,
                    transactionType,
                    transaction.paymentMode || 'N/A',
                    '"' + (transaction.refundReason || '').replace(/"/g, '""') + '"',
                    '"' + (transaction.remarks || '').replace(/"/g, '""') + '"'
                ];
                csvContent += row.join(',') + '\n';
            });
            
            // Create and download file
            const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
            const link = document.createElement('a');
            const url = URL.createObjectURL(blob);
            const currentDate = new Date().toISOString().split('T')[0];
            const fileName = 'customer_ledger_' + patientName.replace(/\s+/g, '_') + '_' + currentDate + '.csv';
            link.setAttribute('href', url);
            link.setAttribute('download', fileName);
            link.style.visibility = 'hidden';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('customerLedgerModal');
            if (event.target === modal) {
                closeCustomerLedger();
            }
        }
    </script>

    <script>
        // Bulk Upload to Selected Examinations
        let bulkSelectedFiles = [];

        function getSelectedExaminationIds() {
            const selectedCheckboxes = document.querySelectorAll('.examination-checkbox:checked');
            return Array.from(selectedCheckboxes).map(cb => cb.value);
        }

        function openBulkUploadSelectedModal() {
            const selectedIds = getSelectedExaminationIds();
            if (selectedIds.length === 0) {
                showAlertModal('Please select at least one examination to upload files.', 'warning');
                return;
            }
            document.getElementById('bulkSelectedCount').textContent = selectedIds.length;
            bulkSelectedFiles = [];
            const input = document.getElementById('bulkSelectedInput');
            if (input) input.value = '';
            const list = document.getElementById('bulkSelectedFileList');
            if (list) list.innerHTML = '';
            document.getElementById('bulkUploadSelectedModal').style.display = 'block';
        }

        function closeBulkUploadSelectedModal() {
            document.getElementById('bulkUploadSelectedModal').style.display = 'none';
            bulkSelectedFiles = [];
            const input = document.getElementById('bulkSelectedInput');
            if (input) input.value = '';
            const list = document.getElementById('bulkSelectedFileList');
            if (list) list.innerHTML = '';
        }

        function renderBulkSelectedFileList(files) {
            const list = document.getElementById('bulkSelectedFileList');
            if (!list) return;
            list.innerHTML = '';
            files.forEach(f => {
                const sizeMB = (f.size / (1024 * 1024)).toFixed(2);
                const item = document.createElement('div');
                item.className = 'file-list-item';
                item.textContent = f.name + ' (' + sizeMB + ' MB)';
                list.appendChild(item);
            });
        }

        async function handleBulkSelectedFiles(fileList) {
            bulkSelectedFiles = [];
            const files = Array.from(fileList || []);
            for (const file of files) {
                const isPdf = file.type === 'application/pdf' || file.name.toLowerCase().endsWith('.pdf');
                let finalFile = file;
                if (!isPdf) {
                    try {
                        // Basic image compression; options can be tuned if needed
                        finalFile = await ImageCompression.compressImage(file);
                    } catch (e) {
                        // Fallback to original file on compression error
                        finalFile = file;
                    }
                }
                bulkSelectedFiles.push(finalFile);
            }
            renderBulkSelectedFileList(bulkSelectedFiles);
        }

        (function initBulkSelectedInput(){
            const input = document.getElementById('bulkSelectedInput');
            if (input) {
                input.addEventListener('change', async function(e){
                    await handleBulkSelectedFiles(e.target.files);
                });
            }
        })();

        async function uploadBulkFilesToSelected() {
            const selectedIds = getSelectedExaminationIds();
            if (selectedIds.length === 0) {
                showAlertModal('Please select at least one examination.', 'warning');
                return;
            }
            if (bulkSelectedFiles.length === 0) {
                showAlertModal('Please choose files to upload.', 'warning');
                return;
            }

            const token = document.querySelector('meta[name="_csrf"]').content;
            let successCount = 0;
            let failCount = 0;

            for (const examId of selectedIds) {
                const fd = new FormData();
                fd.append('examinationId', examId);
                bulkSelectedFiles.forEach(f => fd.append('files', f));

                try {
                    const resp = await fetch(joinUrl(contextPath, '/patients/examination/upload-bulk-media'), {
                        method: 'POST',
                        headers: { 'X-CSRF-TOKEN': token },
                        body: fd
                    });
                    let json = {};
                    try { json = await resp.json(); } catch (e) {}
                    if (resp.ok && (json.success === undefined || json.success)) {
                        successCount++;
                    } else {
                        failCount++;
                    }
                } catch (e) {
                    failCount++;
                }
            }

            if (failCount === 0) {
                showAlertModal('Uploaded to ' + successCount + ' examinations successfully.', 'success');
                closeBulkUploadSelectedModal();
            } else {
                showAlertModal('Upload completed: ' + successCount + ' successful, ' + failCount + ' failed.', 'warning');
            }
        }

        // Bulk Send for Payment
        function openBulkSendForPaymentModal() {
            const selectedIds = getSelectedExaminationIds();
            if (selectedIds.length === 0) {
                showAlertModal('Please select at least one examination to send for payment.', 'warning');
                return;
            }

            // Reset any in-progress guard for bulk send
            window._sendingBulkPayment = false;

            // Update selected count
            const countEl = document.getElementById('bulkSendSelectedCount');
            if (countEl) countEl.textContent = selectedIds.length;

            // Client-side validation: show non-open records
            const validationList = document.getElementById('bulkPaymentValidationList');
            const validationBox = document.getElementById('bulkPaymentValidation');
            if (validationList && validationBox) {
                validationList.innerHTML = '';
                let invalidCount = 0;
                selectedIds.forEach(id => {
                    const checkbox = document.querySelector('.examination-checkbox[value="' + id + '"]');
                    if (checkbox) {
                        const row = checkbox.closest('tr');
                        const statusCell = row ? row.querySelector('td:nth-child(8)') : null;
                        const statusText = statusCell ? statusCell.textContent.trim().toUpperCase() : '';
                        if (statusText !== 'OPEN') {
                            invalidCount++;
                            const li = document.createElement('li');
                            li.textContent = 'Examination ' + id + ' is ' + (statusText || 'UNKNOWN') + ' and cannot be sent';
                            validationList.appendChild(li);
                        }
                    }
                });
                validationBox.style.display = invalidCount > 0 ? 'block' : 'none';
            }

            // Reset progress/result sections
            const progressBox = document.getElementById('bulkPaymentProgress');
            const progressBar = document.getElementById('bulkPaymentProgressBar');
            const resultBox = document.getElementById('bulkPaymentResult');
            const errorContainer = document.getElementById('bulkPaymentErrorContainer');
            const errorList = document.getElementById('bulkPaymentErrorList');
            const resultSummary = document.getElementById('bulkPaymentResultSummary');
            if (progressBox) progressBox.style.display = 'none';
            if (progressBar) progressBar.style.width = '0%';
            if (resultBox) resultBox.style.display = 'none';
            if (errorContainer) errorContainer.style.display = 'none';
            if (errorList) errorList.innerHTML = '';
            if (resultSummary) resultSummary.textContent = '';

            document.getElementById('bulkSendForPaymentModal').style.display = 'block';
        }

        function closeBulkSendForPaymentModal() {
            document.getElementById('bulkSendForPaymentModal').style.display = 'none';
        }

        async function sendSelectedForPayment() {
            // Prevent multiple rapid clicks / duplicate submissions
            if (window._sendingBulkPayment) {
                return;
            }

            const selectedIds = getSelectedExaminationIds();
            if (selectedIds.length === 0) {
                showAlertModal('Please select at least one examination to send for payment.', 'warning');
                return;
            }

            // Show progress UI
            const progressBox = document.getElementById('bulkPaymentProgress');
            const progressBar = document.getElementById('bulkPaymentProgressBar');
            const resultBox = document.getElementById('bulkPaymentResult');
            const errorContainer = document.getElementById('bulkPaymentErrorContainer');
            const errorList = document.getElementById('bulkPaymentErrorList');
            const resultSummary = document.getElementById('bulkPaymentResultSummary');
            const confirmBtn = document.getElementById('confirmBulkSendForPaymentBtn');
            if (progressBox) progressBox.style.display = 'block';
            if (progressBar) progressBar.style.width = '25%';
            if (confirmBtn) {
                confirmBtn.disabled = true;
                confirmBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
            }

            // Mark operation started
            window._sendingBulkPayment = true;

            const token = document.querySelector('meta[name="_csrf"]').content;
            const payload = {
                examinationIds: selectedIds
            };

            try {
                const resp = await fetch(joinUrl(contextPath, '/patients/examinations/status/payment-pending/bulk'), {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': token
                    },
                    body: JSON.stringify(payload)
                });

                let json = {};
                try { json = await resp.json(); } catch (e) {}

                if (progressBar) progressBar.style.width = '60%';

                if (!resp.ok) {
                    const errMsg = (json && json.message) ? json.message : 'Failed to update procedure status';
                    if (resultBox) resultBox.style.display = 'block';
                    if (resultSummary) resultSummary.textContent = errMsg;
                    if (errorContainer) errorContainer.style.display = 'none';
                    if (progressBox) progressBox.style.display = 'none';
                    if (confirmBtn) {
                        confirmBtn.disabled = false;
                        confirmBtn.classList.remove('btn-success','btn-warning');
                        confirmBtn.classList.add('btn-primary');
                        confirmBtn.innerHTML = '<i class="fas fa-redo"></i> Retry';
                    }
                    // Allow retry
                    window._sendingBulkPayment = false;
                    return;
                }

                const updatedIds = (json && json.updatedIds) ? json.updatedIds : [];
                const errors = (json && json.errors) ? json.errors : [];
                const updatedCount = (json && typeof json.updatedCount === 'number') ? json.updatedCount : updatedIds.length;
                const failedCount = (json && typeof json.failedCount === 'number') ? json.failedCount : errors.length;
                const totalCount = (json && typeof json.totalCount === 'number') ? json.totalCount : selectedIds.length;

                // Update UI for updated rows
                updatedIds.forEach(id => {
                    const checkbox = document.querySelector('.examination-checkbox[value="' + id + '"]');
                    if (checkbox) {
                        const row = checkbox.closest('tr');
                        const statusCell = row ? row.querySelector('td:nth-child(8)') : null;
                        if (statusCell) statusCell.textContent = 'PAYMENT_PENDING';
                    }
                });

                if (progressBar) progressBar.style.width = '100%';
                if (resultBox) resultBox.style.display = 'block';
                if (progressBox) progressBox.style.display = 'none';
                if (resultSummary) {
                    const baseMsg = (json && json.message) ? json.message : (json && json.success ? 'Updated successfully' : 'Partial update completed');
                    resultSummary.textContent = baseMsg + ' (' + updatedCount + '/' + totalCount + ' updated, ' + failedCount + ' failed)';
                }

                // Show errors if present
                if (errors && errors.length > 0 && errorContainer && errorList) {
                    errorContainer.style.display = 'block';
                    errorList.innerHTML = '';
                    errors.forEach(err => {
                        const li = document.createElement('li');
                        li.textContent = 'Examination ' + (err.examinationId || '-') + ': ' + (err.message || 'Unknown error');
                        errorList.appendChild(li);
                    });
                } else if (errorContainer) {
                    errorContainer.style.display = 'none';
                }

                // Show success notification and optionally close modal after short delay
                if (json && json.success) {
                    // On success, mark button as completed and prevent further clicks
                    if (confirmBtn) {
                        confirmBtn.disabled = true;
                        confirmBtn.classList.remove('btn-primary','btn-warning');
                        confirmBtn.classList.add('btn-success');
                        confirmBtn.innerHTML = '<i class="fas fa-check"></i> Sent';
                    }

                    // Uncheck updated rows and update bulk action visibility
                    updatedIds.forEach(id => {
                        const checkbox = document.querySelector('.examination-checkbox[value="' + id + '"]');
                        if (checkbox) { checkbox.checked = false; }
                    });
                    if (typeof updateTableSelectionCount === 'function') {
                        updateTableSelectionCount();
                    }

                    showAlertModal('Successfully sent selected examinations for payment.', 'success', () => { window.location.reload(); });
                    setTimeout(() => { closeBulkSendForPaymentModal(); }, 1200);
                } else {
                    // Partial success: disable button to avoid repeated clicks, keep modal open to review issues
                    if (confirmBtn) {
                        confirmBtn.disabled = true;
                        confirmBtn.classList.remove('btn-primary','btn-success');
                        confirmBtn.classList.add('btn-warning');
                        confirmBtn.innerHTML = '<i class="fas fa-exclamation-circle"></i> Review Issues';
                    }

                    // Uncheck successfully updated rows to avoid re-sending them
                    updatedIds.forEach(id => {
                        const checkbox = document.querySelector('.examination-checkbox[value="' + id + '"]');
                        if (checkbox) { checkbox.checked = false; }
                    });
                    if (typeof updateTableSelectionCount === 'function') {
                        updateTableSelectionCount();
                    }

                    // Graceful handling: keep modal open with results and allow closing via Cancel/X
                    showAlertModal('Partial update completed. Some records could not be updated.', 'warning');
                }
            } catch (e) {
                if (resultBox) resultBox.style.display = 'block';
                if (resultSummary) resultSummary.textContent = 'Network error while updating statuses: ' + e.message;
                if (errorContainer) errorContainer.style.display = 'none';
                if (progressBox) progressBox.style.display = 'none';
                // Allow retry on network error
                if (confirmBtn) {
                    confirmBtn.disabled = false;
                    confirmBtn.classList.remove('btn-success','btn-warning');
                    confirmBtn.classList.add('btn-primary');
                    confirmBtn.innerHTML = '<i class="fas fa-redo"></i> Retry';
                }
                window._sendingBulkPayment = false;
            } finally {
                // Do not re-enable the button here; handled per outcome above
            }
        }
    </script>
     
     <!-- Hidden Print Content -->
     <div class="print-content" id="printContent">
         <div class="registration-details" style="text-align: center; display: block;">
             <div class="detail-item" style="display: block; text-align: center; margin-bottom: 10px; font-size: 14pt;">
                 <strong>Full Name:</strong> ${patient.firstName} ${patient.lastName}
             </div>
             <div class="detail-item" style="display: block; text-align: center; margin-bottom: 10px; font-size: 14pt;">
                 <strong>Age:</strong> ${patient.age} years
             </div>
             <div class="detail-item" style="display: block; text-align: center; margin-bottom: 10px; font-size: 14pt;">
                 <strong>Gender:</strong> ${patient.gender}
             </div>
             <div class="detail-item" style="display: block; text-align: center; margin-bottom: 10px; font-size: 14pt;">
                 <strong>Phone Number:</strong> ${patient.phoneNumber}
             </div>
             <div class="detail-item" style="display: block; text-align: center; margin-bottom: 10px; font-size: 14pt;">
                <strong>Medical History:</strong>
                <c:choose>
                    <c:when test="${not empty patient.medicalHistory}">${fn:escapeXml(patient.medicalHistory)}</c:when>
                    <c:otherwise>None reported</c:otherwise>
                </c:choose>
             </div>
             <div class="detail-item" style="display: block; text-align: center; margin-bottom: 10px; font-size: 14pt;">
                <strong>Branch:</strong>
                <c:choose>
                    <c:when test="${not empty patient.registeredClinic}">${fn:escapeXml(patient.registeredClinic.clinicName)}</c:when>
                    <c:otherwise>Not specified</c:otherwise>
                </c:choose>
             </div>
             <div class="detail-item" style="display: block; text-align: center; margin-bottom: 10px; font-size: 14pt;">
                 <strong>Registration Code:</strong> ${patient.registrationCode}
             </div>
         </div>
         
         <!-- Footer positioned 7 lines from bottom -->
         <div style="position: fixed; bottom: 7em; left: 0; right: 0; text-align: center; font-size: 10pt; color: #666;">
             Generated using PeriDesk developed by NavTech Labs
         </div>
     </div>

     <!-- Customer Ledger Modal -->
     <div id="customerLedgerModal" class="modal" style="display: none;">
         <div class="modal-content" style="max-width: 1000px; width: 90%;">
             <div class="modal-header">
                 <h2><i class="fas fa-file-invoice-dollar"></i> Customer Ledger - ${patient.firstName} ${patient.lastName}</h2>
                 <span class="close" onclick="closeCustomerLedger()">&times;</span>
             </div>
             
             <div class="modal-body">
                 <!-- Loading State -->
                 <div id="ledgerLoading" style="display: none; text-align: center; padding: 20px;">
                     <i class="fas fa-spinner fa-spin fa-2x"></i>
                     <p>Loading payment transactions...</p>
                 </div>
                 
                 <!-- Error State -->
                 <div id="ledgerError" style="display: none; text-align: center; padding: 20px; color: #dc3545;">
                     <!-- Error message will be inserted here -->
                 </div>
                 
                 <!-- Content -->
                 <div id="ledgerContent" style="display: none;">
                     <!-- Summary Cards -->
                     <div class="ledger-summary" style="display: flex; gap: 20px; margin-bottom: 20px;">
                         <div class="summary-card" style="flex: 1; background: #e8f5e8; padding: 15px; border-radius: 8px; text-align: center;">
                             <h4 style="margin: 0; color: #27ae60;">Total Paid</h4>
                             <p id="totalPaid" style="font-size: 1.5em; font-weight: bold; margin: 5px 0; color: #27ae60;">₹0.00</p>
                         </div>
                         <div class="summary-card" style="flex: 1; background: #fff3cd; padding: 15px; border-radius: 8px; text-align: center;">
                             <h4 style="margin: 0; color: #856404;">Total Refunded</h4>
                             <p id="totalRefunded" style="font-size: 1.5em; font-weight: bold; margin: 5px 0; color: #856404;">₹0.00</p>
                         </div>
                         <div class="summary-card" style="flex: 1; background: #d1ecf1; padding: 15px; border-radius: 8px; text-align: center;">
                             <h4 style="margin: 0; color: #0c5460;">Net Amount</h4>
                             <p id="netAmount" style="font-size: 1.5em; font-weight: bold; margin: 5px 0; color: #0c5460;">₹0.00</p>
                         </div>
                     </div>
                     
                     <!-- Download Button -->
                     <div style="text-align: right; margin-bottom: 15px;">
                         <button onclick="downloadLedgerCSV()" class="btn btn-success">
                             <i class="fas fa-download"></i> Download CSV
                         </button>
                     </div>
                     
                     <!-- Transactions Table -->
                     <div class="table-responsive">
                         <table class="table" style="margin-bottom: 0;">
                             <thead>
                                 <tr>
                                     <th>Date</th>
                                     <th>Procedure</th>
                                     <th>Amount</th>
                                     <th>Transaction Type</th>
                                     <th>Payment Mode</th>
                                     <th>Refund Reason</th>
                                     <th>Remarks</th>
                                 </tr>
                             </thead>
                             <tbody id="ledgerTableBody">
                                 <!-- Transaction rows will be inserted here -->
                             </tbody>
                         </table>
                     </div>
                 </div>
             </div>
         </div>
     </div>

     <style>
         .transaction-type {
             padding: 3px 8px;
             border-radius: 12px;
             font-size: 0.8em;
             font-weight: 500;
             text-transform: uppercase;
         }
         
         .transaction-type.capture {
             background: #e8f5e8;
             color: #27ae60;
         }
         
         .transaction-type.refund {
             background: #fff3cd;
             color: #856404;
         }
         
         .ledger-summary .summary-card h4 {
             font-size: 0.9em;
             text-transform: uppercase;
             letter-spacing: 0.5px;
         }
     </style>
</body>
</html>
