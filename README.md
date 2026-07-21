[hub]: https://hub.docker.com/r/spritsail/fivem
[git]: https://github.com/spritsail/fivem
[drone]: https://drone.spritsail.io/spritsail/fivem

# [spritsail/fivem][hub]

[![Latest Version](https://img.shields.io/docker/v/spritsail/fivem)][git]
[![Image Size](https://img.shields.io/docker/image-size/spritsail/fivem)][hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/spritsail/fivem.svg)][hub]
[![Docker Stars](https://img.shields.io/docker/stars/spritsail/fivem.svg)][hub]
[![Build Status](https://drone.spritsail.io/api/badges/spritsail/fivem/status.svg)][drone]

This Docker image runs the Linux Cfx Server for **FiveM for GTAV Enhanced**. It uses
the separate Enhanced server artifact published on the official Cfx.re download page.
Upon first run, the configuration is generated in the host mount for the `/config` directory.
The container should be stopped so fivem can be configured to the user requirements in the `server.cfg`.

## Build

Build the local Enhanced image with:

```sh
docker compose build
```

The resulting image is named `fivem-enhanced:90`. The artifact URL and build number
are pinned in the `Dockerfile`, so builds remain reproducible.

## GitHub Container Registry

The GitHub Actions workflow builds the image after every branch push and can also
be started manually from the Actions tab. Branch builds publish a commit SHA tag;
the default branch additionally publishes `latest` and build number `90`:

```text
ghcr.io/<github-user>/fivem-enhanced:latest
ghcr.io/<github-user>/fivem-enhanced:90
ghcr.io/<github-user>/fivem-enhanced:sha-<commit>
```

Pull the published image with:

```sh
docker pull ghcr.io/<github-user>/fivem-enhanced:latest
```

The first published package may be private. Its visibility can be changed to public
under the package settings on GitHub.

## License Key

A freely obtained license key is required to use this server, which should be declared as `$LICENSE_KEY`. A tutorial on how to obtain a license key can be found [here](https://forum.fivem.net/t/explained-how-to-make-add-a-server-key/56120).

## Usage

Use the `docker-compose` script provided if you wish to run a couchdb server with FiveM, else use the line below:

```sh
docker run -d \
  --name FiveM \
  --restart=on-failure \
  -e LICENSE_KEY=<your-license-here> \
  -p 30120:30120 \
  -p 30120:30120/udp \
  -v /volumes/fivem:/config \
  -ti \
  fivem-enhanced:90
```

_It is important that you use `interactive` and `pseudo-tty` options otherwise the container will crash on startup_
See [issue #3](https://github.com/spritsail/fivem/issues/3)

## Image tag

The local image is tagged with its Cfx Server build number. Update `CFX_NUM` and
`CFX_URL` together when a newer Enhanced Linux artifact is published.

### Web UI (txAdmin)

The web UI can be enabled by not passing any `+exec` config to the FXServer binary. This can be achieved by setting the `NO_DEFAULT_CONFIG` environment variable (see below).

`txAdmin` stores it's configuration and database data in `/txData`, so a volume can be set up to persist this data:

```sh
docker run -d \
  --name FiveM \
  --restart=on-failure \
  -e LICENSE_KEY=<your-license-here> \
  -p 30120:30120 \
  -p 30120:30120/udp \
  -p 40120:40120 \ # Allow txAdmin's webserver port to be accessible
  -v /volumes/fivem:/config \
  -v /volumes/txData:/txData \ # Can use a named volume as well -v txData:/txData \
  -ti \
  fivem-enhanced:90
```

### Environment Variables

- `LICENSE_KEY` - This is a required variable for the license key needed to start the server.
- `RCON_PASSWORD` - A password to use for the RCON functionality of the fxserver. If not specified, a random 16 character password is assigned. This is only used upon creation of the default configs
- `NO_DEFAULT_CONFIG` - Optional. Set to any non-zero value to disable the default exec config. This is required for txAdmin.
- `NO_LICENSE_KEY` - Optional. Set to any non-zero length value to disable specifying the license key in the environment. Useful if your license key is in a config file.
- `NO_ONESYNC` - Optional. Set to any non-zero value to disable OneSync being added to the default configs.
