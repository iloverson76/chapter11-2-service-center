FROM gmaslowski/jdk:latest
VOLUME /data/eureka-service-center/service
COPY /root/.jenkins/workspace/springCloud-service-center/eureka-server/target/eureka-server-0.0.1-SNAPSHOT.jar app.jar
#RUN bash -c 'touch /app.jar'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
EXPOSE 8761