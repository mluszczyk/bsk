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
touch ${CATOP}/index.txt


echo Creating CA
CADAYS="-days 3650"
openssl req -new -keyout ${CATOP}/private/$CAKEY \
	   -out ${CATOP}/$CAREQ
openssl ca -create_serial -out ${CATOP}/$CACERT $CADAYS -batch \
	   -keyfile ${CATOP}/private/$CAKEY -selfsign \
	   -extensions v3_ca \
	   -infiles ${CATOP}/$CAREQ
