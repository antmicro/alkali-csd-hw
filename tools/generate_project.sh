#!/bin/bash
#
# vivado tcl generator
#
# author: pgielda@antmicro.com
#

PROJECT_NAME="project_1"
PART_NAME="xczu7ev-ffvc1156-1-e"
DEFAULT_LANG="Verilog"
TOP_MODULE="fpga"

echo
echo "#"
echo -n "# script generated @ "
date
echo "#"
echo

echo "create_project ${PROJECT_NAME} ./${PROJECT_NAME} -part ${PART_NAME} -force"
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

# constr
for f in ./git/src/constrs/*.xdc
do
  if [ -f $f ];
  then
    echo "import_files -fileset constrs_1 \".${f:1}\""
  fi
done

# ip tcls

for f in ./git/src/ip/*.tcl
do
  if [ -f $f ];
  then
    echo "source \".${f:1}\""
  fi
done

echo "source ./git/src/bd/design_1.tcl"
# smp synthesis
# echo "set_property synth_checkpoint_mode Hierarchical [get_files ./${PROJECT_NAME}/${PROJECT_NAME}.srcs/sources_1/bd/design_1/design_1.bd]"

echo "set_property top ${TOP_MODULE} [current_fileset]"
echo "update_compile_order -fileset sources_1"

echo "set_property STEPS.SYNTH_DESIGN.ARGS.DIRECTIVE RuntimeOptimized [get_runs synth_1]"

echo "set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]"
echo "set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE AddRetime [get_runs impl_1]"
echo "set_property STEPS.ROUTE_DESIGN.ARGS.DIRECTIVE AdvancedSkewModeling [get_runs impl_1]"
echo "set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]"
echo "set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.ARGS.DIRECTIVE AddRetime [get_runs impl_1]"

echo
echo "#uncomment this to automatically run synthesis and implementation"
echo "#launch_runs synth_1 -jobs 6"
echo "#wait_on_run synth_1"
echo "#launch_runs impl_1 -to_step write_bitstream"
echo "#wait_on_run impl_1"

