# Maven, Tomcat & Nexus Repo installation on EC2 instance

### Pre-requisites for both Maven & Tomcat Setup
1. T2.Micro Amazon Linux 2023 EC2 instance with Java v17
   ```sh
   yum install java-17 -y 
   ``` 
2. Use the command below to find your jdk installation path
   ```sh 
   find /usr/lib/jvm/java-17 | head -n 3
   ```
3. Edit the ~/.bash_profile script and add the following ENV - JAVA_HOME=/path_to_jdk_installation
4. Check the class video for clarity

### Pre-requisites for Nexus Repo

1. T3.Medium Amazon Linux 2023 EC2 instance with Java v1.8* 
   ```sh
   yum install java-1.8* -y
   ```
2. Use the command below to find your jdk installation path
   ```sh
   find /usr/lib/jvm/java-1.8* | head -n 3 
   ```
3. Edit the ~/.bash_profile script and add the following ENV - JAVA_HOME=/path_to_jdk_installation
4. Check the class video for clarity

### Install Nexus Repo
1. Download Nexus Repo Installation from https://help.sonatype.com/repomanager3/product-information/download
   ```sh
   # Change directory to /opt
   cd /opt
   wget https://download.sonatype.com/nexus/3/nexus-3.57.0-01-unix.tar.gz
   tar -xvzf /opt/nexus-3.57.0-01-unix.tar.gz
   ```
2. Add the Java ENV path to ~/.bash_profile
    ```sh
    vi ~/.bash_profile
    JAVA_HOME=/path_to_jdk_installation
    # Add BJava to PATH in the ~/.bash_profile
    PATH=$PATH:$HOME/bin:$JAVA_HOME
    ```
3. Nexus is accessible on Port 8081, So configure your Security Group to allow connection on port 8081 to your nexus repo
4. Watch the Class Video for full configuration details.

### Install Apache Maven
1. Download Maven packages from https://maven.apache.org/download.cgi
    ```sh
    # Change directory to /opt
    cd /opt
    wget https://dlcdn.apache.org/maven/maven-3/3.9.3/binaries/apache-maven-3.9.3-bin.tar.gz
    tar -xvzf /opt/apache-maven-3.9.3-bin.tar.gz
    ```
2. Add the maven ENV path to ~/.bash_profile
    ```sh
    vi ~/.bash_profile
    M2_HOME=/opt/apache-maven-3.9.3
    M2=/opt/apache-maven-3.9.3/bin
    # Add Both Maven and Java to PATH in the ~/.bash_profile
    PATH=$PATH:$HOME/bin:$JAVA_HOME:$M2_HOME:$M2
    ```
### Install Apache Tomcat
1. Download tomcat packages from  https://tomcat.apache.org/download-90.cgi
   ```sh 
   # Change directory to /opt
   cd /opt
   wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.78/bin/apache-tomcat-9.0.78.tar.gz
   tar -xvzf /opt/apache-tomcat-9.0.78.tar.gz
   ```
2. give executing permissions to startup.sh and shutdown.sh which are under bin. 
   ```sh
   chmod +x /opt/apache-tomcat-9.0.78/bin/startup.sh
   chmod +x /opt/apache-tomcat-9.0.78/bin/shutdown.sh
   ```

3. create link files for tomcat startup.sh and shutdown.sh 
   ```sh
   ln -s /opt/apache-tomcat-9.0.78/bin/startup.sh /usr/local/bin/tomcatup
   ln -s /opt/apache-tomcat-9.0.78/bin/shutdown.sh /usr/local/bin/tomcatdown
   ```
#### Check point :
Using unique ports for each application is best practice in a production environment. But tomcat and Jenkins runs on port 8080. Hence, lets change tomcat port number to 8090. Change port number in conf/server.xml file under tomcat directory /opt/apache-tomcat-9.0.78

   ```sh
 cd /opt/apache-tomcat-9.0.78/conf
 vi server.xml
# update port number in the "connecter port" field in server.xml
# start the tomcat after configuration update
tomcatup
   ```
#### Check point :
access tomcat application from browser on port 8090
 - http://<Public_IP>:8090
make sure to open port 8090 in your security group/firewall

4. Now Tomcat is accessible on port 8090. But tomcat application doesn't  allow to login from browser. changing a default parameter in context.xml does address this issue
   ```sh
   #search for context.xml
   cd /
   find / -name context.xml
   ```
5. The above command gives 4 webapp/..context.xml files. Comment out the valve section using (<!-- & -->) for the 4 files. Check class video for more info
   After that restart tomcat services to effect these changes
   ```sh 
   tomcatdown
   tomcatup
   ```
6. Update users information in the tomcat-users.xml file goto /opt/apache-tomcat-9.0.78/conf/tomcat-user.xml and add below users to the file
   ```sh
	<role rolename="manager-gui"/>
	<role rolename="manager-script"/>
	<role rolename="manager-jmx"/>
	<role rolename="manager-status"/>
	<user username="admin" password="admin" roles="manager-gui, manager-script, manager-jmx, manager-status"/>
	<user username="deployer" password="deployer" roles="manager-script"/>
	<user username="tomcat" password="s3cret" roles="manager-gui, admin-gui"/>
   ```
7. Restart serivce and try to login to tomcat application from the browser by clicking on the Manager app. This time it should be Successful.
