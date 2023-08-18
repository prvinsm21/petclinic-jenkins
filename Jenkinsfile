pipeline {
    agent any
    tools {
        jdk 'jdk17'
        maven 'maven3'
    }
    environment {
        DOCKERHUB_USERNAME = "prvinsm21"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKERIMAGE_NAME = "prvinsm21/petclinic-jenkins:${BUILD_NUMBER}"
    }

    stages {
        stage ('Git Checkout')
        {
            steps {
                sh 'echo Passed'
            }
        }
        stage ('Code Compile') {
            steps {
                sh 'mvn compile'
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
        stage ('Packaging compiled code') {
            steps {
                sh 'mvn clean package -DskipTests=true'
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
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-api'
                }
            }
        }
        stage ('Build Code') {
            steps {
                sh 'mvn clean install'
            }
        }
        stage ('Upload jar file to Nexus') {
            steps{
                script{
                    def readPomVersion = readMavenPom file: 'pom.xml'
                    
                    nexusArtifactUploader artifacts: 
                    [
                        [
                            artifactId: 'spring-petclinic', 
                            classifier: '', 
                            file: 'target/spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar', 
                            type: 'jar'
                        ]
                    ], 
                    credentialsId: 'nexus-auth', 
                    groupId: 'org.springframework.samples', 
                    nexusUrl: '192.168.29.38:8081', 
                    nexusVersion: 'nexus3', 
                    protocol: 'http', 
                    repository: 'petclinic-repo', 
                    version: "${readPomVersion.version}"
                }
            }
        }
        stage ('Build Docker image') {
            steps {
                sh '''
                    docker build . -t ${DOCKERIMAGE_NAME}
                    docker images
                '''
            }
        }
        stage ('Trivy Image Scanning') {
            steps {
                sh 'trivy image ${DOCKERIMAGE_NAME} > $WORKSPACE/trivy-image-scan-$BUILD_NUMBER.txt'
            }
        }
        stage ('Push Docker image') {
            steps {
                script {
                    def dockerImage = docker.image("${DOCKERIMAGE_NAME}")
                    docker.withRegistry('https://index.docker.io/v1/', "dockerhub") {
                    dockerImage.push()
                    }
                }
            }
        }
        stage('Update Deployment File') {
        environment {
            GIT_REPO_NAME = "petclinic-jenkins"
            GIT_USER_NAME = "prvinsm21"
        }
        steps {
            withCredentials([string(credentialsId: 'git-push', variable: 'GITHUB_TOKEN')]) {
                sh '''
                    git config user.email "prvinsm21@gmail.com"
                    git config user.name "Macko"
                    BUILD_NUMBER=${BUILD_NUMBER}
                    sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" manifests/deployment.yml
                    git add manifests/deployment.yml
                    git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                    git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:master
                '''
            }
        }
        }
    }
}