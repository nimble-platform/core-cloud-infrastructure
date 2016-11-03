#!/usr/bin/env bash

echo "Stalling for Config Server"
wget --quiet --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 --tries inf http://config-server:8888/

echo "Starting Application"
java -Djava.security.egd=file:/dev/./urandom -jar /app.jar