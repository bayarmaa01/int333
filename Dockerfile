# ==========================
# 1️⃣ Build Stage (Maven)
# ==========================
FROM maven:3.9.8-eclipse-temurin-11 AS build

# Set working directory
WORKDIR /app

# Copy pom.xml first — this allows Docker to cache dependencies
COPY pom.xml .

# Download dependencies (safe + faster)
RUN mvn dependency:resolve -B

# Copy source code
COPY src ./src

# Build WAR file, skip tests to save time
RUN mvn clean package -DskipTests

# ==========================
# 2️⃣ Runtime Stage (Tomcat)
# ==========================
FROM tomcat:9-jdk11-openjdk-slim

# Remove default Tomcat web apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file from build stage
COPY --from=build /app/target/learning-platform.war /usr/local/tomcat/webapps/learning-platform.war

# Expose port
EXPOSE 8080

# Health check for Jenkins and Docker
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost:8080/learning-platform/ || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"]
