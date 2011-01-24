#!/bin/sh

uname_os=`uname -s | tr '[A-Z]' '[a-z]'`
detected_os=$uname_os
base=`basename $0`

if echo $uname_os | grep -q linux; then
  if [ -r /etc/issue ]; then
    detected_os=`head -1 /etc/issue | awk '{print $1}' | tr '[A-Z]' '[a-z]'`
  fi
fi

if [ -d $base/$detected_os ]; then
  echo $detected_os
else
  echo "$detected_os is not supported." > /dev/stderr
  exit 1
fi
