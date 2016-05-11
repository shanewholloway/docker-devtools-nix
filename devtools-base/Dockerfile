FROM ubuntu:xenial

RUN echo "Preparing for Nix (http://nixos.org/nix/)" \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -q -y --no-install-recommends \
      locales ca-certificates curl bzip2 xz-utils \
      vim sudo file less \
      man most \
 && rm -rf /var/lib/apt/lists/* \
 && localedef -i en_US -f UTF-8 en_US.UTF-8 \
 && groupadd --gid 2042 "devtools" \
 && useradd  --uid 2042 --gid 2042 --groups "adm,sudo" \
      --home-dir /devtools --shell /bin/false \
      devtools \
 && mkdir -p -m 0755 /nix /devtools \
 && chown -R devtools:devtools /nix /devtools

USER devtools
WORKDIR /devtools

RUN echo "Installing Nix (http://nixos.org/nix/)" \
 && ln -s .nix-profile/bin ./bin \
 && ln -s .nix-profile/sbin ./sbin \
 && echo "#!/bin/sh \n\
DEVTOOLS_PATH=\$PATH \n\
. /devtools/.nix-profile/etc/profile.d/nix.sh \n\
export PATH=\"\$DEVTOOLS_PATH:/devtools/bin\" \
  MANPATH=\"/devtools/.nix-profile/share/man:\$MANPATH\" \
  INFOPATH=\"/devtools/.nix-profile/share/info:\$INFOPATH\" \n\
. /devtools/set-path-after " \
      > /devtools/set-path \
 && echo "#!/bin/sh \n" > /devtools/set-path-after \
 && echo "#!/bin/sh \n\
. /devtools/set-path \n\
exec \"\$@\" " \
      > /devtools/enter \
 && echo "#!/bin/sh \n\
/devtools/bin/nix-collect-garbage --delete-old \n\
/devtools/bin/nix-store --gc \n\
/devtools/bin/nix-store --optimise " \
      > /devtools/docker-nix-cleanup \
 && chmod +x \
      /devtools/enter \
      /devtools/set-path \
      /devtools/set-path-after \
      /devtools/docker-nix-cleanup \
  \
 && curl https://nixos.org/nix/install | USER=`whoami` sh \
 && /devtools/bin/nix-env -u \
 && /devtools/docker-nix-cleanup \
 && echo "DONE installing Nix (http://nixos.org/nix/)"

ENTRYPOINT ["/devtools/enter"]
CMD ["/bin/bash", "-l"]
MAINTAINER Shane Holloway <shane.holloway@ieee.org>
# TO IMAGE shane/devtools-nix:base-xenial
