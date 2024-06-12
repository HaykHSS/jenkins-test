pipeline {
    agent { label 'jenkins-test-agent' } // Specify the label of the agent

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id') // Fetches DockerHub credentials
        DOCKER_IMAGE = 'haykhs/jenkins-test' // Docker image name
    }

    stages {
        stage('Build') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:latest") // Builds the Docker image
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    docker.image("${DOCKER_IMAGE}:latest").inside {
                        sh 'npm run test' // Runs tests inside the Docker container
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials-id') {
                        docker.image("${DOCKER_IMAGE}:latest").push() // Pushes the Docker image to DockerHub
                    }
                    sh 'helm upgrade --install jenkins-test ./jenkins-test --set image.repository=${DOCKER_IMAGE},image.tag=latest' // Deploys using Helm
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Cleans up the workspace after the pipeline runs
        }
    }
}
