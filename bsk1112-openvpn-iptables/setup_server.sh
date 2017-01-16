set -xe

sudo apt-get update
sudo apt-get install openvpn easy-rsa

# http://stackoverflow.com/questions/24255205/error-loading-extension-section-usr-cert/26078472#26078472
sudo perl -p -i -e 's|^(subjectAltName=)|#$1|;' /usr/share/easy-rsa/openssl-1.0.0.cnf

EASY_RSA_DIR=/usr/share/easy-rsa

. ${EASY_RSA_DIR}/vars
export EASY_RSA=${EASY_RSA_DIR}
export KEY_CONFIG=`$EASY_RSA/whichopensslcnf $EASY_RSA`

export KEY_COUNTRY="PL"
export KEY_PROVINCE="mazowieckie"
export KEY_CITY="Warsaw"
export KEY_ORG="MIMUW"
export KEY_EMAIL="bsk@mimuw.edu.pl"
export KEY_OU="BSK"

export KEY_DIR="/vagrant/keys/"


${EASY_RSA_DIR}/clean-all
${EASY_RSA_DIR}/build-ca --batch
${EASY_RSA_DIR}/build-dh
${EASY_RSA_DIR}/build-key-server --batch vpn-server


export KEY_CN="CRL"
$OPENSSL ca -gencrl -out $KEY_DIR/crl.pem -config "$KEY_CONFIG"


sudo iptables -A INPUT -i eth1 -s 172.28.128.1/24 -p tcp --dport openvpn -j ACCEPT
sudo iptables -A INPUT -i eth1 -p tcp -j DROP

