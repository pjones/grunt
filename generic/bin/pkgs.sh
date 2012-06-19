#!/bin/sh
################################################################################
#
# Read package commands from a file given on the command line.  If the
# basename of the file is:
#
#  aptitude: List of aptitude commands
#      gems: List of Ruby Gems commands
#      brew: List of Homebrew commands
#
################################################################################
APTITUDE_OPTIONS='-y'
GEM_INSTALL_OPTIONS='--no-rdoc --no-ri'
GEM_OPTIONS=''

################################################################################
die () {
  echo "ERROR: $@"
  exit 1
}

################################################################################
[ `id -u` -ne 0 -a x$RERUN_PKG_TOOL = x ] && die "please run under sudo or as root"

################################################################################
preflight_check () {
  command=$1
  line=$2
  package=`echo $line|sed 's/^install *//'`

  if echo $line | grep -vq '^install'; then
    return 0
  fi

  if [ "$FORCE_PKG_INSTALL" = YES ]; then
    return 0
  fi

  case $command in
    aptitude*)
      if dpkg-query -s $package 2>&1 | egrep -q 'Status:[[:space:]]*install'; then
        return 1
      fi
      ;;
    brew*)
      if brew which $package 2> /dev/null | grep -q ':'; then
        return 1
      fi
      ;;
    gem*)
      if ruby `dirname $0`/hasgem.rb $line; then
        return 1
      fi
      ;;
  esac

  # Fall though: we don't know how to check to see if this package is
  # installed so just say that it isn't.
  return 0
}

################################################################################
suffix_for () {
  command=$1
  line=$2
  suffix=''

  case $command in
    gem*)
      (echo $line | grep -q '^install') && \
        suffix=$GEM_INSTALL_OPTIONS
      ;;
  esac

  echo $suffix
}

################################################################################
apply_commands_from_file () {
  command=$1
  suffix=''

  while read line; do
    line=`echo $line | sed -e 's|#.*$||' -e 's|^[[:space:]]+||'`

    if echo $line | grep -vq '^[[:space:]]*$'; then
      if preflight_check "$command" "$line"; then
        suffix=`suffix_for "$command" "$line"`
        echo "==> $command $line $suffix"
        eval "$command $line $suffix < /dev/null | tee -a pkgs.log" \
          || die "failed to install package"
      fi
    fi
  done
}

################################################################################
case `basename $1` in
  aptitude.pkgs)
    apply_commands_from_file "aptitude $APTITUDE_OPTIONS" < $1
    ;;

  gem.pkgs)
    apply_commands_from_file "gem $GEM_OPTIONS" < $1
    ;;

  brew.pkgs)
    # Can't run brew as root
    if [ x$SUDO_USER != x -a x$RERUN_PKG_TOOL = x ]; then
      export RERUN_PKG_TOOL=yes
      su -m $SUDO_USER -c "$0 $1"
    else
      apply_commands_from_file "brew" < $1
    fi
    ;;

  *)
    echo "ERROR: I don't know which command to use for $1"
    exit 1
    ;;
esac

################################################################################
rm -f pkgs.log # if we didn't die
