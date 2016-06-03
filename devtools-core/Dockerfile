FROM shane/devtools-nix:base-xenial

RUN . /devtools/set-path \
 && /devtools/bin/nix-env --install -j `getconf _NPROCESSORS_ONLN` \
      zsh vim neovim tmux \
      git curl nss-cacert-3.23 socat bind net-tools \
      htop less \
      nodejs python3 \
 && /devtools/lbin/docker-nix-cleanup

RUN mkdir -p /devtools/local/npm \
 && echo "export PATH=\"\$PATH:/devtools/local/npm/bin\" " \
      >> /devtools/set-path-after \
  \
 && npm config set prefix '/devtools/local/npm' \
 && npm install -g \
      gulp nodemon mustache \
  \
 && true

ENTRYPOINT ["/devtools/lbin/tini", "--", "/devtools/enter"]
MAINTAINER Shane Holloway <shane.holloway@ieee.org>
# TO IMAGE shane/devtools-nix:core-xenial

