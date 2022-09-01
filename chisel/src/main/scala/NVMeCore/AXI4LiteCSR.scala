/*
 * Copyright 2021-2022 Western Digital Corporation or its affiliates
 * Copyright 2021-2022 Antmicro
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package NVMeCore

import NVMeCore.Bus.AXI4Lite

import chisel3._
import chisel3.util._

class AXI4LiteCSR(dataWidth : Int, csrCount : Int) extends Module{
  val addrOff = log2Ceil(dataWidth/8)
  val addrWidth = log2Ceil(csrCount) + addrOff

  val io = IO(new Bundle{
    val ctl = Flipped(new AXI4Lite(addrWidth, dataWidth))
    val bus = new RegBusBundle(csrCount, dataWidth)
  })

  val sIdle :: sReadAddr :: sReadData :: sWriteAddr :: sWriteData :: sWriteResp :: Nil = Enum(6)
  val state = RegInit(sIdle)

  val awready = RegInit(false.B)
  val wready = RegInit(false.B)
  val bvalid = RegInit(false.B)
  val bresp = WireInit(0.U(AXI4Lite.respWidth.W))

  val arready = RegInit(false.B)
  val rvalid = RegInit(false.B)
  val rresp = WireInit(0.U(AXI4Lite.respWidth.W))

  val addr = RegInit(0.U(addrWidth.W))

  io.ctl.r.rdata := io.bus.reg.dataIn
  io.bus.reg.dataOut := io.ctl.w.wdata

  io.ctl.aw.awready := awready
  io.ctl.w.wready := wready && io.bus.ready
  io.ctl.b.bvalid := bvalid
  io.ctl.b.bresp := bresp

  io.ctl.ar.arready := arready
  io.ctl.r.rvalid := rvalid && io.bus.ready
  io.ctl.r.rresp := rresp

  io.bus.reg.read := io.ctl.r.rready && rvalid
  io.bus.reg.write := io.ctl.w.wvalid && wready
  io.bus.addr := addr

  switch(state){
    is(sIdle){
      when(io.ctl.aw.awvalid){
        state := sWriteAddr
        addr := io.ctl.aw.awaddr(addrWidth - 1, addrOff)
        awready := true.B

      }.elsewhen(io.ctl.ar.arvalid){
        state := sReadAddr
        addr := io.ctl.ar.araddr(addrWidth - 1, addrOff)
        arready := true.B
      }
    }
    is(sReadAddr){
      when(io.ctl.ar.arvalid && arready){
        state := sReadData
        arready := false.B
        rvalid := true.B
      }
    }
    is(sReadData){
      when(io.ctl.r.rready && io.ctl.r.rvalid){
        state := sIdle
        rvalid := false.B
      }
    }
    is(sWriteAddr){
      when(io.ctl.aw.awvalid && awready){
        state := sWriteData
        awready := false.B
        wready := true.B
      }
    }
    is(sWriteData){
      when(io.ctl.w.wvalid && io.ctl.w.wready){
        state := sWriteResp
        wready := false.B
        bvalid := true.B
      }
    }
    is(sWriteResp){
      when(io.ctl.b.bready && bvalid){
        state := sIdle
        bvalid := false.B
      }
    }
  }
}
