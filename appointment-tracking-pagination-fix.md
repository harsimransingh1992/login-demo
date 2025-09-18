# Appointment Tracking - Pagination Fix and "All" Option

## Issues Fixed

### 1. Missing `changePageSize` Function
**Problem:** JavaScript error `Uncaught ReferenceError: changePageSize is not defined`
**Cause:** The function was commented out but still referenced in the HTML dropdown

### 2. Added "All" Option to Page Size Dropdown
**Enhancement:** Users can now view all records on a single page

## Changes Made

### 1. Fixed JavaScript Function
**File:** `src/main/webapp/WEB-INF/views/receptionist/appointment-tracking.jsp`

#### Uncommented and Updated `changePageSize` Function
```javascript
function changePageSize(size) {
    // Get current URL parameters
    const urlParams = new URLSearchParams(window.location.search);
    
    // Handle "all" option by setting a very large page size
    if (size === 'all') {
        urlParams.set('pageSize', '10000');
    } else {
        urlParams.set('pageSize', size);
    }
    
    // Reset to first page
    urlParams.set('page', '0');
    
    // Redirect to the same page with updated parameters
    window.location.href = window.location.pathname + '?' + urlParams.toString();
}
```

### 2. Enhanced Page Size Dropdown
```html
<select id="pageSize" onchange="changePageSize(this.value)">
    <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
    <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
    <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
    <option value="100" ${pageSize == 100 ? 'selected' : ''}>100</option>
    <option value="all" ${pageSize == 'all' || pageSize > 1000 ? 'selected' : ''}>All</option>
</select>
```

## Functionality

### Page Size Options
- **10, 20, 50, 100:** Standard pagination sizes
- **All:** Shows all records on a single page (implemented as pageSize=10000)

### How It Works
1. **Standard Sizes:** Direct parameter passing to server
2. **"All" Option:** Converts to pageSize=10000 on the server side
3. **URL Preservation:** Maintains all other filter parameters (startDate, endDate, statusFilter, sort, direction)
4. **Page Reset:** Always resets to page 0 when changing page size

### Server-Side Handling
- **Controller:** `AppointmentTrackingController.java`
- **Parameter:** `@RequestParam(defaultValue = "10") int pageSize`
- **Pagination:** Uses Spring Data's `PageRequest.of(page, pageSize, sortObj)`

## Testing

### URL to Test
`http://localhost:8080/receptionist/appointments/tracking?startDate=2025-03-01&endDate=2025-09-10&statusFilter=`

### Test Cases
1. **Standard Page Sizes:**
   - Select 10, 20, 50, or 100 records
   - Verify pagination controls work correctly
   - Check that URL parameters are preserved

2. **"All" Option:**
   - Select "All" from dropdown
   - Verify all records are displayed on single page
   - Check that pagination controls are hidden/disabled when showing all records
   - Confirm URL shows pageSize=10000

3. **Parameter Preservation:**
   - Change page size while filters are active
   - Verify startDate, endDate, statusFilter, sort, and direction are maintained
   - Confirm page resets to 0

### Expected Behavior
- ✅ No more JavaScript errors
- ✅ Page size dropdown works correctly
- ✅ "All" option displays all records
- ✅ URL parameters are preserved during page size changes
- ✅ Smooth user experience without page refresh issues

## Technical Notes
- Uses `URLSearchParams` for clean URL parameter manipulation
- Server-side pagination remains unchanged
- Large page size (10000) used for "All" option to handle reasonable data volumes
- Maintains backward compatibility with existing functionality