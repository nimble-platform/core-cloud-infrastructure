#!/usr/bin/env bash

cf delete sample-client -f
cf delete service-discovery -f
cf delete config-server -f
cf delete proxy-server -f
cf delete hystrix-dashboard -f
cf delete user-registration -f

sleep 2s

cf delete-service discovery-service -f
cf delete-service config-service -f