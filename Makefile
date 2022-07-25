BAR_SIZE ?= 16MB
DOCKER_IMAGE_BASE?=debian:bullseye

REGGEN_PATH = ./third-party/registers-generator
NVME_SPEC_NAME = NVM-Express-1_4-2019.06.10-Ratified.pdf
SCALA_BUILD_DIR = build/scala
VIVADO_COLOR_SCRIPT = ./vivado/tools/color_log.awk
DOCKER_BUILD_DIR = build/docker

DOCKER_TAG_NAME=hw:1.0
DOCKER_TAG = ${DOCKER_IMAGE_PREFIX}hw:1.0

GIT_SHA = "$(shell git rev-parse --short HEAD)"
SBT_EXTRA_DIR=$(shell realpath --relative-to chisel ${SCALA_BUILD_DIR})
SBT_OUTPUT_DIR=$(abspath build/chisel_project)

vivado: generate chisel ## build vivado design
	bash -c "set -o pipefail && ./vivado/build_project.sh vta ${BAR_SIZE} | awk -f ${VIVADO_COLOR_SCRIPT}"

generate: build/registers.json ## generate register description in chisel
generate: ${SCALA_BUILD_DIR}/RegisterDefs.scala
generate: ${SCALA_BUILD_DIR}/CSRRegMap.scala

chisel: build/chisel_project/NVMeTop.v ## generate verilog sources using chisel

test: build/registers.json ## run all tests
test: ${SCALA_BUILD_DIR}/RegisterDefs.scala
test: ${SCALA_BUILD_DIR}/CSRRegMap.scala
	SBT_EXTRA_DIR=${SBT_EXTRA_DIR} make -C chisel testall

format: ## format code
	find -name "*.sh" -not -path "./third-party/*" -not -path "./build/*" | xargs -r shfmt -w --keep-padding
	find -name "*.sh" -not -path "./third-party/*" -not -path "./build/*" | xargs -r shellcheck

docker: hw.dockerfile ${REGGEN_PATH}/requirements.txt ## build development docker image
	@mkdir -p ${DOCKER_BUILD_DIR}
	cp hw.dockerfile ${DOCKER_BUILD_DIR}/Dockerfile
	cp ${REGGEN_PATH}/requirements.txt ${DOCKER_BUILD_DIR}
	cd ${DOCKER_BUILD_DIR} && docker build \
		--build-arg IMAGE_BASE="${DOCKER_IMAGE_BASE}" \
		--build-arg REPO_ROOT="${PWD}" \
		-t ${DOCKER_TAG} .

enter: ## enter development docker image
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
		-it ${DOCKER_TAG}

all: vivado ## build all

clean: ## clean build artifacts
	-rm -rf project_vta
	-rm *.tcl
	-rm *.log *.jou
	-rm -rf build/

.PHONY: all clean vivado generate chisel test docker enter

# chisel register generation

build/registers.json: ${REGGEN_PATH}/get_reg_fields.py
build/registers.json: ${REGGEN_PATH}/${NVME_SPEC_NAME}
	@mkdir -p build
	${REGGEN_PATH}/get_reg_fields.py ${REGGEN_PATH}/${NVME_SPEC_NAME} -f $@

${SCALA_BUILD_DIR}/RegisterDefs.scala: ${REGGEN_PATH}/get_reg_fields_chisel.py
${SCALA_BUILD_DIR}/RegisterDefs.scala: build/registers.json
	@mkdir -p ${SCALA_BUILD_DIR}
	${REGGEN_PATH}/get_reg_fields_chisel.py build/registers.json -f --git-sha=${GIT_SHA} $@

${SCALA_BUILD_DIR}/CSRRegMap.scala: ${REGGEN_PATH}/get_reg_map_chisel.py
${SCALA_BUILD_DIR}/CSRRegMap.scala: ${REGGEN_PATH}/${NVME_SPEC_NAME}
	@mkdir -p ${SCALA_BUILD_DIR}
	${REGGEN_PATH}/get_reg_map_chisel.py ${REGGEN_PATH}/${NVME_SPEC_NAME} -f --git-sha=${GIT_SHA} $@

# verilog sources generation

build/chisel_project/NVMeTop.v: build/registers.json
build/chisel_project/NVMeTop.v: ${SCALA_BUILD_DIR}/RegisterDefs.scala
build/chisel_project/NVMeTop.v: ${SCALA_BUILD_DIR}/CSRRegMap.scala
	OUTPUT_DIR=${SBT_OUTPUT_DIR} SBT_EXTRA_DIR=${SBT_EXTRA_DIR} make -C chisel verilog

HELP_COLUMN_SPAN = 20
HELP_FORMAT_STRING = "\033[36m%-${HELP_COLUMN_SPAN}s\033[0m %s\n"
help: ## show this help
	@echo Here is the list of available targets:
	@echo ""
	@grep -E '^[a-zA-Z_\/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf ${HELP_FORMAT_STRING}, $$1, $$2}'
	@echo ""
	@echo "Additionally, you can use the following environment variables:"
	@echo ""
	@printf ${HELP_FORMAT_STRING} "BAR_SIZE" "bar size with unit (e.g. 16MB)"
	@printf ${HELP_FORMAT_STRING} "DOCKER_IMAGE_PREFIX" "custom registry prefix with '/' at the end"
	@printf ${HELP_FORMAT_STRING} "DOCKER_IMAGE_BASE" "custom docker image base"

.PHONY: help
.DEFAULT_GOAL := help
