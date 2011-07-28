#!/bin/sh

if [ $# -ne 2 ]; then
  echo "Usage: dir-name os-type"
  exit 1
fi

DIR=$1
OS=$2

if [ -r $DIR ]; then
  echo "ERROR: $DIR already exists"
  exit 1
fi

GRUNT=`dirname $0`/..

if [ ! -d $GRUNT/$OS ]; then
  echo "ERROR: Grunt doesn't support $OS"
  exit 1
fi

mkdir $DIR
cp -r $GRUNT/generic/skel/* $DIR/
[ -d $GRUNT/$OS/skel ] && cp -r $GRUNT/$OS/skel/* $DIR/

(cd $DIR
 git init
 git submodule add git://pmade.com/grunt grunt
 git add .
 git commit -m "Initial server configuration")
