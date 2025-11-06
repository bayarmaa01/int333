pipeline {
    agent any

    environment {
        APP_NAME = "learning-platform"
    }

    options {
        ansiColor('xterm')
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 20, unit: 'MINUTES')   // overall speed limit
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/bayarmaa01/INT333.git'
            }
        }

        stage('Build WAR (Quick)') {
            steps {
                sh '''
                    echo "⚙️ Fast Maven build (using cache)..."
                    mvn clean package -DskipTests -T 2C -B
                '''
            }
        }

        stage('Build Docker Image (Cached)') {
            steps {
                sh '''
                    echo "🐳 Building Docker image with cache..."
                    docker build -t learning-platform:latest .
                '''
            }
        }

        stage('Deploy Containers') {
            steps {
                sh '''
                    echo "🚀 Deploying containers (fast mode)..."
                    docker-compose up -d --no-recreate
                '''
            }
        }

        stage('Health Check (Quick)') {
            steps {
                script {
                    echo "🔍 Checking app health quickly..."
                    sleep 10
                    sh '''
                        for i in {1..5}; do
                            if curl -fs http://localhost:8080/learning-platform/ >/dev/null; then
                                echo "✅ App is healthy!"
                                exit 0
                            fi
                            echo "⏳ Retrying health check ($i)..."
                            sleep 3
                        done
                        echo "❌ Health check failed!"
                        exit 1
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Fast deployment successful!'
            sh 'docker ps --filter "name=learning-platform"'
        }
        failure {
            echo '❌ Deployment failed — cleaning up...'
            sh 'docker-compose down || true'
        }
    }
}
