pipeline {
    agent any
    environment {
        DOCKERHUB_USERNAME = "prvinsm21"
        DOCKERHUB_CREDENTIALS = credentialsID('dockerhub')
        DOCKERHUB_REGISTRY = "prvinsm21/petclinic-jenkins-$BUILDNUMBER"
    }

    stages {
        stage ('Git Checkout')
        {
            steps {
                sh 'echo Passed'
            }
        }
    }
}