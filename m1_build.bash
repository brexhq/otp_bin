#!/bin/bash

set -e

# We use 22.0.7 but not compatible in M1
# https://elixirforum.com/t/install-erlang-with-asdf-on-m1-macbook/40009/4
OTP_RELEASE=22.3.4.26 
PLATFORM=macos-12.4
WX=${1:graphical}  # [headless, graphical]
INCLUDE_OTP_SRC=${2:src} # [src, no-src]
BUILD_NAME="otp_${OTP_RELEASE}_${PLATFORM}_${WX}_${INCLUDE_OTP_SRC}"

if [[ ! -d kerl ]]; then
    git clone git@github.com:kerl/kerl.git
fi

if [[ $WX == 'graphical' ]]; then
    if [[ ! -d wxWidgets ]]; then
        git clone git@github.com:wxWidgets/wxWidgets.git
        cd wxWidgets
        git checkout WX_3_0_BRANCH
        git pull origin WX_3_0_BRANCH
        cd ..
    fi
    if [[ ! -d ${HOME}/wx-install/bin ]]; then
        ./build_wxwidgets.bash wxWidgets ~/wx-install
    fi
    PATH="${PATH}:${HOME}/wx-install/bin"
fi

export KERL_CONFIGURE_DISABLE_APPLICATIONS="megaco eldap snmp mnesia et diameter"
kerl/kerl build ${OTP_RELEASE}
RELEASE_DIR="R${OTP_RELEASE}"
kerl/kerl install ${OTP_RELEASE} ${RELEASE_DIR}
[[ $INCLUDE_OTP_SRC == 'no-src' ]] && rm -rf ${RELEASE_DIR}/lib/*/src
tar -czf "$BUILD_NAME.tar.gz" ${RELEASE_DIR}/*
kerl/kerl delete build "$OTP_RELEASE"
kerl/kerl delete installation "$OTP_RELEASE"
