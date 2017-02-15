#!/bin/bash
sudo sed -i -e '/network-feature-enabled/!b;n;n' -e 's/\(api_extensions.*$\)/\1\,lbaasv2/' /etc/tempest/tempest.conf
