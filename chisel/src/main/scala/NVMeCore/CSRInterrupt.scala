/*
 * Copyright (c) 2021 Antmicro <www.antmicro.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package NVMeCore

import chisel3._
import chisel3.util._

class CSRInterrupt(val csrCount: Int, val dataWidth: Int, val queueDepth: Int = 128) extends Module {
	val io = IO(new Bundle {
		val irqReq = Output(Bool())
		val csrBus = Input(new RegBusBundle(csrCount, dataWidth))
		val csrLog = EnqIO(UInt(dataWidth.W))
	})

	val queue = Module(new Queue(UInt(dataWidth.W), queueDepth, false, false))

	queue.io.enq.valid := io.csrBus.reg.write && io.csrBus.ready
	queue.io.enq.bits := io.csrBus.addr

	io.csrLog <> queue.io.deq

	io.irqReq := queue.io.deq.valid
}
