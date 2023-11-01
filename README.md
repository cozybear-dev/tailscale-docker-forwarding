# tailscale-docker-forwarding
This is a small PoC that generates two docker compose files. 

home    -> server to host a socks5 proxy to tunnel traffic into the tailnet by other services on the system.
target  -> server that redirects all traffic to a dedicated target within its network environment.

Somewhat strict ACL applies.

.env.example has two options;

- on disk
- fetch it using unlocked Bitwarden CLI

If you care about security, use Bitwarden CLI option.

To import in your shell;

```
source .env
```
```