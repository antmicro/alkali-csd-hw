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
    val host = Flipped(new AXI4Lite(NVMeTop.addrWidth, NVMeTop.dataWidth))
    val controller = Flipped(new AXI4Lite(NVMeTop.addrWidth, NVMeTop.dataWidth))
    val irqReq = Output(Bool())
    val irqHost = Output(UInt(NVMeTop.hostIrqCount.W))
  })


  // CSR access from host machine (via PCIe)
  val hostCSRAxi = Module(new AXI4LiteCSR(NVMeTop.dataWidth, NVMeTop.regCount))

  hostCSRAxi.io.ctl <> io.host

  // CSR access from controller CPU
  val controllerCSRAxi = Module(new AXI4LiteCSR(NVMeTop.dataWidth, NVMeTop.regCount))

  controllerCSRAxi.io.ctl <> io.controller

  // CSR Arbiter
  val CSRArbiter = Module(new RegBusArbiter(NVMeTop.regCount, NVMeTop.dataWidth))

  CSRArbiter.io.inBusA <> controllerCSRAxi.io.bus
  CSRArbiter.io.inBusB <> hostCSRAxi.io.bus

  val Interrupts = Module(new CSRInterrupt(NVMeTop.regCount, NVMeTop.dataWidth))

  io.irqReq := Interrupts.io.irqReq
  Interrupts.io.csrBus := hostCSRAxi.io.bus

  // register file
  val CSRFile = Module(new CSRFile(NVMeTop.regCount, NVMeTop.dataWidth, NVMeTop.hostIrqCount))

  io.irqHost := CSRFile.io.irqHost

  CSRFile.io.bus <> CSRArbiter.io.outBus
  CSRFile.io.csrLog <> Interrupts.io.csrLog
}

object NVMeTop {
  val regCount = 8192
  val addrWidth = 32
  val dataWidth = 32
  val doorbellCount = 4
  val doorbellBase = 0x1000
  val hostIrqCount = 32
}
