pipeline {
    agent any
    
    environment {
        APP_NAME = "learning-platform"
        DOCKER_IMAGE = "learning-platform:${BUILD_NUMBER}"
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
                    url: 'https://github.com/bayarmaa01/int333.git'
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
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        
        stage('Stop Old Container') {
            steps {
                script {
                    sh '''
                        docker stop learning-platform || true
                        docker rm learning-platform || true
                    '''
                }
            }
        }
        
        stage('Deploy Container') {
            steps {
                script {
                    sh """
                        docker run -d \
                        --name learning-platform \
                        -p 80:8080 \
                        --restart unless-stopped \
                        ${DOCKER_IMAGE}
                    """
                }
            }
        }
        
        stage('Health Check') {
            steps {
                script {
                    sleep 15
                    sh '''
                        for i in {1..10}; do
                            if curl -f http://localhost:80/learning-platform/; then
                                echo "Application is healthy"
                                exit 0
                            fi
                            echo "Waiting for application... attempt $i"
                            sleep 5
                        done
                        echo "Health check failed"
                        exit 1
                    '''
                }
            }
        }
        
        stage('Cleanup Old Images') {
            steps {
                script {
                    sh '''
                        docker image prune -f
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed! Rolling back...'
            script {
                sh '''
                    docker stop learning-platform || true
                    docker rm learning-platform || true
                '''
            }
        }
    }
}