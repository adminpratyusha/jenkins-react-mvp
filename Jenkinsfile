pipeline {
    agent any

    environment {
       PACKAGE_NAME = 'mvprelease-react'
        OUTPUTFILENAME="artifact.tar.gz"
        SSHCONFIGNAME='sshtest'
    }

    parameters {
        string(name: 'currentVersion', defaultValue: '0.1.0.19', description: 'Enter the version number')
        // choice(name: 'ENVIRONMENT', choices: ['QA', 'Pre-Prod', 'Prod'], description: 'Select deployment environment')
    }

    stages {
        // stage('set environment'){    
        //       steps {
        //         script {
        //              if (params.ENVIRONMENT == "QA") {
        //                 SSHCONFIGNAME = 'QACRED'
        //             } else if (params.ENVIRONMENT == "Pre-Prod") {
        //                 SSHCONFIGNAME = 'PREPRODCRED'
        //             } else {
        //                 SSHCONFIGNAME = 'PRODCRED'
        //             }
        //             echo "SSH Configuration Name: ${SSHCONFIGNAME}"


        // }
        //       }
        // }
        stage('Download artifact from Nexus') {
            steps {
                script {
                
                    
                    withCredentials([
                       string(credentialsId: 'nexusurl', variable: 'NEXUS_URL'),
                        string(credentialsId: 'nexusrelease-repo', variable: 'NEXUS_REPO_ID'),
                        string(credentialsId: 'nexuspassword', variable: 'NEXUS_PASSWORD'),
                        string(credentialsId: 'nexususername', variable: 'NEXUS_USERNAME')
                    ]) {
                sh "curl -v -o ${OUTPUTFILENAME} -u ${NEXUS_USERNAME}:${NEXUS_PASSWORD} ${NEXUS_URL}/repository/${NEXUS_REPO_ID}/${PACKAGE_NAME}/${params.currentVersion}/${PACKAGE_NAME}-${params.currentVersion}.tar.gz"
      
                }
            }
        }
        }

        stage("unzip artifact"){
            steps{
                script{
                    sh "tar -xvf ${OUTPUTFILENAME}"
                }
            }
        }

         stage('Stop nginx and remote old version files') {
            steps {
                script {
                    sshPublisher(publishers: [sshPublisherDesc(configName: SSHCONFIGNAME , transfers: [
                                    sshTransfer(
                                        execCommand: "sudo systemctl stop nginx && sudo rm -rf /var/www/html/*",
                                        execTimeout: 120000
                                    )
                                ])
                    ])
                
                }
               
                
            }
        }



        stage('Deploy to VM') {
            steps {
                script {
                 
             sshPublisher(publishers: [sshPublisherDesc(configName: SSHCONFIGNAME ,
                        transfers: [sshTransfer(flatten: false, sourceFiles: OUTPUTFILENAME)])
                    ])                }
            }
        }

         stage('start nginx') {
            steps {
                script {
                        sshPublisher(publishers: [sshPublisherDesc(configName: SSHCONFIGNAME, transfers: [
                                    sshTransfer(
                                        execCommand: "sudo cp -rf /home/ubuntu/build/* /var/www/html/ && rm -rf /home/ubuntu/build && sudo systemctl start nginx",
                                        execTimeout: 120000
                                    )
                                ])
                    ])                }
               
                
            }
        }
    }
}
