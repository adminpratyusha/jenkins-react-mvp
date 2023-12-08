pipeline {
    agent any

    environment {
        // Define any environment variables you need
       PACKAGE_NAME = 'mvp-react'
    }

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

    // stage('CODE ANALYSIS with SONARQUBE') {
    //   environment {
    //     scannerHome = tool 'sonar-scanner'
    //   }

    //     steps {
    //     script {
    //         withSonarQubeEnv(credentialsId: 'sonartoken', installationName: 'sonarqube') {
    //             sh """$scannerHome/bin/sonar-scanner \
    //                 -Dsonar.projectKey='REACT' \
    //                 -Dsonar.projectName='REACT' \
    //                 -Dsonar.sources=src/ \
    //                 -Dsonar.java.binaries=target/classes/ \
    //                 -Dsonar.exclusions=src/test/java/****/*.java \
    //                 -Dsonar.java.libraries=/var/lib/jenkins/.m2/**/*.jar \
    //                 -Dsonar.projectVersion=${BUILD_NUMBER}-${env.GIT_COMMIT_SHORT}"""
    //         }
    //     }
    //  }

    // }

         stage('OWASP Dependency-Check Vulnerabilities') {
      steps {
        script {
            dependencyCheck additionalArguments: ''' 
                            -o './'
                            -s './'
                            -f 'ALL' 
                            --prettyPrint''', odcInstallation: 'OWASP Dependency-Check Vulnerabilities'
                
                dependencyCheckPublisher pattern: 'dependency-check-report.xml'
        }
      }
    }



    //     stage('Test React App') {
    //         steps {
    //              sh 'npm test'
    //         }
    //     }

    //        stage('Archive Artifact') {
    //   steps {
    //     script {
    //      sh 'tar -czvf build.tar.gz build'

    //     }
    //   }
    // }
    // stage('Deploy to Nexus') {
    //         steps {
    //             script {
    //                 withCredentials([
    //                     string(credentialsId: 'nexusurl', variable: 'NEXUS_URL'),
    //                     string(credentialsId: 'nexusrepo-react', variable: 'NEXUS_REPO_ID'),
    //                     string(credentialsId: 'nexuspassword', variable: 'NEXUS_PASSWORD'),
    //                     string(credentialsId: 'nexususername', variable: 'NEXUS_USERNAME')
    //                 ]) {

    //                     // Construct and execute the curl command
    //                     def currentVersion = sh(script: 'node -pe "require(\'./package.json\').version"', returnStdout: true).trim()
    //                     // def artifactPath = "${PACKAGE_NAME}/${currentVersion}/${PACKAGE_NAME}-${currentVersion}.${env.BUILD_ID}"
    //                     def curlCommand = """
    //                       curl -v -u ${NEXUS_USERNAME}:${NEXUS_PASSWORD} --upload-file build.tar.gz ${NEXUS_URL}/repository/${NEXUS_REPO_ID}/${PACKAGE_NAME}/${currentVersion}/${PACKAGE_NAME}-${currentVersion}.${env.BUILD_ID}.tar.gz
    //                     """
    //                     sh curlCommand

    //                     // Print deployment information
    //                     echo "Artifact deployed to Nexus with version ${currentVersion}"
    //                 }
    //             }
    //         }
    //   }



        
    
}}
