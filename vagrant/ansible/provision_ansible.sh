#!/bin/bash

# Install Python and Ansible
if [[ ! -d /opt/ansible ]]; then
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    echo -e "deb https://apt.dockerproject.org/repo ubuntu-trusty main" >> /etc/apt/sources.list.d/docker.list && \
    apt-get update -qq && apt-get upgrade -y && apt-get purge lxc-docker && \
    apt-get install -y docker-engine python-pip git ldap-utils && pip install paramiko PyYAML Jinja2 httplib2 ansible
fi


# Copy the insecure (publicly known and default) vagrant private key https://github.com/mitchellh/vagrant/tree/master/keys
# We use this key so we do not need to put a custom key authorization for ansible in the CoreOS hosts
cp ~vagrant/.ssh/* /root/.ssh
chmod 0400 /root/.ssh/id_rsa
chown root:root /root/.ssh/id_rsa
chmod 0400 /root/.ssh/id_rsa.pub
chown root:root /root/.ssh/id_rsa.pub

echo "[defaults]
host_key_checking=False" > ansible.cfg
