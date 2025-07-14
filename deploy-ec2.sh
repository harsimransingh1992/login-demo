#!/bin/bash

# Configuration
EC2_HOST="your-ec2-host"
EC2_USER="ec2-user"
APP_NAME="peri-desk"
JAR_FILE="target/login-demo-0.0.1-SNAPSHOT.jar"
DEPLOY_DIR="/opt/$APP_NAME"
LOG_DIR="/var/log/$APP_NAME"
CONFIG_DIR="/etc/$APP_NAME"
SSL_DIR="/etc/ssl/$APP_NAME"

# Build the application
echo "Building the application..."
./mvnw clean package -DskipTests

# Check if build was successful
if [ $? -ne 0 ]; then
    echo "Build failed. Exiting..."
    exit 1
fi

# Create deployment directories on EC2
ssh $EC2_USER@$EC2_HOST "sudo mkdir -p $DEPLOY_DIR $LOG_DIR $CONFIG_DIR $SSL_DIR && sudo chown -R $EC2_USER:$EC2_USER $DEPLOY_DIR $LOG_DIR $CONFIG_DIR $SSL_DIR"

# Copy the JAR file to EC2
echo "Copying JAR file to EC2..."
scp $JAR_FILE $EC2_USER@$EC2_HOST:$DEPLOY_DIR/

# Create SSL directory and copy SSL certificates
echo "Setting up SSL certificates..."
ssh $EC2_USER@$EC2_HOST "sudo mkdir -p $SSL_DIR && sudo chown -R $EC2_USER:$EC2_USER $SSL_DIR"
scp ssl/keystore.p12 $EC2_USER@$EC2_HOST:$SSL_DIR/

# Create systemd service file with enhanced configuration
cat << EOF | ssh $EC2_USER@$EC2_HOST "sudo tee /etc/systemd/system/$APP_NAME.service"
[Unit]
Description=PeriDesk Application
After=network.target mysql.service
Wants=mysql.service

[Service]
User=$EC2_USER
WorkingDirectory=$DEPLOY_DIR
ExecStart=/usr/bin/java \
    -Xms512m \
    -Xmx1024m \
    -XX:+UseG1GC \
    -XX:MaxGCPauseMillis=200 \
    -XX:+HeapDumpOnOutOfMemoryError \
    -XX:HeapDumpPath=$LOG_DIR/heapdump.hprof \
    -XX:+UseStringDeduplication \
    -XX:+DisableExplicitGC \
    -Djava.security.egd=file:/dev/./urandom \
    -jar $DEPLOY_DIR/$(basename $JAR_FILE) \
    --spring.profiles.active=prod
SuccessExitStatus=143
Restart=always
RestartSec=5
TimeoutStartSec=300
TimeoutStopSec=300

# Environment variables
Environment="RDS_URL=jdbc:mysql://your-rds-endpoint:3306/peridesk"
Environment="RDS_USERNAME=admin"
Environment="RDS_PASSWORD=your-password"
Environment="ADMIN_USERNAME=admin"
Environment="ADMIN_PASSWORD=your-admin-password"
Environment="SSL_KEYSTORE_PATH=$SSL_DIR/keystore.p12"
Environment="SSL_KEYSTORE_PASSWORD=your-keystore-password"
Environment="SSL_KEY_ALIAS=peri-desk"

# Security
NoNewPrivileges=yes
ProtectSystem=full
ProtectHome=yes
PrivateTmp=yes
CapabilityBoundingSet=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
EOF

# Create logrotate configuration
cat << EOF | ssh $EC2_USER@$EC2_HOST "sudo tee /etc/logrotate.d/$APP_NAME"
$LOG_DIR/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 0640 $EC2_USER $EC2_USER
    sharedscripts
    postrotate
        systemctl reload $APP_NAME
    endscript
}
EOF

# Create Nginx configuration
cat << EOF | ssh $EC2_USER@$EC2_HOST "sudo tee /etc/nginx/conf.d/$APP_NAME.conf"
upstream peri_desk_backend {
    server 127.0.0.1:8080;
    keepalive 32;
}

server {
    listen 80;
    server_name your-domain.com;
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name your-domain.com;

    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:50m;
    ssl_session_tickets off;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_stapling on;
    ssl_stapling_verify on;
    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 5s;
    add_header Strict-Transport-Security "max-age=63072000" always;

    location / {
        proxy_pass http://peri_desk_backend;
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
    }

    location /static/ {
        alias $DEPLOY_DIR/static/;
        expires 30d;
        add_header Cache-Control "public, no-transform";
    }

    location /health {
        proxy_pass http://peri_desk_backend/actuator/health;
        access_log off;
        allow 127.0.0.1;
        deny all;
    }
}
EOF

# Install required packages
ssh $EC2_USER@$EC2_HOST "sudo yum update -y && \
    sudo yum install -y java-17-amazon-corretto nginx certbot python3-certbot-nginx"

# Set up SSL with Let's Encrypt
ssh $EC2_USER@$EC2_HOST "sudo certbot --nginx -d your-domain.com --non-interactive --agree-tos --email your-email@example.com"

# Reload systemd and restart services
ssh $EC2_USER@$EC2_HOST "sudo systemctl daemon-reload && \
    sudo systemctl restart $APP_NAME && \
    sudo systemctl restart nginx && \
    sudo systemctl enable $APP_NAME && \
    sudo systemctl enable nginx"

# Set up CloudWatch agent
cat << EOF | ssh $EC2_USER@$EC2_HOST "sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json"
{
    "agent": {
        "metrics_collection_interval": 60,
        "run_as_user": "root"
    },
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "$LOG_DIR/application.log",
                        "log_group_name": "/peri-desk/application",
                        "log_stream_name": "{instance_id}",
                        "timezone": "UTC"
                    }
                ]
            }
        }
    },
    "metrics": {
        "metrics_collected": {
            "mem": {
                "measurement": ["mem_used_percent"]
            },
            "swap": {
                "measurement": ["swap_used_percent"]
            },
            "disk": {
                "measurement": ["disk_used_percent"],
                "resources": ["/"]
            }
        }
    }
}
EOF

# Start CloudWatch agent
ssh $EC2_USER@$EC2_HOST "sudo systemctl start amazon-cloudwatch-agent && \
    sudo systemctl enable amazon-cloudwatch-agent"

echo "Deployment completed successfully!" 