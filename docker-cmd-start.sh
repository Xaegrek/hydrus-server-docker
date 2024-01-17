#!/bin/bash

. venv/bin/activate

stop() {
  ./hydrus_server.py stop -d="/data"
}

trap "stop" SIGTERM

./hydrus_server.py -d="/data" &

wait $!
