# docker-devtools-nix
DevOps tools using [Nix package manager](http://nixos.org/nix/)

### Using

Make a named container using your `shane/devtools-nix` derived image:

    docker run --name my_devtools \
      -v /devtools -v /nix
      shane/devtools-nix:example

Then compose your devtool container using `--volumes-from my_devtools` which shares `/devtools` between containers

    docker run --rm -it \
      --volumes-from my_devtools \
      ubuntu:xenial \
      /nix/devtools/bin/node -p process.versions

