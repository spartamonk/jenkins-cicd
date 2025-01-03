# JENKINS CI-CD end-2-end Project
For simulation of a ci-cd project that utilizes maven, JUnit, Jenkins, Sonartype Nexus, SonarQube, and Tomcat Webser. 



### Prequisites 
- 4 Servers (`jenkins_mvn_server`, `nexus_server`, `sonar_server`, and `tomcat_server`)
- type: ubuntu 
- size: t2.medium 
- SG: open necessary service ports (jenkins: 8080, sonarqube: 9000, nexus:8081, tomcat:8080)

## On `jenkins_mvn_server` Install JAVA (a prerequisite for Jenkins and Maven)
Add required dependencies for the jenkins package

     sudo apt update && sudo apt install fontconfig openjdk-17-jre -y

     java -version 


### Install ***Maven*** and  [Jenkins](https://www.jenkins.io/doc/book/installing/linux/#debianubuntu). 

Downloads the GPG key required to verify the authenticity of Jenkins packages and saves it in the /usr/share/keyrings/ directory.

     sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

Add the Jenkins repository to your system's APT sources list and ensures that the repository is signed using the GPG key you downloaded

    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]"  https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null


Update and Install Jenkins and Maven

    sudo apt update && sudo apt install jenkins maven -y


### Verify Installations and  Access Jenkins UI

    mvn -h 

You can enable, Start and Check Status of jenkins 

    sudo systemctl enable jenkins

    sudo systemctl start jenkins

    sudo systemctl status jenkins

#### Access Jenkins UI and Configure Jenkins:
On browser, paste http://`<public-IP-jenkins-server>`:8080



## Install Nexus and SonarQube on `nexus_server` and `sonar_server` respectively. 
Follow instructructions ***[here]***(https://github.com/mecbob/maven-nexus-sonarQube-demo)
    
