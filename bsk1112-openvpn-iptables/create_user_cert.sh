set -xe

if test "$#" -ne 3; then
    echo 'wrong number of parameters'
    echo 'usage: create_user_cert.sh first_name last_name email'
    exit 1
fi

FIRST_NAME=$1
LAST_NAME=$2
EMAIL=$3

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

mkdir -p user_certs

CERT_DIR="user_certs/${FIRST_NAME}_${LAST_NAME}"
mkdir $CERT_DIR
echo "Certificate will be stored in: $CERT_DIR"

echo Creating CA request
DAYS="-days 1460"
openssl req -nodes -new -keyout ${CERT_DIR}/newkey.pem -out ${CERT_DIR}/newreq.pem $DAYS \
    -subj "/emailAddress=$EMAIL/C=PL/ST=mazowieckie/L=Warsaw/O=MIMUW/CN=$FIRST_NAME $LAST_NAME/"

echo Signing request by CA
openssl ca -policy policy_anything $DAYS -out ${CERT_DIR}/newcert.pem -infiles ${CERT_DIR}/newreq.pem

