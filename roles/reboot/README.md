# reboot

Reboots the host and waits for it to come back online.

## What it does

1. Issues a reboot via Ansible's `reboot` module with a 5-minute timeout for the host to return.

## Usage

This role is used by the `reboot.yml` playbook, invoked via `./reboot.zsh`. Hosts are rebooted one at a time (serial execution) to avoid taking the entire cluster offline simultaneously.

```bash
./reboot.zsh
```

## No manual setup required

No configuration is needed.
