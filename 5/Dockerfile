FROM bitweb/java:8
MAINTAINER BitWeb

# BAMBOO variables
ENV BAMBOO_HOME         /var/atlassian/bamboo
ENV BAMBOO_INSTALL      /opt/atlassian/bamboo
ENV BAMBOO_VERSION      5.14.1
ENV DOWNLOAD_URL        https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-$BAMBOO_VERSION.tar.gz

# MySQL Connector
ENV CONNECTOR_VERSION      5.1.40
ENV CONNECTOR_DOWNLOAD_URL https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${CONNECTOR_VERSION}.tar.gz

#################################################
####     No need to edit below this line     ####
#################################################

# Install BAMBOO dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl htop nano \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}
    
# Install Bamboo and helper tools and setup initial home directory structure
RUN mkdir -p          ${BAMBOO_HOME} \
    && mkdir -p       ${BAMBOO_HOME}/caches/indexes \
    && chmod -R 700   ${BAMBOO_HOME} \
    && mkdir -p       ${BAMBOO_INSTALL}/conf/Catalina \
    && curl -Ls       ${DOWNLOAD_URL} | tar -xz --directory ${BAMBOO_INSTALL} --strip-components=1 --no-same-owner \
    && curl -Ls       ${CONNECTOR_DOWNLOAD_URL} | tar -xz --directory ${INSTALL_DIR}/lib --strip-components=1 --no-same-owner "mysql-connector-java-$CONNECTOR_VERSION/mysql-connector-java-$CONNECTOR_VERSION-bin.jar"

RUN  chmod -R 700 ${BAMBOO_INSTALL}/conf \
     && echo      "\nbamboo.home=$BAMBOO_HOME" >> ${BAMBOO_INSTALL}/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties

# Set the default working directory as the installation directory.
WORKDIR $BAMBOO_INSTALL

# Expose default HTTP connector port.
EXPOSE 8085

CMD ["./bin/start-bamboo.sh", "-fg"]
