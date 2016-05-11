FROM shane/devtools-nix-core:xenial

RUN echo "Updating pip and npm devtools…" \
 && . /nix/devtools/set-path \
 && /nix/devtools/bin/nix-env --install \
      python3 mercurial \
 && /nix/devtools/docker-nix-cleanup

RUN . /nix/devtools/set-path \
 && python3 -m venv init /nix/devtools/local/py
 #&& python3 -m pip install pip --upgrade

VOLUME ["/nix"]

MAINTAINER Shane Holloway <shane.holloway@ieee.org>
# TO IMAGE shane/devtools-nix-tip:xenial
