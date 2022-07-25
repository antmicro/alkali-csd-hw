SBT?=sbt
DRIVER?=NVMeCore.NVMeDriver
TB?=CoreSpec
OUTPUT_DIR?=.

verilog:
	$(SBT) "runMain $(DRIVER) --target-dir=$(OUTPUT_DIR)"

test:
	$(SBT) "testOnly -t *$(TB)"

testall:
	$(SBT) "test"

.PHONY: verilog test testall
