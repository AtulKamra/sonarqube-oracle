#!/bin/bash -e

if [ "$1" = 'sonar' ]; then
  if [ ! -e ${SONARQUBE_HOME}/conf/sonar.properties.default ]; then
    cp ${SONARQUBE_HOME}/conf/sonar.properties ${SONARQUBE_HOME}/conf/sonar.properties.default

    # Setting up Variables
    SONARQUBE_JDBC_URL=${SONARQUBE_JDBC_URL:-jdbc:h2:tcp://localhost:9092/sonar}
    SONARQUBE_JDBC_USERNAME=${SONARQUBE_JDBC_USERNAME:-sonar}
    SONARQUBE_JDBC_PASSWORD=${SONARQUBE_JDBC_PASSWORD:-sonar}

    # Setting the access to the Database
    sed -i 's|^#sonar.jdbc.username=sonar|sonar.jdbc.username='"${SONARQUBE_JDBC_USERNAME}"'|g' ${SONARQUBE_HOME}/conf/sonar.properties
    sed -i 's|^#sonar.jdbc.password=sonar|sonar.jdbc.password='"${SONARQUBE_JDBC_PASSWORD}"'|g' ${SONARQUBE_HOME}/conf/sonar.properties
    sed -i 's|^#sonar.jdbc.url=jdbc:h2:tcp://localhost:9092/sonar|sonar.jdbc.url='"${SONARQUBE_JDBC_URL}"'|g' ${SONARQUBE_HOME}/conf/sonar.properties

    if [ -d /docker-entrypoint-init.d ]; then
      for f in /docker-entrypoint-init.d/*.sh; do
        [ -f "$f" ] && . "$f"
      done
    fi
  fi

  exec ${SONARQUBE_HOME}/bin/linux-x86-64/sonar.sh console
fi

exec "$@"
