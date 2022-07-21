# docker-bamboo
[![](https://images.microbadger.com/badges/image/bitweb/bamboo.svg)](https://microbadger.com/images/bitweb/bamboo "Get your own image badge on microbadger.com")

Adds aws-cli and docker to the standard Bamboo image by [Atlassian](https://store.docker.com/community/images/atlassian/bamboo-server).

## Build and publish (Intel based machine)

    docker build -t bitweb/bamboo:8.1.8 .
    docker push bitweb/bamboo:8.1.8

## Build and publish (ARM based machine)

    docker buildx build --platform linux/amd64 -t bitweb/bamboo:8.1.8 .
    docker push bitweb/bamboo:8.1.8
