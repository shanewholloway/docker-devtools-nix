FROM ubuntu:xenial

RUN echo "Preparing for Nix (http://nixos.org/nix/)" \
 && mkdir -p -m 0775 /nix /devtools \
 && /bin/echo -e "#!/bin/sh \n\
!(id -g 842 2>/dev/null) \
 && echo 'Creating 'devtools' (842) group' \
 && groupadd --gid 842 --system 'devtools' \
 && adduser root devtools \
\n\
\n\
!(id -u 842 2>/dev/null) \
 && echo 'Creating 'devtools:devtools' user (842:842) ' \
 && useradd  --uid 842 --gid devtools --system \
     --groups 'adm' --home-dir /devtools \
     devtools \
\n\
\n\
" > /devtools/ensure-user \
 && chmod +x /devtools/ensure-user \
 && /devtools/ensure-user \
 && chown -R 842:842 /nix /devtools \
 && chown -R   0:842 /root \
  \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -q -y --no-install-recommends \
      ca-certificates curl bzip2 xz-utils \
      vim sudo file less \
      man \
 && rm -rf /var/lib/apt/lists/* \
  \
 && echo '\numask -S 0002  # set umask for devtools images \n' >>/etc/profile \
 && echo '%devtools ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers \
 && true

USER devtools
WORKDIR /devtools

RUN echo "Installing Nix (http://nixos.org/nix/)" \
 && mkdir -p ./local/bin \
 && ln -s ./local/bin ./lbin \
 && ln -s ./.nix-profile/bin ./bin \
 && ln -s ./.nix-profile/sbin ./sbin \
 && /bin/echo -e "#!/bin/sh \n\
DEVTOOLS_PATH=\$PATH \n\
. /devtools/.nix-profile/etc/profile.d/nix.sh \n\
export LC_ALL='C.UTF-8' \
  PATH=\"\$DEVTOOLS_PATH:/devtools/sbin:/devtools/bin:/devtools/lbin\" \
  MANPATH=\"/devtools/.nix-profile/share/man:\$MANPATH\" \
  INFOPATH=\"/devtools/.nix-profile/share/info:\$INFOPATH\" \
  \n\
. /devtools/set-path-after " \
      > /devtools/set-path \
 && /bin/echo -e "#!/bin/sh \n" > /devtools/set-path-after \
 && /bin/echo -e "#!/bin/sh \n\
. /devtools/set-path \n\
exec \"\$@\" " \
      > /devtools/enter \
 && /bin/echo -e "#!/bin/sh \n\
/devtools/bin/nix-collect-garbage --delete-old \n\
/devtools/bin/nix-store --optimise " \
      > /devtools/lbin/docker-nix-cleanup \
 && chmod +x \
      /devtools/enter \
      /devtools/set-path \
      /devtools/set-path-after \
      /devtools/lbin/docker-nix-cleanup \
  \
 && curl https://nixos.org/nix/install | USER=`whoami` sh \
 && /devtools/bin/nix-env -u \
 && /devtools/lbin/docker-nix-cleanup \
 && echo "DONE installing Nix (http://nixos.org/nix/)"

ENTRYPOINT ["/devtools/enter"]
CMD ["/bin/bash", "-l"]
MAINTAINER Shane Holloway <shane.holloway@ieee.org>
# TO IMAGE shane/devtools-nix:base-xenial
