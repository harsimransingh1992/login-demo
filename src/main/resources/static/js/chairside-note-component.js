// Chairside Note Component JavaScript

// Chairside Note Functions
function openChairsideNoteModal() {
    console.log('openChairsideNoteModal called');
    const modal = document.getElementById('chairsideNoteModal');
    console.log('Modal element found:', !!modal);
    
    if (modal) {
        // Reset all hide states to ensure modal can be shown
        modal.style.display = 'block';
        modal.style.visibility = 'visible';
        modal.style.opacity = '1';
        modal.classList.remove('hidden');
        modal.classList.add('show');
        
        console.log('Modal opened successfully');
        
        // Focus on the textarea
        const textarea = document.getElementById('chairsideNoteText');
        if (textarea) {
            textarea.focus();
        }
        
        // Disable body scroll when modal is open
        document.body.style.overflow = 'hidden';
    } else {
        console.error('Modal element not found');
    }
}

function closeChairsideNoteModal() {
    console.log('closeChairsideNoteModal called');
    const modal = document.getElementById('chairsideNoteModal');
    console.log('Modal element found:', !!modal);
    if (modal) {
        // Use a simpler approach - just hide with display none
        modal.style.display = 'none';
        modal.classList.remove('show');
        console.log('Modal hidden');
        
        // Enable body scroll
        document.body.style.overflow = 'auto';
    } else {
        console.error('Modal element not found');
    }
}

function saveChairsideNote() {
    const textarea = document.getElementById('chairsideNoteText');
    const noteText = textarea ? textarea.value.trim() : '';
    
    // Update the FAB indicator based on content
    updateFabIndicator(noteText);
    
    // Get patient ID from the page URL
    const pathParts = window.location.pathname.split('/');
    let patientId;
    
    // Handle different URL patterns
    if (pathParts.includes('examination')) {
        // For examination pages, we need to get patient ID from the examination
        patientId = getPatientIdFromExamination();
        
        // If still not found, try to get from the clinical-info-layout div
        if (!patientId) {
            const clinicalLayout = document.querySelector('.clinical-info-layout');
            if (clinicalLayout) {
                patientId = clinicalLayout.getAttribute('data-patient-id');
                console.log('Found patient ID from clinical-info-layout:', patientId);
            }
        }
    } else {
        // For patient details pages
        patientId = pathParts[pathParts.length - 1];
    }
    
    if (!patientId) {
        showChairsideNoteNotification('Could not determine patient ID', true);
        return;
    }
    
    console.log('Using patient ID for save:', patientId);
    
    // Show loading state
    const saveBtn = document.querySelector('.chairside-note-modal-footer .btn-primary');
    if (!saveBtn) {
        console.error('Save button not found');
        showChairsideNoteNotification('Save button not found', true);
        return;
    }
    
    const originalText = saveBtn.innerHTML;
    saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
    saveBtn.disabled = true;
    
    // Prepare request data
    const requestData = {
        chairsideNote: noteText
    };
    
    // Send AJAX request
    const url = '/patients/' + patientId + '/update-chairside-note';
    console.log('Sending request to:', url);
    console.log('Request data:', requestData);
    
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').getAttribute('content')
        },
        body: JSON.stringify(requestData)
    })
    .then(response => {
        console.log('Response status:', response.status);
        console.log('Response ok:', response.ok);
        
        if (!response.ok) {
            return response.text().then(text => {
                console.error('Error response text:', text);
                throw new Error(`HTTP ${response.status}: ${text}`);
            });
        }
        return response.json();
    })
    .then(data => {
        console.log('Save response received:', data);
        if (data.success) {
            showChairsideNoteNotification('Hand over note saved successfully!', false);
            console.log('About to close modal after successful save');
            
            // Clear the textarea after successful save
            if (textarea) {
                textarea.value = '';
            }
            
            // Update the history display with the server response
            if (data.updatedNotes) {
                updateChairsideNoteHistoryFromServer(data.updatedNotes);
            }
            
            // Update FAB indicator
            updateFabIndicator('');
            
            // Add a small delay to ensure the notification is shown before closing
            setTimeout(() => {
                closeChairsideNoteModal();
                console.log('Modal close function called');
            }, 500);
        } else {
            throw new Error(data.message || 'Failed to save chairside note');
        }
    })
    .catch(error => {
        console.error('Error saving chairside note:', error);
        showChairsideNoteNotification('Failed to save chairside note: ' + error.message, true);
    })
    .finally(() => {
        // Restore button state
        saveBtn.innerHTML = originalText;
        saveBtn.disabled = false;
    });
}

