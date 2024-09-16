#!/bin/bash

echo "\n################################################################"
echo "#                                                              #"
echo "#                     ***SS training***                        #"
echo "#                  Sonarqube  Installation                     #"
echo "#                                                              #"
echo "################################################################"

# Installing necessary packages
echo "\n\n*****Installing necessary packages"
sudo apt-get update -y > /dev/null 2>&1
#sudo apt-get install -y default-jre unzip > /dev/null 2>&1
sudo apt-get install -y openjdk-17-jdk unzip > /dev/null 2>&1
echo "            -> Done"

# Downloading SonarQube 10.6.0 version to OPT folder
echo "*****Downloading SonarQube 10.6.0 version"
cd /opt 
sudo rm -rf sonarqube*
sudo wget -q https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.6.0.92116.zip
sudo unzip -q sonarqube-10.6.0.92116.zip -d /opt/sonarqube 1>/dev/null
sudo rm -rf sonarqube-10.6.0.92116.zip
echo "            -> Done"

# Changing Ownership as Sonarqube Does not work with Root User
echo "*****Changing Ownership of file to Ubuntu User"
sudo chown -R ubuntu: /opt/sonarqube/*
echo "            -> Done"

# Starting SonarQube Service
echo "*****Starting SonarQube Server"
cd /opt
sudo su -m ubuntu -c "./sonarqube/sonarqube-10.6.0.92116/bin/linux-x86-64/sonar.sh start 1>/dev/null"


# Check if SonarQube is working
echo "\n################################################################ \n"
if [ $? -eq 0 ]; then
        echo "SonarQube installed Successfully"
        echo "Access SonarQube using $(curl -s ifconfig.me):9000"
else
        echo "SonarQube installation failed"
fi
echo "\n################################################################ \n"
