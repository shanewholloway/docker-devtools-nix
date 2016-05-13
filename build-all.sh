#!/bin/bash
echo -e ":: Building 'devtools-nix' chain ::\n" \
  \
  && echo -e "\n\n:: Build 'devtools-nix:base' ::\n" \
  && docker build \
      -t shane/devtools-nix:base-xenial \
      -t shane/devtools-nix:base \
      ./devtools-base \
  \
  && echo -e "\n\n:: Build 'devtools-nix:core' ::\n" \
  && docker build \
      -t shane/devtools-nix:core-xenial \
      -t shane/devtools-nix:core \
      -t shane/devtools-nix:latest \
      ./devtools-core \
  \
  && echo -e "\n\n:: Build 'devtools-nix:example' ::\n" \
  && docker build \
      -t shane/devtools-nix:example-xenial \
      -t shane/devtools-nix:example \
      ./devtools-example \
  \
  && echo -e "\n\n:: Completed building 'devtools-nix' chain ::\n" \
  && true
