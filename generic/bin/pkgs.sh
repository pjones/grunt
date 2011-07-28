#!/bin/sh
################################################################################
#
# Read package commands from two files in the packages directory:
#
#  aptitude: List of aptitude commands
#      gems: List of Ruby Gems commands
#
################################################################################
APTITUDE_OPTIONS='--safe-resolver -y'
GEM_INSTALL_OPTIONS='--no-rdoc --no-ri'
GEM_OPTIONS=''
GEM_TEST='ruby '`dirname $0`/hasgem.rb

################################################################################
die ()
{
  echo "ERROR: $@"
  exit 1
}

################################################################################
[ `id -u` -ne 0 ] && die "please run under sudo or as root"

################################################################################
preflight_for () {
  command=$1
  line=$2
  package=`echo $line|sed 's/^install *//'`
  preflight=''

  case $command in
    brew*)
      (echo $line | grep -q '^install') && \
        preflight="test '`brew which $package`'"
      ;;
    gem*)
      (echo $line | grep -q '^install') && \
        preflight="$GEM_TEST $line"
  esac
  
  echo $preflight
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
apply_commands_from_file ()
{
  command=$1
  suffix=''
  preflight=''

  while read line; do
    line=`echo $line | sed -e 's|#.*$||' -e 's|^[[:space:]]+||'`
    
    if echo $line | grep -q '^[[:space:]]*$'; then
      : # skip blank line
    else
      preflight=`preflight_for "$command" "$line"`
      suffix=`suffix_for "$command" "$line"`

      if [ "x$preflight" = x ] || ! eval $preflight; then
        echo "$command $line $suffix"

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
    apply_commands_from_file "brew" < $1
    ;;
  
  *)
    echo "ERROR: I don't know which command to use for $1"
    exit 1
    ;;
esac

################################################################################
rm -f pkgs.log # if we didn't die
