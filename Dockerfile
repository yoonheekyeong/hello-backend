# FROM public.ecr.aws/docker/library/maven:3.8-openjdk-11 as builder
FROM adoptopenjdk:11-jre-hotspot as builder

WORKDIR /tmp
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} application.jar

RUN java -Djarmode=layertools -jar application.jar extract

#FROM amazoncorretto:11 492MB
#FROM openjdk:11.0.7-jre-slim
FROM adoptopenjdk:11-jre-hotspot

ARG WORKDIR=/tmp

COPY --from=builder ${WORKDIR}/dependencies/ ./
RUN true
COPY --from=builder ${WORKDIR}/snapshot-dependencies/ ./
RUN true
COPY --from=builder ${WORKDIR}/spring-boot-loader/ ./
RUN true
COPY --from=builder ${WORKDIR}/application/ ./
RUN true
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]
