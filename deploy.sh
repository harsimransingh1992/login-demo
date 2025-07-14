#!/bin/bash

# Build the application
echo "Building the application..."
./mvnw clean package -DskipTests

# Check if build was successful
if [ $? -ne 0 ]; then
    echo "Build failed. Exiting..."
    exit 1
fi

# Deploy to Elastic Beanstalk
echo "Deploying to Elastic Beanstalk..."
eb deploy

# Check if deployment was successful
if [ $? -ne 0 ]; then
    echo "Deployment failed. Exiting..."
    exit 1
fi

echo "Deployment completed successfully!" 