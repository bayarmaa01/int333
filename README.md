# Online Learning Platform - CI/CD Project

## 🎯 Project Overview
Automated CI/CD pipeline for a Java-based web application demonstrating DevOps best practices.

## 🏗️ Architecture
- **Application:** Java Servlet + Maven
- **Containerization:** Docker
- **CI/CD:** Jenkins Pipeline
- **Deployment:** AWS EC2
- **Monitoring:** AWS CloudWatch

## 🚀 Features
- Automated build and deployment
- Docker containerization
- Health check endpoints
- Automated rollback on failures
- Real-time monitoring and alerts

## 📋 Prerequisites
- AWS Account (Free tier)
- GitHub Account
- Basic knowledge of Git and command line

## 🛠️ Technologies Used
- **Backend:** Java 11, Maven, Tomcat
- **DevOps:** Jenkins, Docker, Git
- **Cloud:** AWS EC2, CloudWatch
- **Monitoring:** CloudWatch Metrics & Logs

## 📊 Pipeline Stages
1. Cleanup Workspace
2. Checkout Code from GitHub
3. Build with Maven
4. Run Unit Tests
5. Build Docker Image
6. Stop Old Container
7. Deploy New Container
8. Health Check Validation
9. Cleanup Old Images

## 🌐 Access URLs
- **Application:** http://YOUR_EC2_PUBLIC_IP/learning-platform/
- **Health Check:** http://YOUR_EC2_PUBLIC_IP/learning-platform/api/health
- **Jenkins:** http://YOUR_EC2_PUBLIC_IP:8080

## 📈 Monitoring
- CloudWatch Dashboard for metrics
- CPU, Memory, Disk monitoring
- Automated alerts for high resource usage
- Centralized log aggregation

## 🎓 Learning Outcomes
- Hands-on DevOps pipeline implementation
- Docker containerization skills
- Jenkins pipeline creation
- AWS cloud deployment
- Monitoring and observability

## 👨‍💻 Author
**Name:** Bayarmaa Bumandorj  
**Reg No:** 12222441  
**Roll No:** 63

## 📝 License
This project is for educational purposes.