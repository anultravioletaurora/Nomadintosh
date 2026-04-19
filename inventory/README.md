# Inventory File Guide for nomadintosh.yml

This document explains how to structure your Ansible inventory file (`hosts.yml` file) when deploying services using `playbooks/nomadintosh.yml`.

The inventory file defines groups of hosts and can set variables that are used by the roles included in the playbook (e.g., `podman`).

## Inventory Structure Example

Your inventory should list groups of hosts and can optionally define variables for those groups or individual hosts.

**Syntax Overview:**

```yaml
all:
  vars:
    # Variables specific to all hosts
group_name:
  vars:
    # Variables specific to hosts in this group
  hosts:
    host1.example.com:
      # Variables specific to this host
      server: true
    host2.example.com:
      # Variables specific to this host
      podman: true
```

## Supported Variables
| Variable | Required | Description |
|----------|----------|-------------|
| `server`  | `false`    | Whether this node should be considered a Nomad / Consul server |
| `podman` | `false`| Whether this node should be configured to run Nomad jobs via Podman and it's [associated plugin](https://developer.hashicorp.com/nomad/plugins/drivers/podman) |

**Example Inventory:**

Below is an example inventory demonstrating multiple data centers (`cosmonautical` and `jellify`) and specific variables:

```yaml
all: 
  vars:
    ansible_user: violet
cosmonautical:
  hosts:
    cassiopeia.cosmonautical.cloud:
      server: true
    taurus.cosmonautical.cloud:
      server: true
    copernicus.cosmonautical.cloud:
      server: true
      podman: true

jellify:
  hosts:
    galileo.jellify.app:
      podman: true
```

### Key Concepts:

*   **Groups:** Names like `cosmonautical` or `jellify` represent logical groups of servers.
*   **`vars`:** Variables listed under `vars` apply to *all* hosts listed within that group unless overridden at the host level.
*   **Host Variables:** Variables defined directly under a hostname (e.g., `server: true` under `cassiopeia.cosmonautical.cloud:`) override group variables for that specific host.

**Note:** Ensure that any variables used in `nomadintosh.yml` (e.g., `podman`) are correctly set to `true` or `false` on the relevant hosts if the roles are conditional.
