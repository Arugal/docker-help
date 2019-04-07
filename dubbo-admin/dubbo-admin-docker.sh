#!/bin/sh

docker run -d \
-p 9001:8080 \
--name dubbo-admin \
--link zookeeper \
-e dubbo.registry.address=zookeeper://zookeeper:2181 \
-e dubbo.admin.root.password=root \
-e dubbo.admin.guest.password=guest \
chenchuxin/dubbo-admin 

