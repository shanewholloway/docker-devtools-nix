FROM shane/devtools-nix:base-xenial

RUN . /devtools/set-path \
 && /devtools/bin/nix-env --install \
      vim zsh git tmux \
      htop less bind socat \
      nodejs \
 && /devtools/docker-nix-cleanup \
  \
 && mkdir -p /devtools/local/npm /devtools/local/py \
 && echo "export PATH=\"\$PATH:/devtools/local/npm/bin\" " \
      >> /devtools/set-path-after \
  \
 && npm config set prefix '/devtools/local/npm' \
 && npm install -g \
      gulp nodemon mustache \
  \
 && true

MAINTAINER Shane Holloway <shane.holloway@ieee.org>
# TO IMAGE shane/devtools-nix:core-xenial

