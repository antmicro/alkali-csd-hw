#!/bin/bash
#
# vivado tcl generator
#
# author: pgielda@antmicro.com
#

run=$1
switch=$2
bar_size=$3
bar_unit=$4

if [ $run == "gen_synth" ];then
	if [ $switch == "vta" ];then
	PROJECT_NAME="project_vta"
	fi
PART_NAME="xczu7ev-ffvc1156-1-e"
DEFAULT_LANG="Verilog"
TOP_MODULE="top"

echo
echo "#"
echo -n "# script generated @ "
date
echo "#"
echo

echo "create_project ${PROJECT_NAME} ./${PROJECT_NAME} -part ${PART_NAME} -force"
#echo "set_property \"ip_repo_paths\" \"./git/ip_repo/\" [get_filesets sources_1]"
#echo "update_ip_catalog -rebuild"
echo "set_property target_language ${DEFAULT_LANG} [current_project]"

# vhdl/verilog
for f in $(find ./git/src/hdl -name '*.vhd' -or -name '*.v' -or -name '*.sv' -or -name '*.edif');
do
  if [ -f $f ];
  then
    echo "import_files -fileset sources_1 \".${f:1}\""
  fi
done

# vhdl/verilog (pcie core)
for f in $(find ./git/verilog-pcie/rtl -name '*.vhd' -or -name '*.v' -or -name '*.sv' -or -name '*.edif');
do
  if [ -f $f ];
  then
    echo "import_files -fileset sources_1 \".${f:1}\""
  fi
done

# other verilog-pcie files used in nvme
additional_verilog_pcie_files=(
  "./git/verilog-pcie/example/ZCU106/fpga_axi/rtl/axis_register.v"
  "./git/verilog-pcie/example/ZCU106/fpga_axi/rtl/sync_reset.v"
  "./git/verilog-pcie/example/ZCU106/fpga_axi/rtl/axi_ram.v"
  "./git/verilog-pcie/example/ZCU106/fpga_axi/rtl/debounce_switch.v"
  "./git/verilog-pcie/example/ZCU106/fpga_axi/rtl/sync_signal.v"
)

echo "# Additional Verilog PCIE files"
for f in ${additional_verilog_pcie_files[@]}; do
  if [ -f $f ];
  then
    echo "import_files -fileset sources_1 \".${f:1}\""
  fi
done

# constr
for f in ./git/src/constrs/*.xdc
do
  if [ -f $f ];
  then
    echo "import_files -fileset constrs_1 \".${f:1}\""
  fi
done

#user ip add & create in design
echo "set obj [get_filesets sources_1]"
echo 'set_property "ip_repo_paths" "[file normalize "git/ip_repo"] [file normalize "axi_uartlite"]" $obj'
echo "update_ip_catalog -rebuild"
#echo "create_ip -name constant_ip -vendor user.org -library user -version 1.0 -module_name constant_ip_0"
#echo "set_property -dict [list CONFIG.uart_offset_value {2952921088} CONFIG.addon_offset_value {2953117696} CONFIG.sysmon_offset_value {2952986624} CONFIG.vta_offset_value {2952798208} CONFIG.nvme_offset_value {2952855552}] [get_ips constant_ip_0]"

# ip tcls
echo "set bar_size $bar_size"
echo "set bar_unit $bar_unit"

for f in ./git/src/ip/*.tcl
do
  if [ -f $f ];
  then
    echo "source \".${f:1}\""
  fi
done

if [ $switch == "vta" ];then
echo "source ./git/src/bd/vivado_block_design.tcl"
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

echo
echo "#uncomment this to automatically run synthesis and implementation"
echo "launch_runs synth_1 -jobs 6"
echo "wait_on_run synth_1"
else
echo "open_project project_$switch/project_$switch.xpr"
echo "update_compile_order -fileset sources_1"
echo "open_run synth_1 -name synth_1"
if [ $switch == "vta" ];then
echo "startgroup"
echo "create_pblock pblock_VTA_HLS"
echo "resize_pblock pblock_VTA_HLS -add {SLICE_X58Y0:SLICE_X104Y134 DSP48E2_X6Y0:DSP48E2_X12Y53 RAMB18_X2Y0:RAMB18_X4Y53 RAMB36_X2Y0:RAMB36_X4Y26 URAM288_X0Y0:URAM288_X0Y35}"
echo "add_cells_to_pblock pblock_VTA_HLS [get_cells [list vivado_block_design_inst/VTA_HLS]] -clear_locs"
echo "endgroup"
fi
echo "startgroup "
echo "create_pblock pblock_1"
echo "resize_pblock pblock_1 -add {SLICE_X48Y150:SLICE_X109Y209 DSP48E2_X3Y60:DSP48E2_X13Y83 RAMB18_X1Y60:RAMB18_X4Y83 RAMB36_X1Y30:RAMB36_X4Y41 URAM288_X0Y40:URAM288_X0Y55}"
echo "endgroup"
echo "startgroup"
echo "add_cells_to_pblock pblock_1 [get_cells [list vivado_block_design_inst/xlconcat_0 vivado_block_design_inst/zynq_ultra_ps_e_0 nolabel_line875 nvmetop_inst pcie_us_axi_dma_inst pcie_us_axi_master_inst pcie_us_axil_master_inst pcie_us_axil_master_inst_0 pcie_us_cfg_inst pcie_us_msi_inst rc_reg status_error_cor_pm_inst status_error_uncor_pm_inst dbg_hub pcie4_uscale_plus_inst]] -clear_locs"
echo "endgroup"
echo "startgroup"
echo "add_cells_to_pblock pblock_1 [get_cells [list vivado_block_design_inst/*]] -add_primitives -clear_locs"
echo "endgroup"
echo "startgroup"
echo "add_cells_to_pblock pblock_1 [get_cells [list cc_mux_inst cq_demux_inst]] -clear_locs"
echo "endgroup"
echo "startgroup"
echo "add_cells_to_pblock pblock_1 [get_cells [list vivado_block_design_inst/axi_gpio_0 vivado_block_design_inst/axi_gpio_1 vivado_block_design_inst/axi_gpio_2 vivado_block_design_inst/axi_interconnect_4 vivado_block_design_inst/axi_interconnect_0 vivado_block_design_inst/axi_interconnect_1 vivado_block_design_inst/axi_interconnect_2 vivado_block_design_inst/axi_interconnect_3 vivado_block_design_inst/axi_protocol_convert_0 vivado_block_design_inst/axi_protocol_convert_1 vivado_block_design_inst/axi_protocol_convert_2 vivado_block_design_inst/axi_uartlite_0 vivado_block_design_inst/axi_uartlite_1 vivado_block_design_inst/xlconstant_0 vivado_block_design_inst/ila_0 vivado_block_design_inst/ila_1 axi_ram_inst vivado_block_design_inst/proc_sys_reset_0 vivado_block_design_inst/proc_sys_reset_1 vivado_block_design_inst/system_management_wiz_0]] -clear_locs"
echo "endgroup"
echo "file mkdir project_1/project_1.srcs/constrs_1/new"
echo "close [ open project_1/project_1.srcs/constrs_1/new/pblock.xdc w ]"
echo "add_files -fileset constrs_1 project_1/project_1.srcs/constrs_1/new/pblock.xdc"
echo "set_property target_constrs_file project_1/project_1.srcs/constrs_1/new/pblock.xdc [current_fileset -constrset]"
echo "save_constraints -force"
echo "close_design"
echo "reset_run synth_1"
echo "launch_runs synth_1 -jobs 16"
echo "launch_runs impl_1 -to_step write_bitstream"
echo "wait_on_run impl_1"
fi

