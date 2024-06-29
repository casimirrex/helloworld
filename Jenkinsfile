pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'casimirrex/helloworld'
        DOCKER_TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    // Run the Docker container and test the application
                    sh 'docker run --rm -d -p 9091:9090 --name helloworld ${DOCKER_IMAGE}:${DOCKER_TAG}'
                    // Add your test commands here
                    sh 'docker stop helloworld'
                }
            }
        }
        
        stage('Push') {
            steps {
                script {
                    // Login to DockerHub and push the Docker image
                    withCredentials([usernamePassword(credentialsId: 'docker-credentials', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
                        sh 'echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin'
                        sh 'echo "Pushing to DockerHub as $DOCKERHUB_USERNAME"'
                        sh 'docker push ${DOCKER_IMAGE}:${DOCKER_TAG}'
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
