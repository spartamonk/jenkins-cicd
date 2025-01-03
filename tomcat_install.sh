#!/bin/bash

# Define variables
TOMCAT_VERSION="9.0.98"  # Change as per your desired version
TOMCAT_URL="https://downloads.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz"
#https://downloads.apache.org/tomcat/tomcat-9/v9.0.98/bin/apache-tomcat-9.0.98.tar.gz


# Update and install necessary packages
sudo apt update -y && sudo apt install -y wget tar 


# Install Java
sudo apt install fontconfig openjdk-17-jre -y

# Download and extract Tomcat
wget $TOMCAT_URL
sudo tar -xvzf apache-tomcat-${TOMCAT_VERSION}.tar.gz 
sudo mv apache-tomcat-9.0.98 /opt/tomcat

# enable script execution
sudo chmod +x /opt/tomcat/bin/*.sh


# create symlinks
sudo ln -s /opt/tomcat/bin/startup.sh /usr/local/bin/tomcatup
sudo ln -s /opt/tomcat/bin/shutdown.sh /usr/local/bin/tomcatdown

tomcatup


# # Add users and roles to tomcat-users.xml

# TOMCAT_USERS_FILE="/opt/tomcat/conf/tomcat-users.xml"
# sudo bash -c "cat > $TOMCAT_USERS_FILE << 'EOF'
# <tomcat-users xmlns=\"http://tomcat.apache.org/xml\"
#               xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
#               xsi:schemaLocation=\"http://tomcat.apache.org/xml tomcat-users.xsd\" 
#               version=\"1.0\">

#     <role rolename=\"manager-gui\"/>
#     <role rolename=\"manager-script\"/>
#     <role rolename=\"manager-jmx\"/>
#     <role rolename=\"manager-status\"/>
#     <user username=\"admin\" password=\"admin\" roles=\"manager-gui,manager-script,manager-jmx,manager-status\"/>
#     <user username=\"deployer\" password=\"deployer\" roles=\"manager-script\"/>
#     <user username=\"tomcat\" password=\"s3cret\" roles=\"manager-gui\"/>

# </tomcat-users>
# EOF"



# # Define the file path

# FILE_PATH="/opt/tomcat/webapps/manager/META-INF/context.xml"

# # Ensure the file exists
# if [ -f "$FILE_PATH" ]; then
#   # Comment out the specific Valve block (multi-line)
#   sed -i '/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/,/\/>/ s/^/<!-- /; s/$/ -->/' "$FILE_PATH"
#   echo "The specified Valve block has been commented out in $FILE_PATH."
# else
#   echo "File $FILE_PATH does not exist."
# fi



##start and stop tomcat 
tomcatdown
tomcatup