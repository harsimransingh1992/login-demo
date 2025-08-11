// Clean implementation of modal functionality
document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooth examination modal functionality
    const toothModal = document.getElementById('toothModal');
    const toothCloseBtn = toothModal ? toothModal.querySelector('.close') : null;
    const toothCancelBtn = toothModal ? toothModal.querySelector('.btn-secondary') : null;
    const toothForm = toothModal ? document.getElementById('toothExaminationForm') : null;
    
    // Close tooth modal when clicking the close button or cancel button
    if (toothCloseBtn) {
        toothCloseBtn.addEventListener('click', closeToothModal);
    }
    if (toothCancelBtn) {
        toothCancelBtn.addEventListener('click', closeToothModal);
    }
    
    // Close tooth modal when clicking outside
    if (toothModal) {
        window.addEventListener('click', function(event) {
            if (event.target === toothModal) {
                closeToothModal();
            }
        });
    }

    // Initialize consultation modal functionality
    const consultationModal = document.getElementById('consultationModal');
    const consultationCloseBtn = consultationModal ? consultationModal.querySelector('.close') : null;
    const consultationCancelBtn = consultationModal ? consultationModal.querySelector('.btn-secondary') : null;
    const consultationForm = consultationModal ? document.getElementById('consultationForm') : null;
    
    // Close consultation modal when clicking the close button or cancel button
    if (consultationCloseBtn) {
        consultationCloseBtn.addEventListener('click', closeConsultationModal);
    }
    if (consultationCancelBtn) {
        consultationCancelBtn.addEventListener('click', closeConsultationModal);
    }
    
    // Close consultation modal when clicking outside
    if (consultationModal) {
        window.addEventListener('click', function(event) {
            if (event.target === consultationModal) {
                closeConsultationModal();
            }
        });
    }

    // Add click handlers to all teeth
    document.querySelectorAll('.tooth').forEach(tooth => {
        tooth.addEventListener('click', function() {
            const toothNumber = this.getAttribute('data-tooth-number');
            if (toothNumber) {
                openToothDetails(toothNumber);
            }
        });
    });

    // Handle form submissions
    if (toothForm) {
        toothForm.addEventListener('submit', handleToothFormSubmit);
    }
    if (consultationForm) {
        consultationForm.addEventListener('submit', handleConsultationFormSubmit);
    }
    

});

// Function to open general consultation modal
function openGeneralConsultation() {
    // Check if user is a receptionist (additional client-side validation)
    const isReceptionist = document.querySelector('.chart-instructions') && 
                          document.querySelector('.chart-instructions').textContent.includes('Receptionists cannot add');
    
    if (isReceptionist) {
        showNotification('Receptionists are not authorized to add consultations. Please contact a doctor or staff member.', true);
        return;
    }
    
    // Check if patient is checked in
    const patientStatusElement = document.querySelector('.meta-item strong span');
    if (patientStatusElement) {
        const statusText = patientStatusElement.textContent.trim();
        if (statusText === 'Not Checked In') {
            showNotification('Patient must be checked in before adding new consultations. Please check in the patient first.', true);
            return;
        }
    }
    
    const modal = document.getElementById('consultationModal');
    
    if (!modal) {
        console.error('Consultation modal not found');
        return;
    }
    
    // Show the consultation modal
    modal.style.display = 'block';
}



// Function to open tooth details modal
function openToothDetails(toothNumber) {
    // Check if user is a receptionist (additional client-side validation)
    const isReceptionist = document.querySelector('.chart-instructions') && 
                          document.querySelector('.chart-instructions').textContent.includes('Receptionists cannot add');
    
    if (isReceptionist) {
        showNotification('Receptionists are not authorized to add tooth examinations. Please contact a doctor or staff member.', true);
        return;
    }
    
    // Check if patient is checked in
    const patientStatusElement = document.querySelector('.meta-item strong span');
    if (patientStatusElement) {
        const statusText = patientStatusElement.textContent.trim();
        if (statusText === 'Not Checked In') {
            showNotification('Patient must be checked in before adding new tooth examinations. Please check in the patient first.', true);
            return;
        }
    }
    
    const modal = document.getElementById('toothModal');
    const toothNumberInput = document.getElementById('toothNumber');
    const selectedToothNumberSpan = document.getElementById('selectedToothNumber');
    
    if (!modal || !toothNumberInput || !selectedToothNumberSpan) {
        console.error('Required modal elements not found');
        return;
    }
    
    // Set the tooth number in the form
    const formattedToothNumber = `TOOTH_${toothNumber}`;
    toothNumberInput.value = formattedToothNumber;
    selectedToothNumberSpan.textContent = toothNumber;
    
    // Show the modal
    modal.style.display = 'block';
}

