# Author:  Andrea Pivetta && Nicola De Fiorenze
# Date:    17.02.2017

FROM ubuntu:xenial

ARG VERSION
ENV VERSION ${VERSION:-3.5}

ARG BUILD
ENV BUILD ${BUILD:-3597}
#3616

ARG PORT
ENV PORT ${PORT:-8080}

ARG IP_HOST
ENV IP_HOST ${IP_HOST}
ENV APP_HOME /opt/upsource/${VERSION}.${BUILD}

# Install curl and jre
RUN apt-get -qqy update \
    && apt-get -qqy upgrade \
    &&  apt-get -qq install curl unzip default-jre -y

# Download Upsource
RUN curl -L https://download.jetbrains.com/upsource/upsource-${VERSION}.${BUILD}.zip > upsource.zip \
    && unzip  upsource.zip

# Configure Upsource
RUN ./upsource-${VERSION}.${BUILD}/bin/upsource.sh configure \
    --listen-port ${PORT} \
    --backups-dir $APP_HOME/backups \
    --data-dir    $APP_HOME/data \
    --logs-dir    $APP_HOME/log \
    --temp-dir    $APP_HOME/tmp \
    --base-url    http://${IP_HOST}:${PORT}/

EXPOSE $PORT

CMD ./upsource-${VERSION}.${BUILD}/bin/upsource.sh run --no-browser