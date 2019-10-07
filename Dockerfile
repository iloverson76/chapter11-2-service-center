# 建议生产使用，ref: http://blog.tenxcloud.com/?p=1894
FROM gmaslowski/jdk:latest

USER root

COPY springCloud-service-center/eureka-server/target/target/demo.jar /home/