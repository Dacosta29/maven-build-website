COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]


pipeline {
    agent {
        label 'agent-server'
    }

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

        stage("Quality Gate") {
            steps {
              timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
              }
            }
        }

        stage ('upload to nexus') {
            steps {
                nexusArtifactUploader artifacts: [[artifactId: 'earth-app', classifier: '', file: '/var/lib/jenkins/workspace/second-job/target/earth-app-1.0-SNAPSHOT.war', type: 'war']], credentialsId: 'nexus-id', groupId: 'com.devops.maven', nexusUrl: '16.16.209.247:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'maven-build-snapshot', version: '1.0-SNAPSHOT'
            }
        }
      }

      post {
        always {
            slackSend channel: 'success-group', 
                      color: COLOR_MAP[currentBuild.currentResult],
                      message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}"
        }
      }
    }
