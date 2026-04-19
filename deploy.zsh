#! /bin/zsh

# Deploy Nomad and Consul
ansible-playbook -i inventory/hosts.yml playbooks/nomadintosh.yml