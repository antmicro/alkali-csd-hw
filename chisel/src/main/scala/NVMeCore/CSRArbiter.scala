/*
 * Copyright 2021-2022 Western Digital Corporation or its affiliates
 * Copyright 2021-2022 Antmicro
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package NVMeCore

import chisel3._

class RegBusArbiter(val regCount: Int, val dataWidth: Int) extends Module{
  val io = IO(new Bundle{
    val inBusA = Flipped(new RegBusBundle(regCount, dataWidth))
    val inBusB = Flipped(new RegBusBundle(regCount, dataWidth))
    val outBus = new RegBusBundle(regCount, dataWidth)
  })

  val validA = WireInit(io.inBusA.reg.read || io.inBusA.reg.write)
  val validB = WireInit(io.inBusB.reg.read || io.inBusB.reg.write)

  io.outBus.addr := 0.U
  io.outBus.reg.read := 0.U
  io.outBus.reg.write := 0.U
  io.outBus.reg.dataOut := 0.U

  io.inBusA.ready := 0.U
  io.inBusA.reg.dataIn := 0.U

  io.inBusB.ready := 0.U
  io.inBusB.reg.dataIn := 0.U

  when(validA) {
    io.inBusA <> io.outBus
  }.elsewhen(validB){
    io.inBusB <> io.outBus
  }

}
