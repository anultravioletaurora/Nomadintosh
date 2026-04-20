# Nomad Jobs

This document describes the Nomad jobs that can be deployed by this playbook. Each job is opt-in and enabled per-host via inventory variables (see [README.md](README.md)).

## Summary matrix

| Job | Nomad Job Name | Driver | Deployment Type | CPU | Memory | Ports | Consul Services | Enabled By |
|---|---|---|---|---|---|---|---|---|
| [GitHub Actions Runner](#github-actions-runner) | `actions-runner` | `raw_exec` | Bare metal | 20 MHz | 10 GB | — | — | `gh_actions: true` |
| [Minecraft Server](#minecraft-server) | `minecraft` | `raw_exec` | Bare metal | 6 cores | 6 GB | 25565/TCP, 25575/TCP, 19132/UDP | `minecraft-server-java`, `minecraft-server-bedrock` | `minecraft: true` |

---

## GitHub Actions Runner

Registers a [GitHub Actions self-hosted runner](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners) as a long-running Nomad service.

| Property | Value |
|---|---|
| Nomad job name | `actions-runner` |
| Job type | `service` |
| Nomad driver | `raw_exec` |
| Deployment type | Bare metal |
| CPU reservation | 20 MHz |
| Memory reservation | 10 GB |
| Network ports | None |
| Consul services | None |
| Installed by playbook | No — manual setup required |
| Inventory variable | `gh_actions: true` |

### How it works

The job runs the runner's `run.sh` script directly via `raw_exec`. Nomad manages the process lifecycle (start, stop, restart on failure).

### Prerequisites

The GitHub Actions runner must be **manually downloaded and configured on the host** before this role runs:

1. Navigate to your repository or organisation → **Settings** → **Actions** → **Runners** → **New self-hosted runner**.
2. Follow GitHub's instructions to download and configure the runner, accepting the default installation directory.
3. **Do not** start the runner as a service — Nomad will manage it.

### Configuration

| Variable | Default | Purpose |
|---|---|---|
| `github_actions_executable` | `/opt/github-actions/run.sh` | Path to the runner's `run.sh` on the host |
| `github_actions_job_name` | `actions-runner` | Nomad job name |
| `github_actions_job_file_dest` | `{{ nomad_jobs_dir }}/actions-runner.nomad.hcl` | Rendered job file path |

---

## Minecraft Server

Installs a Minecraft server via Homebrew and registers it as a long-running Nomad service. Supports both Java Edition and Bedrock Edition clients simultaneously.

| Property | Value |
|---|---|
| Nomad job name | `minecraft` |
| Job type | `service` |
| Nomad driver | `raw_exec` |
| Deployment type | Bare metal |
| CPU reservation | 6 cores |
| Memory reservation | 6 GB |
| Network ports | 25565/TCP (Java), 25575/TCP (RCON), 19132/UDP (Bedrock) |
| Consul services | `minecraft-server-java`, `minecraft-server-bedrock` |
| Installed by playbook | Yes — via `minecraft-server` Homebrew cask |
| JRE | [Eclipse Temurin](https://adoptium.net/) — installed via `temurin` Homebrew cask |
| Inventory variable | `minecraft: true` |

### How it works

The playbook installs the Eclipse Temurin JRE and the `minecraft-server` Homebrew cask, then templates and registers a Nomad job that runs the server binary directly via `raw_exec`. Both the Java and Bedrock endpoints are registered with Consul for service discovery.

### Ports

| Port | Protocol | Purpose |
|---|---|---|
| `25565` | TCP | Minecraft Java Edition clients |
| `25575` | TCP | RCON (remote console) |
| `19132` | UDP | Minecraft Bedrock Edition clients |

### Configuration

| Variable | Default | Purpose |
|---|---|---|
| `minecraft_server_executable` | `{{ homebrew_dir }}/bin/minecraft-server` | Path to the server binary |
| `minecraft_job_name` | `minecraft-server` | Nomad job name |
| `minecraft_job_file_dest` | `{{ nomad_jobs_dir }}/minecraft-server.nomad.hcl` | Rendered job file path |
