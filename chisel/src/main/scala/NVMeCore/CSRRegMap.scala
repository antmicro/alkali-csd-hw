// Generated on 16/04/2021 16:38:03 with get_reg_map_chisel.py, git rev f15b025
package NVMeCore

import chisel3._

object CSRRegMap {
	val regMap = Map [Int, BaseRegister] (
		 0x0 -> Module(new ReadOnlyRegister(new CAP_0, 32)),
		 0x4 -> Module(new ReadOnlyRegister(new CAP_1, 32)),
		 0x8 -> Module(new ReadOnlyRegister(new VS, 32)),
		 0xc -> Module(new StorageRegister(new INTMS, 32)),
		 0x10 -> Module(new StorageRegister(new INTMC, 32)),
		 0x14 -> Module(new StorageRegister(new CC, 32)),
		 0x1c -> Module(new StorageRegister(new CSTS, 32)),
		 0x20 -> Module(new StorageRegister(new NSSR, 32)),
		 0x24 -> Module(new StorageRegister(new AQA, 32)),
		 0x28 -> Module(new StorageRegister(new ASQ_0, 32)),
		 0x2c -> Module(new StorageRegister(new ASQ_1, 32)),
		 0x30 -> Module(new StorageRegister(new ACQ_0, 32)),
		 0x34 -> Module(new StorageRegister(new ACQ_1, 32)),
		 0x38 -> Module(new StorageRegister(new CMBLOC, 32)),
		 0x3c -> Module(new StorageRegister(new CMBSZ, 32)),
		 0x40 -> Module(new StorageRegister(new BPINFO, 32)),
		 0x44 -> Module(new StorageRegister(new BPRSEL, 32)),
		 0x48 -> Module(new StorageRegister(new BPMBL_0, 32)),
		 0x4c -> Module(new StorageRegister(new BPMBL_1, 32)),
		 0x50 -> Module(new StorageRegister(new CMBMSC_0, 32)),
		 0x54 -> Module(new StorageRegister(new CMBMSC_1, 32)),
		 0x58 -> Module(new StorageRegister(new CMBSTS, 32)),
		 0xe00 -> Module(new StorageRegister(new PMRCAP, 32)),
		 0xe04 -> Module(new StorageRegister(new PMRCTL, 32)),
		 0xe08 -> Module(new StorageRegister(new PMRSTS, 32)),
		 0xe0c -> Module(new StorageRegister(new PMREBS, 32)),
		 0xe10 -> Module(new StorageRegister(new PMRSWTP, 32)),
		 0xe14 -> Module(new StorageRegister(new PMRMSC_0, 32)),
		 0xe18 -> Module(new StorageRegister(new PMRMSC_1, 32)),
	)
}
