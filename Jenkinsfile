pipeline {
    agent any
    environment {
        MAVEN_HOME = '/usr/share/maven'  // maven home directory.  Obtain home directory using mvn --version
        ARTIFACT_PATH = 'JJtechBatchApp/target/JJtechBatchApp.war'
        TOMCAT_URL = 'http://18.197.131.231:8080/'  // replace with your tomcat url

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
            // https://www.jenkins.io/doc/pipeline/steps/workflow-durable-task-step/
                dir('JJtechBatchApp'){
                sh "${MAVEN_HOME}/bin/mvn clean compile test package"
            }
         }
        }

        // Plugins Reference: 
        // using the Sonar Plugin https://www.jenkins.io/doc/pipeline/steps/sonar/#waitforqualitygate-wait-for-sonarqube-analysis-to-be-completed-and-return-quality-gate-status

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

            // use maven's built-in Distribution capability to push to nexus
        stage('Publish to Nexus with maven built-in capability') {
            steps {
                dir('JJtechBatchApp') {
                    sh "${MAVEN_HOME}/bin/mvn -s settings.xml deploy"
              } 
            }   
        }

        // publish via Nexus Plugin
        //https://help.sonatype.com/en/nexus-platform-plugin-for-jenkins.html
        //https://www.jenkins.io/doc/pipeline/steps/nexus-artifact-uploader/
        
        stage('Publish to Nexus using Jenkins-nexus-plugin') {      

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
                        nexusUrl: '18.196.157.115:8081/',  //replace me 
                        repository: repository,
                        groupId: groupId,
                        version: version,
                        credentialsId: 'nexus-credentials-id', // (optional) replace me
                        artifacts: [
                            [artifactId: artifactId, file: artifactPath, type: 'war']
                        ]
                    )
                }
            }
        }

        // requires the Deploy to Container Plugin 
        //https://www.jenkins.io/doc/pipeline/steps/deploy/?utm_source=chatgpt.com#deploy-deploy-warear-to-a-container
        stage('Deploy to Tomcat Server') {
            steps {
                deploy adapters: [tomcat9(credentialsId: 'tomcat-creds', url: "${TOMCAT_URL}")],  // (optional) replace credential
                       war: "${ARTIFACT_PATH}"
                       //contextPath: '/JJtechBatchApp/welcome'
                      
            }
        }
    
    }

    post {
        success {
            echo 'Build and Deployment was Successful!'
        }
        failure {
            echo 'Build or Deployment Failed. Verify logs for debug details.'
        }
    }
    
}
