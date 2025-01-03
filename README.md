# JENKINS CI-CD end-2-end Project
For simulation of a ci-cd project that utilizes maven, JUnit, Jenkins, Sonartype Nexus, SonarQube, and Tomcat Webser. 


# Setup
### Prequisites 
- 4 Servers (`jenkins_mvn_server`, `nexus_server`, `sonar_server`, and `tomcat_server`). 
NB: please use provided ***userdata scripts*** to install nexus, sonar and tomcat. See sections below. 

- type: ubuntu 
- size: t2.medium 
- SG: open necessary service ports (jenkins: 8080, sonarqube: 9000, nexus:8081, tomcat:8080)



## Install Nexus and SonarQube on `nexus_server` and `sonar_server` respectively. 
In order to install nexus and Sonar, please follow steps outlined [here](https://github.com/mecbob/maven-nexus-sonarQube-demo)
    

### Configure SonarQube

- create token
- create sonar-jenkins webhook (only after the Jenkins Server is available) this will be used in the pipeline. 


## Install and Configure Tomcat Server 

- use the tomcat_install.sh script as user data when launching the instance. 

#### Configure and Access Tomcat 

Access Tomcat Application from brower on default port 8080  **http://`<server-ip>`:8080**

***NB:*** 
Tomcat by default does not allow browser based login. Changing a default parameter in context.xml will resolve this issue. 
Find the **context.xml** file, and comment () Value ClassName field on files which are under webapp directory e.g. **manager/META-INF/context.xm**. 
After that restart tomcat services to effect these changes

    find / -name context.xml



In the tomcat home directory **/opt/tomcat/conf** , update users information in the **tomcat-users.xml**

    <role rolename="manager-gui"/>
	<role rolename="manager-script"/>
	<role rolename="manager-jmx"/>
	<role rolename="manager-status"/>
	<user username="admin" password="admin" roles="manager-gui, manager-script, manager-jmx, manager-status"/>
	<user username="deployer" password="deployer" roles="manager-script"/>
	<user username="tomcat" password="s3cret" roles="manager-gui"/>



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

- change admin credentials

##### Install and configure Plugins
Install the following  non default plugins
- SonarQube scanner
- NexusUploader
- Deploy to container

##### Create global credentials for pipeline
- Tomcat credentials : `tomcat-creds`
- Nexus credentials  : `nexus-credentials-id`



# DEMO

- Fork this repository into your github space and replace all placeholders highlighted in files, `settings.xml`, `pom.xml` and `Jenkinsfile` accordingly. 

### Create Jenkins Job with following high level steps. 
In Jenkins, create a new Job using the Pipeline Job with `poll scm`. 

- `New Item` (give a name) > Pipeline > OK

- `Build Triggers` > Poll SCM > Schedule ( H/2 * * * *)

- `Pipeline ` > Definition ( Pipeline script from SCM) >  follow on screen instructions. 

With a successful configuration,  Jenkins should poll scm every 2 minutes. 


-  Change src code and build again. 

- Access Appliction using Tomcat URL on browser. http://`<public-IP-jenkins-server>`:8080JJtechBatchApp/welcome



