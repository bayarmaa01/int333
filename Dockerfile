# Use Tomcat base image
FROM tomcat:9-jdk11-openjdk-slim

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file to Tomcat webapps
COPY target/learning-platform.war /usr/local/tomcat/webapps/learning-platform.war

# Expose port 8080
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8080/learning-platform/ || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"]