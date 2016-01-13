# sonarqube-oracle

This is sonarqube 5.1.2 version image. You can easily connect to external database such as oracle.

Steps for building the sonarqube oracle image.

1) Download the docker-entrypoint.sh and Dockerfile in any folder. 

2) Download the oracle jdbc driver from oracle website - http://www.oracle.com/technetwork/database/features/jdbc/default-2280470.html

3) All 3 files docker-entrypoint.sh, Dockerfile and ojdbc7.jar (which is oracle thin driver for connecting to oracle db) should be present in current folder from where we want to build the sonarqube image.

Build the sonarqube image using command docker build -t .

4) Run the image in container using below command docker run -d --name -p 9000:9000 -e SONARQUBE_JDBC_USERNAME=sonar -e SONARQUBE_JDBC_PASSWORD=sonar -e SONARQUBE_JDBC_URL=jdbc:oracle:thin:@//IPAddress:Port#/orcl 

5) Validate JDBC URL using http://localhost:9000/system. You should be able to see the Oracle JDBC URL 

