# Appointment Tracking - Export Report Feature

## Overview
Added export functionality to the appointment tracking page that allows users to download appointment data as a CSV file with all current filters applied.

## Changes Made

### 1. Frontend Changes (JSP)
**File:** `src/main/webapp/WEB-INF/views/receptionist/appointment-tracking.jsp`

#### Added Export Button
```html
<div class="form-group">
    <button type="button" class="btn btn-success" onclick="exportReport()">
        <i class="fas fa-download"></i>
        Export Report
    </button>
</div>
```

#### Added Export JavaScript Function
```javascript
function exportReport() {
    // Get current filter parameters
    const urlParams = new URLSearchParams(window.location.search);
    
    // Create export URL with current filters
    const exportUrl = '${pageContext.request.contextPath}/receptionist/appointments/tracking/export?' + urlParams.toString();
    
    // Create a temporary link and trigger download
    const link = document.createElement('a');
    link.href = exportUrl;
    link.download = 'appointment-tracking-report.csv';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}
```

### 2. Backend Changes (Controller)
**File:** `src/main/java/com/example/logindemo/controller/AppointmentTrackingController.java`

#### Added Export Endpoint
```java
@GetMapping("/tracking/export")
public void exportAppointmentReport(
        @RequestParam(required = false) String startDate,
        @RequestParam(required = false) String endDate,
        @RequestParam(required = false) String statusFilter,
        @RequestParam(defaultValue = "appointmentDateTime") String sort,
        @RequestParam(defaultValue = "desc") String direction,
        HttpServletResponse response
) throws IOException
```

#### Added Required Imports
```java
import java.io.IOException;
import javax.servlet.http.HttpServletResponse;
```

## Features

### Export Functionality
- **Format:** CSV (Comma Separated Values)
- **Filename:** `appointment-tracking-report.csv`
- **Content-Type:** `text/csv`
- **Download Method:** Direct browser download

### CSV Columns
1. **Patient Name** - Full name or "N/A" if not available
2. **Mobile Number** - Phone number from patient record or appointment
3. **Registration ID** - Patient registration code or "N/A" for walk-ins
4. **Appointment Date** - Formatted as DD/MM/YYYY
5. **Appointment Time** - Formatted as HH:MM AM/PM
6. **Doctor** - Doctor name with "Dr." prefix or "Unassigned"
7. **Status** - Appointment status (SCHEDULED, COMPLETED, etc.)
8. **Notes** - Follow-up notes or empty if none

### Filter Preservation
The export respects all current page filters:
- **Date Range:** Start date and end date
- **Status Filter:** Specific appointment status
- **Sort Order:** Appointment date/time sorting
- **Sort Direction:** Ascending or descending

### Data Handling
- **CSV Escaping:** Properly escapes quotes in notes and text fields
- **Date Formatting:** User-friendly date and time formats
- **Null Handling:** Graceful handling of missing data with "N/A" placeholders
- **Sorting:** Maintains the same sort order as the web interface

## Usage

### How to Export
1. Navigate to appointment tracking page
2. Apply desired filters (date range, status, etc.)
3. Click the "Export Report" button
4. CSV file will be automatically downloaded

### URL Pattern
```
GET /receptionist/appointments/tracking/export?startDate=2025-03-01&endDate=2025-09-10&statusFilter=COMPLETED&sort=appointmentDateTime&direction=desc
```

## Technical Implementation

### Frontend Flow
1. User clicks "Export Report" button
2. JavaScript captures current URL parameters
3. Creates export URL with same parameters
4. Triggers browser download via temporary link

### Backend Flow
1. Controller receives export request with filters
2. Fetches appointments using same logic as main page
3. Applies status filtering if specified
4. Sorts appointments according to parameters
5. Generates CSV content with proper formatting
6. Sets response headers for file download
7. Streams CSV content to browser

### Security
- **Authorization:** Requires RECEPTIONIST role
- **Clinic Isolation:** Only exports appointments from user's clinic
- **Parameter Validation:** Uses same validation as main tracking page

## Benefits
- ✅ Preserves all current filters and sorting
- ✅ Professional CSV format suitable for Excel/Google Sheets
- ✅ Handles all data types (dates, text, numbers)
- ✅ Proper escaping prevents CSV injection
- ✅ User-friendly filename and download experience
- ✅ Consistent with existing application security model