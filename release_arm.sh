#!/usr/bin/env bash
set -euo pipefail

kerl_dir=$(mktemp -d)
wxwidgets_dir=$(mktemp -d)
WX_WIDGETS_BRANCH="WX_3_0_BRANCH"
wxwidgets_bin_dir=$(mktemp -d)
repo_root=$(git rev-parse --show-toplevel)
OTP_RELEASE="22.0.7"

echo "Cloning wx-widgets to ${wxwidgets_dir}"
git clone --branch ${WX_WIDGETS_BRANCH} git@github.com:wxWidgets/wxWidgets.git ${wxwidgets_dir}

echo "Building binaries of wx-widgets"
pushd ${wxwidgets_dir}
${repo_root}/build_wxwidgets.bash ${wxwidgets_dir} ${wxwidgets_bin_dir}
popd

echo "Cloning kerl repo"
git clone git@github.com:kerl/kerl.git  ${kerl_dir}
export KERL_CONFIGURE_DISABLE_APPLICATIONS="megaco eldap snmp mnesia et diameter"
export PATH="${PATH}:${wxwidgets_bin_dir}/bin"
echo "Building OTP release ${OTP_RELEASE}"
pushd ${kerl_dir}
./kerl build ${OTP_RELEASE}
./kerl install ${OTP_RELEASE} ${repo_root}/bin/
popd
tar -czf otp_bin_${OTP_RELEASE}_darwin_arm64.tar.gz bin/*
rm -rf ${wxwidgets_dir}/*
rm -rf ${wxwdigets_bin_dir}/*
rm -rf ${kerl_dir}/*
