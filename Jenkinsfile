pipeline {
    agent any
    
    stages {
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        
        stage('Build React App') {
            steps {
                dir('/var/lib/jenkins/workspace/release-react')
                sh 'npm run build'
                
            }
        }
       
    }
}
