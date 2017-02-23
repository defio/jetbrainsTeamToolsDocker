# Author:  Andrea Pivetta && Nicola De Fiorenze
# Date:    17.02.2017

FROM ubuntu:xenial

ARG VERSION
ENV VERSION ${VERSION:-2.5}

ARG BUILD
ENV BUILD ${BUILD:-456}


ARG IP_HOST
ENV IP_HOST ${IP_HOST}

ARG PORT
ENV PORT ${PORT:-8080}

ENV APP_HOME /opt/hub/${VERSION}.${BUILD}

RUN echo "version ${VERSION}"
RUN echo "build ${BUILD}"
RUN echo "ip host ${IP_HOST}"

# Install curl and jre
RUN apt-get -qqy update \
    && apt-get -qqy upgrade \
    &&  apt-get -qq install curl unzip default-jre -y

# Download Hub
RUN curl -L https://download-cf.jetbrains.com/hub/${VERSION}/hub-ring-bundle-${VERSION}.${BUILD}.zip > hub.zip \
    && unzip hub.zip \
    && rm hub.zip

# Configure Hub
RUN ./hub-ring-bundle-${VERSION}.${BUILD}/bin/hub.sh configure \
    --listen-port ${PORT} \
    --backups-dir $APP_HOME/backups \
    --data-dir    $APP_HOME/data \
    --logs-dir    $APP_HOME/log \
    --temp-dir    $APP_HOME/tmp \
    --base-url    http://${IP_HOST}:${PORT}/


EXPOSE $PORT

CMD ./hub-ring-bundle-${VERSION}.${BUILD}/bin/hub.sh run --no-browser