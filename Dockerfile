FROM alpine:3.23

ARG UID=1000
ARG GID=1000

ENV UID=${UID} \
    GID=${GID}

RUN apk --no-cache add \
      py3-psutil \
      py3-requests \
      py3-twisted \
      py3-yaml \
      py3-lz4 \
      py3-pillow \
      py3-numpy \
      py3-lxml \
      py3-openssl \
      py3-cryptography \
      py3-service_identity \
      py3-opencv \
      py3-send2trash \
      ffmpeg \
      openssl \
      su-exec \
      shadow 

RUN set -xe \
    && mkdir -p /opt/hydrus \
    && addgroup -g 1000 hydrus \
    && adduser -h /opt/hydrus -u 1000 -H -S -G hydrus hydrus \
    && mkdir /data && chown -R ${UID}:${GID} /data

COPY --chown=hydrus:hydrus ./hydrus /opt/hydrus
COPY --chown=hydrus:hydrus docker-cmd-start.sh /opt/hydrus/static/build_files/docker/server/docker-cmd-start.sh 
VOLUME /data

EXPOSE 45870/tcp 45871/tcp 45872/tcp

ENTRYPOINT ["/bin/sh", "/opt/hydrus/static/build_files/docker/server/docker-cmd-start.sh"]

HEALTHCHECK --interval=1m --timeout=10s --retries=3 --start-period=10s \
  CMD wget --quiet --tries=1 --no-check-certificate --spider \
    https://localhost:45870 || exit 1
