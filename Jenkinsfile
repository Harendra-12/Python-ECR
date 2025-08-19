pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = "677276107791"        // Your AWS Account ID
        AWS_REGION     = "us-east-2"           // Your AWS region
        REPO_NAME      = "ecr_repository"      // Your ECR repo name
        IMAGE_TAG      = "latest"              // Or use BUILD_NUMBER / commit SHA
        ECR_URL        = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Harendra-12/Python-ECR.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${REPO_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Login to ECR') {
            steps {
                sh """
                  aws ecr get-login-password --region ${AWS_REGION} \
                  | docker login --username AWS --password-stdin ${ECR_URL}
                """
            }
        }

        stage('Tag & Push Image to ECR') {
            steps {
                sh """
                  docker tag ${REPO_NAME}:${IMAGE_TAG} ${ECR_URL}/${REPO_NAME}:${IMAGE_TAG}
                  docker push ${ECR_URL}/${REPO_NAME}:${IMAGE_TAG}
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
