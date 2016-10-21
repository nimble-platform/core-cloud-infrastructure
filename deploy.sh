#!/usr/bin/env bash

# check args
if [ "$#" -ne "2" ]; then
   echo "Usage: sh deploy.sh EUREKA_URL CONFIG_URL";
   exit;
fi

EUREKA_URL=$1
CONFIG_URL=$2

# build projects
mvn clean package

# creating/updating services
cf cups discovery-service -p "'"'{"url": "'"$EUREKA_URL"'"}'"'"
if [ "$?" -ne "0" ]; then
   echo "Service already exists...trying to update service.";
   cf uups discovery-service -p "'"'{"url": "'"$EUREKA_URL"'"}'"'"
fi

cf cups config-service -p "'"'{"url": "'"$CONFIG_URL"'"}'"'"
if [ "$?" -ne "0" ]; then
   echo "Service already exists...trying to update service.";
   cf uups config-service -p "'"'{"url": "'"$CONFIG_URL"'"}'"'"
fi

## deploying projects
cf push -f config-server/manifest.yml
cf push -f service-discovery/manifest.yml
cf push -f client-template/manifest.yml
