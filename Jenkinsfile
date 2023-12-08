pipeline {
    agent any

    environment {
        // Define any environment variables you need
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout your code from version control (e.g., Git)
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                // Install Node.js and npm if not already installed
                // Install project dependencies
                sh 'npm install'
            }
        }

        stage('Build React App') {
            steps {
                // Build your React app
                sh 'npm run build'
            }
        }

        stage('Test React App') {
            steps {
                // Run tests for your React app if applicable
                 sh 'npm test'
            }
        }
