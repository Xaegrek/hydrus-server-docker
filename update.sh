#!/bin/bash
# checkout master
git checkout master
# update submodules
git submodule update --init --recursive
git submodule foreach "git checkout tags/$1 || exit 1"
# commit submodule updated HEAD
git commit -a -m "$1"
# tag commit
git tag $1
# push commit
git push
#push tag
git push master $1
