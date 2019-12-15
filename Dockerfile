FROM atlassian/bamboo-server:6.10.4

LABEL maintainer="rain@bitweb.ee"

USER root

# MySQL Connector
ENV CONNECTOR_VERSION      5.1.46
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

# Although not reccommended, we do need to run Bamboo in root user, for this we need to use custom entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chown -R root:root "${BAMBOO_SERVER_INSTALL_DIR}"
RUN chown -R root:root "${BAMBOO_SERVER_HOME}"
RUN chown root:root /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create new group with same GID as machine docker user
#RUN groupadd -g 998 docker2 && usermod -a -G docker2 ${BAMBOO_USER}

#USER ${BAMBOO_USER}
