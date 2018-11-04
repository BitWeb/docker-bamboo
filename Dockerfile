FROM atlassian/bamboo-server:6.7.1

LABEL maintainer="rain@bitweb.ee"

USER root

# Install Docker engine to enable building in Docker containers
RUN curl -fsSL https://get.docker.com/gpg | apt-key add - \
    && curl -fsSL https://get.docker.com/ | sh

# Link Docker executable to installation dir, as for some reason Bamboo looks for Docker in that directory
RUN ln -s /usr/bin/docker /opt/atlassian/bamboo/

# Install AWS CLI to /usr/local/bin/aws
RUN apt-get update && apt-get install -y unzip python \
    && curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
    && unzip awscli-bundle.zip \
    && rm awscli-bundle.zip \
    && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

USER ${BAMBOO_USER}
