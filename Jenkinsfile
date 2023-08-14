pipeline {
    agent any
    tools {
        jdk 'jdk17'
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
                sh 'mvn clean package -DskipTests=true'
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
        stage ('Integration Test') {
            steps {
                sh 'mvn verify -DskipUnitTests'
            }
        }
        stage ('Static Code analysis') {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: 'sonar-api') {
                        sh 'mvn sonar:sonar'
                    }
                }
            }
        }
        stage ('Quality Gate Check') {
            steps {
                script {
                    waitForQualityGate abortPipeline:false, credentialsId: 'sonar-api'
                }
            }
        }
        
    }
}