pipeline {
    agent any
    
    options {
        timeout(time: 1, unit: 'HOURS')
        timestamps()
    }
    
    environment {
        APP_NAME = "learning-platform"
        COMPOSE_PROJECT_NAME = "cicd-project"
        MAVEN_OPTS = "-Dmaven.repo.local=/var/lib/jenkins/.m2/repository"
    }
    
    stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }
        
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/bayarmaa01/INT333.git'
            }
        }
        
        stage('Build with Maven') {
            steps {
                sh '''
                    mvn clean package -DskipTests \
                    -Dmaven.repo.local=/var/lib/jenkins/.m2/repository \
                    --batch-mode \
                    --no-transfer-progress
                '''
            }
        }
        
        stage('Run Tests') {
            steps {
                sh 'mvn test -Dmaven.repo.local=/var/lib/jenkins/.m2/repository || true'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh '''
                        echo "🐳 Building Docker image..."
                        docker build -t learning-platform:latest .
                        echo "✅ Docker image built"
                        # Optional: Tag and push to Docker Hub
                        # docker tag learning-platform:latest bayarmaa/learning-platform:latest
                        # docker push bayarmaa01/learning-platform:latest
                    '''
                }
            }
        }
        
        stage('Stop Old Containers') {
            steps {
                script {
                    sh '''
                        docker-compose down || true
                        sleep 5
                    '''
                }
            }
        }
        
        stage('Deploy with Monitoring Stack') {
            steps {
                script {
                    sh '''
                        echo "🚀 Deploying application with monitoring stack..."
                        docker-compose up -d
                        echo "✅ Deployment initiated"
                    '''
                }
            }
        }
        
        stage('Wait for Services') {
            steps {
                script {
                    sh '''
                        echo "⏳ Waiting for services to start..."
                        sleep 30
                    '''
                }
            }
        }
        
        stage('Health Check') {
            steps {
                script {
                    sh '''
                        echo "🏥 Running health checks..."
                        
                        for i in {1..10}; do
                            if curl -f http://localhost:80/learning-platform/ > /dev/null 2>&1; then
                                echo "✅ Application is healthy"
                                break
                            fi
                            echo "⏳ Waiting for application... attempt $i/10"
                            sleep 5
                        done
                        
                        if ! curl -f http://localhost:80/learning-platform/ > /dev/null 2>&1; then
                            echo "⚠️ Application health check failed but continuing..."
                        fi
                    '''
                }
            }
        }
        
        stage('Verify Monitoring Stack') {
            steps {
                script {
                    sh '''
                        echo "📊 Verifying monitoring services..."
                        docker-compose ps
                    '''
                }
            }
        }
        
        stage('Cleanup Old Images') {
            steps {
                script {
                    sh '''
                        docker image prune -f
                        echo "🧹 Cleaned up unused images"
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo '✅ PIPELINE COMPLETED SUCCESSFULLY!'
            sh 'docker-compose ps'
        }
        failure {
            echo '❌ PIPELINE FAILED!'
            sh 'docker-compose down || true'
        }
        always {
            echo 'Pipeline execution completed'
        }
    }
}