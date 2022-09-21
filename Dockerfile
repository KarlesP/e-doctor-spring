FROM maven:3.8.6-eclipse-temurin-18-alpine AS maven_build
RUN apk add --no-cache git openssh 
RUN git clone https://github.com/KarlesP/e-doctor-springboot.git
RUN cd e-doctor-springboot
RUN mvn -f /e-doctor-springboot/pom.xml clean package

FROM openjdk:18-slim
COPY --from=maven_build /e-doctor-springboot/ /usr/local/lib/
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/local/lib/target/demo1-0.0.1-SNAPSHOT.jar"]