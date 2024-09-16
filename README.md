# Pre-Requisite
Check the Compatible version SONAR version with java version as a pre-requisite and install unzip



# To install the java 11
sudo apt-get update,
sudo apt-get install -y openjdk-11-jre

# To install the java 17
sudo apt-get update,
sudo apt-get install -y openjdk-17-jdk

# Command to Switch the Java version
sudo update-alternatives --config java  ----> To switch between java version if we have multiple java version

# Sonar Operations
start and stop the sonar server
cd /opt/sonarqube
./bin/linux-x86-64/sonar.sh start
./bin/linux-x86-64/sonar.sh stop
# we cannot start the sonar with the root user we should use other users like ubuntu or any other user
