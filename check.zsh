#! /bin/zsh

# Run Nomadintosh in check mode
ansible-playbook -i inventory/hosts.yml playbooks/nomadintosh.yml --check --diff