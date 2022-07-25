#!/bin/bash

set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
REPO_ROOT=$(realpath "${SCRIPT_DIR}/..")

TOOLS_DIR=${REPO_ROOT}/vivado/tools
BUILD_DIR=${REPO_ROOT}/build

switch=$1
if [ $# -lt 1 ]; then
	echo ""
	echo "Please give arguments as per below."
	echo "arg1 - vta"
	echo "arg2 - bar size with unit (e.g.16MB)"
	echo ""
	exit
fi
bar_size=$2
if [ $# -lt 2 ]; then
	bar_size=16
fi
echo "$bar_size" >barsize_file
unit=$(grep -o '[[:alpha:]]*' barsize_file)
size=$(grep -o '[[:digit:]]*' barsize_file)
rm -rf barsize_file
if [ $# -gt 2 ]; then
	echo "Give bar size unit without space e.g. 16MB"
fi

bar_unit="Megabytes"
mb_units=("mb" "MB" "Mb" "megabytes" "Megabytes")
for item in "${mb_units[@]}"; do
	if [ "${item}" = "${unit}" ]; then
		bar_unit="Megabytes"
	fi
done

kb_units=("kb" "KB" "Kb" "kilobytes" "Kilobytes")
for item in "${kb_units[@]}"; do
	if [ "${item}" = "${unit}" ]; then
		bar_unit="Kilobytes"
	fi
done

gb_units=("gb" "GB" "Gb" "gigabytes" "Gigabytes")
for item in "${gb_units[@]}"; do
	if [ "${item}" = "${unit}" ]; then
		bar_unit="Gigabytes"
	fi
done

# Generate vivado project and run synthesis
bash "${TOOLS_DIR}/generate_project.sh" gen_synth "$switch" "$size" "$bar_unit" >"${BUILD_DIR}/project_$switch.tcl"
vivado -mode batch -source "${BUILD_DIR}/project_$switch.tcl"

#patch command for basalt project
(cd "${BUILD_DIR}" && bash "${TOOLS_DIR}/patch.sh" "$switch")

# Run implementation and generate bitstream
bash "${TOOLS_DIR}/generate_project.sh" impl "$switch" "$size" "$bar_unit" >"${BUILD_DIR}/project_impl_$switch.tcl"
vivado -mode batch -source "${BUILD_DIR}/project_impl_$switch.tcl"
