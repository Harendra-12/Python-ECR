pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = "677276107791"         
        AWS_REGION     = "us-east-2"           
        REPO_NAME      = "ecr_repository"      
        IMAGE_TAG      = "latest"              
        ECR_URL        = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Harendra-12/Python-ECR.git'
            }
        }

        stage('Build Podman Image') {
            steps {
                sh """
                  echo '🔨 Building image from Dockerfile'
                  podman build --cgroup-manager=cgroupfs -t ${REPO_NAME}:${IMAGE_TAG} .
                """
            }
        }

        stage('Login to ECR') {
            steps {
                withAWS(credentials: 'aws-creds', region: "${AWS_REGION}") {
                    sh '''
                    PASSWORD=$(aws ecr get-login-password --region ${AWS_REGION})
                    podman login --username AWS --password $PASSWORD ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    '''
                }
            }
        }

        stage('Tag & Push to ECR') {
            steps {
                sh """
                  echo '🏷️  Tagging image for ECR'
                  podman tag ${REPO_NAME}:${IMAGE_TAG} ${ECR_URL}:${IMAGE_TAG}

                  echo '🚀 Pushing image to ECR'
                  podman push ${ECR_URL}:${IMAGE_TAG}
                """
            }
        }
    }

    post {
        success {
            echo "✅ Image pushed successfully: ${ECR_URL}:${IMAGE_TAG}"
        }
        failure {
            echo "❌ Pipeline failed. Check logs."
        }
    }
}
