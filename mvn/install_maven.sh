#!/bin/sh

# maven version
HIGH_VERSION='3'
LOW_VERSION='.6.0'

if [ -n "$1" ]; then
    HIGH_VERSION=$1
fi

if [ -n "$2" ]; then
    LOW_VERSION=$2
fi

echo $HIGH_VERSION$LOW_VERSION

# download Maven
MAVEN_FILE="apache-maven-$HIGH_VERSION$LOW_VERSION-bin.tar.gz"
cd /usr && \
    wget http://mirror.bit.edu.cn/apache/maven/maven-$HIGH_VERSION/$HIGH_VERSION$LOW_VERSION/binaries/$MAVEN_FILE && \
    tar -zxvf ./$MAVEN_FILE && \
    rm ./$MAVEN_FILE

# the environment variable
cat >> /etc/profile << EOF
# maven
export M2_HOME="/usr/apache-maven-$HIGH_VERSION$LOW_VERSION"
export MAVEN_OPTS="-Xms64M -Xmx128M"
export PATH=$PATH:/usr/apache-maven-$HIGH_VERSION$LOW_VERSION/bin
EOF
source /etc/profile

# echo mvn version
mvn -v