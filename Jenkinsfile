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
                        downloadartifact.nexusartifact(OUTPUTFILENAME,Nexus_USERNAME,Nexus_PASSWORD,Nexus_URL,Nexus_REPO_ID,PACKAGE_NAME,currentVersion)                  }
        }
        }
        }


        stage("unzip artifact"){
            steps{
                script{
                   unzipartifact.dowloadedartifact(OUTPUTFILENAME)
                }
            }
        }

         stage('Stop nginx and remote old version files') {
            steps {
                script {
                   stopnginx.stop(SSHCONFIGNAME)
                }
               
                
            }
        }



        stage('Deploy to VM') {
            steps {
                script {
                 deploytoVM.deploy(SSHCONFIG)
             }
            }
        }

         stage('start nginx') {
            steps {
                script {
                     startnginx.start(OUTPUTFILENAME,SSHCONFIGNAME) 
                }
               
                
            }
        }
    }
}

