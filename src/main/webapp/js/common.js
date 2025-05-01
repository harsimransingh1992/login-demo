// src/main/webapp/js/common.js

async function checkIn(patientId) {
    try {
        const url = `${contextPath}/patients/checkin/${patientId}`;
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
            },
            credentials: 'same-origin'
        });

        if (response.ok) {
            window.location.reload(); // Reload page on successful check-in
        } else {
            console.error('Error response:', response.status, response.statusText);
        }
    } catch (error) {
        console.error('Request failed:', error);
    }
}

async function uncheck(patientId) {
    try {
        const url = `${contextPath}/patients/uncheck/${patientId}`;
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
            },
            credentials: 'same-origin'
        });

        if (response.ok) {
            window.location.reload(); // Reload page on successful check-out
        } else {
            console.error('Error response:', response.status, response.statusText);
        }
    } catch (error) {
        console.error('Request failed:', error);
    }
}