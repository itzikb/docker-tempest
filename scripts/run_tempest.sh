#!/bin/bash
sudo chmod +rx /env
source /env/overcloudrc
export OS_AUTH_URL=$(echo $OS_AUTH_URL | sed 's/v2.0/v3/')
DS_REPO_TEMPEST=/home/centos/tempset-upstream/python-tempestconf
US_REPO_TEMPEST=/home/centos/tempest-upstream/tempest
US_REPO_NEUTRON=/home/centos/tempest-upstream/neutron-tempest-plugin
US_REPO_LBAAS=/home/centos/tempest-upstream/neutron-lbaas

for i in ${DS_REPO_TEMPEST} ${US_REPO_TEMPEST} ${US_REPO_NEUTRON} ${US_REPO_LBAAS};do
    git checkout master && git pull
done

cd /home/centos/tempest-upstream/python-tempestconf
source ../bin/activate
python config_tempest/config_tempest.py identity.uri $OS_AUTH_URL identity.admin_password $OS_PASSWORD DEFAULT.use_stderr true identity.region regionOne validation.run_validation True --create
sudo cp etc/tempest.conf /etc/tempest
if [ "${OTHER_CONFIG}" ]; then
  bash ${OTHER_CONFIG}
fi
cd /home/centos/tempest-upstream/tempest
source ../bin/activate
