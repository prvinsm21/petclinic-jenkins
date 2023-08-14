FROM adoptopenjdk/openjdk8:alpine-jre

ARG  artifact=target/petclinic-jenkins.jar

WORKDIR /opt/app 

COPY ${artifact} app.jar 

ENTRYPOINT [ "java", "-jar", "app.jar" ]