FROM centos:7
RUN useradd -ms /bin/bash centos
RUN yum -y install python-devel sshpass gcc git libffi-devel \
    libxml2-devel libxslt-devel  mariadb-devel openssl-devel  python-pip \
    python-virtualenv  redhat-rpm-config sudo iputils
RUN yum -y update && mkdir -p /etc/tempest

RUN echo "centos ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ADD run_tempest.sh /home/centos
RUN chmod 755 /home/centos/run_tempest.sh \
    && chown centos:centos /home/centos/run_tempest.sh

USER centos
WORKDIR /home/centos
RUN virtualenv redhat-tempest && cd redhat-tempest \
    && source bin/activate \
    && git clone https://github.com/redhat-openstack/python-tempestconf.git ; cd python-tempestconf \
    && pip install -U pip python-subunit && pip install -U setuptools  \
    && pip install requests && pip install -r requirements.txt 

RUN pwd && virtualenv tempest-upstream && cd tempest-upstream \
    && source bin/activate \
    && git clone https://github.com/openstack/tempest.git && cd tempest \
    && pip install -U pip python-subunit \
    && pip install -U setuptools && pip install -e . \ 
    && pip install -r test-requirements.txt && testr init && cd .. \
    && git clone https://github.com/openstack/neutron.git \
    && cd neutron && pip install -e . && pip install -r test-requirements.txt                                                                                                                                      

RUN cd /home/centos/tempest-upstream && source bin/activate \
    && git clone https://github.com/openstack/neutron-lbaas.git \
    && cd neutron-lbaas && pip install -e . \
    && pip install -r test-requirements.txt
WORKDIR /home/centos/tempest-upstream/tempest
VOLUME /env
CMD ['/bin/bash']
