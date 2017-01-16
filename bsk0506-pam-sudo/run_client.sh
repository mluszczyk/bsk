# assume it runs as guest

set -x
set -e

SERVER=172.28.128.10

ssh-keygen -f ~/.ssh/id_rsa -P ''
cat <<EOF > ~/.ssh/config
Host server
    Hostname $SERVER
    User guest
EOF
ssh-copy-id server
