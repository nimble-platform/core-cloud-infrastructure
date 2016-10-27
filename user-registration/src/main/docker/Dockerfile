FROM nimbleplatform/base-image:latest
VOLUME /tmp
ADD user-registration-0.0.1.jar app.jar
ADD entry.sh entry.sh
RUN bash -c 'touch /app.jar'
EXPOSE 80
ENTRYPOINT ["sh", "/entry.sh"]