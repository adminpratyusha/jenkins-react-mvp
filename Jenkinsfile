@Library('react-shared-library') _
pipeline {
    agent any
    environment {
        // Define any environment variables you need
         PACKAGE_NAME = 'mvp-react'
        IMAGE_NAME = 'pratyusha2001/mvpreact'
        DOCKER_CREDENTIALS_ID = 'dockercred'
    }
    stages {
        stage('Install Dependencies') {
            steps {
                script{
                npm.install()    
                }
            }
        }

        stage('Build React App') {
            steps {
                script{
                npm.build()
                }
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
                script{
                 npm.test()
                }
            }
        }


    stage('CODE ANALYSIS with SONARQUBE') {
      environment {
        scannerHome = tool 'sonar-scanner'
      }

        steps {
        script {
            withSonarQubeEnv(credentialsId: 'sonartoken', installationName: 'sonarqube') {
                sonar.sonarscananalysis('React-proj', 'React-proj')
            }
        }
     }

    }

         stage('OWASP Dependency-Check Vulnerabilities') {
      steps {
        script {
               dependency.owasp()
      }
      }
    }

           stage('Archive Artifact') {
      steps {
        script {
           archivefiles.unzipping()
        }
      }
    }
        
    stage('Deploy to Nexus') {
            steps {
                script {
                    withCredentials([
                        string(credentialsId: 'nexusurl', variable: 'NEXUS_URL'),
                        string(credentialsId: 'nexusrepo-react', variable: 'NEXUS_REPO_ID'),
                        string(credentialsId: 'nexuspassword', variable: 'NEXUS_PASSWORD'),
                        string(credentialsId: 'nexususername', variable: 'NEXUS_USERNAME')
                    ]) {

                     ARTIFACT_VERSION=nexusrepo.pushtonexus(NEXUS_USERNAME,NEXUS_PASSWORD,NEXUS_URL,NEXUS_REPO_ID,env.PACKAGE_NAME)
                    }
                }
            }
      }
        
        stage('DOCKER BUILD & PUSH') {
      steps {
        script {
             dockertask.pushtodocker(IMAGE_NAME,DOCKER_CREDENTIALS_ID)

                    }


        }
      }
         stage('Trigger Downstream Pipeline') {
            steps {
                script {
                    // Trigger the downstream pipeline (Pipeline B) only if the build is stable or successful
                    if (currentBuild.resultIsBetterOrEqualTo('SUCCESS')) {
                        build job: 'AutoDeployToDev-react', parameters: [string(name: 'buildID', value: ARTIFACT_VERSION)]
                    } else {
                        echo 'Skipping downstream pipeline due to unsuccessful upstream build.'
                    }
                }
            }
        }
    }


        
    
}
