#!/bin/bash
DS_REPO_TEMPEST=/home/fedora/redhat-tempest/tempest
US_REPO_TEMPEST=/home/fedora/tempest-upstream/tempest
US_REPO_NEUTRON=/home/fedora/tempest-upstream/neutron
US_REPO_LBAAS=/home/fedora/tempest-upstream/neutron-lbaas

for i in ${DS_REPO_TEMPEST} ${US_REPO_TEMPEST} ${US_REPO_NEUTRON} ${US_REPO_LBAAS};do
    git checkout master && git pull
done

cd /home/fedora/redhat-tempest/tempest
source ../bin/activate
python tools/config_tempest.py identity.uri $OS_AUTH_URL identity.admin_password $OS_PASSWORD --create
sudo cp etc/tempest.conf /etc/tempest
cd /home/fedora/tempest-upstream/tempest
source ../bin/activate
