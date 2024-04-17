
pipeline {
    agent any

    tools {
        maven "maven3.9.6"
    }

    stages {
        stage ("git clone") {
            steps {
                git 'https://github.com/Dacosta29/maven-build-website.git'
            }
        }

        stage ("build with maven") {
            steps {
                sh'''
                mvn clean
                mvn test
                mvn package
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t dacosta29/maven-build-website:latest ."
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-credentials', toolName: 'Docker') {
                        sh "docker push dacosta29/maven-build-website:latest"
                    }
                }
            }
        }

        stage('Docker Run') {
            steps {
                sh "docker run -d -p 8090:8080 dacosta29/maven-build-website:latest"
            }
        }
      }
    }

