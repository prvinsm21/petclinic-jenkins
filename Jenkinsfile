pipeline {
    agent any
    tools {
        jdk 'jdk11'
        maven 'maven3'
    }
    environment {
        DOCKERHUB_USERNAME = "prvinsm21"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKERIMAGE_NAME = "prvinsm21/petclinic-jenkins:${BUILDNUMBER}"
    }

    stages {
        stage ('Git Checkout')
        {
            steps {
                sh 'echo Passed'
            }
        }
        stage ('Build') {
            steps {
                sh 'mvn clean package'
            }
            post {
                success {
                    echo "Now Archiving...!"
                    archiveArtifacts artifacts: '**/trget/*.war'
                }
            }
        }
        stage ('Unit Cases') {
            steps {
                sh 'mvn test'
            }
            post{
                always {
                    junit '**/target/surefire-reports/TEST-*.xml'
                }
            }
        }
        
    }
}