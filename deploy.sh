#!/usr/bin/env bash

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

if [ "$1" == "--deploy-cf" ]; then

    # build projects
    mvn clean package

    ## deploying projects
    cf push -f config-server/manifest.yml
    deploy_service config-server config-service

    cf push -f service-discovery/manifest.yml
    deploy_service service-discovery discovery-service

    cf push -f gateway-proxyr/manifest.yml
    cf push -f hystrix-dashboard/manifest.yml

#    cf push -f sample-client/manifest.yml
#    cf push -f user-registration/manifest.yml

elif [ "$1" == "--reset-cf" ]; then

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

    # build docker images
    mvn -f config-server/pom.xml docker:build
    mvn -f service-discovery/pom.xml docker:build
    mvn -f gateway-proxy/pom.xml docker:build
    mvn -f hystrix-dashboard/pom.xml docker:build

else
    echo Wrong usage. Provide either --deploy-cf, --reset-cf or --docker-build as parameter.
    exit 1
fi

