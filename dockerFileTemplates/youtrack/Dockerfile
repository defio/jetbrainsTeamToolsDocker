# Author:  Andrea Pivetta && Nicola De Fiorenze
# Date:    17.02.2017

FROM ubuntu:xenial

ARG VERSION
ENV VERSION ${VERSION:-7.0}

ARG BUILD
ENV BUILD ${BUILD:-29566}

ARG PORT
ENV PORT ${PORT:-8080}

ARG IP_HOST
ENV IP_HOST ${IP_HOST}
ENV APP_HOME /opt/youtrack/${VERSION}.${BUILD}

# Install curl and jre
RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get install curl unzip default-jre -y

# Download Youtrack
# https://download.jetbrains.com/charisma/youtrack-7.0.29566.zip
RUN curl -L https://download.jetbrains.com/charisma/youtrack-${VERSION}.${BUILD}.zip > youtrack.zip \
    && unzip youtrack.zip

# Configure Youtrack
RUN ./youtrack-${VERSION}.${BUILD}/bin/youtrack.sh configure \
    --listen-port ${PORT} \
    --backups-dir $APP_HOME/backups \
    --data-dir    $APP_HOME/data \
    --logs-dir    $APP_HOME/log \
    --temp-dir    $APP_HOME/tmp \
    --base-url    http://${IP_HOST}:${PORT}/

EXPOSE $PORT

CMD ./youtrack-${VERSION}.${BUILD}/bin/youtrack.sh run --no-browser