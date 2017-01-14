#!/bin/bash

# Generuje certyfikaty.

set -xe

CATOP=./demoCA/
CAKEY=./cakey.pem
CAREQ=./careq.pem
CACERT=./cacert.pem

mkdir -p ${CATOP}
mkdir -p ${CATOP}/private
mkdir -p ${CATOP}/newcerts
echo 1000 > ${CATOP}/serial
touch ${CATOP}/index.txt


echo Creating CA
CADAYS="-days 3650"
openssl req -new -keyout ${CATOP}/private/$CAKEY \
	   -out ${CATOP}/$CACERT \
       -x509 -nodes \
       -subj "/C=PL/ST=mazowieckie/L=Warsaw/O=MIMUW/CN=VPN CA"
