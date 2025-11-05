pipeline {
    agent any
    
    environment {
        APP_NAME = "learning-platform"
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
                sh 'mvn clean package'
            }
        }
        
        stage('Run Tests') {
            steps {
                sh 'mvn test'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker-compose build app'
                }
            }
        }
        
        stage('Stop Old Containers') {
            steps {
                script {
                    sh '''
                        docker-compose down || true
                    '''
                }
            }
        }
        
        stage('Deploy with Monitoring Stack') {
            steps {
                script {
                    sh '''
                        docker-compose up -d
                    '''
                }
            }
        }
        
        stage('Health Check') {
            steps {
                script {
                    sleep 20
                    sh '''
                        for i in {1..10}; do
                            if curl -f http://localhost:80/learning-platform/; then
                                echo "✅ Application is healthy"
                                exit 0
                            fi
                            echo "⏳ Waiting for application... attempt $i"
                            sleep 5
                        done
                        echo "❌ Health check failed"
                        exit 1
                    '''
                }
            }
        }
        
        stage('Verify Monitoring Stack') {
            steps {
                script {
                    sh '''
                        echo "🔍 Checking monitoring services..."
                        docker-compose ps
                        
                        echo "\n📊 Prometheus: http://$(curl -s ifconfig.me):9090"
                        echo "📈 Grafana: http://$(curl -s ifconfig.me):3000"
                        echo "🐳 cAdvisor: http://$(curl -s ifconfig.me):8081"
                    '''
                }
            }
        }
        
        stage('Cleanup Old Images') {
            steps {
                script {
                    sh 'docker image prune -f'
                }
            }
        }
    }
    
    post {
        success {
            echo '✅ Deployment successful with monitoring stack!'
            sh 'docker-compose ps'
        }
        failure {
            echo '❌ Deployment failed! Rolling back...'
            sh 'docker-compose down'
        }
    }
}