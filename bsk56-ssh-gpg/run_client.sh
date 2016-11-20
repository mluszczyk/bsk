# assume it runs as guest

set -x
set -e

SERVER=172.28.128.3

ssh-keygen -f ~/.ssh/id_rsa -P herbata
cat <<EOF > ~/.ssh/config
Host server
    Hostname $SERVER
    User guest
EOF
ssh-copy-id $SERVER
