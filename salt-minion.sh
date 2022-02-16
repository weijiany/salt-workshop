#!/bin/bash

set -e

sudo curl -fsSL -o /usr/share/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest/salt-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg arch=amd64] https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest focal main" | sudo tee /etc/apt/sources.list.d/salt.list

apt-get update
apt install salt-minion -y

echo "master: salt-master" > /etc/salt/minion
cat << EOF > /etc/salt/grains
roles:
  - prometheus
EOF
systemctl restart salt-minion
