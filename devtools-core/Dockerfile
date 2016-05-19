FROM shane/devtools-nix:base-xenial

RUN . /devtools/set-path \
 && /devtools/bin/nix-env --install \
      vim neovim zsh git tmux \
      htop less bind socat \
      curl wget \
      nodejs python3 \
 && /devtools/lbin/docker-nix-cleanup

ENV PATH="/devtools/sbin:/devtools/bin:/devtools/lbin:$PATH" \
    GOSU_VERSION=1.9 \
    TINI_VERSION=v0.9.0

RUN mkdir -p /devtools/local/npm \
 && echo "export PATH=\"\$PATH:/devtools/local/npm/bin\" " \
      >> /devtools/set-path-after \
  \
 && npm config set prefix '/devtools/local/npm' \
 && npm install -g \
      gulp nodemon mustache \
  \
 && curl -sSL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture)" \
       -o /devtools/lbin/gosu \
 && curl -sSL "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini" \
       -o /devtools/lbin/tini \
 && chmod +x \
       /devtools/lbin/gosu \
       /devtools/lbin/tini \
 && true

ENTRYPOINT ["/devtools/lbin/tini", "--", "/devtools/enter"]
CMD ["zsh", "-l"]
MAINTAINER Shane Holloway <shane.holloway@ieee.org>
# TO IMAGE shane/devtools-nix:core-xenial