// Function to close the consultation modal
function closeConsultationModal() {
    const modal = document.getElementById('consultationModal');
    if (modal) {
        modal.style.display = 'none';
        // Reset form
        document.getElementById('consultationForm').reset();
    }
}

// Function to close the tooth examination modal
function closeToothModal() {
    const modal = document.getElementById('toothModal');
    if (modal) {
        modal.style.display = 'none';
        // Reset form
        document.getElementById('toothExaminationForm').reset();
    }
}

// Function to close the modal (legacy function for backward compatibility)
function closeModal() {
    closeToothModal();
}

// Function to show notification
function showNotification(message, isError = false) {
    const alertContainer = document.getElementById('alertContainer');
    if (alertContainer) {
        const alertClass = isError ? 'alert-danger' : 'alert-success';
        alertContainer.innerHTML = `<div class="alert ${alertClass}">${message}</div>`;
        
        // If it's a success message, make it more visible
        if (!isError) {
            alertContainer.style.display = 'block';
            alertContainer.style.position = 'fixed';
            alertContainer.style.top = '20px';
            alertContainer.style.left = '50%';
            alertContainer.style.transform = 'translateX(-50%)';
            alertContainer.style.zIndex = '9999';
            alertContainer.style.minWidth = '300px';
            alertContainer.style.textAlign = 'center';
        }
    }
}

// Function to handle consultation form submission
function handleConsultationFormSubmit(event) {
    event.preventDefault();
    
    // Prevent multiple submissions
    const submitButton = event.target.querySelector('button[type="submit"]');
    if (submitButton && submitButton.disabled) {
        console.log('Consultation form submission already in progress, ignoring click');
        return;
    }
    
    // Store original button text and disable submit button
    let originalText = '';
    if (submitButton) {
        originalText = submitButton.innerHTML;
        submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
        submitButton.disabled = true;
        submitButton.classList.add('btn-loading');
    }
    
    const form = event.target;
    const formData = new URLSearchParams();
    
    // Add consultation form fields to URLSearchParams
    formData.append('id', document.getElementById('consultationExaminationId').value);
    formData.append('patientId', document.getElementById('consultationPatientId').value);
    formData.append('toothNumber', document.getElementById('consultationToothNumber').value);
    formData.append('chiefComplaints', document.getElementById('consultationChiefComplaints').value || '');
    formData.append('examinationNotes', document.getElementById('consultationExaminationNotes').value || '');
    formData.append('advised', ''); // Empty for consultation

    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/patients/tooth-examination/save', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.setRequestHeader('X-CSRF-TOKEN', document.querySelector("meta[name='_csrf']").content);

    xhr.onload = function() {
        if (xhr.status === 200) {
            try {
                const response = JSON.parse(xhr.responseText);
                if (response.success) {
                    showNotification('Consultation saved successfully!');
                    closeConsultationModal();
                    // Reload the page to show updated data
                    setTimeout(() => {
                        window.location.reload();
                    }, 1000);
                } else {
                    showNotification(response.message || 'Failed to save consultation', true);
                    // Restore button state on error
                    if (submitButton) {
                        submitButton.innerHTML = originalText;
                        submitButton.disabled = false;
                        submitButton.classList.remove('btn-loading');
                    }
                }
            } catch (e) {
                showNotification('Error processing response', true);
                // Restore button state on error
                if (submitButton) {
                    submitButton.innerHTML = originalText;
                    submitButton.disabled = false;
                    submitButton.classList.remove('btn-loading');
                }
            }
        } else {
            showNotification('Failed to save consultation', true);
            // Restore button state on error
            if (submitButton) {
                submitButton.innerHTML = originalText;
                submitButton.disabled = false;
                submitButton.classList.remove('btn-loading');
            }
        }
    };

    xhr.onerror = function() {
        showNotification('Network error occurred', true);
        // Restore button state on error
        if (submitButton) {
            submitButton.innerHTML = originalText;
            submitButton.disabled = false;
            submitButton.classList.remove('btn-loading');
        }
    };

    xhr.send(formData);
}

