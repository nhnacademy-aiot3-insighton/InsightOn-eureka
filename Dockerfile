FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offine -B

COPY src ./src
RUN mvn clean package -DskipTests -B

FROM eclipse-temurin:21-jre

RUN useradd -m srious
USER srious

WORKDIR /app
COPY --from=build --chown=srious:srious /app/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]