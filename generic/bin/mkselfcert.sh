#!/bin/sh

################################################################################
#
# A script to make a self signed certificate.
#
################################################################################

DEST=tempcert
DAYS=1825

if ! which openssl > /dev/null 2>&1; then
  echo "Please install the OpenSSL tool first"
  exit 1
elif [ -r $DEST ]; then
  echo "Whoa! The $DEST directory already exists."
  exit 1
fi


################################################################################
mkdir -p $DEST

( cd $DEST &&
  openssl genrsa -des3 -passout pass:x -out server.pass.key 2048 &&
  openssl rsa -passin pass:x -in server.pass.key -out server.key &&
  openssl req -new -key server.key -out server.csr               &&
  openssl x509 -req -days $DAYS \
    -in server.csr -signkey server.key -out server.crt           &&
  cat server.crt server.key > server.pem
)
