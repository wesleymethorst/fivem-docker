ARG CFX_NUM=90
ARG CFX_URL=https://downloads.cfx-services.net/prod/019f8155-958f-7748-af5a-e80e9b48966c/cfx-server_linux_x64.tar.xz

FROM spritsail/alpine:3.23 AS builder

ARG CFX_URL

WORKDIR /output

RUN mkdir -p /tmp/cfx-artifact \
 && wget -O- "${CFX_URL}" | tar xJ -C /tmp/cfx-artifact \
 && cp -a /tmp/cfx-artifact/alpine/. /output/ \
 && chmod 0755 /output/opt/cfx-server/cfx-server \
 && rm -rf /tmp/cfx-artifact

COPY entrypoint usr/bin/entrypoint

RUN chmod +x /output/usr/bin/entrypoint

#================

FROM spritsail/alpine:3.23

ARG CFX_NUM
ARG CFX_URL

LABEL org.opencontainers.image.authors="Spritsail <fivem@spritsail.io>" \
      org.opencontainers.image.vendor="Spritsail" \
      org.opencontainers.image.title="FiveM GTAV Enhanced txAdmin Server" \
      org.opencontainers.image.url="https://fivem.net" \
      org.opencontainers.image.description="txAdmin-only Cfx Server image for FiveM for GTAV Enhanced." \
      org.opencontainers.image.version=${CFX_NUM} \
      io.spritsail.version.cfx=${CFX_NUM} \
      io.spritsail.source.cfx=${CFX_URL}

COPY --from=builder /output/ /
RUN test -x /opt/cfx-server/cfx-server \
 && apk add --no-cache bash tini

WORKDIR /txData
EXPOSE 30120 40120

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/entrypoint"]
