FROM openjdk:8-jdk-alpine

WORKDIR /app

ADD gradle /app/gradle
ADD gradlew /app/gradlew
ADD gradlew.bat /app/gradlew.bat
ADD build.gradle /app/build.gradle

RUN ./gradlew download

ADD src/ /app/src

RUN ./gradlew build

CMD java -jar build/libs/recommendation-0.1.0.jar
