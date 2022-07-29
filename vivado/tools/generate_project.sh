#!/bin/bash
#
# vivado tcl generator
#
# author: pgielda@antmicro.com

set -e

function help() {
	echo >&2 "usage: generate_project.sh <run> <switch> <bar_size> <bar_unit> <board> <build_dir>"
	echo >&2 ""
	echo >&2 "positional arguments"
	echo >&2 "	arg1 - run       	vivado run type"
	echo >&2 "	arg2 - switch    	project type"
	echo >&2 "	arg3 - bar_size  	size of bar"
	echo >&2 "	arg4 - bar_unit  	unit of bar"
	echo >&2 "	arg5 - board     	target board"
	echo >&2 "	arg6 - build_dir 	path to build directory"
}

function import_file() {
	ABS_PATH=$(realpath "$1")
	FILESET=$2
	if [ -f "$ABS_PATH" ]; then
		echo "import_files -fileset $FILESET \"${ABS_PATH}\""
	else
		echo >&2 "$ABS_PATH does not exist"
		exit 1
	fi
}

function source_file() {
	ABS_PATH=$(realpath "$1")
	if [ -f "$ABS_PATH" ]; then
		echo "source \"${ABS_PATH}\""
	else
		echo >&2 "$ABS_PATH does not exist"
	fi
}

BOARD=$5

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
REPO_ROOT=$(realpath "${SCRIPT_DIR}/../..")
MAIN_BUILD_DIR=$6/${BOARD}
# arguments handling

if [ "$#" -ne 6 ]; then
	echo >&2 "Invalid script usage"
	help
	exit 1
fi

ARG_RUN=$1
ARG_SWITCH=$2
ARG_BAR_SIZE=$3
ARG_BAR_UNIT=$4
ARG_BUILD_DIR=$6

# main project settings
case ${BOARD} in

basalt)
	PART_NAME="xczu7ev-ffvc1156-1-e"
	;;

zcu106)
	PART_NAME="xczu7ev-ffvc1156-2-e"
	;;

*)
	echo >&2 "Unsupported board '${BOARD}'"
	exit 255
	;;

esac

PROJECT_NAME="project_${ARG_SWITCH}"
BUILD_DIR="${MAIN_BUILD_DIR}/${PROJECT_NAME}"

