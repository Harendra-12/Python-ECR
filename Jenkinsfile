pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = "677276107791"
        AWS_REGION     = "us-east-2"
        REPO_NAME      = "ecr_repository"
        IMAGE_TAG      = "latest"   // You can change this to BUILD_NUMBER or git commit SHA
        ECR_URL        = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Harendra-12/Python-ECR.git'
            }
        }

        stage('Build Image with Podman') {
            steps {
                sh "sudo podman build --cgroup-manager=cgroupfs -t ${REPO_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Login to ECR') {
            steps {
                withAWS(credentials: 'aws-creds', region: "${AWS_REGION}") {
                    sh '''
                    PASSWORD=$(aws ecr get-login-password --region us-east-2)
                    podman login --username AWS --password $PASSWORD 677276107791.dkr.ecr.us-east-2.amazonaws.com
                    '''
                }
            }
        }

        stage('Tag & Push Image to ECR') {
            steps {
                sh """
                podman tag ${REPO_NAME}:${IMAGE_TAG} ${ECR_URL}:${IMAGE_TAG}
                podman push ${ECR_URL}:${IMAGE_TAG}
                """
            }
        }
    }
