set -xe

if test "$#" -ne 2; then
    echo "wrong number of parameters"
    echo "usage: run_client.sh vpn_server_ip cert_name"
    exit 1
fi

KEYS=/vagrant/keys

sudo openvpn --dev tun --tls-client --ifconfig 10.0.0.2 10.0.0.1 --ca $KEYS/ca.crt --cert $KEYS/"$2".crt \
    --key $KEYS/"$2".key --remote "$1" --proto tcp-client
