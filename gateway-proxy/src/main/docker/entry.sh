#!/usr/bin/env bash

echo "Stalling for Config Server"
while true; do
    nc -q 1 config-server 8888 2>/dev/null && break
done

echo "Stalling for Service Discovery"
while true; do
    nc -q 1 service-discovery 8761 2>/dev/null && break
done

echo "Starting Application"
java -Djava.security.egd=file:/dev/./urandom -jar /app.jar