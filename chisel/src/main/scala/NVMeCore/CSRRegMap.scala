// Generated on 14/04/2021 16:42:53
package NVMeCore

import chisel3._

object CSRRegMap {
	val regMap = Map [Int, Register] (
		 0x0 -> Module(new SimpleRegRegister(new CAP_0, 32)),
		 0x4 -> Module(new SimpleRegRegister(new CAP_1, 32)),
		 0x8 -> Module(new SimpleRegRegister(new VS, 32)),
		 0xc -> Module(new SimpleRegRegister(new INTMS, 32)),
		 0x10 -> Module(new SimpleRegRegister(new INTMC, 32)),
		 0x14 -> Module(new SimpleRegRegister(new CC, 32)),
		 0x1c -> Module(new SimpleRegRegister(new CSTS, 32)),
		 0x20 -> Module(new SimpleRegRegister(new NSSR, 32)),
		 0x24 -> Module(new SimpleRegRegister(new AQA, 32)),
		 0x28 -> Module(new SimpleRegRegister(new ASQ_0, 32)),
		 0x2c -> Module(new SimpleRegRegister(new ASQ_1, 32)),
		 0x30 -> Module(new SimpleRegRegister(new ACQ_0, 32)),
		 0x34 -> Module(new SimpleRegRegister(new ACQ_1, 32)),
		 0x38 -> Module(new SimpleRegRegister(new CMBLOC, 32)),
		 0x3c -> Module(new SimpleRegRegister(new CMBSZ, 32)),
		 0x40 -> Module(new SimpleRegRegister(new BPINFO, 32)),
		 0x44 -> Module(new SimpleRegRegister(new BPRSEL, 32)),
		 0x48 -> Module(new SimpleRegRegister(new BPMBL_0, 32)),
		 0x4c -> Module(new SimpleRegRegister(new BPMBL_1, 32)),
		 0x50 -> Module(new SimpleRegRegister(new CMBMSC_0, 32)),
		 0x54 -> Module(new SimpleRegRegister(new CMBMSC_1, 32)),
		 0x58 -> Module(new SimpleRegRegister(new CMBSTS, 32)),
		 0xe00 -> Module(new SimpleRegRegister(new PMRCAP, 32)),
		 0xe04 -> Module(new SimpleRegRegister(new PMRCTL, 32)),
		 0xe08 -> Module(new SimpleRegRegister(new PMRSTS, 32)),
		 0xe0c -> Module(new SimpleRegRegister(new PMREBS, 32)),
		 0xe10 -> Module(new SimpleRegRegister(new PMRSWTP, 32)),
		 0xe14 -> Module(new SimpleRegRegister(new PMRMSC_0, 32)),
		 0xe18 -> Module(new SimpleRegRegister(new PMRMSC_1, 32)),
		 0x1000 -> Module(new SimpleRegRegister(new SQ0TDBL, 32)),
	)
}
