sudo apt update -y
sudo apt install openjdk-11-jre -y
sudo apt-get install maven -y





##################----INSTALL TOMCAT----##################
cd /opt
sudo wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.90/bin/apache-tomcat-9.0.90.tar.gz (Search chrome dlcdn tomcat)

sudo tar -xvf apache-tomcat-9.0.90.tar.gz

sudo su


cd /opt/apache-tomcat-9.0.90/conf
sudo vi tomcat-users.xml
# ---add-below-line at the end (2nd-last line)----
# <user username="admin" password="admin1234" roles="admin-gui, manager-gui"/>

sudo ln -s /opt/apache-tomcat-9.0.90/bin/startup.sh /usr/bin/startTomcat
sudo ln -s /opt/apache-tomcat-9.0.90/bin/shutdown.sh /usr/bin/stopTomcat

sudo vi /opt/apache-tomcat-9.0.90/webapps/manager/META-INF/context.xml

comment:
<!-- Valve className="org.apache.catalina.valves.RemoteAddrValve"
  allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->

sudo vi /opt/apache-tomcat-9.0.90/webapps/host-manager/META-INF/context.xml

comment:
<!-- Valve className="org.apache.catalina.valves.RemoteAddrValve"
  allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->

sudo stopTomcat
sudo startTomcat

sudo cp target/*.war /opt/apache-tomcat-9.0.65/webapps/

Tomcat Deployment PIPELINE:


PIPELINE:

pipeline {
    agent any

    tools{
        jdk 'jdk11'
        maven 'maven3'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Ushaprasad143/Petclinic-Jenkins-Project.git'
            }
        }
        
         
         stage('Compile') {
            steps {
                sh "mvn clean compile"
            }
        }
        
         stage('Build') {
            steps {
                sh "mvn clean package -DskipTests=true"
            }
        }
        
        stage('Deploy to Tomcat') {
            steps {
                sh "cp target/petclinic.war /opt/apache-tomcat-9.0.90/webapps"
            }
        }
        
       
       
        
       
       
       
        
    }
}
