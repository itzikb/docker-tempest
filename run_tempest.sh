#!/bin/bash
cd /home/fedora/redhat-tempest/tempest
source ../bin/activate
python tools/config_tempest.py identity.uri $OS_AUTH_URL identity.admin_password $OS_PASSWORD
sudo cp etc/tempest.conf /etc/tempest
cd /home/fedora/tempest-upstream/tempest
source ../bin/activate
