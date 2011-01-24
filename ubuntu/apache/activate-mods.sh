#!/bin/sh

################################################################################
if [ $# -ne 2 ]; then
  echo "ERROR: Usage: modules-file modules-dir"
  exit 1
fi

################################################################################
MODULES_FILE=$1
MODULES_DIR=$2

################################################################################
if [ ! -r $MODULES_FILE ]; then
  echo "ERROR: no such file: $MODULES_FILE"
  exit 1
fi

################################################################################
# First, remove any modules that shouldn't be active
for mod in `ls $MODULES_DIR`; do
  name=`echo $mod|sed 's|\..*$||'`

  if ! grep -qxLF "$name" $MODULES_FILE; then
    echo "==> removing $mod"
    rm $MODULES_DIR/$mod
  fi
done

################################################################################
# Now activate modules that are missing
for mod in `cat $MODULES_FILE`; do
  if [ ! -r $MODULES_DIR/${mod}.load ]; then
    echo "==> adding $mod"
    (cd $MODULES_DIR && \
      ln -s ../mods-available/${mod}.load . && \
      [ -r ../mods-available/${mod}.conf ] && \
      ln -s ../mods-available/${mod}.conf .)
  fi
done
