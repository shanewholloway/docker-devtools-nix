FROM shane/devtools-nix:core-xenial

RUN . /devtools/set-path \
 && /devtools/bin/nix-env --install \
      python3 mercurial \
 && /devtools/docker-nix-cleanup

RUN . /devtools/set-path \
 && python3 -m venv /devtools/local/py \
 #&& python3 -m pip install pip --upgrade \
 && true

MAINTAINER Shane Holloway <shane.holloway@ieee.org>
# TO IMAGE shane/devtools-nix:example-xenial
