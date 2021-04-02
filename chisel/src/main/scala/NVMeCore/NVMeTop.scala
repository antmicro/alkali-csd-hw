package NVMeCore

import chisel3._
import NVMeCore.Bus._
import chisel3.util.Queue

class NVMeTop extends Module{
  val io = IO(new Bundle{
    val host = Flipped(new AXI4Lite(NVMeTop.addrWidth, NVMeTop.dataWidth))
    val controller = Flipped(new AXI4Lite(NVMeTop.addrWidth, NVMeTop.dataWidth))
  })

}

object NVMeTop {
  val addrWidth = 32
  val dataWidth = 32
  val doorbellCount = 4
}
