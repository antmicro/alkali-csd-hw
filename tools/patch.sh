#!/usr/bin/env bash

#patch the gt xdc file
patch project_1/project_1.srcs/sources_1/ip/pcie4_uscale_plus_0/ip_0/synth/pcie4_uscale_plus_0_gt.xdc git/src/patch/basalt_xdma_0_0_pcie4_ip_gt.xdc.patch 

#patch the gt xdc file
patch project_1/project_1.srcs/sources_1/ip/pcie4_uscale_plus_0/synth/pcie4_uscale_plus_0_late.xdc git/src/patch/basalt_xdma_0_0_pcie4_ip_late.xdc.patch
