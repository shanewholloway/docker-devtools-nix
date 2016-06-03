FROM ubuntu:xenial

RUN echo "Preparing for Nix (http://nixos.org/nix/)" \
 && mkdir -p -m 0775 /nix /devtools \
 && /bin/echo -e "#!/bin/sh \n\
if ! id -g 842 2>/dev/null ; then \n\
  echo \"Creating 'devtools' (842) group\" \n\
  groupadd --gid 842 --system 'devtools' \n\
  adduser root devtools \n\
fi \n\
\n\
if ! id -u 842 2>/dev/null ; then \n\
  echo \"Creating 'devtools:devtools' user (842:842)\" \n\
  useradd --uid 842 --gid devtools --system \
     --groups 'adm' --home-dir /devtools \
     devtools \n\
fi \n\
\n\
if test -z \"\$LC_ALL\" -o -n \"\$(export LC_ALL=en_US.UTF-8 >/dev/null 2>/dev/stdout)\"; then \n\
  export LC_ALL=en_US.UTF-8 \n\
  localedef -i en_US -f UTF-8 en_US.UTF-8 \n\
fi \n\
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
ENV PATH="/devtools/sbin:/devtools/bin:/devtools/lbin:$PATH" \
    GOSU_VERSION=1.9 \
    TINI_VERSION=v0.9.0

RUN echo "Customizing /devtools for Nix" \
 && mkdir -p ./local/bin \
 && ln -s ./local/bin ./lbin \
 && ln -s ./.nix-profile/bin ./bin \
 && ln -s ./.nix-profile/sbin ./sbin \
 && /bin/echo -e "#!/bin/sh \n\
DEVTOOLS_PATH=\$PATH \n\
if test -e /devtools/.nix-profile; then \n\
  . /devtools/.nix-profile/etc/profile.d/nix.sh \n\
fi \n\
test -z \"\$TERM\" && export TERM=xterm \n\
if test -z \"\$LC_ALL\" ; then \n\
  if test -n \"\$(export LC_ALL=en_US.UTF-8 >/dev/null 2>/dev/stdout)\"; then \n\
    echo 'Locale not set properly. Run:' \n\
    echo \n\
    echo '    sudo localedef -i en_US -f UTF-8 en_US.UTF-8' \n\
    echo \n\
  fi \n\
fi \n\
\n\
export \\\\\\n\
  PATH=\"\$DEVTOOLS_PATH:/devtools/sbin:/devtools/bin:/devtools/lbin\" \\\\\n\
  MANPATH=\"/devtools/.nix-profile/share/man:\$MANPATH\" \\\\\n\
  INFOPATH=\"/devtools/.nix-profile/share/info:\$INFOPATH\" \\\\\n\
  ; \n\
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
  \
 && curl -sSL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture)" \
       -o /devtools/lbin/gosu \
 && curl -sSL "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini" \
       -o /devtools/lbin/tini \
  \
 && chmod +x \
      /devtools/enter \
      /devtools/set-path \
      /devtools/set-path-after \
      /devtools/lbin/docker-nix-cleanup \
      /devtools/lbin/gosu \
      /devtools/lbin/tini \
  \
 && echo "DONE customizing /devtools for Nix"

RUN echo "Installing Nix (http://nixos.org/nix/)" \
 && curl https://nixos.org/nix/install | USER=`whoami` sh \
 && /devtools/bin/nix-env -u \
 && /devtools/lbin/docker-nix-cleanup \
 && echo "DONE installing Nix (http://nixos.org/nix/)"

ENTRYPOINT ["/devtools/enter"]
CMD ["/bin/bash", "-l"]
MAINTAINER Shane Holloway <shane.holloway@ieee.org>
# TO IMAGE shane/devtools-nix:base-xenial
