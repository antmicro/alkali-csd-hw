#!/usr/bin/env bash

switch=$1

#patch the gt xdc file
patch project_$1/project_$1.srcs/sources_1/ip/pcie4_uscale_plus_0/ip_0/synth/pcie4_uscale_plus_0_gt.xdc vivado/src/patch/basalt_xdma_0_0_pcie4_ip_gt.xdc.patch

#patch the gt xdc file
patch project_$1/project_$1.srcs/sources_1/ip/pcie4_uscale_plus_0/synth/pcie4_uscale_plus_0_late.xdc vivado/src/patch/basalt_xdma_0_0_pcie4_ip_late.xdc.patch
