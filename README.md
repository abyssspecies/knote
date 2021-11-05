# KNote

the simplest [knote](https://learnk8s.io/spring-boot-kubernetes-guide) demo to learning building docker image for spring boot project and deploy to k8s  
build spring boot app docker image with layered building feature, and a multi-stage Dockerfile

## Install or Running

run mongo container firstly and create user knote/knote, then run knote app container link to mongo
```shell
sudo docker volume create mongodb_data
sudo docker run -d -p 27017:27017 --name=mongo --privileged=true --restart=unless-stopped -v mongodb_data:/data \
  -e "MONGO_INITDB_ROOT_USERNAME=admin" -e "MONGO_INITDB_ROOT_PASSWORD=Admin@123!" mongo --auth
```

execute docker maven plugin build docker image then running knote app container

```shell
sudo docker run --name=knote --restart=unless-stopped --link mongo --privileged=true -d -p 8090:8090 -p 8091:8091 \
  -e "SPRING_DATA_MONGODB_URI=mongodb://knote:knote@mongo:27017/knote" io.abyssspecies.train/knote:0.0.1-SNAPSHOT
```

OTLP
-javaagent:E:\SDK\opentelemetry-javaagent-all.jar
OTEL_EXPORTER=otlp;OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:55680;OTEL_RESOURCE_ATTRIBUTES=service.name=knote

## Todo

- [ ] correct dockerfile-maven-plugin configuration when locate Dockerfile
- [ ] add signoz metrics and traces support, maybe check [SigNoz](https://signoz.io/docs/instrumentation/java)
- [ ] complete k8s deploy with cloud ci/cd tool [codefresh](https://g.codefresh.io/)
