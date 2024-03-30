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

        stage ('SonarQube Analysis') {
            environment {
                ScannerHome = tool 'sonar5.0'
            }
            steps {
                script {
                    withSonarQubeEnv('sonarqube') {
                        sh "${ScannerHome}/bin/sonar-scanner -Dsonar.projectKey=jomacs"
                    }
                }
            }
        }

        stage ('upload to nexus') {
            steps {
                nexusArtifactUploader artifacts: [[artifactId: 'earth-app', classifier: '', file: '/var/lib/jenkins/workspace/maven-build-website/target/earth-app-1.0-SNAPSHOT.war', type: 'war']], credentialsId: 'nexus-id', groupId: 'com.devops.maven', nexusUrl: '13.51.158.15:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'webapp-snapshot', version: '1.0-SNAPSHOT'
            }
        }

        stage ("deploy to tomcat") {
            steps {
                deploy adapters: [tomcat9(credentialsId: 'tomcat-id', path: '', url: 'http://16.171.141.196:8080/')], contextPath: null, war: 'target/*war'
            }
        }
        
        }
    }
}