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

USER fedora
WORKDIR /home/fedora
RUN virtualenv redhat-tempest && cd redhat-tempest \
    && source bin/activate && git clone https://github.com/redhat-openstack/tempest ; cd tempest \
    && pip install -r requirements.txt && pip install requests 

RUN pwd && virtualenv tempest-upstream && cd tempest-upstream && source bin/activate \
    && git clone https://github.com/openstack/tempest.git && cd tempest && pip install -e . 
WORKDIR /home/fedora/tempest-upstream/tempest
ADD run_tempest.sh /home/fedora
RUN chown fedora:fedora /home/fedora/run_tempest.sh && chmod +x /home/fedora/run_tempest.sh 
