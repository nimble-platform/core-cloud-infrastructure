FROM java:8
MAINTAINER Salzburg Research <nimble-srfg@salzburgresearch.at>
RUN apt-get update && apt-get install -y netcat
VOLUME /tmp
ADD gateway-proxy-0.0.1.jar app.jar
ADD entry.sh entry.sh
RUN bash -c 'touch /app.jar'
EXPOSE 80
ENTRYPOINT ["sh", "entry.sh"]