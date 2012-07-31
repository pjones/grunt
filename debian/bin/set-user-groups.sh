#!/bin/sh

################################################################################
. $GRUNT_LIB/util.sh

################################################################################
if [ $# -le 1 ]; then
  echo "Usage: "`basename $0`" username group [group...]"
  exit 1
fi

################################################################################
username=$1
existing=`groups $1|sed 's/^.*: *//'`

################################################################################
# Don't shift so that the username is allowed in the group list.

################################################################################
for e in $*; do
  if ! grunt_array_includes_element $e $existing; then
    echo "adduser $username $e"
    adduser $username $e
  fi
done

################################################################################
for e in $existing; do
  if ! grunt_array_includes_element $e $*; then
    echo "deluser $username $e"
    deluser $username $e
  fi
done
