################################################################################
# building
################################################################################
FROM gradle:6.6.1 as building

ENV TZ=Asia/Bangkok

COPY build.gradle gradle.properties gradlew settings.gradle ./
RUN gradle build --no-daemon 2>/dev/null || return 0

COPY . .
RUN gradle test build --no-daemon --profile --debug

################################################################################
# deployment
################################################################################
FROM openjdk:8-jre-alpine as deployment

COPY --from=building /home/gradle/build/libs/sbthapi0-0.0.1.jar ./sbthapi0-0.0.1.jar

ENTRYPOINT ["java","-jar","/sbthapi0-0.0.1.jar"]