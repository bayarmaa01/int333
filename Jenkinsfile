pipeline {
    agent any

    environment {
        APP_NAME = "learning-platform"
    }

    options {
        timeout(time: 30, unit: 'MINUTES')                     // Full pipeline timeout
        ansiColor('xterm')                                     // Colorized logs
        buildDiscarder(logRotator(numToKeepStr: '5'))          // Keep only 5 builds
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/bayarmaa01/INT333.git'
            }
        }

        stage('Build with Maven') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    sh '''
                        echo "🔧 Building WAR package..."
                        mvn clean package -DskipTests -B
                    '''
                }
            }
        }

        stage('Run Tests') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    sh '''
                        echo "🧪 Running unit tests..."
                        mvn test
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    script {
                        sh '''
                            echo "🐳 Building Docker image with cache..."
                            docker pull tomcat:9-jdk11-openjdk-slim || true
                            docker-compose build --pull --no-cache=false app
                        '''
                    }
                }
            }
        }

        stage('Stop Old Containers') {
            steps {
                script {
                    echo "🧹 Stopping old containers..."
                    sh 'docker-compose down || true'
                }
            }
        }

        stage('Deploy with Monitoring Stack') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    sh '''
                        echo "🚀 Starting application and monitoring stack..."
                        docker-compose up -d
                    '''
                }
            }
        }

        stage('Health Check') {
            steps {
                script {
                    echo "🔍 Performing health check..."
                    sleep 20
                    sh '''
                        for i in {1..10}; do
                            if curl -f http://localhost:8080/learning-platform/; then
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
                        echo "📊 Verifying monitoring services..."
                        docker-compose ps
                        echo "\nPrometheus: http://$(curl -s ifconfig.me):9090"
                        echo "Grafana:   http://$(curl -s ifconfig.me):3000"
                        echo "cAdvisor:  http://$(curl -s ifconfig.me):8081"
                    '''
                }
            }
        }

        stage('Cleanup Old Images') {
            steps {
                sh '''
                    echo "🧽 Cleaning up unused images..."
                    docker image prune -f --filter "dangling=true" || true
                '''
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
            sh 'docker-compose down || true'
            sh 'docker system prune -af || true'
            cleanWs()  // only clean if failed
        }
    }
}
