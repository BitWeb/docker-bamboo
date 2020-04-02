FROM atlassian/bamboo-server:7.0.2

LABEL maintainer="rain@bitweb.ee"

USER root

# MySQL Connector
ENV CONNECTOR_VERSION      5.1.48
ENV CONNECTOR_DOWNLOAD_URL https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${CONNECTOR_VERSION}.tar.gz
RUN curl -Ls ${CONNECTOR_DOWNLOAD_URL} | tar -xz --directory ${BAMBOO_SERVER_INSTALL_DIR}/lib --strip-components=1 --no-same-owner "mysql-connector-java-$CONNECTOR_VERSION/mysql-connector-java-$CONNECTOR_VERSION-bin.jar"


# Install Docker engine to enable building in Docker containers
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" && \
    apt-get update && \
    apt-get install -y docker-ce

# Link Docker executable to installation and data dir, as for some reason Bamboo looks for Docker in those directories too
RUN ln -s /usr/bin/docker /opt/atlassian/bamboo/
RUN ln -s /usr/bin/docker /var/atlassian/application-data/bamboo/

# Install AWS CLI to /usr/local/bin/aws
RUN apt-get update && apt-get install -y unzip python \
    && curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
    && unzip awscli-bundle.zip \
    && rm awscli-bundle.zip \
    && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

# Intstall Docker Compose
ENV DOCKER_COMPOSE_VERSION 1.25.4
RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose
    
RUN docker-compose --version

# Although not reccommended, we do need to run Bamboo in root user, for this we need to use custom entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chown -R root:root "${BAMBOO_INSTALL_DIR}"
RUN chown -R root:root "${BAMBOO_HOME}"
RUN chown root:root /entrypoint.sh
RUN chmod +x /entrypoint.sh
