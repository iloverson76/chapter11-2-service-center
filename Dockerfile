# 建议生产使用，ref: http://blog.tenxcloud.com/?p=1894
FROM gmaslowski/jdk:latest

USER root

COPY ./eureka-server/target/app.jar /home/