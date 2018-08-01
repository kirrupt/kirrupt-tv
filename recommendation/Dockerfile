FROM gradle:4.9-jdk8-alpine

# Horrible hack to create writeable /app.
ADD --chown=gradle gradle /app
RUN rm -rf /app/wrapper

ADD --chown=gradle gradle /app/gradle
ADD --chown=gradle gradlew /app/gradlew
ADD --chown=gradle gradlew.bat /app/gradlew.bat
ADD --chown=gradle build.gradle /app/build.gradle

WORKDIR /app

RUN gradle download

ADD --chown=gradle src/ /app/src

RUN gradle build

CMD java -jar build/libs/recommendation-0.1.0.jar
