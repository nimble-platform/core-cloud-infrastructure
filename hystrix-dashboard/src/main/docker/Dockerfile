FROM java:8
MAINTAINER Salzburg Research <nimble-srfg@salzburgresearch.at>
VOLUME /tmp
ADD hystrix-dashboard-0.0.1.jar app.jar
ADD entry.sh entry.sh
RUN bash -c 'touch /app.jar'
EXPOSE 9080
ENTRYPOINT ["sh", "entry.sh"]