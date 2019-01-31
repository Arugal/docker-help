#!/bin/sh

docker build -t nacos:1.0 . && \
docker run -d --name nacos -p 8848:8848 -v /etc/localtime:/etc/localtime nacos:1.0