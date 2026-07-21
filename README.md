# FiveM for GTAV Enhanced — txAdmin

Docker image for running the Linux Cfx Server for FiveM for GTAV Enhanced with
txAdmin. This image is txAdmin-only; vanilla `server.cfg` startup is not included.

## Image

```text
ghcr.io/wesleymethorst/fivem-enhanced:enhanced
```

The `enhanced` tag is updated by GitHub Actions after a push to the `enhanced`
branch. Commit-specific `sha-*` tags are also published.

## Dokploy

```yaml
services:
  fivem:
    image: ghcr.io/wesleymethorst/fivem-enhanced:enhanced
    pull_policy: always
    restart: unless-stopped
    tty: true
    stdin_open: true
    environment:
      TXADMIN_PORT: "40120"
      TXADMIN_INTERFACE: "0.0.0.0"
      TXDATA_PATH: "/txData"
    volumes:
      - /home/fivem/woenselcombat:/txData
    ports:
      - "30120:30120/tcp"
      - "30120:30120/udp"
      - "40120:40120/tcp"
```

Open txAdmin at `http://<server-ip>:40120`. Enter the Cfx.re license key during
the txAdmin setup; do not set `LICENSE_KEY` or `NO_DEFAULT_CONFIG` in Compose.

For a second server, keep the container ports unchanged and change only the host
ports, for example `30121:30120` and `40121:40120`.

## Configuration

| Variable | Default | Description |
|---|---|---|
| `TXADMIN_PORT` | `40120` | Internal txAdmin web port |
| `TXADMIN_INTERFACE` | `0.0.0.0` | Listen on all container interfaces |
| `TXDATA_PATH` | `/txData` | Persistent txAdmin data directory |
| `DEBUG` | empty | Enables shell tracing when set |

## Local build

```sh
docker build -t fivem-enhanced:txadmin .
```
