FROM public.ecr.aws/docker/library/maven:3.8-openjdk-11 as builder

WORKDIR /tmp
COPY pom.xml .
# go-offline using the pom.xml
RUN mvn dependency:go-offline
# copy your other files
COPY ./src ./src
# compile the source code and package it in a jar file
RUN mvn clean install -Dmaven.test.skip=true
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} application.jar

RUN java -Djarmode=layertools -jar application.jar extract

#FROM amazoncorretto:11 492MB
FROM openjdk:11.0.7-jre-slim

ARG WORKDIR=/tmp

COPY --from=builder ${WORKDIR}/dependencies/ ./
COPY --from=builder ${WORKDIR}/snapshot-dependencies/ ./
COPY --from=builder ${WORKDIR}/spring-boot-loader/ ./
COPY --from=builder ${WORKDIR}/application/ ./
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]