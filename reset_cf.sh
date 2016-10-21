#!/usr/bin/env bash

cf delete client-template -f
cf delete service-discovery -f
cf delete config-server -f

cf delete-service discovery-service -f
cf delete-service config-service -f