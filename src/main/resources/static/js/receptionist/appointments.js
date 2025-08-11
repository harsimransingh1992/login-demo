function initializeCalendar(appointments) {
    const calendarEl = document.getElementById('calendar');
    const calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'timeGridDay',
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'timeGridDay,timeGridWeek,timeGridMonth'
        },
        events: appointments.map(appointment => ({
            id: appointment.id,
            title: appointment.patient ? 
                  `${appointment.patient.firstName} ${appointment.patient.lastName}` : 
                  appointment.patientMobile,
            start: appointment.appointmentDateTime,
            backgroundColor: getStatusColor(appointment.status),
            borderColor: getStatusColor(appointment.status)
        }))
    });
    calendar.render();
}

function getStatusColor(status) {
    switch(status) {
        case 'SCHEDULED': return '#1976d2';
        case 'COMPLETED': return '#2e7d32';
        case 'CANCELLED': return '#c62828';
        case 'NO_SHOW': return '#ef6c00';
        default: return '#757575';
    }
}

function initializeStatusUpdates() {
    const modal = document.getElementById('statusUpdateModal');
    const confirmBtn = document.getElementById('confirmStatusUpdate');
    const cancelBtn = document.getElementById('cancelStatusUpdate');
    let currentAppointmentId = null;
    let currentNewStatus = null;

    // Handle status update button clicks
    document.querySelectorAll('.update-status').forEach(button => {
        button.addEventListener('click', function() {
            currentAppointmentId = this.dataset.id;
            currentNewStatus = this.dataset.status;
            
            const message = document.getElementById('statusUpdateMessage');
            if (currentNewStatus === 'COMPLETED') {
                message.innerHTML = 'Are you sure you want to mark this appointment as completed? ' +
                                  'Note: The patient must be registered to complete the appointment.';
            } else {
                message.innerHTML = `Are you sure you want to mark this appointment as ${currentNewStatus.toLowerCase()}?`;
            }
            
            modal.style.display = 'block';
        });
    });

    // Handle confirm button click
    confirmBtn.addEventListener('click', async function() {
        if (currentAppointmentId && currentNewStatus) {
            try {
                const response = await fetch(`/api/appointments/${currentAppointmentId}/status`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
                    },
                    body: JSON.stringify({ status: currentNewStatus })
                });

                if (response.ok) {
                    window.location.reload();
                } else {
                    const error = await response.json();
                    alert(error.message || 'Failed to update appointment status');
                }
            } catch (error) {
                alert('An error occurred while updating the appointment status');
            }
        }
        modal.style.display = 'none';
    });

    // Handle cancel button click
    cancelBtn.addEventListener('click', function() {
        modal.style.display = 'none';
    });

    // Close modal when clicking outside
    window.addEventListener('click', function(event) {
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    });
}

function filterAppointments(status) {
    const rows = document.querySelectorAll('.appointment-row');
    rows.forEach(row => {
        if (status === 'ALL' || row.dataset.status === status) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
} 