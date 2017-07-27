FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    cmake ninja-build make git \
    exuberant-ctags perl binutils abi-dumper \
    pkg-config g++ gcc ccache


ADD https://github.com/lvc/abi-compliance-checker/archive/2.1.tar.gz /
RUN tar -xvf 2.1.tar.gz
WORKDIR abi-compliance-checker-2.1
RUN make install prefix=/usr

VOLUME /scripts
VOLUME /results

ARG UNAME=test
ARG UID
ARG GID
RUN groupadd -g $GID $UNAME
RUN useradd -m -u $UID -g $GID -s /bin/bash $UNAME

USER test
WORKDIR /home/test
CMD /bin/bash
