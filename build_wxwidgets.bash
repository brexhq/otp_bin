#!/usr/bin/env bash

WXWIDGETS_SOURCE_DIRECTORY="$1"
WXWIDGETS_INSTALL_PREFIX="$2"

cd $WXWIDGETS_SOURCE_DIRECTORY

case $(uname -s) in
    Darwin)
        ./configure --prefix="$WXWIDGETS_INSTALL_PREFIX" --with-cocoa --with-macosx-version-min=10.9 --disable-shared
        ;;
    Linux)
        export CFLAGS=-fPIC
        export CXXFLAGS=-fPIC
        ./configure --prefix="$WXWIDGETS_INSTALL_PREFIX" --disable-shared
    ;;
esac

make -j3
make install
