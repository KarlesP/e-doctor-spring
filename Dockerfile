# ARG for minimal maintenance
ARG gitAccount=https://github.com/KarlesP
ARG repo=e-doctor-spring
ARG port=8080
ARG jarPath=/usr/local/lib/
ARG file=${repo}-${snapshot}
ARG jarPathFile=$jarPath'target'/$file

# Lightweight version of maven
FROM maven:3.8.6-eclipse-temurin-18-alpine AS maven_build
ARG repo
ARG gitAccount

# Install packages for maintenance
RUN apk add --no-cache git openssh

# Git clone the repo containing code using https protocol
RUN git clone ${gitAccount}/${repo}.git
RUN cd ${repo}

# Build jar file with Maven
RUN mvn -f /${repo}/pom.xml clean package

# Build new jdk docker image, copy built jar file and execute it from a shell script
FROM openjdk:18-slim

# Pass default values
ARG repo
ARG port
ARG jarPath
ARG file
ARG jarPathFile

#Copy files from maven_build 
COPY --from=maven_build /${repo}/ ${jarPath}

# Assign the command to a shell script to execute it later
RUN echo "java -jar $(find .$jarPath/target -name *.jar)" > /executeScript.sh

# Run jar file using the port 8080
EXPOSE ${port}
ENTRYPOINT ["/bin/bash", "/executeScript.sh"]
