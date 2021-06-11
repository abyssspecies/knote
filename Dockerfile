FROM maven:3.8.1-jdk-8-slim AS MAVEN_TOOL_CHAIN
COPY pom.xml /tmp/
RUN mvn -B dependency:go-offline -f /tmp/pom.xml -s /usr/share/maven/ref/settings-docker.xml
COPY src /tmp/src/
WORKDIR /tmp/
RUN mvn -B -s /usr/share/maven/ref/settings-docker.xml package

FROM openjdk:8-jdk-alpine
MAINTAINER abyssspecies <abyssspecies@gmail.com>
ARG MIRROR_ALPINE_HOST=mirrors.ustc.edu.cn
RUN mkdir /app
RUN sed -i "s/dl-cdn.alpinelinux.org/${MIRROR_ALPINE_HOST}/g" /etc/apk/repositories \
  && apk add --no-cache tini curl wget vim ca-certificates tzdata \
  && ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo "Asia/Shanghai" > /etc/timezone \
  && apk del tzdata \
  && rm -rf /var/cache/apk/*
RUN addgroup -S knote && adduser -S knote -G knote
USER knote:knote
COPY --from=MAVEN_TOOL_CHAIN /tmp/target/*.jar /app/app.jar
VOLUME /tmp
EXPOSE 8090 8091
ENV JAVA_OPTS -noverify -XX:TieredStopAtLevel=1 -XX:+UnlockExperimentalVMOptions -XX:MaxRAMPercentage=90.0 -Dspring.jmx.enabled=false
ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8 -Duser.language=zh -Duser.region=zh_CN -Duser.country=zh_CN -Duser.timezone=Asia/Shanghai -Djava.security.egd=file:/dev/./urandom
ENTRYPOINT ["/sbin/tini", "--", "sh", "-c", "exec java $JAVA_OPTS /app/app.jar"]
HEALTHCHECK --interval=1m --timeout=3s CMD wget -q -T 3 -s http://localhost:8091/actuator/health/ || exit 1