// Function to handle tooth examination form submission
function handleToothFormSubmit(event) {
    event.preventDefault();
    
    // Prevent multiple submissions
    const submitButton = event.target.querySelector('button[type="submit"]');
    if (submitButton && submitButton.disabled) {
        console.log('Form submission already in progress, ignoring click');
        return;
    }
    
    // Store original button text and disable submit button
    let originalText = '';
    if (submitButton) {
        originalText = submitButton.innerHTML;
        submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
        submitButton.disabled = true;
        submitButton.classList.add('btn-loading');
    }
    
    const form = event.target;
    const formData = new URLSearchParams();
    
    // Add all form fields to URLSearchParams
    formData.append('id', document.getElementById('examinationId').value);
    formData.append('patientId', document.getElementById('patientId').value);
    formData.append('toothNumber', document.getElementById('toothNumber').value);
    formData.append('toothCondition', document.getElementById('toothCondition').value);
    formData.append('existingRestoration', document.getElementById('existingRestoration').value);
    formData.append('toothMobility', document.getElementById('toothMobility').value);
    formData.append('pocketDepth', document.getElementById('pocketDepth').value);
    formData.append('bleedingOnProbing', document.getElementById('bleedingOnProbing').value);
    formData.append('plaqueScore', document.getElementById('plaqueScore').value);
    formData.append('gingivalRecession', document.getElementById('gingivalRecession').value);
    formData.append('toothVitality', document.getElementById('toothVitality').value);
    formData.append('furcationInvolvement', document.getElementById('furcationInvolvement').value);
    formData.append('toothSensitivity', document.getElementById('toothSensitivity').value);
    
    formData.append('examinationNotes', document.getElementById('examinationNotes').value || '');
    formData.append('advised', document.getElementById('advised').value || '');
    
    formData.append('chiefComplaints', document.getElementById('chiefComplaints').value || '');

    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/patients/tooth-examination/save', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.setRequestHeader('X-CSRF-TOKEN', document.querySelector("meta[name='_csrf']").content);

    xhr.onload = function() {
        if (xhr.status === 200) {
            try {
                const response = JSON.parse(xhr.responseText);
                if (response.success) {
                    showNotification('Examination saved successfully!');
                    closeToothModal();
                    // Reload the page to show updated data
                    setTimeout(() => {
                        window.location.reload();
                    }, 1000);
                } else {
                    showNotification(response.message || 'Failed to save examination', true);
                    // Restore button state on error
                    if (submitButton) {
                        submitButton.innerHTML = originalText;
                        submitButton.disabled = false;
                        submitButton.classList.remove('btn-loading');
                    }
                }
            } catch (e) {
                showNotification('Error processing response', true);
                // Restore button state on error
                if (submitButton) {
                    submitButton.innerHTML = originalText;
                    submitButton.disabled = false;
                    submitButton.classList.remove('btn-loading');
                }
            }
        } else {
            showNotification('Failed to save examination', true);
            // Restore button state on error
            if (submitButton) {
                submitButton.innerHTML = originalText;
                submitButton.disabled = false;
                submitButton.classList.remove('btn-loading');
            }
        }
    };

    xhr.onerror = function() {
        showNotification('Network error occurred', true);
        // Restore button state on error
        if (submitButton) {
            submitButton.innerHTML = originalText;
            submitButton.disabled = false;
            submitButton.classList.remove('btn-loading');
        }
    };

    xhr.send(formData);
}

// Function to handle form submission (legacy function for backward compatibility)
function handleFormSubmit(event) {
    handleToothFormSubmit(event);
}

// Utility function to prevent multiple form submissions
function preventMultipleSubmissions(form, submitButton) {
    if (submitButton && submitButton.disabled) {
        console.log('Form submission already in progress, ignoring click');
        return false;
    }
    
    if (submitButton) {
        const originalText = submitButton.innerHTML;
        submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
        submitButton.disabled = true;
        submitButton.classList.add('btn-loading');
        
        // Store original text for restoration
        submitButton.dataset.originalText = originalText;
    }
    
    return true;
}

// Utility function to restore button state
function restoreButtonState(submitButton) {
    if (submitButton) {
        submitButton.innerHTML = submitButton.dataset.originalText || 'Save';
        submitButton.disabled = false;
        submitButton.classList.remove('btn-loading');
    }
}

function showError(message) {
    const alertContainer = document.getElementById('alertContainer');
    if (alertContainer) {
        alertContainer.innerHTML = `<div class="alert alert-danger">${message}</div>`;
    }
    console.error(message);
}

// Function to load examinations
function loadExaminations() {
    const patientId = document.getElementById('patientId').value;
    if (patientId) {
        fetch(`/patients/${patientId}/examinations`)
            .then(response => response.json())
            .then(data => {
                updateExaminationsList(data);
            })
            .catch(error => {
                console.error('Error loading examinations:', error);
                showNotification('Error loading examinations', true);
            });
    }
}

