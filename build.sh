#!/bin/bash
cd `dirname $0`

img_mvn="maven:3.3.3-jdk-8"                 # docker image of maven
m2_cache=~/.m2                              # the local maven cache dir
proj_home=$PWD                              # the project root dir

echo "use docker maven"
docker run --rm \
   -v $m2_cache:/root/.m2 \
   -v $proj_home:/usr/src/mymaven \
   -w /usr/src/mymaven $img_mvn mvn clean package -U -Dmaven.test.skip=true

mv $proj_home/springCloud-service-center/eureka-server/target/target/eureka-server-0.0.1-SNAPSHOT.jar $proj_home/springCloud-service-center/eureka-server/target/target/demo.jar

echo "构建镜像"
docker build -t eureka-server .