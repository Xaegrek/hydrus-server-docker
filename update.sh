#!/bin/bash
git checkout master
git submodule update --init --recursive
git submodule foreach "git checkout tags/$1 || exit 1"
git commit -a -m "$1"
git tag $1
git push
git push orgin $1