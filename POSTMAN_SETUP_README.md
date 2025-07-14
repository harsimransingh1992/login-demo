# PeriDesk Mobile API - Postman Collection

This repository contains a complete Postman collection for testing the PeriDesk Mobile API endpoints.

## Files Included

1. **`PeriDesk_Mobile_API.postman_collection.json`** - Main collection with all API endpoints
2. **`PeriDesk_Mobile_API.postman_environment.json`** - Environment variables for local development
3. **`POSTMAN_SETUP_README.md`** - This setup guide

## Setup Instructions

### 1. Import Collection and Environment

1. Open Postman
2. Click **Import** button
3. Import both files:
   - `PeriDesk_Mobile_API.postman_collection.json`
   - `PeriDesk_Mobile_API.postman_environment.json`

### 2. Configure Environment Variables

1. Select the **"PeriDesk Mobile API - Local"** environment from the dropdown
2. Update the following variables:

#### Required Variables:
- **`baseUrl`**: Your API base URL (default: `http://localhost:8080`)
- **`apiKey`**: Your API key from `application.properties`
- **`apiSecret`**: Your API secret from `application.properties`

#### Optional Variables:
- **`username`**: Your test username (default: `harsimran.singh`)
- **`password`**: Your test password (default: `Dexter@123`)
- **`examinationId`**: Test examination ID (default: `1`)

### 3. Update API Configuration

Make sure your `application.properties` has the correct values:

```properties
# Mobile API Security Configuration
api.key=your-secure-api-key-here-change-in-production
api.secret=your-secure-api-secret-here-change-in-production
api.rate.limit.requests=100
api.rate.limit.window.minutes=15
```

## Collection Structure

### 1. Debug & Test Endpoints
- **Debug Configuration**: Check if API configuration is loaded
- **Test Endpoint**: Basic connectivity test
- **Health Check**: Service health status
- **Login Test (No Security)**: Test login without security headers

### 2. Authentication
- **Login**: Full login with security headers (API key, timestamp, signature)

### 3. Examination Management
- **Get Examination Details**: Fetch examination by ID with security

### 4. File Upload
- **Upload Images**: Upload denture and X-ray images

## Features

### Automatic Security Headers
The collection automatically generates:
- **X-API-Key**: From environment variable
- **X-Timestamp**: Current ISO timestamp with timezone
- **X-Signature**: HMAC-SHA256 signature

### Pre-request Scripts
Each secured endpoint includes pre-request scripts that:
1. Generate current timestamp
2. Create HMAC signature
3. Add required headers automatically

### Response Validation
Global test scripts validate:
- Response status codes
- JSON response format
- Common response structure
- Error handling

## Testing Workflow

### 1. Start with Debug Endpoints
1. Run **Debug Configuration** to verify API setup
2. Run **Test Endpoint** to check connectivity
3. Run **Health Check** to verify service status

### 2. Test Authentication
1. Run **Login Test (No Security)** to verify credentials
2. Run **Login** with security headers to test full authentication

### 3. Test Business Logic
1. Run **Get Examination Details** to test examination access
2. Run **Upload Images** to test file upload functionality

## Troubleshooting

### Common Issues

1. **401 Unauthorized**
   - Check `apiKey` and `apiSecret` values
   - Verify timestamp is current (within 5 minutes)
   - Ensure signature is generated correctly

2. **429 Too Many Requests**
   - Wait for rate limit to reset (15 minutes)
   - Reduce request frequency

3. **403 Forbidden**
   - Check user permissions
   - Verify examination belongs to user
   - Ensure examination is from today

4. **500 Internal Server Error**
   - Check server logs
   - Verify API configuration
   - Test with debug endpoints first

### Debug Steps

1. **Check Environment Variables**
   ```javascript
   console.log('API Key:', pm.environment.get('apiKey'));
   console.log('API Secret:', pm.environment.get('apiSecret'));
   ```

2. **Verify Request Headers**
   - Open Postman Console (View → Show Postman Console)
   - Check pre-request script logs
   - Verify headers are being set correctly

3. **Test Signature Generation**
   - Use the debug endpoint to verify configuration
   - Check timestamp format matches expected format

4. **Signature Generation Troubleshooting**
   - **Use the "Test Signature Generation" endpoint** to verify your signature algorithm
   - Check Postman Console for detailed signature generation logs
   - Verify the signature format: `HMAC-SHA256(payload + timestamp + apiSecret)`
   - Ensure your API secret matches exactly what's in `application.properties`
   - Check that the timestamp format includes timezone: `2025-07-01T11:40:06.000Z`

5. **Common Signature Issues**
   - **Wrong API Secret**: Ensure it matches exactly with `application.properties`
   - **Wrong Timestamp Format**: Must include timezone (e.g., `.000Z`)
   - **Wrong Payload**: For login, payload should be `username + password` (no JSON formatting)
   - **Wrong Algorithm**: Must use HMAC-SHA256, not SHA256
   - **Wrong Data Concatenation**: Must be `payload + timestamp + apiSecret` (no separators)

## Security Notes

- **API Key and Secret**: Store these securely, never commit to version control
- **Environment Variables**: Use different environments for different environments (dev, staging, prod)
- **Request Logging**: Be careful with sensitive data in logs
- **Rate Limiting**: Respect API rate limits in testing

## Environment Variables Reference

| Variable | Type | Description | Example |
|----------|------|-------------|---------|
| `baseUrl` | string | API base URL | `http://localhost:8080` |
| `apiKey` | secret | API key for authentication | `your-api-key` |
| `apiSecret` | secret | API secret for signature generation | `your-api-secret` |
| `username` | string | Test username | `harsimran.singh` |
| `password` | secret | Test password | `Dexter@123` |
| `examinationId` | number | Test examination ID | `1` |
| `timestamp` | string | Generated timestamp | Auto-generated |
| `signature` | string | Generated signature | Auto-generated |

## API Endpoints Reference

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/mobile/debug` | Debug configuration | No |
| GET | `/api/mobile/test` | Test connectivity | No |
| GET | `/api/mobile/health` | Health check | No |
| POST | `/api/mobile/login-test` | Login without security | No |
| POST | `/api/mobile/login` | Login with security | Yes |
| POST | `/api/mobile/examination` | Get examination details | Yes |
| POST | `/api/mobile/upload-images` | Upload images | Yes |

## Support

For issues with the API:
1. Check the server logs
2. Use debug endpoints first
3. Verify environment configuration
4. Test with curl commands from the API documentation

For issues with the Postman collection:
1. Check environment variables
2. Verify pre-request scripts
3. Check Postman console for errors
4. Ensure CryptoJS is available for signature generation 