if [ "$ARG_RUN" == "gen_synth" ]; then

	DEFAULT_LANG="Verilog"
	TOP_MODULE="top"
	BUILD_DIR="${ARG_BUILD_DIR}/${PROJECT_NAME}"

	# vivado script generation

	echo
	echo "#"
	echo -n "# script generated @ "
	date
	echo "#"
	echo

	echo "create_project ${PROJECT_NAME} ${BUILD_DIR} -part ${PART_NAME} -force"
	echo "set_property target_language ${DEFAULT_LANG} [current_project]"

	# vhdl/verilog
	VIVADO_SRC_HDL_PATH="${REPO_ROOT}/vivado/src/hdl"

	VIVADO_SRC_HDL_FILES=$(find "${VIVADO_SRC_HDL_PATH}" -maxdepth 1 \
		-name '*.vhd' -or \
		-name '*.v' -or \
		-name '*.sv' -or \
		-name '*.edif')

	for f in ${VIVADO_SRC_HDL_FILES}; do
		import_file "$f" "sources_1"
	done

	VIVADO_SRC_HDL_FILES=$(find "${VIVADO_SRC_HDL_PATH}/${BOARD}" -maxdepth 1 \
		-name '*.vhd' -or \
		-name '*.v' -or \
		-name '*.sv' -or \
		-name '*.edif')

	for f in ${VIVADO_SRC_HDL_FILES}; do
		import_file "$f" "sources_1"
	done

	# generated NVMe source
	import_file "${ARG_BUILD_DIR}/chisel_project/NVMeTop.v" "sources_1"

	# vhdl/verilog (pcie core)
	VERILOG_PCIE_RTL_PATH="${REPO_ROOT}/third-party/verilog-pcie/rtl"
	VERILOG_PCIE_RTL_FILES=$(find "${VERILOG_PCIE_RTL_PATH}" \
		-name '*.vhd' -or \
		-name '*.v' -or \
		-name '*.sv' -or \
		-name '*.edif')

	for f in ${VERILOG_PCIE_RTL_FILES}; do
		import_file "$f" "sources_1"
	done

	# other third-party/verilog-pcie files used in nvme
	additional_verilog_pcie_files=(
		"${REPO_ROOT}/third-party/verilog-pcie/example/ZCU106/fpga_axi/rtl/axis_register.v"
		"${REPO_ROOT}/third-party/verilog-pcie/example/ZCU106/fpga_axi/rtl/sync_reset.v"
		"${REPO_ROOT}/third-party/verilog-pcie/example/ZCU106/fpga_axi/rtl/axi_ram.v"
		"${REPO_ROOT}/third-party/verilog-pcie/example/ZCU106/fpga_axi/rtl/debounce_switch.v"
		"${REPO_ROOT}/third-party/verilog-pcie/example/ZCU106/fpga_axi/rtl/sync_signal.v"
	)
	for f in "${additional_verilog_pcie_files[@]}"; do
		import_file "$f" "sources_1"
	done

	# constr
	CONSTRS_PATH="${REPO_ROOT}/vivado/src/constrs"

	CONSTR_FILES=$(find "${CONSTRS_PATH}" -maxdepth 1 -name '*.xdc')
	for f in ${CONSTR_FILES}; do
		import_file "$f" "constrs_1"
	done

	CONSTR_FILES=$(find "${CONSTRS_PATH}/${BOARD}" -maxdepth 1 -name '*.xdc')
	for f in ${CONSTR_FILES}; do
		import_file "$f" "constrs_1"
	done

	#user ip add & create in design
	echo "set obj [get_filesets sources_1]"
	echo "set_property \"ip_repo_paths\" \"[file normalize \"${REPO_ROOT}/vivado/ip_repo\"] [file normalize \"axi_uartlite\"]\" \$obj"
	echo "update_ip_catalog -rebuild"
	#echo "create_ip -name constant_ip -vendor user.org -library user -version 1.0 -module_name constant_ip_0"
	#echo "set_property -dict [list CONFIG.uart_offset_value {2952921088} CONFIG.addon_offset_value {2953117696} CONFIG.sysmon_offset_value {2952986624} CONFIG.vta_offset_value {2952798208} CONFIG.nvme_offset_value {2952855552}] [get_ips constant_ip_0]"

	# ip tcls
	echo "set bar_size $ARG_BAR_SIZE"
	echo "set bar_unit $ARG_BAR_UNIT"

	TCL_PATH="${REPO_ROOT}/vivado/src/ip"
	TCL_FILES=$(find "${TCL_PATH}" -name '*.tcl')
	for f in ${TCL_FILES}; do
		source_file "$f"
	done

	if [ "$ARG_SWITCH" == "vta" ]; then
		source_file "${REPO_ROOT}/vivado/src/bd/vivado_block_design.tcl"
		source_file "${REPO_ROOT}/vivado/src/bd/${BOARD}/zynqmp_config.tcl"
	fi

	# smp synthesis
	# echo "set_property synth_checkpoint_mode Hierarchical [get_files ./${PROJECT_NAME}/${PROJECT_NAME}.srcs/sources_1/bd/vivado_block_design/vivado_block_design.bd]"

	echo "set_property top ${TOP_MODULE} [current_fileset]"
	echo "update_compile_order -fileset sources_1"

	echo "set_property STEPS.SYNTH_DESIGN.ARGS.DIRECTIVE RuntimeOptimized [get_runs synth_1]"
	echo "set_property STEPS.SYNTH_DESIGN.ARGS.RETIMING true [get_runs synth_1]"

	echo "set_property STEPS.OPT_DESIGN.ARGS.DIRECTIVE RuntimeOptimized [get_runs impl_1]"
	echo "set_property STEPS.PLACE_DESIGN.ARGS.DIRECTIVE RuntimeOptimized [get_runs impl_1]"
	echo "set_property STEPS.POST_PLACE_POWER_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]"
	echo "set_property STEPS.POST_PLACE_POWER_OPT_DESIGN.TCL.PRE {} [get_runs impl_1]"

	echo "set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]"
	echo "set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE AddRetime [get_runs impl_1]"
	echo "set_property STEPS.ROUTE_DESIGN.ARGS.DIRECTIVE AdvancedSkewModeling [get_runs impl_1]"
	echo "set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]"
	echo "set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.ARGS.DIRECTIVE AddRetime [get_runs impl_1]"

	echo "launch_runs synth_1 -jobs 6"
	echo "wait_on_run synth_1"

