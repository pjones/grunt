#!/bin/sh

if [ $# -lt 1 -o $# -gt 2 ]; then
  echo "Usage: directory-name [operating system]"
  exit 1
fi

DIR=$1
OS=$2

if [ -r $DIR ]; then
  echo "ERROR: $DIR already exists"
  exit 1
fi

GRUNT=`dirname $0`/..

if [ x$OS = x ]; then
  OS=`sh $GRUNT/bin/detectos.sh`

  if [ $? -ne 0 ]; then
    echo "ERROR: Grunt doesn't support this operating system"
    exit 1
  fi
else
  if [ ! -d $GRUNT/$OS ]; then
    echo "ERROR: Grunt doesn't support $OS"
    exit 1
  fi
fi

mkdir $DIR
cp -r $GRUNT/generic/skel/* $DIR/
[ -d $GRUNT/$OS/skel ] && cp -r $GRUNT/$OS/skel/* $DIR/

URL=`(cd $GRUNT && git config remote.origin.url)`

(cd $DIR
 git init
 git submodule add $URL grunt
 git add .
 git commit -m "Initial server configuration")
