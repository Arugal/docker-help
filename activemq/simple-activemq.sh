#!/bin/sh


docker run -d --name dc-active-mq -p 61616:61616 -p 8161:8161 webcenter/activemq
