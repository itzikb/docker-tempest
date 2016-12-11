FROM fedora:24
RUN useradd -ms /bin/bash fedora
RUN dnf -y install python-devel \
    sshpass gcc git libffi-devel \
    libxml2-devel libxslt-devel \
    mariadb-devel openssl-devel \
    python-pip python-virtualenv \
    redhat-rpm-config sudo \
    && mkdir -p /etc/tempest

RUN echo "fedora ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ADD run_tempest.sh /home/fedora
RUN chmod 755 /home/fedora/run_tempest.sh && chown fedora:fedora /home/fedora/run_tempest.sh

USER fedora
WORKDIR /home/fedora
RUN virtualenv redhat-tempest && cd redhat-tempest \
    && source bin/activate && git clone https://github.com/redhat-openstack/tempest ; cd tempest \
    && pip install -r requirements.txt && pip install requests 

RUN pwd && virtualenv tempest-upstream && cd tempest-upstream && source bin/activate \
    && git clone https://github.com/openstack/tempest.git && cd tempest && pip install -e . \ 
    && pip install -r test-requirements.txt && cd .. && git clone https://github.com/openstack/neutron.git \
    && cd neutron && pip install -e . && pip install -r test-requirements.txt                                                                                                                                      

RUN cd /home/fedora/tempest-upstream && source bin/activate && git clone https://github.com/openstack/neutron-lbaas.git \
    && cd neutron-lbaas && pip install -e . && pip install -r test-requirements.txt
WORKDIR /home/fedora/tempest-upstream/tempest


