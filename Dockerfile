FROM atlassian/bamboo-server:6.7.1

LABEL maintainer="rain@bitweb.ee"

USER root

# MySQL Connector
ENV CONNECTOR_VERSION      5.1.46
ENV CONNECTOR_DOWNLOAD_URL https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${CONNECTOR_VERSION}.tar.gz
RUN curl -Ls ${CONNECTOR_DOWNLOAD_URL} | tar -xz --directory ${INSTALL_DIR}/lib --strip-components=1 --no-same-owner "mysql-connector-java-$CONNECTOR_VERSION/mysql-connector-java-$CONNECTOR_VERSION-bin.jar"


# Install Docker engine to enable building in Docker containers
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" && \
    apt-get update && \
    apt-get install -y docker-ce

# Link Docker executable to installation dir, as for some reason Bamboo looks for Docker in that directory
RUN ln -s /usr/bin/docker /opt/atlassian/bamboo/

# Install AWS CLI to /usr/local/bin/aws
RUN apt-get update && apt-get install -y unzip python \
    && curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
    && unzip awscli-bundle.zip \
    && rm awscli-bundle.zip \
    && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

USER ${BAMBOO_USER}