// Function to update examinations list in the UI
function updateExaminationsList(examinations) {
    const container = document.getElementById('examinationsList');
    if (container) {
        container.innerHTML = '';
        examinations.forEach(exam => {
            const examElement = document.createElement('div');
            examElement.className = 'examination-item';
            examElement.innerHTML = `
                <h4>Tooth ${exam.toothNumber}</h4>
                <p>Date: ${new Date(exam.examinationDate).toLocaleString()}</p>
                <p>Condition: ${exam.toothCondition}</p>
                <p>Notes: ${exam.examinationNotes || 'No notes'}</p>
            `;
            container.appendChild(examElement);
        });
    }
}

// Function to filter examinations by doctor
function filterByDoctor(doctorId) {
    const table = document.getElementById('examinationHistoryTable');
    const rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
    
    for (let row of rows) {
        const doctorCell = row.querySelector('td[data-doctor]');
        const doctorValue = doctorCell.getAttribute('data-doctor');
        
        if (doctorId === 'all') {
            row.style.display = '';
        } else if (doctorId === 'unassigned') {
            row.style.display = doctorValue === '' ? '' : 'none';
        } else {
            row.style.display = doctorValue === doctorId ? '' : 'none';
        }
    }
    
    updateTableInfo();
}

// Function to filter examinations by clinic
function filterByClinic(clinicId) {
    const table = document.getElementById('examinationHistoryTable');
    const rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
    
    for (let row of rows) {
        const clinicCell = row.querySelector('td[data-clinic-id]');
        const clinicValue = clinicCell.getAttribute('data-clinic-id');
        
        if (clinicId === 'all') {
            row.style.display = '';
        } else {
            row.style.display = clinicValue === clinicId ? '' : 'none';
        }
    }
    
    updateTableInfo();
}

// Function to sort the examination table
function sortTable(sortType) {
    const table = document.getElementById('examinationHistoryTable');
    const tbody = table.getElementsByTagName('tbody')[0];
    const rows = Array.from(tbody.getElementsByTagName('tr'));
    
    rows.sort((a, b) => {
        switch (sortType) {
            case 'dateDesc':
                return new Date(b.querySelector('td[data-date]').getAttribute('data-date')) - 
                       new Date(a.querySelector('td[data-date]').getAttribute('data-date'));
            case 'dateAsc':
                return new Date(a.querySelector('td[data-date]').getAttribute('data-date')) - 
                       new Date(b.querySelector('td[data-date]').getAttribute('data-date'));
            case 'toothNumberAsc':
                return parseInt(a.querySelector('td[data-tooth]').getAttribute('data-tooth')) - 
                       parseInt(b.querySelector('td[data-tooth]').getAttribute('data-tooth'));
            case 'toothNumberDesc':
                return parseInt(b.querySelector('td[data-tooth]').getAttribute('data-tooth')) - 
                       parseInt(a.querySelector('td[data-tooth]').getAttribute('data-tooth'));
            default:
                return 0;
        }
    });
    
    // Reorder the rows
    rows.forEach(row => tbody.appendChild(row));
    updateTableInfo();
}

// Function to update the table info text
function updateTableInfo() {
    const table = document.getElementById('examinationHistoryTable');
    const visibleRows = Array.from(table.getElementsByTagName('tbody')[0].getElementsByTagName('tr'))
        .filter(row => row.style.display !== 'none');
    const totalRows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr').length;
    
    const tableInfo = document.querySelector('.table-info small');
    if (tableInfo) {
        tableInfo.textContent = `Showing ${visibleRows.length} of ${totalRows} records`;
    }
}

// Notes Modal Functions
function showNotesPopup(notes, examId) {
    // Prevent default behavior and event bubbling
    event.preventDefault();
    event.stopPropagation();
    
    const modal = document.getElementById('notesModal');
    const notesContent = document.getElementById('notesContent');
    
    if (!modal || !notesContent) {
        console.error('Notes modal elements not found');
        return false;
    }
    
    // Set the notes content
    notesContent.textContent = notes;
    
    // Show the modal
    modal.style.display = 'block';
    
    // Prevent body scroll when modal is open
    document.body.style.overflow = 'hidden';
    
    return false;
}

function closeNotesModal() {
    const modal = document.getElementById('notesModal');
    
    if (!modal) {
        console.error('Notes modal not found');
        return;
    }
    
    // Hide the modal
    modal.style.display = 'none';
    
    // Restore body scroll
    document.body.style.overflow = 'auto';
}

// Close notes modal when clicking outside
document.addEventListener('DOMContentLoaded', function() {
    const notesModal = document.getElementById('notesModal');
    
    if (notesModal) {
        window.addEventListener('click', function(event) {
            if (event.target === notesModal) {
                closeNotesModal();
            }
        });
    }
    
    // Close notes modal with Escape key
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            const modal = document.getElementById('notesModal');
            if (modal && modal.style.display === 'block') {
                closeNotesModal();
            }
        }
    });
});

 