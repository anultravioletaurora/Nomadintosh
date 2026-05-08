# notify

Posts a webhook notification. Used internally by other roles to send status updates on deployment events.

## What it does

POSTs a JSON payload to every URL in the `notifications` list. Execution is delegated to localhost so the request originates from the control machine regardless of which host triggered it. The task runs with `no_log: true` to prevent webhook URLs from appearing in output.

## Variables

| Variable | Required | Default | Purpose |
|---|---|---|---|
| `notifications` | Yes | `[]` | List of `{url}` objects — store in Ansible Vault. If empty or absent the role is a no-op. |
| `notify_webhook_message` | Yes | — | The message string to send. |
| `webhook_username` | No | `"Ansible"` | Display name shown alongside the message. |
| `webhook_body` | No | `{content, username}` | Override the entire POST body. Use this for platforms with a different payload schema than Discord/Slack. |

## Usage

```yaml
- name: Send notification
  ansible.builtin.include_role:
    name: notify
  vars:
    notify_webhook_message: "Deployment completed on {{ inventory_hostname }}."
```

## Notes

- The default body format (`content` + `username`) is compatible with Discord and Slack incoming webhooks.
- `notifications` is expected to be a list to support multiple destinations in a single call.
- Store `notifications` in Ansible Vault — never commit webhook URLs in plaintext.
