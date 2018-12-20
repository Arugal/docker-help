FROM 31z4/storm:1.1.0

ENV STORM_TOPO_JAR="/topojar"

RUN mkdir -p "${STORM_TOPO_JAR}"; \
     chown -R "$STORM_USER:$STORM_USER" "${STORM_TOPO_JAR}"

RUN echo "Asia/Shanghai" > /etc/timezone

COPY docker-entrypoint.sh /

RUN chmod 775 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]