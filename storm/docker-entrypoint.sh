#!/bin/bash

set -e

# Generate the config only if it doesn't exist
CONFIG="$STORM_CONF_DIR/storm.yaml"

# zk
if [[ -n "$ZK_HOSTNAME" && -n "$ZK_NODE" ]]; then
    echo "storm.zookeeper.servers:" > $CONFIG
    for NODE in `seq $ZK_NODE`
    do
        echo "    - \""$ZK_HOSTNAME$NODE"\"" >> $CONFIG
    done
else
    echo "storm.zookeeper.servers: [zookeeper]" > $CONFIG
fi

    # zk port
if [ -n "$ZK_PORT" ]; then
    echo "storm.zookeeper.port: "$ZK_PORT >> $CONFIG
fi

#  nimbus
if [ -n "$NIMBUS" ]; then
    echo "nimbus.seeds: [\""$NIMBUS"\"]" >> $CONFIG
else 
    echo "nimbus.seeds: [nimbus]" >> $CONFIG
fi

# ui port
if [ -n "$UI_PORT" ]; then
    echo "ui.port: "$UI_PORT >> $CONFIG
fi

# log dir
echo "storm.log.dir: "$STORM_LOG_DIR >> $CONFIG

# local dir
echo "torm.local.dir: "$STORM_DATA_DIR >> $CONFIG

# Allow the container to be started with `--user`
if [ "$1" = 'storm' -a "$(id -u)" = '0' ]; then
    chown -R "$STORM_USER" "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR"
    # Set /etc/hosts
    # 10.61.200.35:app1 / ip:hostname,ip:hostname
    if [ -n "$ADD_HOSTS" ]; then
        OLD_IFS="$IFS"
        IFS=","
        ARRAY_HOST=(${ADD_HOSTS})
        
        for HOST in ${ARRAY_HOST[@]}
        do
                OLD_IFS="$IFS"
                IFS=":"
                ARRAT_IP=(${HOST})
                cat >> /etc/hosts <<EOF
${ARRAT_IP[0]}            ${ARRAT_IP[1]}
EOF
        done
    fi

    exec su-exec "$STORM_USER" "$0" "$@"
fi

exec "$@"