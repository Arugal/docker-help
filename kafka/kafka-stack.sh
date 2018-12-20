#!/bin/sh

# 根据实际情况填写 zk 信息
# zk 主机名, 根据节点号递增
ZK_HOSTNAME="zookeeper"

# zk 集群节点数
ZK_NODE=3

# zk 集群内部端口
ZK_PORT=2181

# kafka 主机名
KAFKA_HOSTNAME="kafka"

# kafka 集群端口(宿主机端口), 根据节点数量递增
KAFKA_FIRST_PORT=9092

# kafka 节点数量
KAFKA_NODE=3

# 配置文件
KAFKA_YML="./kafka.yml"

# 指定网络
NETWORK="base_network"

# 打印帮助信息
usage(){
    echo "-create --p {port} --h {hostname} -- i{image name} --node {node num} --n {network} --zkh {zk hosrtname} --zknode {zk node num} --zkp {zk port} or -help {display help message}"
}

if [[ "$1" = '-help' || "$#" = '0' ]]; then
    usage
    exit 0
fi

# 生成 yml 文件
genreate_config(){
    KAFKA_IMAGE="kafka:latest"

    while [ -n "$2" ]
    do
    case $2 in 
        --p)
            KAFKA_FIRST_PORT=$3
            shift
            ;;
        --h)
            KAFKA_HOSTNAME=$3
            shift
            ;;
        --i)
            KAFKA_IMAGE=$3
            shift
            ;;
        --node)
            KAFKA_NODE=$3
            shift
            ;;
        --n)
            NETWORK=$3
            shift
            ;;
        --zkh)
            ZK_HOSTNAME=$3
            shift
            ;;
        --zknode)
            ZK_NODE=$3
            shift
            ;;
        --zkp)
            ZK_PORT=$3
            shift
            ;;
    esac
    shift
    done

    echo "version: '3.1'" > $KAFKA_YML
    echo "services:" >> $KAFKA_YML

    #   zk 集群地址
    ZOOKEEPER_CONNECT=""
    for ((NODE = 1; NODE <= $ZK_NODE; NODE++))
    do
        ZOOKEEPER_CONNECT=$ZOOKEEPER_CONNECT$ZK_HOSTNAME$NODE":"$ZK_PORT
        if [ $NODE != $ZK_NODE ]; then
            ZOOKEEPER_CONNECT=$ZOOKEEPER_CONNECT","
        fi
    done

    for ((NODE = 1; NODE <= $KAFKA_NODE; NODE++))
    do
        PORT=`expr $KAFKA_FIRST_PORT + $NODE - 1`
        echo "  $KAFKA_HOSTNAME$NODE:" >> $KAFKA_YML
        echo "    image: $KAFKA_IMAGE" >> $KAFKA_YML
        echo "    hostname: $KAFKA_HOSTNAME$NODE" >> $KAFKA_YML
        echo "    ports:" >> $KAFKA_YML
        echo "      - $PORT:9094" >> $KAFKA_YML
        echo "    environment:" >> $KAFKA_YML
        echo "      HOSTNAME_COMMAND: \"docker info | grep ^Name: | cut -d' ' -f 2\"" >> $KAFKA_YML
        echo "      KAFKA_ZOOKEEPER_CONNECT: "$ZOOKEEPER_CONNECT >> $KAFKA_YML
        echo "      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: INSIDE:PLAINTEXT,OUTSIDE:PLAINTEXT" >> $KAFKA_YML
        echo "      KAFKA_ADVERTISED_LISTENERS: INSIDE://:9092,OUTSIDE://_{HOSTNAME_COMMAND}:9094" >> $KAFKA_YML
        echo "      KAFKA_LISTENERS: INSIDE://:9092,OUTSIDE://:9094" >> $KAFKA_YML
        echo "      KAFKA_INTER_BROKER_LISTENER_NAME: INSIDE" >> $KAFKA_YML
        echo "    volumes:" >> $KAFKA_YML
        echo "      - /var/run/docker.sock:/var/run/docker.sock" >> $KAFKA_YML
    done

    # 指定网络
    echo "networks:" >> $KAFKA_YML
    echo "  default:" >> $KAFKA_YML
    echo "    external:" >> $KAFKA_YML
    echo "      name: $NETWORK" >> $KAFKA_YML

    cat $KAFKA_YML
}

if [[ "$1" = '-help' || "$#" = '0' ]]; then
    usage
    exit 0
fi

if [ "$1" = '-create' ]; then
    genreate_config $*
    echo "create"
else
    usage
    exit 0
fi
