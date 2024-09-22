#start and stop the sonar server
#cd /opt/sonarqube
#./bin/linux-x86-64/sonar.sh start
#./bin/linux-x86-64/sonar.sh stop
# we cannot start the sonar with the root user we should other users like ubuntu or any other user

#!/bin/bash

echo -e "\n################################################################"
echo "#                                                              #"
echo "#                     ***SS training***                        #"
echo "#                  Sonarqube Installation                      #"
echo "#                                                              #"
echo "################################################################"

# Installing necessary packages
echo -e "\n\n*****Installing necessary packages"
sudo apt-get update -y > /dev/null 2>&1
apt-get install -y openjdk-17-jre unzip wget > /dev/null 2>&1
echo "            -> Done"

# Fetch the latest SonarQube version from GitHub
echo "*****Fetching the latest SonarQube version"
LATEST_VERSION=$(curl -s https://api.github.com/repos/SonarSource/sonarqube/releases/latest | grep -oP '"tag_name": "\K[^"]+')

if [ -z "$LATEST_VERSION" ]; then
    echo "Failed to fetch the latest SonarQube version."
    exit 1
fi

LATEST_VERSION_ZIP="sonarqube-${LATEST_VERSION}.zip"
LATEST_VERSION_URL="https://binaries.sonarsource.com/Distribution/sonarqube/${LATEST_VERSION_ZIP}"

echo "            -> Latest version is ${LATEST_VERSION}"

# Downloading the latest SonarQube version to the OPT folder
echo "*****Downloading SonarQube ${LATEST_VERSION}"
cd /opt 
sudo rm -rf sonarqube*
sudo wget -q ${LATEST_VERSION_URL}
if [ $? -ne 0 ]; then
    echo "Failed to download SonarQube ${LATEST_VERSION}. Exiting."
    exit 1
fi

sudo unzip -q ${LATEST_VERSION_ZIP} -d /opt/sonarqube
if [ $? -ne 0 ]; then
    echo "Failed to unzip SonarQube ${LATEST_VERSION}. Exiting."
    exit 1
fi

sudo rm -rf ${LATEST_VERSION_ZIP}
echo "            -> Done"

# Changing Ownership as Sonarqube Does not work with Root User
echo "*****Changing Ownership of file to Ubuntu User"
sudo chown -R ubuntu: /opt/sonarqube/*
if [ $? -ne 0 ]; then
    echo "Failed to change ownership of SonarQube files. Exiting."
    exit 1
fi
echo "            -> Done"

# Starting SonarQube Service
echo "*****Starting SonarQube Server"
SONARQUBE_DIR=$(find /opt/sonarqube -maxdepth 1 -type d -name 'sonarqube-*' | head -n 1)
if [ -z "$SONARQUBE_DIR" ]; then
    echo "SonarQube directory not found. Exiting."
    exit 1
fi

echo "Using SonarQube directory: $SONARQUBE_DIR"
sudo su -m ubuntu -c "$SONARQUBE_DIR/bin/linux-x86-64/sonar.sh start 1>/dev/null"
if [ $? -ne 0 ]; then
    echo "Failed to start SonarQube. Exiting."
    exit 1
fi

# Wait for SonarQube to start up
echo "*****Waiting for SonarQube to start"
sleep 30  # Adjust the sleep time based on your system's startup time

# Check if SonarQube is working
echo -e "\n################################################################ \n"
if curl -s http://localhost:9000 | grep -q 'SonarQube'; then
    echo "SonarQube installed Successfully"
    echo "Access SonarQube using http://$(curl -s ifconfig.me):9000"
else
    echo "SonarQube installation failed or service is not available"
fi
echo -e "\n################################################################ \n"
