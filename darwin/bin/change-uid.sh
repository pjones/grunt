#!/bin/sh

################################################################################
if [ `id -u` -ne 0 -o $# -ne 2 ]; then
  cat <<EOF
Usage: change-uid.sh username new-UID

This script will change the user ID of the given user to the UID given
in new-UID.  For example:

  change-uid.sh pjones 1000

Will change the pjones user to UID 1000.

Tested on:

  - Mac OS X Lion 10.7.3

NOTE: You must run this script as root.  Preferably by either logging
in directly as root or getting a root shell via 'sudo su -'.
EOF
  exit 1
fi

################################################################################
die () {
  echo "$@" > /dev/stderr
  exit 1
}

################################################################################
user_name=$1
new_uid=$2
old_uid=`id -u $user_name`
[ $? -eq 0 ] || exit 1

################################################################################
local_fs=`df -l | awk 'NR > 1 {print $6}'`

for fs in $local_fs; do
  if [ ! -d $fs ]; then
    die "bad file system name, maybe it has a space in its name: $fs"
  fi
done

################################################################################
echo "==> changing $user_name from $old_uid to $new_uid"
old_unique_id=`dscl . -read /Users/$user_name UniqueID | awk '{print $2}'`

if [ "$old_uid" -ne "$old_unique_id" ]; then
  echo "whoa, id and dscl don't agree on the UID" > /dev/stderr
  echo "id says $old_uid and dscl says $old_unique_id" > /dev/stderr
  exit 1
fi

dscl . -change /Users/$user_name UniqueID $old_uid $new_uid || \
  die "failed to change UID using dscl"

################################################################################
echo "==> updating ownership on local file systems"

for fs in $local_fs; do
  echo "===> updating $fs"
  find -x $fs -user $old_uid -print0 | xargs -0 chown -h $new_uid

  if [ -r $fs/.Trashes/$old_uid ]; then
    echo "===> renaming Finder Trash for $fs"
    mv $fs/.Trashes/$old_uid $fs/.Trashes/$new_uid
  fi

  find -x $fs -name "*.$old_uid" -type f -print0  | \
    xargs -0 -n 1 sh -c 'echo $0 `echo $0|sed s/\\.'$old_uid'/.'$new_uid'/`'
done

################################################################################
echo "==> Done.  You may want to reboot."
