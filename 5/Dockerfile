FROM bitweb/java:8
MAINTAINER BitWeb

# BAMBOO variables
ENV HOME_DIR     /var/atlassian/bamboo
ENV INSTALL_DIR  /opt/atlassian/bamboo
ENV VERSION      5.13.1
ENV DOWNLOAD_URL https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-$VERSION.tar.gz

# MySQL Connector
ENV CONNECTOR_VERSION      5.1.40
ENV CONNECTOR_DOWNLOAD_URL https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${CONNECTOR_VERSION}.tar.gz

#################################################
####     No need to edit below this line     ####
#################################################

# Install BAMBOO dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl htop nano git ssh \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}
    
# Install Bamboo and helper tools and setup initial home directory structure
RUN mkdir -p          ${HOME_DIR} \
    && mkdir -p       ${HOME_DIR}/caches/indexes \
    && chmod -R 700   ${HOME_DIR} \
    && mkdir -p       ${INSTALL_DIR}/conf/Catalina \
    && curl -Ls       ${DOWNLOAD_URL} | tar -xz --directory ${INSTALL_DIR} --strip-components=1 --no-same-owner \
    && curl -Ls       ${CONNECTOR_DOWNLOAD_URL} | tar -xz --directory ${INSTALL_DIR}/lib --strip-components=1 --no-same-owner "mysql-connector-java-$CONNECTOR_VERSION/mysql-connector-java-$CONNECTOR_VERSION-bin.jar"

RUN  chmod -R 700 ${INSTALL_DIR}/conf \
     && echo      "\nbamboo.home=$HOME_DIR" >> ${INSTALL_DIR}/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties
     
# Install Docker engine to enable building in Docker containers
RUN curl -fsSL https://get.docker.com/gpg | apt-key add - \
    && curl -fsSL https://get.docker.com/ | sh

# Set the default working directory as the installation directory.
WORKDIR $INSTALL_DIR

# Expose default HTTP connector port.
EXPOSE 8085

CMD ["./bin/start-bamboo.sh", "-fg"]
