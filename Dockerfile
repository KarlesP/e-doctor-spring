# ARG for minimal maintenance
ARG account=KarlesP
ARG repo=e-doctor-spring
ARG snapshot=0.0.1-SNAPSHOT.jar

# Lightweight version of maven
FROM maven:3.8.6-eclipse-temurin-18-alpine AS maven_build
ARG repo
ARG account

# Install packages for maintenance
RUN apk add --no-cache git openssh

# Git repo containing code
RUN git clone https://github.com/${account}/${repo}.git
RUN cd ${repo}

# Build jar file with Maven
RUN mvn -f /${repo}/pom.xml clean package

# Build new jdk docker image and copy jar file from maven docker
FROM openjdk:18-slim
ARG repo
ARG snapshot

# Copy files from maven_build docker

# Create enviroment variable in order to have a more automated script 
# (i.e change the repo/account/snapshot values and you are good to go)
ENV file=${repo}-${snapshot}
ENV jarPathFile=$jarPath'target'/$file

# Assign and copy directory in the new docker for our preciously built jar file
ENV jarPath=/usr/local/lib/
COPY --from=maven_build /${repo}/ ${jarPath}

# Assign the command to a shell script to execute it later
RUN echo "java -jar $jarPathFile" > /executeScript.sh

# Run jar file using the port 8080
EXPOSE 8080
ENTRYPOINT ["/bin/bash", "/executeScript.sh"]
