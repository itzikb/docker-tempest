#!/bin/bash
sudo chmod +rx /env
source /env/overcloudrc
DS_REPO_TEMPEST=/home/centos/tempest-upstream/python-tempestconf
US_REPO_TEMPEST=/home/centos/tempest-upstream/tempest
US_REPO_NEUTRON=/home/centos/tempest-upstream/neutron-tempest-plugin
US_REPO_LBAAS=/home/centos/tempest-upstream/neutron-lbaas

for i in ${US_REPO_TEMPEST} ${US_REPO_NEUTRON} ${US_REPO_LBAAS};do
    pushd $i && git checkout master && git pull && popd
done

source ../bin/activate

pushd ${DS_REPO_TEMPEST}
git checkout 96a257e6c7d45c827813c71410a8ff36b6809e90 -b osp11
pip install -e .
python config_tempest/config_tempest.py identity.uri $OS_AUTH_URL identity.admin_password $OS_PASSWORD DEFAULT.use_stderr true identity.region regionOne validation.run_validation True --create
sudo cp etc/tempest.conf /etc/tempest
if [ "${OTHER_CONFIG}" ]; then
  bash ${OTHER_CONFIG}
fi
cd /home/centos/tempest-upstream/tempest
