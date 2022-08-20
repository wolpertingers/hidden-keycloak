#!/bin/bash
function cleanup {
  printf '\U1F433 %s\n' "Stopping Docker containers"
  docker-compose down --volumes
}

trap cleanup EXIT

# build sms authenticator extension
mvn clean package -f ../keycloak-sms-authenticator/pom.xml -DskipTests
if [[ "$?" -ne 0 ]] ; then
  echo 'could not run maven package'; exit $rc
fi

# start docker
docker-compose up --build
