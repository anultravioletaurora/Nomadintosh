# Nomadintosh

<img src="logo.png" alt="Nomadintosh Logo" width="200" height="225"  />

An Ansible playbook for installing and configuring Nomad + Consul on a macOS cluster.

## Requirements

- Ansible installed on the control machine (`brew install ansible`)
- Ansible collections:
  ```
  ansible-galaxy collection install -r collections/requirements.yml
  ```

## Inventory

Copy the structure below to `inventory/hosts.yml` and fill in your own hostnames and credentials. Hosts are organised into named groups; the group name becomes the Consul/Nomad **datacenter** for every host in that group.

```yaml
# Nomad/Consul server nodes (control plane)
<datacenter-name>:
  vars:
    ansible_user: <ssh-user>
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
    # ansible_password / ansible_become_password if needed
  hosts:
    <server1.example.com>:
      server: true
    <server2.example.com>:
      server: true
    <server3.example.com>:
      server: true

# Nomad/Consul client nodes (workload runners)
<datacenter-name>:
  vars:
    ansible_user: <ssh-user>
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
  hosts:
    <client1.example.com>:
      podman: true   # set to enable the Podman task driver
```

**Host variables:**

| Variable | Values | Purpose |
|---|---|---|
| `server` | `true` / _(absent)_ | Configures the host as a Nomad/Consul server |
| `podman` | `true` / _(absent)_ | Installs and configures the Podman task driver |

## Running the playbook

```bash
ansible-playbook playbooks/nomad.yml -i inventory/hosts.yml
```

Pass `--diff` to preview config file changes before they are applied:

```bash
ansible-playbook playbooks/nomad.yml -i inventory/hosts.yml --diff
```

Limit execution to a single host or group:

```bash
ansible-playbook playbooks/nomad.yml -i inventory/hosts.yml --limit <hostname>
```

## What it does

For every host, the `nomad` role performs the following steps:

1. **Directories** — creates config and data directories for both Nomad (`/etc/nomad.d`, `/opt/nomad`) and Consul (`/etc/consul.d`, `/opt/consul`).
2. **Install** — taps `hashicorp/tap` via Homebrew and installs/upgrades `nomad` and `consul`.
3. **Configuration** — templates out `server.hcl` for both Nomad and Consul, with datacenter, node name, server/client mode, and `retry_join` derived automatically from inventory.
4. **Drivers** — on hosts with `podman: true`, downloads the [`nomad-driver-podman`](https://github.com/hashicorp/nomad-driver-podman) source, compiles it with Go, and installs the binary into `/opt/nomad/plugins`.

Services are managed as macOS LaunchAgents (Nomad, Consul, and optionally the Podman machine).

## Roadmap

- [ ] Templating / configuration deployment (`templating.yml` is currently a stub)
