SBT?=sbt
DRIVER?=NVMeCore.NVMeDriver
TB?=CoreSpec

verilog:
	$(SBT) "runMain $(DRIVER)"

test:
	$(SBT) "testOnly -t *$(TB)"

testall:
	$(SBT) "test"

.PHONY: verilog test testall
