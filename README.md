# Microservice Infrastructure for the Nimble Platform
This repository sets up the general microservice infrastructure for the Nimble platform.

## Modules
The following sections describes each module briefly.

### Config Server (config-server)
The module 'config-server' is in charge of the central configuration. It fetches the config from a public git repository.
Please see application.yml for further details.

### Service Discovery (service-discovery)
Netflix Eureka is used as service discovery and registration tool.

### Gateway Proxy Server (gateway-proxy)
The public entry point is a Netlix Zuul service, which is configured using the central configuration server.

### Hystrix Dashboard (hystrix-dashboard)
The circuit breaker pattern is implemented using Netflix Hystrix. This dashboard provides graphical information about the current state of the system.

## Deployment

Currently the infrastructure can be deployed using Cloud Foundry or Docker. The following sections provide more information. 
Please make sure to have all dependencies installed (or running).

### Cloud Foundry

**Dependencies:**

* Cloud Foundry Command Line Interface (CLI)
* Maven 3

In order to deploy the infrastructure execute 

```shell
./deploy.sh --cf-deploy
```

with the Cloud Foundry CLI tool installed and properly authenticated. This may take a couple of minutes, so grab a cup of coffee in the meantime.
To reset all applications and services execute the following the command.

```shell
./deploy.sh --cf-reset
```

### Docker

* Docker (running)
* Docker Compose
* Maven 3

Execute the following command with Docker preinstalled.

```shell
./deploy.sh --docker-build
./deploy.sh --docker-run
```
