#!/usr/bin/env bash

set -e    # Exit immediately if a command exits with a non-zero status.

function app_domain(){
  D=`cf apps | grep $1 | tr -s ' ' | cut -d' ' -f 6 | cut -d, -f1`
  echo $D
}

function deploy_service(){
    N=$1
    D=`app_domain $N`
    SN=$2
    JSON="'"'{"url":"http://'$D'"}'"'"
    echo cf cups $SN -p $JSON
    cf cups $SN -p $JSON
    if [ "$?" -ne "0" ]; then
       echo cf uups $SN -p $JSON
       cf uups $SN -p $JSON
    fi
}

if [ "$1" == "cf-deploy" ]; then

    # build projects
    mvn clean package

    ## deploying projects
    cf push -f config-server/manifest.yml
    deploy_service config-server config-service

    cf push -f service-discovery/manifest.yml
    deploy_service service-discovery discovery-service

    cf push -f gateway-proxy/manifest.yml
    cf push -f hystrix-dashboard/manifest.yml

elif [ "$1" == "cf-reset" ]; then

    cf delete sample-client -f
    cf delete service-discovery -f
    cf delete config-server -f
    cf delete gateway-proxy -f
    cf delete hystrix-dashboard -f
    cf delete user-registration -f

    sleep 2s

    cf delete-service discovery-service -f
    cf delete-service config-service -f

elif [ "$1" == "docker-build" ]; then

    # build projects
    mvn clean package

    # build base image
    docker build -t nimbleplatform/nimble-base docker/nimble-base

    # build microservice images
    mvn -f config-server/pom.xml docker:build
    mvn -f service-discovery/pom.xml docker:build
    mvn -f gateway-proxy/pom.xml docker:build
    mvn -f hystrix-dashboard/pom.xml docker:build
    mvn -f sidecar/pom.xml docker:build

elif [ "$1" == "docker-run" ]; then

    # start up all containers (detached mode)
    docker-compose -f docker/docker-compose.yml -f docker/uaa/docker-compose.yml --project-name nimbleinfra up -d

elif [ "$1" == "docker-logs" ]; then

    # connect to logs of all containers and follow them
    docker-compose -f docker/docker-compose.yml -f docker/uaa/docker-compose.yml --project-name nimbleinfra logs -f

elif [ "$1" == "docker-stop" ]; then

    docker-compose -f docker/docker-compose.yml  -f docker/uaa/docker-compose.yml --project-name nimbleinfra down

elif [ "$1" == "docker-push" ]; then

    # base image
    docker push nimbleplatform/nimble-base

    # infrastructure images
    mvn -f config-server/pom.xml docker:push
    mvn -f service-discovery/pom.xml docker:push
    mvn -f gateway-proxy/pom.xml docker:push
    mvn -f hystrix-dashboard/pom.xml docker:push
    mvn -f sidecar/pom.xml docker:push

else
    echo Usage: $0 COMMAND
    echo Commands:
    echo -e "\tcf-deploy\n\tcf-reset"
    echo -e "\tdocker-build\n\tdocker-run\n\tdocker-logs\n\tdocker-stop\n\tdocker-push"
    exit 2
fi

