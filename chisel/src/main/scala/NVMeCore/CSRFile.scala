/*
 * Copyright (c) 2021 Antmicro <www.antmicro.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package NVMeCore

import chisel3._
import chisel3.util._

class CSRFile(val csrCount: Int, val dataWidth: Int, val irqCount: Int) extends Module {
  val io = IO(new Bundle {
    val bus = Flipped(new RegBusBundle(csrCount, dataWidth))
    val csrLog = DeqIO(UInt(dataWidth.W))
    val irqHost = Output(UInt(irqCount.W))
  })

  def tieOff(b: Bundle) = {
    for((_, data) <- b.elements) {
      data := 0.U
    }
  }

  io.bus.ready := true.B
  io.bus.reg.dataIn := 0.U

  val regMap = collection.mutable.Map[Int, BaseRegister]() ++= CSRRegMap.regMap

  for(i <- 0 to NVMeTop.doorbellCount) {
    val addr = NVMeTop.doorbellBase + 8*i
    println(f"adding doorbell register pair ${i} at 0x${addr}%x")
    regMap(addr) = Module(new StorageRegister(new TDBL, dataWidth))
    regMap(addr + 4) = Module(new StorageRegister(new HDBL, dataWidth))
  }

  val irqStaBase = NVMeTop.doorbellBase + 8 * (NVMeTop.doorbellCount + 1)
  val irqDatBase = irqStaBase + 4
  val irqHostBase = irqStaBase + 8

  val irqSta = Module(new ReadOnlyRegister(new IRQSTA, dataWidth))

  tieOff(irqSta.fields)

  irqSta.fields.VALID := io.csrLog.valid

  println(f"adding R5 interrupt status register at 0x${irqStaBase}%x")
  regMap(irqStaBase) = irqSta

  val irqDat = Module(new ReadOnlyRegister(new IRQDAT, dataWidth))

  irqDat.fields.DATA := io.csrLog.bits

  println(f"adding R5 interrupt data register at 0x${irqDatBase}%x")
  regMap(irqDatBase) = irqDat

  io.csrLog.ready := io.bus.readAddr((irqDatBase/(dataWidth/8)).U)

  val irqHost = Module(new AutoClearingRegister(new IRQHOST, dataWidth))

  println(f"adding Host interrupt register at 0x${irqHostBase}%x")
  regMap(irqHostBase) = irqHost

  io.irqHost := irqHost.fields.REQ

  for((addr, reg) <- regMap) {
    println(f"connecting register 0x${addr}%x")
    when(io.bus.addr === (addr/(dataWidth/8)).U) {
      reg.io <> io.bus.reg
    }.otherwise{
      reg.io.write := false.B
      reg.io.read := false.B
      reg.io.dataOut := 0.U
    }
  }

  val ver = regMap(0x8).asInstanceOf[ReadOnlyRegister[VS]].fields
  tieOff(ver)

  ver.MJR := CSRFile.ver_major
  ver.MNR := CSRFile.ver_minor
  ver.TER := CSRFile.ver_tetr

  val cap1 = regMap(0x4).asInstanceOf[ReadOnlyRegister[CAP_1]].fields
  tieOff(cap1)

  cap1.CSS := CSRFile.CSS

  val cap0 = regMap(0x0).asInstanceOf[ReadOnlyRegister[CAP_0]].fields
  tieOff(cap0)

  cap0.TO := CSRFile.TO
  cap0.CQR := CSRFile.CQR
  cap0.MQES := CSRFile.MQES

}

object CSRFile {
  // Capabilities
  val CSS = 1.U // NVMe command set
  val TO = 8.U // 4s
  val CQR = 1.U // Continuous queues
  val MQES = 4095.U // max 4096 entries in a queue
  // Version
  val ver_major = 1.U
  val ver_minor = 4.U
  val ver_tetr  = 0.U
}
