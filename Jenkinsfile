pipeline {
    agent any

    // environment {
    //     // Define any environment variables you need
    // }

    stages {
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
             post {
        success {
          echo 'Now Archiving...'
          archiveArtifacts artifacts: 'build/**/*'
        }
      }
        }

        stage('Test React App') {
            steps {
                 sh 'npm test'
            }
        }
      stage('Deploy to Nexus') {
            steps {
                script {
                    // Construct and execute the curl command
                    def currentVersion = sh(script: 'npm -s show --json version', returnStdout: true).trim()
                    def curlCommand = """
                        curl -v -u ${NEXUS_USERNAME}:${NEXUS_PASSWORD} --upload-file build ${NEXUS_URL}/repository/${NEXUS_REPO_ID}/${PACKAGE_NAME}/${currentVersion}/${PACKAGE_NAME}-${currentVersion}.${env.BUILD_ID}
                    """
                    sh curlCommand

                    // Print deployment information
                    echo "Artifact deployed to Nexus with version ${currentVersion}"
                }
            }
        }

    
    
}}
