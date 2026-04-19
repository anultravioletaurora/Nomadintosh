# Inventory File Guide for Nomadintosh

This document explains how to structure your Ansible inventory file (`hosts.yml`) when deploying services using `playbooks/nomadintosh.yml`.

## Key Concepts

### Datacenter derivation

The **group name** each host belongs to becomes its Consul/Nomad **datacenter**. This is derived automatically from `group_names` at runtime — you do not set a `datacenter` variable manually. Every host in the `cosmonautical` group will belong to the `cosmonautical` datacenter, and so on.

### Servers vs. clients

Hosts with `server: true` form the Nomad/Consul control plane for their datacenter. All other hosts are enrolled as client nodes that schedule and run workloads. The `bootstrap_expect` value is set automatically based on how many `server: true` hosts exist in the inventory.

### `retry_join`

Both Nomad and Consul are configured to `retry_join` every host across the full inventory that has `server: true`. You do not need to maintain this list manually.

---

## Inventory Structure

```yaml
all:
  vars:
    # Applied to every host
<datacenter-name>:
  hosts:
    <server1.example.com>:
      server: true
    <client1.example.com>:
      podman: true
      gh_actions: true
```

Variables defined directly under a hostname override any group-level `vars` for that host.

---

## Supported Variables

### Connection variables (set under `all.vars` or per-group `vars`)

| Variable | Description |
|----------|-------------|
| `ansible_user` | SSH user for all hosts |
| `ansible_ssh_private_key_file` | Path to the SSH private key |
| `ansible_password` | SSH password (if not using key auth) |
| `ansible_become_password` | `sudo` password |
| `additional_homebrew_packages` | List of extra Homebrew packages to install on every host |

### Host variables (set per-host)

| Variable | Default | Description |
|----------|---------|-------------|
| `server` | `false` | Configures the host as a Nomad/Consul server node |
| `podman` | `false` | Installs Podman and the [nomad-driver-podman](https://developer.hashicorp.com/nomad/plugins/drivers/podman) plugin |
| `docker` | `false` | Installs Docker Desktop and enables the Nomad Docker driver |
| `gh_actions` | `false` | Deploys a GitHub Actions self-hosted runner as a Nomad job |
| `minecraft` | `false` | Deploys a Minecraft server as a Nomad job |
| `volumes` | _(absent)_ | List of host volumes to expose to the Nomad client (see below) |

#### `volumes` format

The `volumes` variable accepts a list of objects with `name` and `path` keys. Each entry is registered as a [Nomad host volume](https://developer.hashicorp.com/nomad/docs/configuration/client#host_volume) on the client:

```yaml
volumes:
  - name: config
    path: /Users/myuser/.config
  - name: data
    path: /opt/myapp/data
```

---

## Example Inventory

```yaml
all:
  vars:
    ansible_user: violet
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
    additional_homebrew_packages:
      - fastfetch

cosmonautical:
  hosts:
    cassiopeia.cosmonautical.cloud:
      server: true
    taurus.cosmonautical.cloud:
      server: true
    copernicus.cosmonautical.cloud:
      server: true
      docker: true
      podman: true
      volumes:
        - name: config
          path: /Users/violet/.config

jellify:
  hosts:
    galileo.jellify.app:
      podman: true
      gh_actions: true
      minecraft: true
```

In this example, `cosmonautical` and `jellify` are two separate datacenters. The three `cassiopeia`, `taurus`, and `copernicus` hosts form the `cosmonautical` control plane (`bootstrap_expect = 3`). `galileo` is a client-only node in the `jellify` datacenter running Nomad jobs via Podman.
