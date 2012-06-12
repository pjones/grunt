#!/bin/sh

################################################################################
# Build and install the latest version of Ruby.
ruby_url=http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p194.tar.gz
log_file=/tmp/build-ruby.log

################################################################################
exec 4>&1 # save STDOUT so we can restore in die()
exec > $log_file 2>&1
set -x

################################################################################
die () {
  exec 1>&4
  echo "==> !!! An error occurred while building Ruby !!! <=="
  echo "$@"
  echo "More information in $log_file"
  exit 1
}

################################################################################
if [ `id -u` -ne 0 ]; then
  die "you need to be root!"
fi

if ! which curl > /dev/null 2>&1; then
  die "cURL isn't installed!"
fi

################################################################################
tarball=`basename $ruby_url`
dir=`basename $tarball .tar.gz`

################################################################################
cd /tmp
[ -d $dir ] && die "$dir already exists in /tmp"

if [ ! -r $tarball ]; then
  curl -o $tarball $ruby_url || die "can't download Ruby"
  [ -r $tarball ]            || die "missing file after download"
fi

tar -xzf $tarball          || die "couldn't untar Ruby"
[ -d $dir ]                || die "tar didn't create the correct directory"

################################################################################
cd $dir
./configure --prefix=/usr || die "configure failed"
make                      || die "make failed"
make install              || die "make install failed"

################################################################################
cd ..
rm -r $dir $tarball
exit 0
