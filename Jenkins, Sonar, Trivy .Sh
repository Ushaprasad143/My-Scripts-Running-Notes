JENKINS SET UP STEPS:

INSTALL JENKINS ON LINUX METHOD -2 --- (Ubuntu JENKINS Run on Different Port)

sudo apt update -y
sudo apt install openjdk-11-jre -y
sudo wget https://updates.jenkins.io/download/war/2.387.3/jenkins.war
java -jar Jenkins.war 
java -jar Jenkins.war --httpPort=8082

----------------------------------------------


--- INSTALL JENKINS ON LINUX METHOD -1 ---

sudo apt update -y
sudo apt install openjdk-11-jre -y

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y 
sudo apt-get install jenkins -y

sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
---------------------------------------------------------

CHANGE THE PORT NUMBER FOR JENKINS:

find / -name jenkins.service
vim /usr/lib/systemd/system/jenkins.service (Line Number:67)
systemctl daemon-reload
systemctl restart jenkins.service
systemctl status jenkins.service


---------------------------------------------------

SONARQUBE SCRIPT STEPS:

apt  install docker.io
docker -v
sudo chmod 666 /var/run/docker.sock
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
docker ps
apt install maven -y (install in jenkins server)

pipeline {
    agent any
    
    tools{
        jdk 'jdk11'
        maven 'maven3'
    }
    
    environment{
        SCANNER_HOME=tool 'sonar-scanner'
    }

    stages {
        stage('git checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Ushaprasad143/Petclinic-Jenkins-Project.git'
            }
        }
        
        stage('compile') {
            steps {
                sh 'mvn clean compile'
            }
        }
        stage('Test Cases') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Sonarqube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Petclinic \
                    -Dsonar.java.binaries=. \
                    -Dsonar.projectKey=Petclinic '''
                }
            }
        }
    }
}



TRIVY INSTALLATION:

sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy
trivy --version
