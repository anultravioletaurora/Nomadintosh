# set_facts

Derives and sets inventory-level Ansible facts used by downstream roles.

## What it does

1. Sets the `datacenter` fact by inspecting the host's inventory group name — the first non-`all`, non-`ungrouped` group is used as the datacenter name for both Consul and Nomad.
2. Emits a debug message confirming the resolved datacenter name.

## No manual setup required

This role runs automatically as a pre-task for every host. No variables need to be set — the datacenter is inferred from the inventory group structure.
