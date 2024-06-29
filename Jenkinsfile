pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'casimirrex/helloworld'
        BACKEND_PORT = '9091'
    }

    stages {
        stage('Clone Backend Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/casimirrex/helloworld.git', credentialsId: 'docker-credentials'
            }
        }

        stage('Build with Maven') {
            steps {
                script {
                    sh 'mvn clean package'
                }
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                }
            }
        }

        stage('Build Backend Docker Image') {
            steps {
                script {
                    retry(3) {
                        backendDockerImage = docker.build("${DOCKER_IMAGE}")
                    }
                }
            }
        }

        stage('Run Backend Docker Container') {
            steps {
                script {
                    backendDockerImage.run("-d -p ${BACKEND_PORT}:9090") // Assuming your backend service runs on port 9090 inside the container
                }
            }
        }

        stage('Wait for Backend Container') {
            steps {
                script {
                    sleep 120 // Wait for 2 minutes
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                        sh 'docker push ${DOCKER_IMAGE}:latest'
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker environment
            sh 'docker system prune -f'
        }
    }
}
