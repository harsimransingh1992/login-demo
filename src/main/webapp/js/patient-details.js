// Clean implementation of modal functionality
document.addEventListener('DOMContentLoaded', function() {
    // Initialize modal functionality
    const modal = document.getElementById('toothModal');
    const closeBtn = modal ? modal.querySelector('.close') : null;
    const cancelBtn = modal ? modal.querySelector('.btn-secondary') : null;
    const form = modal ? document.getElementById('toothExaminationForm') : null;
    
    // Close modal when clicking the close button or cancel button
    if (closeBtn) {
    closeBtn.addEventListener('click', closeModal);
    }
    if (cancelBtn) {
    cancelBtn.addEventListener('click', closeModal);
    }
    
    // Close modal when clicking outside
    if (modal) {
    window.addEventListener('click', function(event) {
        if (event.target === modal) {
            closeModal();
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

    // Handle form submission
    if (form) {
    form.addEventListener('submit', handleFormSubmit);
    }
});

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

// Function to close the modal
function closeModal() {
    const modal = document.getElementById('toothModal');
    if (modal) {
        modal.style.display = 'none';
        // Reset form
        document.getElementById('toothExaminationForm').reset();
    }
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

// Function to handle form submission
function handleFormSubmit(event) {
    event.preventDefault();
    
    const form = event.target;
    const formData = new URLSearchParams();
    
    // Add all form fields to URLSearchParams
    formData.append('id', document.getElementById('examinationId').value);
    formData.append('patientId', document.getElementById('patientId').value);
    formData.append('toothNumber', document.getElementById('toothNumber').value);
    formData.append('toothSurface', document.getElementById('toothSurface').value);
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
    formData.append('chiefComplaints', document.getElementById('chiefComplaints').value || '');
    formData.append('advised', document.getElementById('advised').value || '');

    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/patients/tooth-examination/save', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.setRequestHeader('X-CSRF-TOKEN', document.querySelector("meta[name='_csrf']").content);

    xhr.onload = function() {
        if (xhr.status === 200) {
                const response = JSON.parse(xhr.responseText);
                if (response.success) {
                closeModal();
                showNotification('Examination saved successfully');
                // Wait for 2 seconds before reloading to show the success message
                    setTimeout(() => {
                        window.location.reload();
                }, 2000);
                } else {
                showNotification(response.message || 'Failed to save examination', true);
            }
        } else {
            showNotification('Error saving examination', true);
        }
    };

    xhr.onerror = function() {
        showNotification('Network error occurred', true);
    };

    xhr.send(formData.toString());
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