function clearChairsideNote() {
    // Show confirmation dialog
    if (!confirm('Are you sure you want to clear the chairside note? This action cannot be undone.')) {
        return;
    }
    
    const textarea = document.getElementById('chairsideNoteText');
    if (textarea) {
        textarea.value = '';
        // Update the FAB indicator since content is cleared
        updateFabIndicator('');
    }
    
    // Get patient ID from the page URL
    const pathParts = window.location.pathname.split('/');
    let patientId;
    
    // Handle different URL patterns
    if (pathParts.includes('examination')) {
        // For examination pages, we need to get patient ID from the examination
        patientId = getPatientIdFromExamination();
    } else {
        // For patient details pages
        patientId = pathParts[pathParts.length - 1];
    }
    
    if (!patientId) {
        showChairsideNoteNotification('Could not determine patient ID', true);
        return;
    }
    
    // Show loading state
    const clearBtn = document.querySelector('.chairside-note-modal-footer .btn-danger');
    const originalText = clearBtn.innerHTML;
    clearBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Clearing...';
    clearBtn.disabled = true;
    
    // Prepare request data
    const requestData = {
        chairsideNote: ''
    };
    
    // Send AJAX request to clear the note
    fetch('/patients/' + patientId + '/update-chairside-note', {
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
        console.log('Clear response received:', data);
        if (data.success) {
            showChairsideNoteNotification('Hand over note cleared successfully!', false);
            console.log('About to close modal after successful clear');
            
            // Update the history display to show empty state
            updateChairsideNoteHistoryFromServer('');
            
            // Update FAB indicator
            updateFabIndicator('');
            
            // Add a small delay to ensure the notification is shown before closing
            setTimeout(() => {
                closeChairsideNoteModal();
                console.log('Modal close function called');
            }, 500);
        } else {
            throw new Error(data.message || 'Failed to clear chairside note');
        }
    })
    .catch(error => {
        console.error('Error clearing chairside note:', error);
        showChairsideNoteNotification('Failed to clear chairside note: ' + error.message, true);
    })
    .finally(() => {
        // Restore button state
        clearBtn.innerHTML = originalText;
        clearBtn.disabled = false;
    });
}

// Helper function to get patient ID from examination page
function getPatientIdFromExamination() {
    console.log('getPatientIdFromExamination called');
    
    // Try to get patient ID from a data attribute or hidden field
    const patientIdElement = document.querySelector('[data-patient-id]');
    if (patientIdElement) {
        const patientId = patientIdElement.getAttribute('data-patient-id');
        console.log('Found patient ID from data attribute:', patientId);
        return patientId;
    }
    
    // Try to get from examination data if available
    if (typeof examinationData !== 'undefined' && examinationData.patientId) {
        console.log('Found patient ID from examinationData:', examinationData.patientId);
        return examinationData.patientId;
    }
    
    // Try to extract from URL if it contains patient information
    const urlParams = new URLSearchParams(window.location.search);
    const patientId = urlParams.get('patientId');
    if (patientId) {
        console.log('Found patient ID from URL params:', patientId);
        return patientId;
    }
    
    // Try to extract from the URL path (for examination pages like /patients/examination/54/lifecycle)
    const pathParts = window.location.pathname.split('/');
    console.log('URL path parts:', pathParts);
    
    // Look for examination ID and try to get patient ID from it
    const examinationIndex = pathParts.indexOf('examination');
    if (examinationIndex !== -1 && pathParts[examinationIndex + 1]) {
        const examinationId = pathParts[examinationIndex + 1];
        console.log('Found examination ID from URL:', examinationId);
        
        // Try to get patient ID from examination data on the page
        const examinationDataElement = document.querySelector('[data-examination-id="' + examinationId + '"]');
        if (examinationDataElement) {
            const patientId = examinationDataElement.getAttribute('data-patient-id');
            if (patientId) {
                console.log('Found patient ID from examination element:', patientId);
                return patientId;
            }
        }
        
        // Try to get from global examination data
        if (typeof window.examinationData !== 'undefined' && window.examinationData.patientId) {
            console.log('Found patient ID from window.examinationData:', window.examinationData.patientId);
            return window.examinationData.patientId;
        }
    }
    
    // As a fallback, try to get from the page content
    const patientInfoElement = document.querySelector('.patient-info, .examination-info, .patient-details');
    if (patientInfoElement) {
        const patientIdMatch = patientInfoElement.textContent.match(/Patient ID[:\s]*(\d+)/i);
        if (patientIdMatch) {
            console.log('Found patient ID from page content:', patientIdMatch[1]);
            return patientIdMatch[1];
        }
    }
    
    console.log('Could not find patient ID');
    return null;
}

