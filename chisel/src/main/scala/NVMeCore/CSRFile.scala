/*
 * Copyright (c) 2021 Antmicro <www.antmicro.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package NVMeCore

import chisel3._

class CSRFile(val csrCount: Int, val dataWidth: Int) extends Module {
  val io = IO(new Bundle {
    val bus = Flipped(new RegBusBundle(csrCount, dataWidth))
    val out = Output(UInt(4.W))
  })

  io.bus.ready := true.B
  io.bus.reg.dataIn := 0.U

  for((addr, reg) <- CSRRegMap.regMap) {
    when(io.bus.addr === (addr/(dataWidth/8)).U) {
      reg.io <> io.bus.reg
    }.otherwise{
      reg.io.write := false.B
      reg.io.read := false.B
      reg.io.dataOut := 0.U
    }
  }

  io.out := CSRRegMap.regMap(0x14).asInstanceOf[SimpleRegRegister[CC]].fields.IOCQES

}
