#! /bin/zsh

# This script is used to lint the Ansible playbooks and roles using ansible-lint.
ansible-lint playbooks/nomadintosh.yml
ansible-lint playbooks/reboot.yml
