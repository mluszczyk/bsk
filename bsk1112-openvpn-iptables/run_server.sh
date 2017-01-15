set -xe

KEYS=/vagrant/keys

sudo openvpn --dev tun --tls-server --ifconfig 10.0.0.1 10.0.0.2 --ca $KEYS/ca.crt --cert $KEYS/vpn-server.crt \
    --key $KEYS/vpn-server.key --dh $KEYS/dh2048.pem --proto tcp-server \
    --crl-verify $KEYS/crl.pem

