#!/bin/bash

# Skrypt prowadzi przez tworzenie nowych certyfikatów na serwerze
# i ustawienia ich w serwerze Apache.

set -xe

docker exec bsk-apache mkdir -p /ca
docker cp create_certs.sh bsk-apache:/ca/
docker exec -it bsk-apache /bin/bash -c "cd /ca && /ca/create_certs.sh"
docker cp bsk-apache:/ca/newcert.pem .
docker cp bsk-apache:/ca/newkey.pem .
docker cp bsk-apache:/ca/demoCA/cacert.pem .
docker cp newcert.pem bsk-apache:/etc/ssl/certs/
docker cp newkey.pem bsk-apache:/etc/ssl/private/
docker exec bsk-apache service apache2 reload

./test_curl.sh
