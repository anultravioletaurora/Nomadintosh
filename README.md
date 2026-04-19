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

Hosts are organised into named groups; the group name becomes the Consul/Nomad **datacenter** for every host in that group. See [inventory/README.md](inventory/README.md) for full instructions on how to populate `inventory/hosts.yml`.

**Host variables:**

| Variable | Values | Purpose |
|---|---|---|
| `server` | `true` / _(absent)_ | Configures the host as a Nomad/Consul server |
| `podman` | `true` / _(absent)_ | Installs and configures the Podman task driver |
| `docker` | `true` / _(absent)_ | Installs and configures Docker Desktop |
| `gh_actions` | `true` / _(absent)_ | Deploys a GitHub Actions runner Nomad job |
| `minecraft` | `true` / _(absent)_ | Deploys a Minecraft server Nomad job |

## Running the playbook

Run a full deployment:

```bash
./deploy.zsh
```

Dry-run in check + diff mode to preview changes without applying them:

```bash
./check.zsh
```

Serial Reboot all hosts in the inventory:

```bash
./reboot.zsh
```

To limit execution to a single host or group, you can also pass `--limit` directly to the underlying playbook:

```bash
ansible-playbook -i inventory/hosts.yml playbooks/nomadintosh.yml --limit <hostname>
```

## What it does

For every host, the playbook performs the following steps:

1. **Facts** — asserts the host is running macOS and gathers additional inventory-derived facts (datacenter, `retry_join` peer list).
2. **Homebrew** — Installs Homebrew, taps `hashicorp/tap` and installs any packages listed in `additional_homebrew_packages`.
3. **Docker Desktop** _(hosts with `docker: true`)_ — installs and configures Docker Desktop.
4. **Podman** _(hosts with `podman: true`)_ — installs Podman, initialises the machine, and installs the [`nomad-driver-podman`](https://developer.hashicorp.com/nomad/plugins/drivers/podman) plugin.
5. **Consul** — creates config/data directories, installs Consul via Homebrew, templates `server.hcl` with datacenter, node name, server/client mode, and `retry_join` derived from inventory, and registers a LaunchAgent.
6. **Nomad** — creates config/data directories, installs Nomad via Homebrew, templates `server.hcl`, and registers a LaunchAgent.
7. **Nomad Jobs**:
   - **GitHub Actions runner** _(hosts with `gh_actions: true`)_ — templates and deploys a Nomad job for a self-hosted Actions runner.
   - **Minecraft server** _(hosts with `minecraft: true`)_ — templates and deploys a Nomad job for a Minecraft server.

Services are managed as macOS LaunchAgents (Nomad, Consul, and optionally the Podman machine).
