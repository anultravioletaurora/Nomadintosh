# Nomadintosh

<img src="logo.png" alt="Nomadintosh Logo" width="200" height="225"  />

An Ansible playbook for installing and configuring Nomad + Consul on a macOS cluster.

## What it does

For every host, the `nomad` role performs the following steps:

1. **Directories** — creates config and data directories for both Nomad (`/etc/nomad.d`, `/opt/nomad`) and Consul (`/etc/consul.d`, `/opt/consul`).
2. **Install** — taps `hashicorp/tap` via Homebrew and installs/upgrades `nomad` and `consul`.
3. **Configuration** — templates out `server.hcl` for both Nomad and Consul, with datacenter, node name, server/client mode, and `retry_join` derived automatically from inventory.
4. **Drivers** — on hosts with `podman: true`, downloads the [`nomad-driver-podman`](https://github.com/hashicorp/nomad-driver-podman) source, compiles it with Go, and installs the binary into `/opt/nomad/plugins`.

Services are managed as macOS LaunchAgents (Nomad, Consul, and optionally the Podman machine).

## Roadmap

- [ ] Templating / configuration deployment (`templating.yml` is currently a stub)
