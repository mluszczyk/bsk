server setup
------------
sudo apt-get update
sudo apt-get install openvpn

cd easy-rsa
. ./vars
./clean-all 
./build-ca
./build-dh 
./build-key-server vpn-server
./build-key vpn-client
# copy stuff
sudo openvpn --dev tun --tls-server --ifconfig 10.0.0.1 10.0.0.2 --ca ca.crt --cert vpn-server.crt \
    --key vpn-server.key --dh dh2048.pem --proto tcp-server \
    --crl-verify /etc/openvpn/crl.pem

sudo iptables -A INPUT -i eth1 -p tcp --dport openvpn -j ACCEPT
sudo iptables -A INPUT -i eth1 -p tcp -j DROP




client setup
------------
sudo apt-get update
sudo apt-get install openvpn
VPN_SERVER_IP=172.28.128.3
# go to the right dir
sudo openvpn --dev tun --tls-client --ifconfig 10.0.0.2 10.0.0.1 --ca ca.crt --cert vpn-client.crt \
    --key vpn-client.key --remote $VPN_SERVER_IP --proto tcp-client
