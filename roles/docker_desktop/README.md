# docker_desktop

Installs [Docker Desktop](https://www.docker.com/products/docker-desktop/) on the host via Homebrew Cask.

## What it does

1. Installs the `docker-desktop` cask if it is not already present. The task is skipped if Docker Desktop is already installed.

## Host variables

This role is only applied to hosts with `docker: true` set in the inventory.

## Manual setup required

Docker Desktop requires a user to **accept the licence agreement and complete the first-run setup** through the GUI before it can be used. This role does not automate that step.
