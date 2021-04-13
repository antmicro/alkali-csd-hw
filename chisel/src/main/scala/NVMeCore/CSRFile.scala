/*
 * Copyright (c) 2021 Antmicro <www.antmicro.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package NVMeCore

import chisel3._

class CSRFile(dataWidth: Int) extends Module {
  val csrCount = 32 // TODO: use regMap size
  val io = IO(new Bundle {
    val bus = Flipped(new RegBusBundle(csrCount, dataWidth))
    val out = Output(UInt(4.W))
  })

  io.bus.ready := true.B
  io.bus.reg.dataIn := 0.U

  for((addr, reg) <- CSRFile.regMap) {
    when(io.bus.addr === (addr/(dataWidth/8)).U) {
      reg.io <> io.bus.reg
    }.otherwise{
      reg.io.write := false.B
      reg.io.read := false.B
      reg.io.dataOut := 0.U
    }
  }

  io.out := CSRFile.regMap(0xc).asInstanceOf[SimpleRegRegister[CC]].fields.IOCQES

}

object CSRFile {
  val regMap = Map [Int, Register] (
    0x0 -> Module(new SimpleRegRegister(new VS, 32)),
    0x4 -> Module(new SimpleRegRegister(new INTMS, 32)),
    0x8 -> Module(new SimpleRegRegister(new INTMC, 32)),
    0xc -> Module(new SimpleRegRegister(new CC, 32)),
/*
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
*/
    )
}
