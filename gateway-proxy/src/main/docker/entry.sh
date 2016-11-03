#!/usr/bin/env bash

echo "Stalling for Config Server"
wget --quiet --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 --tries inf http://config-server:8888/

echo "Stalling for Service Discovery"
wget --quiet --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 --tries inf http://service-discovery:8761/

echo "Starting Application"
java -Djava.security.egd=file:/dev/./urandom -jar /app.jar