#! /bin/zsh

# This script is used to deploy Nomad jobs using Ansible. It assumes that you have already set up your inventory and configured your Ansible playbooks.
# Run the Ansible playbook to deploy Nomad jobs
ansible-playbook playbooks/jobs.yml
