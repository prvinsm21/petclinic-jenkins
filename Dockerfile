FROM adoptopenjdk/openjdk8:alpine-jre

ARG  artifact=target/spring-petclinic-2.2.0.jar

WORKDIR /opt/app 

COPY ${artifact} app.jar 

ENTRYPOINT [ "java", "-jar", "app.jar" ]