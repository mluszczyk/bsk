set -xe

if test "$#" -ne 1; then
    echo "wrong number of parameters"
    echo "usage: revoke_cert.sh cert_name"
    exit 1
fi

EASY_RSA_DIR=/usr/share/easy-rsa

. ${EASY_RSA_DIR}/vars
export EASY_RSA=${EASY_RSA_DIR}
export KEY_CONFIG=`$EASY_RSA/whichopensslcnf $EASY_RSA`

export KEY_COUNTRY="PL"
export KEY_PROVINCE="mazowieckie"
export KEY_CITY="Warsaw"
export KEY_ORG="MIMUW"
export KEY_EMAIL="$4"
export KEY_OU="BSK"
export KEY_CN="$2 $3"

export KEY_DIR="/vagrant/keys/"

${EASY_RSA_DIR}/revoke-full "$1"
