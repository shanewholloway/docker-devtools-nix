FROM shane/devtools-nix-base:xenial

RUN . /nix/devtools/set-path \
 && /nix/devtools/bin/nix-env --install \
      vim zsh git tmux \
      htop less bind socat \
      nodejs \
 && /nix/devtools/docker-nix-cleanup \
 && mkdir -p /nix/devtools/local/npm /nix/devtools/local/py \
 && echo "export PATH=\"\$PATH:/nix/devtools/local/npm/bin\" " \
      >> /nix/devtools/set-path-after \
  \
 && npm config set prefix '/nix/devtools/local/npm' \
 && npm install -g \
      gulp nodemon mustache \
  \
 && true

MAINTAINER Shane Holloway <shane.holloway@ieee.org>
# TO IMAGE shane/devtools-nix-core:xenial

# Then in an inherited Dockerfile, add:
#
#     VOLUME ["$HOMEBREW_PREFIX"]
#

