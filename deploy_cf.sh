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

# build projects
mvn clean package

## deploying projects
cf push -f config-server/manifest.yml
deploy_service config-server config-service
cf push -f service-discovery/manifest.yml
deploy_service service-discovery discovery-service
cf push -f sample-client/manifest.yml
cf push -f proxy-server/manifest.yml
#cf push -f hystrix-dashboard/manifest.yml
cf push -f user-registration/manifest.yml

