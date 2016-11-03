#!/usr/bin/env bash

echoerr() { echo "$@" 1>&2; }

# Check Java version
version=$(java -version 2>&1 | sed 's/java version "\(.*\)\.\(.*\)\..*"/\1\2/; 1q')
if [[ "$version" < "18" ]]; then
    echoerr version is lower than 1.8
    exit 1
fi

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

if [ "$1" == "--cf-deploy" ]; then

    # build projects
    mvn clean package

    ## deploying projects
    cf push -f config-server/manifest.yml
    deploy_service config-server config-service

    cf push -f service-discovery/manifest.yml
    deploy_service service-discovery discovery-service

    cf push -f gateway-proxy/manifest.yml
#    cf push -f hystrix-dashboard/manifest.yml

    cf push -f sample-client/manifest.yml
    cf push -f user-registration/manifest.yml

elif [ "$1" == "--cf-reset" ]; then

    cf delete sample-client -f
    cf delete service-discovery -f
    cf delete config-server -f
    cf delete gateway-proxy -f
    cf delete hystrix-dashboard -f
    cf delete user-registration -f

    sleep 2s

    cf delete-service discovery-service -f
    cf delete-service config-service -f

elif [ "$1" == "--docker-build" ]; then

    # build projects
    mvn clean package

    # build base image
    docker build -t nimbleplatform/nimble-base docker/nimble-base

    # build docker images
    mvn -f config-server/pom.xml docker:build
    mvn -f service-discovery/pom.xml docker:build
    mvn -f gateway-proxy/pom.xml docker:build
    mvn -f hystrix-dashboard/pom.xml docker:build

elif [ "$1" == "--docker-run" ]; then

    docker-compose -f docker/docker-compose.yml up

elif [ "$1" == "--docker-push" ]; then

    # base image
    docker push nimbleplatform/nimble-base

    # infrastructure images
    mvn -f config-server/pom.xml docker:push
    mvn -f service-discovery/pom.xml docker:push
    mvn -f gateway-proxy/pom.xml docker:push
    mvn -f hystrix-dashboard/pom.xml docker:push

else
    echo Wrong usage. Provide either --cf-deploy, --cf-reset, --docker-build or--docker-run as parameter.
    exit 2
fi

