#!/bin/sh

# 启动 mysql 容器
container(){
   echo "container_name:$1"
   echo "mysql_passwd:$2"
   echo "mysql_tag:$3"
   docker run --name $1 -e MYSQL_ROOT_PASSWORD=$2 -d mysql:$3
}

# 替换 mysql 容器中的配置文件
replace_cnf_f(){
   echo "container_id:$1"
   docker cp ./mysql.cnf $1:/etc/mysql/conf.d/mysql.cnf
}

case $1 in
run)
    shift
    container $*
;;
replace)
    shift
    replace_cnf_f $*
;;
*)
    echo "run mysql container: ./mysql_docker.sh run \"container_name\" \"mysql_passwd\" \"image_tag\""
    echo "replace mysql cnf: ./mysql_docker.sh replace \"container_id\""
;;
esac