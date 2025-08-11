// Color Code Component JavaScript

// Initialize color code functionality
function initializeColorCodeComponent() {
    // Initialize color code dropdown functionality
    initializeColorCodeDropdown();
    
    // Add click event listeners for color code elements
    addColorCodeClickListeners();
}

function initializeColorCodeDropdown() {
    // Close dropdown when clicking outside
    document.addEventListener('click', function(event) {
        const dropdown = document.getElementById('colorCodeDropdown');
        const clickableElements = document.querySelectorAll('.clickable-code');
        
        if (dropdown && !dropdown.contains(event.target) && 
            !Array.from(clickableElements).some(element => element.contains(event.target))) {
            hideColorCodeDropdown();
        }
    });
    
    // Close dropdown with Escape key
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            hideColorCodeDropdown();
        }
    });
}

function addColorCodeClickListeners() {
    // Add click listeners for all clickable color code elements (badge and strip)
    const clickableElements = document.querySelectorAll('.clickable-code');
    if (clickableElements && clickableElements.length > 0) {
        clickableElements.forEach(function(element) {
            element.addEventListener('click', function() {
                const patientId = this.getAttribute('data-patient-id');
                const colorCode = this.getAttribute('data-color-code');
                showColorCodeDropdown(patientId, colorCode);
            });
        });
    }
}

function showColorCodeDropdown(patientId, currentColorCode) {
    const dropdown = document.getElementById('colorCodeDropdown');
    const clickedElement = event.target.closest('.clickable-code');
    
    if (!dropdown || !clickedElement) {
        console.error('Color code dropdown elements not found');
        return;
    }
    
    // Position the dropdown relative to the clicked element
    const rect = clickedElement.getBoundingClientRect();
    dropdown.style.position = 'fixed';
    dropdown.style.top = (rect.bottom + 5) + 'px';
    dropdown.style.left = rect.left + 'px';
    
    // Update selected state
    document.querySelectorAll('.color-code-option').forEach(option => {
        option.classList.remove('selected');
        if (option.getAttribute('data-value') === currentColorCode) {
            option.classList.add('selected');
        }
    });
    
    // Add click handlers to options
    document.querySelectorAll('.color-code-option').forEach(option => {
        option.onclick = function() {
            const newColorCode = this.getAttribute('data-value');
            updatePatientColorCode(patientId, newColorCode);
        };
    });
    
    // Show the dropdown
    dropdown.classList.add('show');
}

function hideColorCodeDropdown() {
    const dropdown = document.getElementById('colorCodeDropdown');
    if (dropdown) {
        dropdown.classList.remove('show');
    }
}

function updatePatientColorCode(patientId, newColorCode) {
    // Show loading state for all clickable elements
    const clickableElements = document.querySelectorAll('.clickable-code');
    const originalStates = new Map();
    
    clickableElements.forEach(function(element) {
        if (element.classList.contains('patient-code-badge')) {
            // Store original text for badges
            originalStates.set(element, element.innerHTML);
            element.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
        } else if (element.classList.contains('color-code-strip')) {
            // Store original class for strips
            originalStates.set(element, element.className);
            element.classList.add('updating');
        }
    });
    
    // Prepare the request data
    const requestData = {
        colorCode: newColorCode
    };
    
    // Get context path
    const contextPath = window.location.pathname.split('/').slice(0, -4).join('/') || '';
    
    // Send AJAX request to update color code
    fetch(contextPath + '/patients/' + patientId + '/update-color-code', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').getAttribute('content')
        },
        body: JSON.stringify(requestData)
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            // Update the UI
            updateColorCodeDisplay(newColorCode);
            showNotification('Patient color code updated successfully!', false);
        } else {
            throw new Error(data.message || 'Failed to update color code');
        }
    })
    .catch(error => {
        console.error('Error updating color code:', error);
        showNotification('Failed to update color code: ' + error.message, true);
        // Restore original states
        originalStates.forEach(function(originalState, element) {
            if (element.classList.contains('patient-code-badge')) {
                element.innerHTML = originalState;
            } else if (element.classList.contains('color-code-strip')) {
                element.className = originalState;
            }
        });
    })
    .finally(() => {
        hideColorCodeDropdown();
        // Remove updating class from strips
        clickableElements.forEach(function(element) {
            if (element.classList.contains('color-code-strip')) {
                element.classList.remove('updating');
            }
        });
    });
}

function updateColorCodeDisplay(newColorCode) {
    const clickableElements = document.querySelectorAll('.clickable-code');
    const colorCodeStrips = document.querySelectorAll('.color-code-strip');
    
    const colorCodeMap = {
        'CODE_BLUE': { displayName: 'Code Blue', className: 'code-blue' },
        'CODE_YELLOW': { displayName: 'Code Yellow', className: 'code-yellow' },
        'NO_CODE': { displayName: 'No Code', className: 'no-code' }
    };
    
    const colorInfo = colorCodeMap[newColorCode];
    if (colorInfo) {
        // Update all clickable elements (badges and strips)
        clickableElements.forEach(function(element) {
            if (element.classList.contains('patient-code-badge')) {
                // Update badge
                element.className = 'patient-code-badge ' + colorInfo.className + ' clickable-code';
                element.innerHTML = colorInfo.displayName + ' <i class="fas fa-edit" style="margin-left: 5px; font-size: 0.8em;"></i>';
            } else if (element.classList.contains('color-code-strip')) {
                // Update strip
                element.className = 'color-code-strip ' + colorInfo.className + ' clickable-code';
            }
            element.setAttribute('data-color-code', newColorCode);
        });
        
        // Update all color code strips (including non-clickable ones)
        colorCodeStrips.forEach(function(strip) {
            if (!strip.classList.contains('clickable-code')) {
                strip.className = 'color-code-strip ' + colorInfo.className;
            }
        });
    }
}

// Simple notification function
function showNotification(message, isError = false) {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `notification ${isError ? 'error' : 'success'}`;
    notification.innerHTML = `
        <i class="fas ${isError ? 'fa-exclamation-circle' : 'fa-check-circle'}"></i>
        <span>${message}</span>
    `;
    
    // Add styles
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 12px 20px;
        border-radius: 8px;
        color: white;
        font-weight: 500;
        z-index: 10000;
        display: flex;
        align-items: center;
        gap: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        transition: all 0.3s ease;
        ${isError ? 'background-color: #dc3545;' : 'background-color: #28a745;'}
    `;
    
    // Add to page
    document.body.appendChild(notification);
    
    // Remove after 3 seconds
    setTimeout(() => {
        notification.style.opacity = '0';
        notification.style.transform = 'translateX(100%)';
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    }, 3000);
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeColorCodeComponent();
}); 