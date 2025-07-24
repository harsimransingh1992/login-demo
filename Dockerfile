# Use OpenJDK 17 as base image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the Maven wrapper and pom.xml
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Make mvnw executable
RUN chmod +x mvnw

# Download dependencies (this layer will be cached if pom.xml doesn't change)
RUN ./mvnw dependency:go-offline -B

# Copy source code
COPY src src

# Build the application
RUN ./mvnw clean package -DskipTests

# Create a new stage for runtime
FROM tomcat:9-jdk17-openjdk-slim

# Install additional packages for JSP support and security
RUN apt-get update && apt-get install -y \
    libtcnative-1 \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Create non-root user for security
RUN groupadd -r tomcat && useradd -r -g tomcat tomcat

# Remove default Tomcat applications and unnecessary files
RUN rm -rf /usr/local/tomcat/webapps/* \
    && rm -rf /usr/local/tomcat/server/webapps/* \
    && rm -rf /usr/local/tomcat/conf/Catalina/localhost/*

# Copy the built WAR file to Tomcat webapps (using correct artifact name)
COPY --from=0 /app/target/peridesk.war /usr/local/tomcat/webapps/ROOT.war

# Use a non-standard port for security (8443 instead of 8080)
EXPOSE 8443

# Change Tomcat's default port from 8080 to 8443
RUN sed -i 's/port="8080"/port="8443"/' /usr/local/tomcat/conf/server.xml

# Add JSP configuration to web.xml if needed
RUN echo '<?xml version="1.0" encoding="UTF-8"?>' > /usr/local/tomcat/conf/web.xml && \
    echo '<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"' >> /usr/local/tomcat/conf/web.xml && \
    echo '         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' >> /usr/local/tomcat/conf/web.xml && \
    echo '         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"' >> /usr/local/tomcat/conf/web.xml && \
    echo '         version="4.0">' >> /usr/local/tomcat/conf/web.xml && \
    echo '    <servlet>' >> /usr/local/tomcat/conf/web.xml && \
    echo '        <servlet-name>jsp</servlet-name>' >> /usr/local/tomcat/conf/web.xml && \
    echo '        <servlet-class>org.apache.jasper.servlet.JspServlet</servlet-class>' >> /usr/local/tomcat/conf/web.xml && \
    echo '        <init-param>' >> /usr/local/tomcat/conf/web.xml && \
    echo '            <param-name>fork</param-name>' >> /usr/local/tomcat/conf/web.xml && \
    echo '            <param-value>false</param-value>' >> /usr/local/tomcat/conf/web.xml && \
    echo '        </init-param>' >> /usr/local/tomcat/conf/web.xml && \
    echo '        <init-param>' >> /usr/local/tomcat/conf/web.xml && \
    echo '            <param-name>xpoweredBy</param-name>' >> /usr/local/tomcat/conf/web.xml && \
    echo '            <param-value>false</param-value>' >> /usr/local/tomcat/conf/web.xml && \
    echo '        </init-param>' >> /usr/local/tomcat/conf/web.xml && \
    echo '        <load-on-startup>3</load-on-startup>' >> /usr/local/tomcat/conf/web.xml && \
    echo '    </servlet>' >> /usr/local/tomcat/conf/web.xml && \
    echo '    <servlet-mapping>' >> /usr/local/tomcat/conf/web.xml && \
    echo '        <servlet-name>jsp</servlet-name>' >> /usr/local/tomcat/conf/web.xml && \
    echo '        <url-pattern>*.jsp</url-pattern>' >> /usr/local/tomcat/conf/web.xml && \
    echo '    </servlet-mapping>' >> /usr/local/tomcat/conf/web.xml && \
    echo '    <!-- Security headers for Cloudflare compatibility -->' >> /usr/local/tomcat/conf/web.xml && \
    echo '    <filter>' >> /usr/local/tomcat/conf/web.xml && \
    echo '        <filter-name>SecurityHeadersFilter</filter-name>' >> /usr/local/tomcat/conf/web.xml && \
    echo '        <filter-class>org.apache.catalina.filters.HttpHeaderSecurityFilter</filter-class>' >> /usr/local/tomcat/conf/web.xml && \
    echo '        <init-param>' >> /usr/local/tomcat/conf/web.xml && \
    echo '            <param-name>antiClickJackingEnabled</param-name>' >> /usr/local/tomcat/conf/web.xml && \
    echo '            <param-value>true</param-value>' >> /usr/local/tomcat/conf/web.xml && \
    echo '        </init-param>' >> /usr/local/tomcat/conf/web.xml && \
    echo '        <init-param>' >> /usr/local/tomcat/conf/web.xml && \
    echo '            <param-name>antiClickJackingOption</param-name>' >> /usr/local/tomcat/conf/web.xml && \
    echo '            <param-value>DENY</param-value>' >> /usr/local/tomcat/conf/web.xml && \
    echo '        </init-param>' >> /usr/local/tomcat/conf/web.xml && \
    echo '    </filter>' >> /usr/local/tomcat/conf/web.xml && \
    echo '    <filter-mapping>' >> /usr/local/tomcat/conf/web.xml && \
    echo '        <filter-name>SecurityHeadersFilter</filter-name>' >> /usr/local/tomcat/conf/web.xml && \
    echo '        <url-pattern>/*</url-pattern>' >> /usr/local/tomcat/conf/web.xml && \
    echo '    </filter-mapping>' >> /usr/local/tomcat/conf/web.xml && \
    echo '</web-app>' >> /usr/local/tomcat/conf/web.xml

# Security hardening - remove server info
RUN sed -i 's/server="Apache-Coyote\/1.1"/server=""/' /usr/local/tomcat/conf/server.xml

# Set environment variables for production
ENV JAVA_OPTS="-Xms1g -Xmx2g -XX:+UseG1GC -XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -Djava.security.egd=file:/dev/./urandom -Dfile.encoding=UTF-8"
ENV CATALINA_OPTS="-Dorg.apache.catalina.connector.RECYCLE_FACADE_ON_PARSER_FAILURE=false"

# Create health check script
RUN echo '#!/bin/bash' > /usr/local/bin/healthcheck.sh && \
    echo 'curl -f http://localhost:8443/ || exit 1' >> /usr/local/bin/healthcheck.sh && \
    chmod +x /usr/local/bin/healthcheck.sh

# Set ownership to tomcat user
RUN chown -R tomcat:tomcat /usr/local/tomcat

# Switch to non-root user
USER tomcat

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD /usr/local/bin/healthcheck.sh

# Start Tomcat
CMD ["catalina.sh", "run"] 