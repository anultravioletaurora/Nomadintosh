#! /bin/zsh

# Run Nomadintosh in check mode
ansible-playbook playbooks/nomadintosh.yml --check --diff
