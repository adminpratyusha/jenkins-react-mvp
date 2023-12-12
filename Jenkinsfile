pipeline {
    agent any
    environment {
       PACKAGE_NAME = 'mvprelease-react'
        OUTPUTFILENAME="build.tar.gz"
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
        stage('clean artifact ws') {
            steps {
                script {
                    cleanWs()
                }
            }
        }
        stage('Download artifact from Nexus') {
            steps {
                script {
                
                    
                    withCredentials([
                       string(credentialsId: 'downloadurl', variable: 'Nexus_URL'),
                        string(credentialsId: 'downloadrepo', variable: 'Nexus_REPO_ID'),
                        string(credentialsId: 'nexuspassword', variable: 'Nexus_PASSWORD'),
                        string(credentialsId: 'nexususername', variable: 'Nexus_USERNAME')
                    ]) {
                sh "curl -v -o  ${OUTPUTFILENAME} -u ${Nexus_USERNAME}:${Nexus_PASSWORD} ${Nexus_URL}/repository/${Nexus_REPO_ID}/${PACKAGE_NAME}/0.1.0/${PACKAGE_NAME}-${params.currentVersion}.tar.gz"
      // sh "curl -v -o build.tar.gz -u admin:admin http://34.42.7.89:8081/repository/mvp-react-release/mvprelease-react/0.1.0/mvprelease-react-0.1.0.30.tar.gz"        
                    }
        }
        }
        }


        stage("unzip artifact"){
            steps{
                script{
                    sh 'ls'
                    sh "tar -xvf ${OUTPUTFILENAME} build"
                     sh 'ls'
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
                        transfers: [sshTransfer(flatten: false, sourceFiles: "build/**")])
                                       
                    ])                }
            }
        }

         stage('start nginx') {
            steps {
                script {
                      sh "tar -xf ${OUTPUTFILENAME} build"
                        sshPublisher(publishers: [sshPublisherDesc(configName: SSHCONFIGNAME, transfers: [
                                    sshTransfer(
                                        execCommand: "sudo cp -rf /home/ubuntu/build /var/www/html/ && rm -rf /home/ubuntu/build && sudo systemctl restart nginx",
                                        execTimeout: 120000
                                    )
                                ])
                    ])                }
               
                
            }
        }
    }
}

