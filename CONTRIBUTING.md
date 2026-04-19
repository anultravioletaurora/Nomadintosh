# Contributing

Thanks for your interest in contributing to Nomadintosh!

## Getting started

1. Fork the repository and clone your fork.
2. Install dependencies on your control machine:
   ```zsh
   brew install ansible ansible-lint
   ansible-galaxy collection install -r collections/requirements.yml
   ```
3. Copy the example inventory and fill in your hosts:
   ```zsh
   cp inventory/hosts.example.yml inventory/hosts.yml
   ```

## Making changes

- **New roles** should follow the existing structure: `defaults/main.yml`, `tasks/main.yml`, and a `README.md` documenting all variables.
- **Variable names** must be prefixed with the role name (e.g. `consul_`, `nomad_`). This is enforced by `ansible-lint`.
- **Templates** live in `roles/<role>/templates/`. Jinja2 files use `.j2` extensions.

Before opening a pull request, run the dry-run check and linter:

```zsh
./check.zsh       # ansible-playbook --check --diff
ansible-lint      # must pass with 0 failures
```

## Pull requests

- Keep PRs focused — one logical change per PR.
- Update the relevant role `README.md` if you add or rename variables.
- The lint workflow will run automatically on your PR; don't open it until the linter passes locally.

## Reporting issues

Use the issue templates — they ask for the information needed to reproduce problems quickly (affected role, macOS version, architecture, Ansible version).

## Code of conduct

Be excellent to each other.
