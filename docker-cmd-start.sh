#!/bin/sh

USER_ID=${UID}
GROUP_ID=${GID}

echo "Starting Hydrus with UID/GID : $USER_ID/$GROUP_ID"
stop() {
  python3 /opt/hydrus/hydrus_server.py stop -d="/data"
}

trap "stop" SIGTERM

su-exec ${USER_ID}:${GROUP_ID} python3 /opt/hydrus/hydrus_server.py  -d="/data" &

wait $!