# KNote

the simplest demo to learning building docker image for spring boot project  
using spring boot layered building feature, and a multi-stage Dockerfile

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

## Todo

- [ ] correct dockerfile-maven-plugin configuration when locate Dockerfile


