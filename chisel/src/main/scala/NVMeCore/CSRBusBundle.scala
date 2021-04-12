/*
 * Copyright (c) 2021 Antmicro <www.antmicro.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package NVMeCore.CSR

import NVMeCore.NVMeTop
import chisel3._
import chisel3.util.log2Ceil

class CSRBusBundle extends Bundle {
  val addr = Output(UInt(log2Ceil(NVMeTop.controlRegCount).W))
  val dataOut = Output(UInt(NVMeTop.controlDataWidth.W))
  val dataIn = Input(UInt(NVMeTop.controlDataWidth.W))
  val write = Output(Bool())
  val read = Output(Bool())
  val ready = Input(Bool())
}
