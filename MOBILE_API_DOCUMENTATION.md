# PeriDesk Mobile API Documentation

## Security Requirements

**Note:** The health check endpoint (`GET /api/mobile/health`) does not require any authentication or security headers.

All other mobile API endpoints require the following security headers:

### Required Headers:
- `X-API-Key`: Your API key (configured in application.properties)
- `X-Timestamp`: Current timestamp in ISO format with timezone (e.g., "2024-01-15T10:30:00.000Z")
- `X-Signature`: HMAC-SHA256 signature of the request

### Signature Generation:
The signature is generated using HMAC-SHA256 with the following formula:
```
signature = HMAC-SHA256(payload + timestamp + apiSecret)
```

Where:
- `payload`: Request body or key parameters concatenated
- `timestamp`: Same value as X-Timestamp header (ISO format with timezone, e.g., "2024-01-15T10:30:00.000Z")
- `apiSecret`: Your API secret (configured in application.properties)

### Security Features:
- **Rate Limiting**: 100 requests per 15 minutes per IP address
- **Account Lockout**: 5 failed login attempts locks account for 30 minutes
- **Timestamp Validation**: Requests older than 5 minutes are rejected
- **File Upload Validation**: Only image files up to 10MB are allowed
- **Access Control**: Users can only access their own examinations

## Base URL
```
http://localhost:8080/api/mobile
```

## Authentication
The mobile API uses username/password authentication. No JWT tokens are required for basic operations.

## Endpoints

### 0. Debug Configuration

**Endpoint:** `GET /api/mobile/debug`

**Description:** Check if API configuration is loaded correctly.

**Security:** No authentication required (public endpoint)

**Request Example:**
```bash
curl -X GET "http://localhost:8080/api/mobile/debug"
```

**Success Response (200):**
```json
{
  "apiKeySet": true,
  "apiSecretSet": true,
  "rateLimitRequests": 100,
  "rateLimitWindowMinutes": 15,
  "timestamp": "2024-01-15T10:30:00"
}
```

### 1. Test Endpoint

**Endpoint:** `GET /api/mobile/test`

**Description:** Simple test endpoint to verify the mobile API is accessible.

**Security:** No authentication required (public endpoint)

**Request Example:**
```bash
curl -X GET "http://localhost:8080/api/mobile/test"
```

**Success Response (200):**
```json
{
  "message": "Mobile API is working!",
  "timestamp": "2024-01-15T10:30:00"
}
```

### 2. Login Test (No Security Headers)

**Endpoint:** `POST /api/mobile/login-test`

**Description:** Test login without security headers (for debugging).

**Security:** No authentication required (public endpoint)

**Request Example:**
```bash
curl -X POST "http://localhost:8080/api/mobile/login-test" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "harsimran.singh",
    "password": "Dexter@123"
  }'
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Login test successful",
  "user": {
    "id": 1,
    "username": "harsimran.singh",
    "firstName": "Harsimran",
    "lastName": "Singh",
    "email": "harsimran@example.com",
    "role": "DOCTOR",
    "isActive": true
  },
  "timestamp": "2024-01-15T10:30:00"
}
```

### 3. Health Check

**Endpoint:** `GET /api/mobile/health`

**Description:** Check if the mobile API service is running and healthy.

**Security:** No authentication required (public endpoint)

**Request Example:**
```bash
curl -X GET "http://localhost:8080/api/mobile/health"
```

**Success Response (200):**
```json
{
  "status": "healthy",
  "timestamp": "2024-01-15T10:30:00",
  "service": "PeriDesk Mobile API",
  "version": "1.0.0",
  "environment": "production",
  "uptime": 1705312200000,
  "system": {
    "javaVersion": "17.0.1",
    "osName": "Linux",
    "availableMemory": 123456789,
    "totalMemory": 234567890
  }
}
```

**Error Response (500):**
```json
{
  "status": "unhealthy",
  "timestamp": "2024-01-15T10:30:00",
  "error": "Health check failed"
}
```

### 4. Login
**POST** `/login`

Authenticate a user with username and password.

**Request Body:**
```json
{
  "username": "doctor123",
  "password": "password123"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Login successful",
  "user": {
    "id": 1,
    "username": "doctor123",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com",
    "phoneNumber": "+1234567890",
    "role": "DOCTOR",
    "isActive": true,
    "clinic": {
      "id": 1,
      "name": "Dental Care Clinic",
      "clinicId": "DC001",
      "cityTier": "TIER1"
    },
    "specialization": "Orthodontist",
    "licenseNumber": "DENT123456",
    "qualification": "MDS",
    "designation": "Senior Orthodontist",
    "joiningDate": "2020-01-15"
  },
  "timestamp": "2024-01-15T10:30:00"
}
```

