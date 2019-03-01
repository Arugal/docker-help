FROM openjdk:8-jre-alpine3.8

ENV SERVER_PORT=10001
ENV SERVER_NAME=sentinel-dashboard
ENV SENTINEL_DASHBOARD_VERSION 1.4.1

ADD docker-entrypoint.sh /home/docker-entrypoint.sh

RUN chmod +x /home/docker-entrypoint.sh

RUN wget -P /home https://github.com/alibaba/Sentinel/releases/download/$SENTINEL_DASHBOARD_VERSION/sentinel-dashboard-$SENTINEL_DASHBOARD_VERSION.jar && \
    mv /home/sentinel-dashboard-$SENTINEL_DASHBOARD_VERSION.jar /home/sentinel-dashboard.jar

EXPOSE 10001

WORKDIR /home

ENTRYPOINT ["./docker-entrypoint.sh"]