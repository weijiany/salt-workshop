#!/bin/bash

set -e

sudo curl -fsSL -o /usr/share/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest/salt-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg arch=amd64] https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest focal main" | sudo tee /etc/apt/sources.list.d/salt.list

apt-get update
apt install salt-master salt-minion -y

echo "auto_accept: True" > /etc/salt/master
cat << EOF > /etc/salt/master
auto_accept: True
pillar_roots:
  base:
    - /srv/pillar
  int:
    - /srv/pillar/int
file_roots:
  base:
    - /srv/salt
  int:
    - /srv/salt/int
EOF
systemctl restart salt-master

cat << EOF > /etc/salt/minion
master: salt-master
saltenv: int
EOF

cat << EOF > /etc/salt/grains
roles:
  - salt
EOF
systemctl restart salt-minion

# create ln from / to home dir, due to vagrant can not support login via root.
rm -rf /srv
mkdir -p /home/vagrant/srv
chown vagrant:vagrant /home/vagrant/srv
ln -s /home/vagrant/srv /srv
