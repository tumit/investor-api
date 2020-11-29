pipeline {
    agent any
    environment {
        APP_NAME = 'sbthapi0'
        APP_VERSION = '1.0.0'
    }
    stages {
        stage('Pull code') {
            steps {
                git branch: "main", credentialsId: 'git-ci-user', url: "$GIT_URL"
            }
        }
        stage('Build') {
            steps {
                sh """
                    docker build \
                        --build-arg APP_NAME=$APP_NAME \
                        --build-arg APP_VERSION=$APP_VERSION \
                        --file Dockerfile \
                        --tag $APP_NAME:$APP_VERSION .
                """
            }
        }
        stage('Upload to repository') {
            steps {
                sh "docker tag $APP_NAME:$APP_VERSION localhost:5000/$APP_NAME:$APP_VERSION"
                sh "docker push localhost:5000/$APP_NAME:$APP_VERSION"
            }
        }
    }
    post {
        always {
            sh "docker image rm $APP_NAME:$APP_VERSION || exit 0"
            sh "docker image rm localhost:5000/$APP_NAME:$APP_VERSION || exit 0"
        }
    }
}
