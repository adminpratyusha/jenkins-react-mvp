pipeline {
    agent any
    stages {
        stage('CLEANWS') {
            steps {
                cleanWs()
            }
        }
         stage('Checkout') {
            steps {
          checkout scmGit(branches: [[name: '*/release-*']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/adminpratyusha/jenkins-react-mvp']])            }
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