**Error Response (401):**
```json
{
  "success": false,
  "message": "Invalid username or password",
  "timestamp": "2024-01-15T10:30:00"
}
```

### 5. Get Examination Details
**POST** `/examination`

Get examination details by ID with access control. User must be the OPD doctor or assigned doctor, and examination must be from today.

**Request Body:**
```json
{
  "examinationId": 123,
  "username": "doctor123"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Examination found",
  "examination": {
    "id": 123,
    "examinationDate": "2024-01-15T10:30:00",
    "toothNumber": "UPPER_RIGHT_CENTRAL_INCISOR",
    "procedureStatus": "IN_PROGRESS",
    "patient": {
      "name": "John Doe",
      "registrationId": "P001",
      "phoneNumber": "+1234567890"
    },
    "assignedDoctor": {
      "name": "Dr. Jane Smith",
      "role": "Assigned Doctor"
    },
    "opdDoctor": {
      "name": "Dr. Mike Johnson",
      "role": "OPD Doctor"
    }
  },
  "timestamp": "2024-01-15T10:30:00"
}
```

**Error Response (403):**
```json
{
  "success": false,
  "message": "Access denied: You are not authorized to view this examination",
  "timestamp": "2024-01-15T10:30:00"
}
```

**Error Response (403):**
```json
{
  "success": false,
  "message": "Examination is not from today",
  "timestamp": "2024-01-15T10:30:00"
}
```

### 6. Get Examination Details

**Endpoint:** `POST /api/mobile/examination`

**Description:** Fetch examination details by ID after login verification.

**Request Parameters:**
- `examinationId` (Long, required): The ID of the examination to fetch
- `username` (String, required): The username of the logged-in user

**Request Example:**
```bash
curl -X POST "http://localhost:8080/api/mobile/examination" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: your-secure-api-key-here-change-in-production" \
  -H "X-Timestamp: 2024-01-15T10:30:00.000Z" \
  -H "X-Signature: generated-hmac-signature" \
  -d '{
    "examinationId": 123,
    "username": "doctor1"
  }'
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Examination details retrieved successfully",
  "data": {
    "examinationId": 123,
    "patientName": "John Doe",
    "patientAge": 35,
    "patientPhone": "+91-9876543210",
    "opdDoctorName": "Dr. Smith",
    "assignedDoctorName": "Dr. Johnson",
    "examinationDate": "2024-01-15T10:30:00",
    "chiefComplaints": "Tooth pain",
    "advised": "Root canal treatment"
  },
  "timestamp": "2024-01-15T10:30:00"
}
```

**Error Responses:**
- `400 Bad Request`: Missing required parameters
- `404 Not Found`: User or examination not found
- `403 Forbidden`: User not authorized or examination not from today
- `500 Internal Server Error`: Server error

### 7. Upload Images

**Endpoint:** `POST /api/mobile/upload-images`

**Description:** Upload images (denture pictures and X-ray) for an examination.

**Request Parameters:**
- `examinationId` (Long, required): The ID of the examination
- `username` (String, required): The username of the logged-in user
- `upperDentureImage` (MultipartFile, optional): Upper denture picture
- `lowerDentureImage` (MultipartFile, optional): Lower denture picture
- `xrayImage` (MultipartFile, optional): X-ray image

**Request Example:**
```bash
curl -X POST "http://localhost:8080/api/mobile/upload-images" \
  -H "X-API-Key: your-secure-api-key-here-change-in-production" \
  -H "X-Timestamp: 2024-01-15T10:30:00.000Z" \
  -H "X-Signature: generated-hmac-signature" \
  -F "examinationId=123" \
  -F "username=doctor1" \
  -F "upperDentureImage=@/path/to/upper-denture.jpg" \
  -F "lowerDentureImage=@/path/to/lower-denture.jpg" \
  -F "xrayImage=@/path/to/xray.jpg"
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Images uploaded successfully",
  "uploadedFiles": {
    "upperDentureImage": "upper-denture-550e8400-e29b-41d4-a716-446655440000.jpg",
    "lowerDentureImage": "lower-denture-550e8400-e29b-41d4-a716-446655440001.jpg",
    "xrayImage": "xray-550e8400-e29b-41d4-a716-446655440002.jpg"
  },
  "timestamp": "2024-01-15T10:30:00"
}
```