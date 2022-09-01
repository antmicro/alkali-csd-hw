#!/usr/bin/env bash
#
# Copyright 2021-2022 Western Digital Corporation or its affiliates
# Copyright 2021-2022 Antmicro
#
# SPDX-License-Identifier: Apache-2.0


SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
REPO_ROOT=$(realpath "${SCRIPT_DIR}/../..")

SWITCH=$1

#patch the gt xdc file
echo "Patch the GT XDC file"
patch "project_$SWITCH/project_$SWITCH.srcs/sources_1/ip/pcie4_uscale_plus_0/ip_0/synth/pcie4_uscale_plus_0_gt.xdc" \
	"${REPO_ROOT}/vivado/src/patch/an300_xdma_0_0_pcie4_ip_gt.xdc.patch"

#patch the gt xdc file
echo "Patch the GT XDC file"
patch "project_$SWITCH/project_$SWITCH.srcs/sources_1/ip/pcie4_uscale_plus_0/synth/pcie4_uscale_plus_0_late.xdc" \
	"${REPO_ROOT}/vivado/src/patch/an300_xdma_0_0_pcie4_ip_late.xdc.patch"
