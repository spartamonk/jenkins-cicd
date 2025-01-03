# jenkins-cicd
or complete build of project



## Install JAVA (a prerequisite for Jenkins and Maven)
Add required dependencies for the jenkins package

     sudo apt update && sudo apt install fontconfig openjdk-17-jre -y

     java -version 


## Install ***Maven** and  [Jenkins](https://www.jenkins.io/doc/book/installing/linux/#debianubuntu). 

Downloads the GPG key required to verify the authenticity of Jenkins packages and saves it in the /usr/share/keyrings/ directory.

     sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

Add the Jenkins repository to your system's APT sources list and ensures that the repository is signed using the GPG key you downloaded

    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]"  https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null


Update and Install Jenkins and Maven

    sudo apt-get update && sudo apt-get install jenkins -y


## Verify Installations and  Access Jenkins UI

    mvn -h 

You can enable, Start and Check Status of jenkins 

    sudo systemctl enable jenkins

    sudo systemctl start jenkins

    sudo systemctl status jenkins

    
