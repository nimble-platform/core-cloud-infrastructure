FROM nimbleplatform/base-image:latest
VOLUME /tmp
ADD service-discovery-0.0.1.jar app.jar
ADD entry.sh entry.sh
RUN bash -c 'touch /app.jar'
EXPOSE 8761
ENTRYPOINT ["sh", "/entry.sh"]