else
	BUILD_DIR="${ARG_BUILD_DIR}/project_${ARG_SWITCH}"
	echo "open_project ${BUILD_DIR}/project_$ARG_SWITCH.xpr"
	echo "update_compile_order -fileset sources_1"
	echo "open_run synth_1 -name synth_1"
	if [ "$ARG_SWITCH" == "vta" ]; then
		echo "startgroup"
		echo "create_pblock pblock_VTA_HLS"
		echo "resize_pblock pblock_VTA_HLS -add {SLICE_X58Y0:SLICE_X104Y134 DSP48E2_X6Y0:DSP48E2_X12Y53 RAMB18_X2Y0:RAMB18_X4Y53 RAMB36_X2Y0:RAMB36_X4Y26 URAM288_X0Y0:URAM288_X0Y35}"
		echo "add_cells_to_pblock pblock_VTA_HLS [get_cells [list rtl_top/vivado_block_design_inst/VTA_HLS]] -clear_locs"
		echo "endgroup"
	fi
	echo "startgroup "
	echo "create_pblock pblock_1"
	echo "resize_pblock pblock_1 -add {SLICE_X48Y150:SLICE_X109Y209 DSP48E2_X3Y60:DSP48E2_X13Y83 RAMB18_X1Y60:RAMB18_X4Y83 RAMB36_X1Y30:RAMB36_X4Y41 URAM288_X0Y40:URAM288_X0Y55}"
	echo "endgroup"
	echo "startgroup"
	echo "add_cells_to_pblock pblock_1 [get_cells [list rtl_top/vivado_block_design_inst/xlconcat_0 rtl_top/vivado_block_design_inst/zynq_ultra_ps_e_0 nolabel_line875 nvmetop_inst pcie_us_axi_dma_inst pcie_us_axi_master_inst pcie_us_axil_master_inst pcie_us_axil_master_inst_0 pcie_us_cfg_inst pcie_us_msi_inst rc_reg status_error_cor_pm_inst status_error_uncor_pm_inst dbg_hub pcie4_uscale_plus_inst]] -clear_locs"
	echo "endgroup"
	echo "startgroup"
	echo "add_cells_to_pblock pblock_1 [get_cells [list rtl_top/vivado_block_design_inst/*]] -add_primitives -clear_locs"
	echo "endgroup"
	echo "startgroup"
	echo "add_cells_to_pblock pblock_1 [get_cells [list rtl_top/cc_mux_inst cq_demux_inst]] -clear_locs"
	echo "endgroup"
	echo "startgroup"
	echo "add_cells_to_pblock pblock_1 [get_cells [list rtl_top/vivado_block_design_inst/axi_gpio_0 rtl_top/vivado_block_design_inst/axi_gpio_1 rtl_top/vivado_block_design_inst/axi_gpio_2 rtl_top/vivado_block_design_inst/axi_interconnect_4 rtl_top/vivado_block_design_inst/axi_interconnect_0 rtl_top/vivado_block_design_inst/axi_interconnect_1 rtl_top/vivado_block_design_inst/axi_interconnect_2 rtl_top/vivado_block_design_inst/axi_interconnect_3 rtl_top/vivado_block_design_inst/axi_protocol_convert_0 rtl_top/vivado_block_design_inst/axi_protocol_convert_1 rtl_top/vivado_block_design_inst/axi_protocol_convert_2 rtl_top/vivado_block_design_inst/axi_uartlite_0 rtl_top/vivado_block_design_inst/axi_uartlite_1 rtl_top/vivado_block_design_inst/xlconstant_0 rtl_top/vivado_block_design_inst/ila_0 rtl_top/vivado_block_design_inst/ila_1 axi_ram_inst rtl_top/vivado_block_design_inst/proc_sys_reset_0 rtl_top/vivado_block_design_inst/proc_sys_reset_1 rtl_top/vivado_block_design_inst/system_management_wiz_0]] -clear_locs"
	echo "endgroup"

	CONSTRS_NEW=${BUILD_DIR}/${PROJECT_NAME}.srcs/constrs_1/new
	echo "file mkdir ${CONSTRS_NEW}"
	echo "close [ open ${CONSTRS_NEW}/pblock.xdc w ]"
	echo "add_files -fileset constrs_1 ${CONSTRS_NEW}/pblock.xdc"
	echo "set_property target_constrs_file ${CONSTRS_NEW}/pblock.xdc [current_fileset -constrset]"

	echo "save_constraints -force"
	echo "close_design"

	echo "reset_run synth_1"
	echo "launch_runs synth_1 -jobs 6"
	echo "launch_runs impl_1 -to_step write_bitstream"
	echo "wait_on_run impl_1"

	echo "write_hw_platform -fixed -minimal ${BUILD_DIR}/${PROJECT_NAME}.runs/impl_1/top.xsa -force"

fi
