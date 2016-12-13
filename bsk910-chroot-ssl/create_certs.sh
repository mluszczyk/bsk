#!/bin/bash

# Generuje certyfikaty.
# Poniżej znajdują się skopiowane i dostosowane polecenia z CA.sh.
# CA.sh nie pozwala zmieniać ważności certyfikatu CA.

set -xe

CATOP=./demoCA
CAKEY=./cakey.pem
CAREQ=./careq.pem
CACERT=./cacert.pem


mkdir -p ${CATOP}
mkdir -p ${CATOP}/certs
mkdir -p ${CATOP}/crl
mkdir -p ${CATOP}/newcerts
mkdir -p ${CATOP}/private
touch ${CATOP}/index.txt


echo Creating CA
CADAYS="-days 3650"
openssl req -new -keyout ${CATOP}/private/$CAKEY \
	   -out ${CATOP}/$CAREQ
openssl ca -create_serial -out ${CATOP}/$CACERT $CADAYS -batch \
	   -keyfile ${CATOP}/private/$CAKEY -selfsign \
	   -extensions v3_ca \
	   -infiles ${CATOP}/$CAREQ

echo Creating CA request
DAYS="-days 1460"
openssl req -new -keyout newkey.pem -out newreq.pem $DAYS

echo Removing password
openssl rsa -in newkey.pem -out newkey.pem

echo Signing request by CA
openssl ca -policy policy_anything $DAYS -out newcert.pem -infiles newreq.pem
