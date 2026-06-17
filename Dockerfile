# Stage 1: Build the WAR using Maven
FROM maven:3.9-eclipse-temurin-11 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run it on Tomcat
FROM tomcat:9.0-jdk11
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY --from=build /app/target/mediassist.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]