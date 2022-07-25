SBT?=sbt
DRIVER?=NVMeCore.NVMeDriver
TB?=CoreSpec
OUTPUT_DIR?=.
SBT_OPTS=--no-share --no-global

verilog:
	$(SBT) $(SBT_OPTS) "runMain $(DRIVER) --target-dir=$(OUTPUT_DIR)"

test:
	$(SBT) $(SBT_OPTS) "testOnly -t *$(TB)"

testall:
	$(SBT) $(SBT_OPTS) "test"

.PHONY: verilog test testall
