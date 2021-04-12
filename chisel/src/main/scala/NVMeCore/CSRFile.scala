/*
 * Copyright (c) 2021 Antmicro <www.antmicro.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package NVMeCore.CSR

import chisel3._

class CSRFile extends Module {
  val io = IO(new Bundle {
    val csrBus = new CSRBusBundle
  })

  io.csrBus.ready := true.B

}

object CSRFile {
  val regMap = Map [UInt, Bundle] (
    0x0 -> new CAP(),
    0x8 -> new VS(),
    0xc -> new INTMS(),
    0x10 -> new INTMC(),
    0x14 -> new CC(),
    0x1c -> new CSTS(),
    0x20 -> new NSSR(),
    0x24 -> new AQA(),
    0x28 -> new ASQ(),
    0x30 -> new ACQ(),
    0x38 -> new CMBLOC(),
    0x3c -> new CMBSZ(),
    0x40 -> new BPINFO(),
    0x44 -> new BPRSEL(),
    0x48 -> new BPMBL(),
    0x50 -> new CMBMSC(),
    0x58 -> new CMBSTS(),
    0xe00 -> new PMRCAP(),
    0xe04 -> new PMRCTL(),
    0xe08 -> new PMRSTS(),
    0xe0c -> new PMREBS(),
    0xe10 -> new PMRSWTP(),
    0xe14 -> new PMRMSC(),
    )
}
