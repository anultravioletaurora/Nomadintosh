# podman

Installs [Podman](https://podman.io/) and initialises a Podman machine on the host, then registers a LaunchAgent to keep the machine running across reboots.

## What it does

1. Installs or upgrades Podman via Homebrew.
2. Checks for an existing Podman machine. If none exists, initialises and starts one.
3. Inspects the machine to obtain its Unix socket path and sets the `podman_socket_path` fact (used by the Nomad role when building the Podman driver config).
4. Templates a LaunchAgent plist to `~/Library/LaunchAgents/com.podman.machine.default.plist` and bootstraps it into launchd so the Podman machine starts automatically on login.

## Host variables

This role is only applied to hosts with `podman: true` set in the inventory.

## No manual setup required

Podman is installed and the machine is initialised entirely automatically. The socket path is discovered at runtime and passed to the Nomad role.
