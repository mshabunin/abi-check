#!/bin/bash

set -e

DST=/results

pushd $HOME
git clone https://github.com/opencv/opencv
[ -d build ] && rm -rf build || mkdir -p build
popd

build() {
    pushd $HOME/opencv
    git checkout $1
    git reset --hard
    popd

    pushd $HOME/build && rm -rf *
    PATH=/usr/lib/ccache:$PATH \
        cmake -GNinja \
            -DGENERATE_ABI_DESCRIPTOR=ON \
            -DCMAKE_INSTALL_PREFIX=install \
            -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_opencv_apps=OFF -DBUILD_EXAMPLES=OFF \
            ../opencv
    ninja install
    popd
}

dump() {
    pushd $DST
    abi-compliance-checker \
        -l opencv \
        -dump $HOME/build/opencv_abi.xml \
        -relpath $HOME/build/install \
        -dump-path current-$1.abi.tar.gz
    popd
}

for ver in 3.0.0 3.1.0 3.2.0 3.3.0-rc master ; do
    build $ver
    dump $ver
done

/scripts/cmp-abi.sh
