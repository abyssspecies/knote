FROM openjdk:8-jdk-alpine as builder
WORKDIR application
ARG JAR_FILE
COPY ${JAR_FILE} app.jar
RUN java -Djarmode=layertools -jar app.jar extract

FROM openjdk:8-jdk-alpine
MAINTAINER abyssspecies <abyssspecies@gmail.com>
WORKDIR application
COPY --from=builder application/dependencies/ ./
COPY --from=builder application/spring-boot-loader/ ./
COPY --from=builder application/snapshot-dependencies/ ./
COPY --from=builder application/application/ ./
ARG MIRROR_ALPINE_HOST=mirrors.ustc.edu.cn
RUN sed -i "s/dl-cdn.alpinelinux.org/${MIRROR_ALPINE_HOST}/g" /etc/apk/repositories \
  && apk add --no-cache tini curl wget vim ca-certificates tzdata \
  && ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo "Asia/Shanghai" > /etc/timezone \
  && apk del tzdata \
  && rm -rf /var/cache/apk/*
RUN addgroup -S knote && adduser -S knote -G knote
USER knote:knote
VOLUME /tmp
EXPOSE 8090 8091
ARG JAR_FILE
COPY ${JAR_FILE} app.jar
ENV JAVA_OPTS -noverify -XX:TieredStopAtLevel=1 -XX:+UnlockExperimentalVMOptions -XX:MaxRAMPercentage=90.0 -Dspring.jmx.enabled=false
ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8 -Duser.language=zh -Duser.region=zh_CN -Duser.country=zh_CN -Duser.timezone=Asia/Shanghai -Djava.security.egd=file:/dev/./urandom
ENTRYPOINT ["/sbin/tini", "--", "sh", "-c", "exec java $JAVA_OPTS org.springframework.boot.loader.JarLauncher"]
