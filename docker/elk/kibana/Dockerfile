FROM kibana:latest
MAINTAINER Salzburg Research <nimble-srfg@salzburgresearch.at>

COPY config/kibana.yml /opt/kibana/config/
COPY entrypoint.sh /tmp/entrypoint.sh
RUN chmod +x /tmp/entrypoint.sh

# RUN kibana plugin --install elastic/sense

CMD ["/tmp/entrypoint.sh"]
