#
#SonarQube Dockerfile for External Database
#
FROM java:openjdk-8u66-jdk

MAINTAINER Atul Kumar <kamraatul@gmail.com>

# Install SonarQube
ENV SONARQUBE_VERSION 5.1.2
ENV SONARQUBE_HOME /opt/sonarqube
# JDBC URL will be jdbc:oracle:thin:@//localhost:1520/orcl
ENV SONARQUBE_JDBC_URL jdbc:h2:tcp://localhost:9092/sonar
ENV SONARQUBE_JDBC_USERNAME sonar
ENV SONARQUBE_JDBC_PASSWORD sonar

WORKDIR /opt
RUN \
  wget http://dist.sonar.codehaus.org/sonarqube-${SONARQUBE_VERSION}.zip &&\
  unzip sonarqube-${SONARQUBE_VERSION}.zip &&\
  rm    sonarqube-${SONARQUBE_VERSION}.zip &&\
  ln -s sonarqube-${SONARQUBE_VERSION} ${SONARQUBE_HOME} &&\
  # Remove unnecessary files
  rm -r \
    ${SONARQUBE_HOME}/bin/linux-x86-32 \
    ${SONARQUBE_HOME}/bin/macosx-* \
    ${SONARQUBE_HOME}/bin/solaris-* \
    ${SONARQUBE_HOME}/bin/windows-*

# Upgrade SonarQube plugins
# - http://docs.sonarqube.org/display/PLUG/Plugin+Version+Matrix
# - http://www.sonarsource.com/category/plugins-news/
WORKDIR ${SONARQUBE_HOME}/lib/bundled-plugins
RUN \
  rm sonar-java-plugin-*.jar &&\
  wget --no-check-certificate https://sonarsource.bintray.com/Distribution/sonar-java-plugin/sonar-java-plugin-3.7.1.jar &&\
  rm sonar-scm-git-plugin-*.jar &&\
  wget http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/sonar-scm-git-plugin/1.1/sonar-scm-git-plugin-1.1.jar

WORKDIR ${SONARQUBE_HOME}/extensions/jdbc-driver/oracle

# Download the Driver and copy it in the extensions folder from where sonarqube expect the driver file.
# URL for downloading the Oracle jdbc thin driver - http://www.oracle.com/technetwork/database/features/jdbc/default-2280470.html
# Example for Oracle below command will look like COPY ojdbc7.jar ${SONARQUBE_HOME}/extensions/jdbc-driver/oracle/ojdbc7.jar
COPY ojdbc7.jar ${SONARQUBE_HOME}/extensions/jdbc-driver/oracle/ojdbc7.jar


# Add a directory to process setup scripts for the container
RUN mkdir /docker-entrypoint-init.d

COPY docker-entrypoint.sh /

WORKDIR ${SONARQUBE_HOME}

# forward sonar logs to docker log collector
RUN ln -sf /dev/stdout ${SONARQUBE_HOME}/logs/sonar.log

VOLUME ["$SONARQUBE_HOME/data", "$SONARQUBE_HOME/extensions"]

EXPOSE 9000
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sonar"]
