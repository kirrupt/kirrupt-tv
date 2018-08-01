FROM gradle:4.9-jdk8-alpine

ADD --chown=gradle . /app

WORKDIR /app

RUN gradle build

CMD java -jar build/libs/recommendation-0.1.0.jar
