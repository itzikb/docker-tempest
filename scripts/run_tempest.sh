#!/bin/bash
sudo chmod +rx /env
source /env/overcloudrc
DS_REPO_TEMPEST=/home/centos/tempset-upstream/python-tempestconf
US_REPO_TEMPEST=/home/centos/tempest-upstream/tempest
US_REPO_NEUTRON=/home/centos/tempest-upstream/neutron-tempest-plugin
US_REPO_LBAAS=/home/centos/tempest-upstream/neutron-lbaas

for i in ${US_REPO_TEMPEST} ${US_REPO_NEUTRON} ${US_REPO_LBAAS};do
    pushd && git checkout master && git pull && popd
done

pushd ${DS_REPO_TEMPEST}
git checkout 1.1.3
popd

cd /home/centos/tempest-upstream/python-tempestconf
source ../bin/activate
python config_tempest/config_tempest.py identity.uri $OS_AUTH_URL identity.admin_password $OS_PASSWORD DEFAULT.use_stderr true identity.region regionOne validation.run_validation True --create
sudo cp etc/tempest.conf /etc/tempest
if [ "${OTHER_CONFIG}" ]; then
  bash ${OTHER_CONFIG}
fi
cd /home/centos/tempest-upstream/tempest
source ../bin/activate
