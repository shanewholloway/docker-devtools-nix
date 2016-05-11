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
      --home-dir /nix/devtools --shell /bin/false \
      devtools \
 && mkdir -p -m 0755 /nix /nix/devtools \
 && chown -R devtools:devtools /nix /nix/devtools

USER devtools
WORKDIR /nix/devtools

RUN echo "Installing Nix (http://nixos.org/nix/)" \
 && ln -s .nix-profile/bin ./bin \
 && ln -s .nix-profile/sbin ./sbin \
 && echo "#!/bin/bash \n\
DEVTOOLS_PATH=\$PATH \n\
. /nix/devtools/.nix-profile/etc/profile.d/nix.sh \n\
export PATH=\"\$DEVTOOLS_PATH:/nix/devtools/bin\" \
  MANPATH=\"/nix/devtools/.nix-profile/share/man:\$MANPATH\" \
  INFOPATH=\"/nix/devtools/.nix-profile/share/info:\$INFOPATH\" \n\
. /nix/devtools/set-path-after " \
      > /nix/devtools/set-path \
 && echo "#!/bin/bash \n" > /nix/devtools/set-path-after \
 && echo "#!/bin/bash \n\
. /nix/devtools/set-path \n\
exec \"\$@\" " \
      > /nix/devtools/enter \
 && echo "#!/bin/bash \n\
/nix/devtools/bin/nix-collect-garbage --delete-old \n\
/nix/devtools/bin/nix-store --gc \n\
/nix/devtools/bin/nix-store --optimise " \
      > /nix/devtools/docker-nix-cleanup \
 && chmod +x \
      /nix/devtools/enter \
      /nix/devtools/set-path \
      /nix/devtools/set-path-after \
      /nix/devtools/docker-nix-cleanup \
  \
 && curl https://nixos.org/nix/install | USER=`whoami` sh \
 && /nix/devtools/bin/nix-env -u \
 && /nix/devtools/docker-nix-cleanup \
 && echo "DONE installing Nix (http://nixos.org/nix/)"

ENTRYPOINT ["/nix/devtools/enter"]
CMD ["/bin/bash", "-l"]
MAINTAINER Shane Holloway <shane.holloway@ieee.org>
# TO IMAGE shane/nix/devtools-nix-base:xenial
