# Microservice Infrastructure for the Nimble Platform
This repository sets up the general microservice infrastructure for the Nimble platform.

## Modules
The following sections describes each model briefly.

### Config Server (config-server)
The module 'config-server' is in charge of the central configuration. It fetches the config from a public git repository.
Please see application.yml for further details.

### Service Discovery (service-discovery)
Netflix Eureka is used as service discovery and registration tool.

### Edge Proxy Server (proxy-server)
The public entry point is a Netlix Zuul service, which is configured using the central configuration server.

### Hystrix Dashboard (hystrix-dashboard)
The circuit breaker pattern is implemented using Netflix Hystrix. This dashboard provides graphical information about the current state of the system.

## Deployment

In order to deploy the infrastructure execute 
```shell
sh cf.sh --deploy
```
with the Cloud Foundry CLI tool installed and properly authenticated.
To reset all applications and services execute the following the command.
```shell
sh cf.sh --reset
```
