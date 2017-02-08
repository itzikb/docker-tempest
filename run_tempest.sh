#!/bin/bash
DS_REPO_TEMPEST=/home/centos/redhat-tempest/python-tempestconf
US_REPO_TEMPEST=/home/centos/tempest-upstream/tempest
US_REPO_NEUTRON=/home/centos/tempest-upstream/neutron
US_REPO_LBAAS=/home/centos/tempest-upstream/neutron-lbaas

for i in ${DS_REPO_TEMPEST} ${US_REPO_TEMPEST} ${US_REPO_NEUTRON} ${US_REPO_LBAAS};do
    git checkout master && git pull
done

cd /home/centos/redhat-tempest/python-tempestconf
source ../bin/activate
python config_tempest/config_tempest.py identity.uri $OS_AUTH_URL identity.admin_password $OS_PASSWORD --create
sudo cp etc/tempest.conf /etc/tempest
cd /home/centos/tempest-upstream/tempest
source ../bin/activate
