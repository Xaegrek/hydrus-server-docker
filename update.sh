#!/bin/bash
echo "checkout master"
git checkout master

echo "update submodules"
git submodule update --init --recursive
git submodule foreach "git checkout tags/$1 || exit 1"

echo "commit submodule updated HEAD"
git commit -a -m "$1"

echo "tag commit"
git tag $1

echo "push commit"
git push

echo "push tag"
git remote -v
git push origin $1
