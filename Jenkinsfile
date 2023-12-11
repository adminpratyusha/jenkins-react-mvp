pipeline {
    agent any
    stages {
        stage('CLEANWS') {
            steps {
                cleanWS()
            }
        }
         stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build React App') {
            steps {
                sh 'npm run build'
            }
        }
    
}
}
