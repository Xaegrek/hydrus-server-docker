FROM python:3.7-slim-stretch

ARG HOST_USER_ID=1000
ARG HOST_GROUP_ID=1000

ENV HOST_USER_ID=$HOST_USER_ID
ENV HOST_GROUP_ID=$HOST_GROUP_ID

RUN \
  if [ $(getent group ${HOST_GROUP_ID}) ]; then \
    useradd -r -u ${HOST_USER_ID} hydrus; \
  else \
    groupadd -g ${HOST_GROUP_ID} hydrus && \
    useradd -r -u ${HOST_USER_ID} -g hydrus hydrus; \
  fi

WORKDIR /usr/src/app

COPY ./hydrus .
COPY ./deb .

RUN \
  chown -R hydrus:hydrus /usr/src/app && \
  chmod +x server.py && \
  chmod +x bin/swfrender_linux bin/upnpc_linux && \
  rm \
    bin/swfrender_osx \
    bin/swfrender_win32.exe \
    bin/upnpc_osx \
    bin/upnpc_win32.exe && \
  mkdir /data && chown -R hydrus:hydrus /data && \
  apt-get update && apt-get install -y \
    build-essential \
    ffmpeg \
    wget && \
  dpkg -i libjpeg8_8d-1+deb7u1_amd64.deb && \
  rm libjpeg8_8d-1+deb7u1_amd64.deb && \
  pip install virtualenv && \
  virtualenv venv && \
  . venv/bin/activate && \
  pip install \
    beautifulsoup4~=4.7.1 \
    lz4~=2.1.10 \
    numpy~=1.16.4 \
    pillow~=5.4.1 \
    psutil~=5.4.8 \
    pylzma~=0.5.0 \
    pyopenssl~=18.0.0 \
    pyyaml~=3.13 \
    opencv-python-headless~=4.1.0.25 \
    requests~=2.21.0 \
    send2trash~=1.5.0 \
    service_identity~=18.1.0 \
    twisted~=18.9.0 && \
  rm -r ~/.cache && \
  apt-get clean && apt-get autoclean && apt-get autoremove --purge -y && \
  rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

EXPOSE 45870/tcp
EXPOSE 45871/tcp
EXPOSE 45872/tcp

HEALTHCHECK --interval=1m --timeout=10s --retries=3 \
  CMD wget --quiet --tries=1 --no-check-certificate --spider \
    https://localhost:45870 || exit 1

VOLUME /data

USER hydrus

ENTRYPOINT ["docker-entrypoint"]
