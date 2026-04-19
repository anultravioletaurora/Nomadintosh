# minecraft

Installs a Minecraft server and registers it as a Nomad job using the `raw_exec` driver.

## What it does

1. Installs a JRE via the `temurin` Homebrew cask (required to run the Minecraft server).
2. Installs the `minecraft-server` Homebrew cask.
3. Templates `minecraft-server.nomad.hcl` and writes it to `{{ nomad_jobs_dir }}/minecraft-server.nomad.hcl`.
4. Submits the job to Nomad via `nomad job run`.

The Nomad job exposes the following static ports:

| Port | Protocol | Purpose |
|---|---|---|
| `25565` | TCP | Minecraft Java Edition |
| `25575` | TCP | RCON |
| `19132` | UDP | Minecraft Bedrock Edition |

Both the Java and Bedrock services are registered with Consul for service discovery.

## Host variables

This role is only applied to hosts with `minecraft: true` set in the inventory.

## No manual setup required

The server binary and its runtime dependency (JRE) are installed automatically via Homebrew.

## Configuration

| Variable | Default | Purpose |
|---|---|---|
| `minecraft_server_executable` | `{{ homebrew_dir }}/bin/minecraft-server` | Path to the server binary |
| `job_name` | `minecraft-server` | Nomad job name |
| `job_file_dest` | `{{ nomad_jobs_dir }}/minecraft-server.nomad.hcl` | Where the rendered job file is written |
