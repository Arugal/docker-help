#!/bin/sh
JAVA_OPTS="-Dserver.port=$SERVER_PORT -Dcsp.sentinel.dashboard.server=localhost:$SERVER_PORT -Dproject.name=$SERVER_NAME"

echo $JAVA_OPTS

java $JAVA_OPTS -jar ./sentinel-dashboard.jar