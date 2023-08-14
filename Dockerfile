FROM openjdk:8
EXPOSE 8085

ADD target/petclinic-jenkins.jar petclinic-jenkins.jar

ENTRYPOINT [ "java", "-jar", "/petclinic-jenkins.jar" ]