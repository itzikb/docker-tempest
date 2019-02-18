#!/bin/bash
sudo cp /env/overcloudrc /home/centos
sudo chmod +rx /home/centos/overcloudrc
sudo chown centos /home/centos/overcloudrc
sudo sed -i 's/v2.*/v3/g' /home/centos/overcloudrc
source /home/centos/overcloudrc
DS_REPO_TEMPEST=/home/centos/tempset-upstream/python-tempestconf
US_REPO_TEMPEST=/home/centos/tempest-upstream/tempest

for i in ${DS_REPO_TEMPEST} ${US_REPO_TEMPEST};do
    git checkout master && git pull
done

cd /home/centos/tempest-upstream/python-tempestconf
source ../bin/activate

python config_tempest/main.py identity.uri $OS_AUTH_URL identity.admin_password $OS_PASSWORD DEFAULT.use_stderr true identity.region regionOne validation.run_validation True load_balancer.enable_security_groups True load_balancer.member_role _member_ load_balancer.admin_role admin load_balancer.RBAC_test_type owner_or_admin --create
sudo cp etc/tempest.conf /etc/tempest
if [ "${OTHER_CONFIG}" ]; then
  bash ${OTHER_CONFIG}
fi
cd /home/centos/tempest-upstream/tempest
source ../bin/activate
stestr init
