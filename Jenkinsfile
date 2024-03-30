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
    }
}