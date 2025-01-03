pipeline {
    agent any
    environment {
       // AWS_REGION = 'us-east-1'
        MAVEN_HOME = '/usr/share/maven'  // maven home directory.  Obtain home directory using mvn --version
        ARTIFACT_PATH = 'target/JJtechBatchApp.war'
        TOMCAT_URL = 'http://18.197.131.231:8080/'

    }
    stages {
        stage('Checkout Code') {
            steps {
               // replace git URL below with your git repo url
                git branch: 'main', url: 'https://github.com/mecbob/jenkins-cicd.git'
            }
        }

        stage('Build with Maven') {
            steps {
                dir('JJtechBatchApp'){
                sh "${MAVEN_HOME}/bin/mvn clean compile test package"
            }
         }
        }

        stage('Scan') {
            steps {
                 dir('JJtechBatchApp') {
                 withSonarQubeEnv(installationName: 'jenkins-sonar') { 
                    // sh './mvn clean org.sonarsource.scanner.maven:sonar-maven-plugin:3.9.0.2155:sonar'   To use a specific version of sonarqube
                    sh "${MAVEN_HOME}/bin/mvn clean sonar:sonar"       // uses the installed sonar plugin
                 } }
            }
        }


        // For quality gates, the pipeline will wait for sonar to send back a success quality gate check.  : https://docs.sonarsource.com/sonarqube-server/9.9/analyzing-source-code/scanners/jenkins-extension-sonarqube/
        stage("Quality Gate") {        
             steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

            // use maven publish capability to push to nexus
        stage('Publish to Nexus with maven built-in capability') {
            steps {
                dir('JJtechBatchApp') {
                    sh "${MAVEN_HOME}/bin/mvn -s settings.xml deploy"
              } 
            }   
        }

        // publish via plugin
        stage('Publish to Nexus using Jenkins-nexus-plugin') {      //https://help.sonatype.com/en/nexus-platform-plugin-for-jenkins.html 
            steps {
                script {
                    // Define artifact details
                    def artifactPath = 'JJtechBatchApp/target/JJtechBatchApp.war'
                    def groupId = 'com.jjtech'
                    def artifactId = 'JJtechBatchApp.war'
                    def version = '1.0.0'
                    def repository = 'maven-releases'

                    nexusArtifactUploader(
                        nexusVersion: 'nexus3',
                        protocol: 'http',
                        nexusUrl: '18.196.157.115:8081/',
                        repository: repository,
                        groupId: groupId,
                        version: version,
                        credentialsId: 'nexus-credentials-id',
                        artifacts: [
                            [artifactId: artifactId, file: artifactPath, type: 'war']
                        ]
                    )
                }
            }
        }


        stage('Deploy to Tomcat Server') {
            steps {
                deploy adapters: [tomcat9(credentialsId: 'tomcat-creds', url: "${TOMCAT_URL}")], 
                       //contextPath: '/YourApp',
                       contextPath: '/JJtechBatchApp/welcome'
                       war: "${ARTIFACT_PATH}"
            }
        }



        
                  



        // stage('Initialize Terraform') {
        //     steps {
        //         sh 'terraform init'
        //     }
        // }
        // stage('Plan Terraform') {
        //     steps {
        //         sh 'terraform plan -out=tfplan'
        //     }
        // }
        // stage('Apply Terraform') {
        //     steps {
        //         input message: "Approve deployment?", ok: "Deploy"
        //         sh 'terraform apply tfplan'
        //     }
        // }
    }
}
