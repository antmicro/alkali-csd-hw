BOARD ?= basalt
BAR_SIZE ?= 16MB
DOCKER_IMAGE_BASE?=debian:bullseye

REGGEN_PATH = ./third-party/registers-generator
NVME_SPEC_NAME = NVM-Express-1_4-2019.06.10-Ratified.pdf
VIVADO_COLOR_SCRIPT = ./vivado/tools/color_log.awk
BUILD_DIR = build
DOCKER_BUILD_DIR = ${BUILD_DIR}/docker
SCALA_BUILD_DIR = ${BUILD_DIR}/scala
CHISEL_BUILD_DIR = ${BUILD_DIR}/chisel_project

DOCKER_TAG_NAME=hw:1.0
DOCKER_TAG = ${DOCKER_IMAGE_PREFIX}${DOCKER_TAG_NAME}

GIT_SHA = "$(shell git rev-parse --short HEAD)"
SBT_EXTRA_DIR=$(shell realpath --relative-to chisel ${SCALA_BUILD_DIR})
SBT_OUTPUT_DIR=$(abspath build/chisel_project)

${BUILD_DIR}:
	mkdir -p $@

vivado: ${BUILD_DIR}/${BOARD}/project_vta/out/top.bit ## build bitstream and hardware configuration file (".xsa")

${BUILD_DIR}/${BOARD}/project_vta/out/top.bit: ${CHISEL_BUILD_DIR}/NVMeTop.v ## build vivado design
	@echo "Building for board: ${BOARD}"
	bash -c "set -o pipefail && ./vivado/build_project.sh vta ${BAR_SIZE} ${BOARD} 2>&1 | awk -f ${VIVADO_COLOR_SCRIPT}"

generate: ${BUILD_DIR}/registers.json ${SCALA_BUILD_DIR}/RegisterDefs.scala ${SCALA_BUILD_DIR}/CSRRegMap.scala ## generate register description in chisel

chisel: ${CHISEL_BUILD_DIR}/NVMeTop.v ## generate verilog sources using chisel

test: build/registers.json ${SCALA_BUILD_DIR}/RegisterDefs.scala ${SCALA_BUILD_DIR}/CSRRegMap.scala ## run all tests
	SBT_EXTRA_DIR=${SBT_EXTRA_DIR} make -C chisel testall

format: ## format code
	find -name "*.sh" -not -path "./third-party/*" -not -path "./build/*" | xargs -r shfmt -w --keep-padding
	find -name "*.sh" -not -path "./third-party/*" -not -path "./build/*" | xargs -r shellcheck

${DOCKER_BUILD_DIR}:
	@mkdir -p ${DOCKER_BUILD_DIR}

${DOCKER_BUILD_DIR}/docker.ok: hw.dockerfile ${REGGEN_PATH}/requirements.txt | ${DOCKER_BUILD_DIR} ## build development docker image
	cp hw.dockerfile ${DOCKER_BUILD_DIR}/Dockerfile
	cp ${REGGEN_PATH}/requirements.txt ${DOCKER_BUILD_DIR}
	cd ${DOCKER_BUILD_DIR} && docker build \
		--build-arg IMAGE_BASE="${DOCKER_IMAGE_BASE}" \
		--build-arg REPO_ROOT="${PWD}" \
		-t ${DOCKER_TAG} . && touch docker.ok

docker: ${DOCKER_BUILD_DIR}/docker.ok ## build the developmend docker image

enter: ${DOCKER_BUILD_DIR}/docker.ok ## enter the development docker image
	docker run \
		--rm \
		-v ${PWD}:${PWD} \
		-v /etc/passwd:/etc/passwd \
		-v /etc/group:/etc/group \
		-v /tmp:${HOME}/.cache \
		-v /tmp:${HOME}/.sbt \
		-v /tmp:${HOME}/.Xilinx \
		-u $(shell id -u):$(shell id -g) \
		-h docker-container \
		-w ${PWD} \
		-it ${DOCKER_TAG} || true

all: vivado ## build all

clean: ## clean build artifacts
	rm -rf project_vta
	rm *.tcl
	rm *.log *.jou
	rm -rf .Xil
	rm -rf ${BUILD_DIR}

.PHONY: all clean vivado generate chisel test docker enter

# chisel register generation

${BUILD_DIR}/registers.json: ${REGGEN_PATH}/get_reg_fields.py ${REGGEN_PATH}/${NVME_SPEC_NAME} | ${BUILD_DIR}
	@mkdir -p build
	${REGGEN_PATH}/get_reg_fields.py ${REGGEN_PATH}/${NVME_SPEC_NAME} -f $@

${SCALA_BUILD_DIR}:
	@mkdir -p $@

${SCALA_BUILD_DIR}/RegisterDefs.scala: ${REGGEN_PATH}/get_reg_fields_chisel.py build/registers.json | ${SCALA_BUILD_DIR}
	${REGGEN_PATH}/get_reg_fields_chisel.py build/registers.json -f --git-sha=${GIT_SHA} $@

${SCALA_BUILD_DIR}/CSRRegMap.scala: ${REGGEN_PATH}/get_reg_map_chisel.py ${REGGEN_PATH}/${NVME_SPEC_NAME} | ${SCALA_BUILD_DIR}
	${REGGEN_PATH}/get_reg_map_chisel.py ${REGGEN_PATH}/${NVME_SPEC_NAME} -f --git-sha=${GIT_SHA} $@

# verilog sources generation

${CHISEL_BUILD_DIR}:
	@mkdir -p $@

${CHISEL_BUILD_DIR}/NVMeTop.v: ${BUILD_DIR}/registers.json ${SCALA_BUILD_DIR}/RegisterDefs.scala ${SCALA_BUILD_DIR}/CSRRegMap.scala | ${CHISEL_BUILD_DIR}
	OUTPUT_DIR=${SBT_OUTPUT_DIR} SBT_EXTRA_DIR=${SBT_EXTRA_DIR} $(MAKE) -C chisel verilog

# help

HELP_COLUMN_SPAN = 20
HELP_FORMAT_STRING = "\033[36m%-${HELP_COLUMN_SPAN}s\033[0m %s\n"
help: ## show this help
	@echo Here is the list of available targets:
	@echo ""
	@grep -E '^[a-zA-Z_\/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf ${HELP_FORMAT_STRING}, $$1, $$2}'
	@echo ""
	@echo "Additionally, you can use the following environment variables:"
	@echo ""
	@printf ${HELP_FORMAT_STRING} "BOARD" "The board to build the gateware for ('basalt' or 'zcu106')"
	@printf ${HELP_FORMAT_STRING} "BAR_SIZE" "bar size with unit (e.g. 16MB)"
	@printf ${HELP_FORMAT_STRING} "DOCKER_IMAGE_PREFIX" "custom registry prefix with '/' at the end"
	@printf ${HELP_FORMAT_STRING} "DOCKER_IMAGE_BASE" "custom docker image base"

.PHONY: vivado generate chisel test docker format help
.DEFAULT_GOAL := help
