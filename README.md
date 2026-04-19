# Nomadintosh

<img src="logo.png" alt="Nomadintosh Logo" width="200" height="225"  />

An Ansible playbook for deploying [Nomad](https://developer.hashicorp.com/nomad/docs) + [Consul](https://developer.hashicorp.com/consul/docs) on a macOS cluster.

**[Nomad](https://developer.hashicorp.com/nomad/docs)** is a workload orchestrator by HashiCorp. It schedules and runs containerised and bare-metal applications across a cluster of machines, similar in spirit to Kubernetes but can run natively on macOS.

**[Consul](https://developer.hashicorp.com/consul/docs)** is a service mesh and service discovery tool, also by HashiCorp. It provides a distributed key-value store, health checking, and DNS-based service discovery. Nomad integrates with Consul natively to handle cluster membership and service registration.

<details>
<summary><strong>Why I built this</strong></summary>

I wanted a job orchestrator to keep my homelab workloads organised, but Kubernetes doesn't run natively on macOS or Apple Silicon — it requires a Linux VM intermediary, which adds overhead and complexity.

My previous homelab was a 3-node [Rancher Harvester](https://harvesterhci.io/) cluster. I wanted to experiment with Apple Silicon to evaluate performance-per-watt as an alternative, and Nomad was the natural fit: it runs as a native macOS binary, supports scheduling workloads directly on the host without a container runtime, and is significantly simpler to operate than Kubernetes at homelab scale.

A bonus of running bare-metal jobs is easy access to full hardware acceleration — no passthrough configuration needed.

Longer term, Nomad's multi-platform support means I can add Linux or Windows agents to the same cluster if needed — for example, running [Exact Audio Copy](https://www.exactaudiocopy.de/) on a Windows node for lossless CD ripping.

![Three Mac Minis stacked in a rack — "cosmonautical", a 3-node cluster comprising 2× M4 Mac Mini and 1× M4 Pro Mac Mini](cluster.jpg)
*"cosmonautical" — 2× M4 Mac Mini + 1× M4 Pro Mac Mini*


</details>

## Requirements

- Ansible installed on the control machine (`brew install ansible`)
- Ansible collections:
  ```
  ansible-galaxy collection install -r collections/requirements.yml
  ```

## Inventory

Hosts are organised into named groups; the group name becomes the Consul/Nomad [**datacenter**](https://developer.hashicorp.com/consul/docs/reference/agent/configuration-file/general#datacenter) for every host in that group. See [inventory/README.md](inventory/README.md) for full instructions on how to populate `inventory/hosts.yml`.

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
2. **Software Update** — downloads all pending macOS system updates via `softwareupdate`, installs any available Command Line Tools for Xcode, and warns if a restart is required.
3. **Homebrew** — Installs Homebrew, taps `hashicorp/tap` and installs any packages listed in `additional_homebrew_packages`.
4. **Docker Desktop** _(hosts with `docker: true`)_ — installs and configures Docker Desktop.
5. **Podman** _(hosts with `podman: true`)_ — installs Podman, initialises the machine, and installs the [`nomad-driver-podman`](https://developer.hashicorp.com/nomad/plugins/drivers/podman) plugin.
6. **Consul** — creates config/data directories, installs Consul via Homebrew, templates [`server.hcl`](https://developer.hashicorp.com/consul/docs/reference/agent/configuration-file) with datacenter, node name, server/client mode, and [`retry_join`](https://developer.hashicorp.com/consul/docs/reference/agent/configuration-file/general#retry_join) derived from inventory, and registers a LaunchAgent.
7. **Nomad** — creates config/data directories, installs Nomad via Homebrew, templates [`server.hcl`](https://developer.hashicorp.com/nomad/docs/configuration) (including [`bootstrap_expect`](https://developer.hashicorp.com/nomad/docs/configuration/server#bootstrap_expect) and [`retry_join`](https://developer.hashicorp.com/nomad/docs/configuration/server_join)), and registers a LaunchAgent.
8. **Nomad Jobs**:
   - **GitHub Actions runner** _(hosts with `gh_actions: true`)_ — templates and deploys a Nomad job for a self-hosted Actions runner.
   - **Minecraft server** _(hosts with `minecraft: true`)_ — templates and deploys a Nomad job for a Minecraft server.

Services are managed as macOS LaunchAgents (Nomad, Consul, and optionally the Podman machine).
