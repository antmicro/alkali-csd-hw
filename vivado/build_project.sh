#!/bin/bash
NC="\\033[0m"
WHITE="\\033[1;37m"

set -e

BOARD=$4
BOARD=${BOARD=an300} # Build for AN300 for default

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
REPO_ROOT=$(realpath "${SCRIPT_DIR}/..")

TOOLS_DIR=${REPO_ROOT}/vivado/tools
BUILD_DIR=$1

switch=$2
if [ $# -lt 2 ]; then
	echo ""
	echo "Please give arguments as per below:"
	echo " build_project.sh <build dir> <vta> <BAR size> [<board>]"
	echo "	mandatory:"
	echo "		arg1 - absolute path to build directory"
	echo "		arg2 - vta"
	echo "		arg3 - bar size with unit (e.g. 16MB)"
	echo "	optional:"
	echo "		arg4 - board (optional)"
	echo ""
	exit
fi
bar_size=$3
if [ $# -lt 3 ]; then
	bar_size="16MB"
fi
echo "$bar_size" >barsize_file
unit=$(grep -o '[[:alpha:]]*' barsize_file)
size=$(grep -o '[[:digit:]]*' barsize_file)
rm -rf barsize_file
if [ -z "$unit" ] || [ -z "$size" ]; then
	echo "Give bar size unit without space e.g. '16MB'"
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

# Check board support
if [ "${BOARD}" != "an300" ] && [ "${BOARD}" != "zcu106" ]; then
	echo "Unsupported board '${BOARD}'"
	exit 255
fi

# Generate vivado project and run synthesis
echo -e "${WHITE}Generating Vivado project...${NC}"
mkdir -p "${BUILD_DIR}"
echo "$BUILD_DIR"
bash "${TOOLS_DIR}/generate_project.sh" gen_synth "$switch" "$size" "$bar_unit" "$BOARD" "$BUILD_DIR" >"${BUILD_DIR}/project_$switch.tcl"

echo -e "${WHITE}Running synthesis...${NC}"
vivado -mode batch -source "${BUILD_DIR}/project_$switch.tcl" || (echo -e "${WHITE}Vivado exited with $?${NC}" && false)

# Patch command for an300 project
if [ "${BOARD}" == "an300" ]; then
	echo -e "${WHITE}Patching files...${NC}"
	(cd "${BUILD_DIR}" && bash "${TOOLS_DIR}/patch.sh" "$switch")
fi

# Run implementation and generate bitstream
echo -e "${WHITE}Running implementation...${NC}"
bash "${TOOLS_DIR}/generate_project.sh" impl "$switch" "$size" "$bar_unit" "$BOARD" "$BUILD_DIR" >"${BUILD_DIR}/project_impl_$switch.tcl"
vivado -mode batch -source "${BUILD_DIR}/project_impl_$switch.tcl" || (echo -e "${WHITE}Vivado exited with $?${NC}" && false)

# Verify that files exist, copy them
echo -e "${WHITE}Copying files...${NC}"

IMPL_DIR=${BUILD_DIR}/project_${switch}/project_${switch}.runs/impl_1
OUTP_DIR=${BUILD_DIR}/project_${switch}/out

test -f "${IMPL_DIR}"/top.bit
test -f "${IMPL_DIR}"/top.xsa

mkdir -p "${OUTP_DIR}"
cp "${IMPL_DIR}"/top.bit "${OUTP_DIR}"/
cp "${IMPL_DIR}"/top.xsa "${OUTP_DIR}"/

echo -e "${WHITE}Done.${NC}"
