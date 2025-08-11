#!/bin/bash

# Cloudflare + Tomcat Deployment Script
# Optimized for image loading performance

echo "🚀 Deploying PeriDesk with Cloudflare + Tomcat Optimization"

# Configuration
APP_NAME="peridesk"
DEPLOY_DIR="/opt/peridesk"
LOG_DIR="/opt/peridesk/logs"
TOMCAT_VERSION="9.0"
JAVA_VERSION="17"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   exit 1
fi

print_status "Starting Cloudflare + Tomcat optimized deployment..."

# 1. Build the application
print_status "Building application with image optimization..."
./mvnw clean package -DskipTests

if [ $? -ne 0 ]; then
    print_error "Build failed"
    exit 1
fi

print_success "Application built successfully"

# 2. Create deployment directory
print_status "Setting up deployment directory..."
sudo mkdir -p $DEPLOY_DIR
sudo mkdir -p $LOG_DIR
sudo mkdir -p $DEPLOY_DIR/uploads
sudo mkdir -p $DEPLOY_DIR/static

# 3. Copy application files
print_status "Copying application files..."
sudo cp target/*.jar $DEPLOY_DIR/
sudo cp -r src/main/webapp/uploads/* $DEPLOY_DIR/uploads/ 2>/dev/null || true
sudo cp -r src/main/webapp/images/* $DEPLOY_DIR/static/ 2>/dev/null || true

# 4. Create systemd service file
print_status "Creating systemd service..."
sudo tee /etc/systemd/system/$APP_NAME.service > /dev/null <<EOF
[Unit]
Description=PeriDesk Application
After=network.target

[Service]
Type=simple
User=peridesk
WorkingDirectory=$DEPLOY_DIR
ExecStart=/usr/bin/java -Xms512m -Xmx2g -XX:+UseG1GC -XX:+UseStringDeduplication -jar *.jar
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=$APP_NAME

# Environment variables for optimization
Environment="SPRING_PROFILES_ACTIVE=production"
Environment="SERVER_TOMCAT_MAX_THREADS=200"
Environment="SERVER_TOMCAT_MIN_SPARE_THREADS=10"
Environment="SERVER_TOMCAT_ACCEPT_COUNT=100"

# Security settings
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ReadWritePaths=$DEPLOY_DIR

[Install]
WantedBy=multi-user.target
EOF

# 5. Create user for the application
print_status "Creating application user..."
sudo useradd -r -s /bin/false -d $DEPLOY_DIR peridesk 2>/dev/null || true
sudo chown -R peridesk:peridesk $DEPLOY_DIR

# 6. Configure Tomcat for Cloudflare
print_status "Configuring Tomcat for Cloudflare optimization..."

# Create application.properties for production
sudo tee $DEPLOY_DIR/application-prod.properties > /dev/null <<EOF
# Production Configuration for Cloudflare + Tomcat
server.port=8080
server.tomcat.max-threads=200
server.tomcat.min-spare-threads=10
server.tomcat.accept-count=100
server.tomcat.connection-timeout=20000
server.tomcat.max-connections=8192

# Image optimization settings
file.upload-dir=uploads
image.compression.enabled=true
image.compression.max-dimension=1200
image.compression.quality=0.85
image.cache.duration=86400

# Logging for production
logging.level.root=WARN
logging.level.com.example.logindemo=INFO
logging.file.name=logs/application.log
logging.file.max-size=100MB
logging.file.max-history=30

# Database configuration (update with your production DB)
spring.datasource.url=jdbc:mysql://localhost:3306/sdcdatab?useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=Dexter@2608
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA Configuration
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.format_sql=false

# Session configuration
server.servlet.session.timeout=180m
server.servlet.session.cookie.secure=true
server.servlet.session.cookie.http-only=true

# Security headers for Cloudflare
server.servlet.session.cookie.same-site=strict
EOF

# 7. Configure Nginx for Cloudflare (if using Nginx as reverse proxy)
print_status "Configuring Nginx for Cloudflare..."
sudo tee /etc/nginx/sites-available/peridesk-cloudflare > /dev/null <<EOF
server {
    listen 80;
    server_name your-domain.com;
    
    # Redirect HTTP to HTTPS (Cloudflare will handle SSL)
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name your-domain.com;
    
    # SSL configuration (Cloudflare will handle this)
    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    
    # Cloudflare specific headers
    add_header CF-Cache-Status \$upstream_http_cf_cache_status;
    add_header CF-Ray \$http_cf_ray;
    
    # Image optimization
    location ~* \.(jpg|jpeg|png|gif|ico|svg|webp)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        add_header Vary "Accept-Encoding";
        gzip_static on;
        gzip_vary on;
        gzip_min_length 1024;
        gzip_proxied any;
        gzip_comp_level 6;
        gzip_types
            image/svg+xml
            image/x-icon
            image/png
            image/jpeg
            image/gif
            image/webp;
    }
    
    # Uploads directory with Cloudflare optimization
    location /uploads/ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        add_header Vary "Accept-Encoding";
        gzip_static on;
        gzip_vary on;
        gzip_min_length 1024;
        gzip_proxied any;
        gzip_comp_level 6;
        gzip_types
            image/svg+xml
            image/x-icon
            image/png
            image/jpeg
            image/gif
            image/webp
            application/pdf;
    }
    
    # Static assets
    location /static/ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        add_header Vary "Accept-Encoding";
    }
    
    # Main application
    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_read_timeout 300;
        proxy_connect_timeout 300;
        proxy_send_timeout 300;
        
        # Cloudflare headers
        proxy_set_header CF-Connecting-IP \$http_cf_connecting_ip;
        proxy_set_header CF-Ray \$http_cf_ray;
        proxy_set_header CF-Visitor \$http_cf_visitor;
    }
    
    # Health check
    location /health {
        proxy_pass http://127.0.0.1:8080/actuator/health;
        access_log off;
        allow 127.0.0.1;
        deny all;
    }
}
EOF

# 8. Enable Nginx site
sudo ln -sf /etc/nginx/sites-available/peridesk-cloudflare /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# 9. Start the application
print_status "Starting application service..."
sudo systemctl daemon-reload
sudo systemctl enable $APP_NAME
sudo systemctl start $APP_NAME

# 10. Wait for application to start
print_status "Waiting for application to start..."
sleep 10

# Check if application is running
if sudo systemctl is-active --quiet $APP_NAME; then
    print_success "Application started successfully"
else
    print_error "Application failed to start"
    sudo systemctl status $APP_NAME
    exit 1
fi

# 11. Cloudflare optimization checklist
print_status "Cloudflare Optimization Checklist:"
echo "✅ Application deployed with image optimization"
echo "✅ Tomcat configured for high performance"
echo "✅ Nginx configured for Cloudflare"
echo ""
echo "📋 Next steps in Cloudflare Dashboard:"
echo "1. Go to Page Rules and create rules for:"
echo "   - yourdomain.com/uploads/* (Cache Everything, 1 year TTL)"
echo "   - yourdomain.com/images/* (Cache Everything, 1 year TTL)"
echo "2. Enable Speed optimizations:"
echo "   - Auto Minify: CSS, JavaScript, HTML"
echo "   - Rocket Loader: On"
echo "   - Brotli: On"
echo "   - HTTP/3: On"
echo "3. Enable Caching:"
echo "   - Always Online: On"
echo "   - Browser Cache TTL: 1 year"
echo "4. Monitor performance in Analytics tab"

print_success "Deployment completed successfully!"
print_status "Application URL: https://your-domain.com"
print_status "Health Check: https://your-domain.com/health" 