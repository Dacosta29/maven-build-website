
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

        stage ("build") {
            steps {
                sh 'mvn clean'
            }
        }

        stage ("test") {
            steps {
                sh 'mvn test'
            }
        }
      }
    }
