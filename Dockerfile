FROM maven:3.8.6-openjdk-11-slim AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

RUN mv /app/target/*.war /app/target/ROOT.war


FROM tomcat:latest

WORKDIR /app

RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]