// Simple notification function for chairside note component
function showChairsideNoteNotification(message, isError = false) {
    
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

// Function to update FAB indicator based on note content
function updateFabIndicator(noteText) {
    const fab = document.getElementById('chairsideNoteFab');
    if (!fab) return;
    
    let indicator = fab.querySelector('.fab-indicator');
    
    // Check if there are any existing chairside notes (from the server)
    const existingNotes = document.querySelector('.notes-history');
    const hasExistingNotes = existingNotes && existingNotes.textContent.trim() !== '';
    
    if ((noteText && noteText.trim() !== '') || hasExistingNotes) {
        // Show indicator if there's content in textarea OR existing notes
        if (!indicator) {
            indicator = document.createElement('div');
            indicator.className = 'fab-indicator';
            fab.appendChild(indicator);
        }
    } else {
        // Remove indicator if no content
        if (indicator) {
            indicator.remove();
        }
    }
}

// Function to update the chairside note history display from server response
function updateChairsideNoteHistoryFromServer(updatedNotes) {
    // Find the history container
    let historyContainer = document.querySelector('.notes-history');
    
    if (!historyContainer) {
        // If history container doesn't exist, create it
        const historySection = document.querySelector('.chairside-note-modal-body');
        if (historySection) {
            // Create the history section
            const historyDiv = document.createElement('div');
            historyDiv.className = 'form-group';
            historyDiv.style.marginTop = '20px';
            
            historyDiv.innerHTML = `
                <label>Hand Over Notes History</label>
                <div class="notes-history" style="background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 15px; max-height: 300px; overflow-y: auto; font-family: 'Courier New', monospace; font-size: 12px; white-space: pre-wrap; line-height: 1.4; color: #495057;">
                    ${updatedNotes}
                </div>
            `;
            
            historySection.appendChild(historyDiv);
        }
    } else {
        // Update existing history with the complete updated notes from server
        historyContainer.textContent = updatedNotes;
    }
}

// Initialize chairside note functionality
function initializeChairsideNoteComponent() {
    console.log('Initializing chairside note component');
    
    // Close chairside note modal when clicking outside
    const chairsideNoteModal = document.getElementById('chairsideNoteModal');
    console.log('Chairside note modal found:', !!chairsideNoteModal);
    
    if (chairsideNoteModal) {
        window.addEventListener('click', function(event) {
            if (event.target === chairsideNoteModal) {
                console.log('Clicked outside modal, closing');
                closeChairsideNoteModal();
            }
        });
    }
    
    // Close modal with Escape key
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            console.log('Escape key pressed, closing modal');
            closeChairsideNoteModal();
        }
    });
    
    // Add real-time monitoring of textarea content
    const textarea = document.getElementById('chairsideNoteText');
    if (textarea) {
        console.log('Textarea found, setting up monitoring');
        // Initial check - check for existing notes on page load
        updateFabIndicator('');
        
        // Monitor changes
        textarea.addEventListener('input', function() {
            updateFabIndicator(this.value);
        });
    } else {
        console.log('Textarea not found');
    }
    
    // Test if close button works
    const closeButton = document.querySelector('.chairside-note-modal-close');
    if (closeButton) {
        console.log('Close button found, adding click listener');
        closeButton.addEventListener('click', function(e) {
            console.log('Close button clicked');
            e.preventDefault();
            e.stopPropagation();
            closeChairsideNoteModal();
        });
    } else {
        console.log('Close button not found');
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeChairsideNoteComponent();
}); 