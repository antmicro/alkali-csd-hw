/*
 * Copyright 2021-2022 Western Digital Corporation or its affiliates
 * Copyright 2021-2022 Antmicro
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package NVMeCore

import chisel3._
import chisel3.util.log2Ceil

class RegAccessBundle(val dataWidth: Int) extends Bundle{
  val write = Output(Bool())
  val dataOut = Output(UInt(dataWidth.W))
  val read = Output(Bool())
  val dataIn = Input(UInt(dataWidth.W))
}

class RegBusBundle(val regCount: Int, val dataWidth: Int) extends Bundle {
  val ready = Input(Bool())
  val addr = Output(UInt(log2Ceil(regCount).W))
  val reg = new RegAccessBundle(dataWidth)

  def read : Bool = ready && reg.read
  def readAddr(tgtAddr: UInt) : Bool = (addr === tgtAddr) && read
  def write : Bool = ready && reg.write
}

