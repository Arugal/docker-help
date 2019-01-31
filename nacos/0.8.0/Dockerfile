FROM openjdk:8-jre-alpine3.8

RUN wget -P /usr https://github.com/alibaba/nacos/releases/download/0.8.0/nacos-server-0.8.0.tar.gz && \
    tar -zxvf nacos-server-0.8.0.tar.gz && \
    rm nacos-server-0.8.0.tar.gz
    
RUN chmod -R +x /usr/nacos/bin/*

RUN echo "Asia/Shanghai" > /etc/timezone

WORKDIR /usr/nacos

EXPOSE 8848

ENTRYPOINT ["./bin/startup.sh"]

CMD ["-m", "standalone"]