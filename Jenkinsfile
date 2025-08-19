pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = "677276107791"         // 🔹 Replace with your AWS Account ID
        AWS_REGION     = "us-east-2"           // 🔹 Replace with your region
        REPO_NAME      = "ecr_repository"      // 🔹 Your ECR repo name
        IMAGE_TAG      = "latest"              // or use BUILD_NUMBER / commit SHA
        ECR_URL        = "677276107791.dkr.ecr.us-east-2.amazonaws.com/ecr_repository"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Harendra-12/Python-ECR.git'
            }
        }

        stage('Build Podman Image') {
    steps {
        script {
            sh "sudo podman build --cgroup-manager=cgroupfs -t ${REPO_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Login to ECR') {
            steps {
                sh """
                  aws ecr get-login-password --region ${AWS_REGION} \
                  | podman login --username AWS --password-stdin ${ECR_URL}
                """
            }
        }

        stage('Tag & Push Image to ECR') {
            steps {
                sh """
                  podman tag ${REPO_NAME}:${IMAGE_TAG} ${ECR_URL}/${REPO_NAME}:${IMAGE_TAG}
                  podman push ${ECR_URL}/${REPO_NAME}:${IMAGE_TAG}
                """
            }
        }
    }

    post {
        success {
            echo "✅ Image pushed: ${ECR_URL}/${REPO_NAME}:${IMAGE_TAG}"
        }
        failure {
            echo "❌ Build failed. Check logs."
        }
    }
}
