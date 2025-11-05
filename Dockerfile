# Use official Tomcat 9 with JDK 11 (lightweight and stable)
FROM tomcat:9-jdk11-openjdk-slim

# Metadata (optional but good practice)
LABEL maintainer="bayarmaa01 <b.bayarmaa0321@gmail.com>" \
      project="Learning Platform" \
      version="1.0.0"

# Remove default Tomcat applications to avoid clutter
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your built WAR file into Tomcat's webapps directory
COPY target/learning-platform.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat default port
EXPOSE 8080

# Health check to ensure container is alive
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# Start Tomcat server
CMD ["catalina.sh", "run"]
