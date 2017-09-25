FROM ubuntu:latest

MAINTAINER BitWeb

RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
    && echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 \
    && apt-get update \
    && apt-get -y install oracle-java8-installer \
    && apt-get -y install oracle-java8-set-default
    
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/jre/

# BAMBOO variables
ENV HOME_DIR     /var/atlassian/bamboo
ENV INSTALL_DIR  /opt/atlassian/bamboo
ENV VERSION      6.1.1
ENV DOWNLOAD_URL https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-$VERSION.tar.gz

# MySQL Connector
ENV CONNECTOR_VERSION      5.1.44
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
    
# Install AWS CLI to /usr/local/bin/aws
RUN apt-get update && apt-get install -y unzip python \
    && curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
    && unzip awscli-bundle.zip \
    && rm awscli-bundle.zip \
    && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

# Set the default working directory as the installation directory.
WORKDIR $INSTALL_DIR

# Expose default HTTP connector port.
EXPOSE 8085

CMD ["./bin/start-bamboo.sh", "-fg"]
