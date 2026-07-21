ARG CFX_NUM=90
ARG CFX_URL=https://downloads.cfx-services.net/prod/019f8155-958f-7748-af5a-e80e9b48966c/cfx-server_linux_x64.tar.xz
ARG DATA_VER=e265cb251c88260533c847d4a1a2838c7d828a66

FROM spritsail/alpine:3.23 AS builder

ARG CFX_URL
ARG DATA_VER

WORKDIR /output

RUN mkdir -p /tmp/cfx-artifact \
 && wget -O- "${CFX_URL}" | tar xJ -C /tmp/cfx-artifact \
 && cp -a /tmp/cfx-artifact/alpine/. /output/ \
 && chmod 0755 /output/opt/cfx-server/cfx-server \
 && rm -rf /tmp/cfx-artifact \
 && mkdir -p /output/opt/cfx-server-data /output/usr/local/share \
 && wget -O- https://github.com/citizenfx/cfx-server-data/archive/${DATA_VER}.tar.gz \
        | tar xz --strip-components=1 -C opt/cfx-server-data

ADD server.cfg opt/cfx-server-data
ADD entrypoint usr/bin/entrypoint

RUN chmod +x /output/usr/bin/entrypoint

#================

FROM spritsail/alpine:3.23

ARG CFX_NUM
ARG CFX_URL
ARG DATA_VER

LABEL org.opencontainers.image.authors="Spritsail <fivem@spritsail.io>" \
      org.opencontainers.image.vendor="Spritsail" \
      org.opencontainers.image.title="Cfx Server for FiveM GTAV Enhanced" \
      org.opencontainers.image.url="https://fivem.net" \
      org.opencontainers.image.description="Cfx Server for hosting a FiveM for GTAV Enhanced server." \
      org.opencontainers.image.version=${CFX_NUM} \
      io.spritsail.version.cfx=${CFX_NUM} \
      io.spritsail.source.cfx=${CFX_URL} \
      io.spritsail.version.fivem_data=${DATA_VER}

COPY --from=builder /output/ /
RUN test -x /opt/cfx-server/cfx-server \
 && apk add --no-cache tini

WORKDIR /config
EXPOSE 30120

# Default to an empty CMD, so we can use it to add seperate args to the binary
CMD [""]

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/entrypoint"]
