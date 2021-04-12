/*
 * Copyright (c) 2021 Antmicro <www.antmicro.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package NVMeCore

import NVMeCore.Bus._

import chisel3._
import chisel3.util.Queue

class NVMeTop extends Module{
  val io = IO(new Bundle{
    val host = Flipped(new AXI4Lite(NVMeTop.addrWidth, NVMeTop.dataWidth))
    val controller = Flipped(new AXI4Lite(NVMeTop.addrWidth, NVMeTop.dataWidth))
  })


  // CSR access from host machine (via PCIe)
  val hostCSRAxi = Module(new AXI4LiteCSR(NVMeTop.addrWidth, NVMeTop.dataWidth))

  hostCSRAxi.io.ctl <> io.host
  // CSR access from controller CPU
  val controllerCSRAxi = Module(new AXI4LiteCSR(NVMeTop.addrWidth, NVMeTop.dataWidth))

  controllerCSRAxi.io.ctl <> io.controller

  // register file
  val CSRFile = Module(new CSRFile())

  //TODO: implement access logic
}

object NVMeTop {
  val addrWidth = 32
  val dataWidth = 32
  val doorbellCount = 4
}
