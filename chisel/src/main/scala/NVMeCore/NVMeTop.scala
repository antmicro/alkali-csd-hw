/*
 * Copyright (c) 2021 Antmicro <www.antmicro.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package NVMeCore

import NVMeCore.Bus._

import chisel3._

class NVMeTop extends Module{
  val io = IO(new Bundle{
    //val host = Flipped(new AXI4Lite(NVMeTop.addrWidth, NVMeTop.dataWidth))
    //val controller = Flipped(new AXI4Lite(NVMeTop.addrWidth, NVMeTop.dataWidth))
    val cap = Output(new CAP)
    val dout = Output(UInt(64.W))
    val re = Input(Bool())
    val din = Input(UInt(64.W))
    val we = Input(Bool())
  })


  // CSR access from host machine (via PCIe)
  //val hostCSRAxi = Module(new AXI4LiteCSR(NVMeTop.dataWidth, NVMeTop.regCount))

  //hostCSRAxi.io.ctl <> io.host

  //hostCSRAxi.io.bus.ready := 0.U
  //hostCSRAxi.io.bus.dataIn := 0.U

  // CSR access from controller CPU
  //val controllerCSRAxi = Module(new AXI4LiteCSR(NVMeTop.dataWidth, NVMeTop.regCount))

  //controllerCSRAxi.io.ctl <> io.controller

  //controllerCSRAxi.io.bus.ready := 0.U
  //controllerCSRAxi.io.bus.dataIn := 0.U

  val reg = Module(new SimpleRegRegister(new CAP, 64))

  io.cap := reg.fields

  reg.io.dataOut := io.din
  reg.io.write := io.we
  reg.io.read := io.re
  io.dout := reg.io.dataIn

  // register file
  // val CSRFile = Module(new CSRFile())

  //TODO: implement access logic
}

object NVMeTop {
  val regCount = 1024
  val addrWidth = 32
  val dataWidth = 32
  val doorbellCount = 4
}
