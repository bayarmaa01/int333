# ==========================
# 1️⃣ Build Stage (using Maven)
# ==========================
FROM maven:3.9.8-eclipse-temurin-11 AS build

# Set working directory
WORKDIR /app

# Copy only the pom.xml first to cache dependencies
COPY pom.xml .

# Download dependencies
#RUN mvn dependency:go-offline -B

# Copy the full source code
COPY src ./src

# Package the WAR file (skip tests for CI)
RUN mvn clean package -DskipTests

# ==========================
# 2️⃣ Runtime Stage (Tomcat)
# ==========================
FROM tomcat:9-jdk11-openjdk-slim

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file from build stage
COPY --from=build /app/target/learning-platform.war /usr/local/tomcat/webapps/learning-platform.war

# Expose port 8080
EXPOSE 8080

# Health check (used by Docker and Jenkins)
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost:8080/learning-platform/ || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"]
