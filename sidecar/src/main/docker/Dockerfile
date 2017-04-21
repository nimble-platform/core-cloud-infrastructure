FROM nimbleplatform/nimble-base
MAINTAINER Salzburg Research <nimble-srfg@salzburgresearch.at>
VOLUME /tmp
ADD sidecar.jar /sidecar.jar
RUN bash -c 'touch /sidecar.jar'
EXPOSE 9097
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/sidecar.jar"]