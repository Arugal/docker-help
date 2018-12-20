#!/bin/sh

# 配置文件地址
ZK_YML="./zookeeper.yml"

# zk 集群端口(宿主机端口),根据节点号递增
ZK_FIRST_PORT=2181

# zk 主机名, 根据节点号递增
ZK_HOSTNAME="zookeeper"

# zk 集群节点数
ZK_NODE=3

# 服务重启模式
RESTART_MODE="always"

# 指定网络
NETWORK="base_network"

# 打印帮助信息
usage(){
    echo "-create --p {port} --h {hostname} --i {image name} --node {node num} --r {restart mode} --n {network} or -help {display help message}"
}

# 生成 yml 文件
generate_config(){
    ZOOKEEPER_IMAGE="zookeeper/zookeeper:latest"

    while [ -n "$2" ]
    do 
    case $2 in 
        --p)
            ZK_FIRST_PORT=$3
            shift
            ;;
        --h)
            ZK_HOSTNAME=$3
            shift
            ;;
        --i)
            ZOOKEEPER_IMAGE=$3
            shift
            ;;
        --node)
            ZK_NODE=$3
            shift
            ;;
        --r)
            RESTART_MODE=$3
            shift
            ;;
        --n)
            NETWORK=$3
            shift
            ;;
    esac
    shift
    done 

    echo "version: '3.1'" > $ZK_YML
    echo "services:" >> $ZK_YML

    for ((NODE = 1; NODE <= $ZK_NODE; NODE++))
    do
        PORT=`expr $ZK_FIRST_PORT + $NODE - 1`
        echo "  $ZK_HOSTNAME$NODE:" >> $ZK_YML
        echo "    image: "$ZOOKEEPER_IMAGE >> $ZK_YML
        echo "    restart: "$RESTART_MODE >> $ZK_YML
        echo "    hostname: "$ZK_HOSTNAME$NODE >> $ZK_YML
        echo "    ports:" >> $ZK_YML
        echo "      - $PORT:2181" >> $ZK_YML
        echo "    environment:" >> $ZK_YML
        echo "      ZOO_MY_ID: "$NODE >> $ZK_YML
        ZOO_SERVERS=""
        for ((ID = 1; ID <= $ZK_NODE; ID++))
        do
            if [ $ID = $NODE ]; then
                ZOO_SERVERS=$ZOO_SERVERS"server."$ID"=0.0.0.0:2888:3888"
            else
                ZOO_SERVERS=$ZOO_SERVERS"server."$ID"="$ZK_HOSTNAME$ID":2888:3888"
            fi
            # 添加空格
            if [ $ID != $ZK_NODE ]; then
                ZOO_SERVERS=$ZOO_SERVERS" "
            fi
        done
        echo "      ZOO_SERVERS: "$ZOO_SERVERS >> $ZK_YML
    done

    # 指定网络
    echo "networks:" >> $ZK_YML
    echo "  default:" >> $ZK_YML
    echo "    external:" >> $ZK_YML
    echo "      name: "$NETWORK >> $ZK_YML

    cat $ZK_YML
}


if [[ "$1" = '-help' || "$#" = '0' ]]; then
    usage
    exit 0
fi

if [ "$1" = '-create' ]; then
    generate_config $*
    docker stack deploy -c $ZK_YML zookeeper
else
    usage
    exit 0
fi