# github_actions

Templates and registers a [GitHub Actions self-hosted runner](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners) as a Nomad job using the `raw_exec` driver.

## What it does

1. Templates `github-actions-runner.nomad.hcl` from the Jinja2 template and writes it to `{{ nomad_jobs_dir }}/actions-runner.nomad.hcl`.
2. Submits the job to Nomad via `nomad job run`.

The job runs the runner's `run.sh` script directly as a long-running service, allocating 10 GB of memory and minimal CPU.

## Host variables

This role is only applied to hosts with `gh_actions: true` set in the inventory.

## Manual setup required

The GitHub Actions runner must be **downloaded and configured manually on the host before this role runs**. Specifically:

1. Go to your repository (or organisation) → **Settings** → **Actions** → **Runners** → **New self-hosted runner**.
2. Follow the GitHub instructions to download and configure the runner. Accept all defaults for the installation directory — the role expects the runner's `run.sh` to exist at the path defined by `gh_actions_executable`.
3. **Do not** start or install the runner as a service — Nomad manages its lifecycle.

## Configuration

| Variable | Default | Purpose |
|---|---|---|
| `gh_actions_executable` | `/opt/github-actions/run.sh` | Path to the runner's `run.sh` script on the host |
| `job_name` | `actions-runner` | Nomad job name |
| `job_file_dest` | `{{ nomad_jobs_dir }}/actions-runner.nomad.hcl` | Where the rendered job file is written |
