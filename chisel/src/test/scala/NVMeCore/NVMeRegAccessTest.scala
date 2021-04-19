/*
 * Copyright (c) 2021 Antmicro <www.antmicro.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package NVMeCore

import NVMeCore.Bfm._

import scala.reflect.runtime.universe._
import scala.collection.mutable.Queue
import scala.util.Random
import scala.math.pow

import chisel3._
import chisel3.iotesters._

class NVMeRegAccessTest(dut: NVMeTop) extends PeekPokeTester(dut){
	var cnt: Int = 0

	def waitRange(data: Bits, exp: Int, min: Int, max: Int) : Unit = {
		var cnt = 0

		while(peek(data) != exp && cnt < max){
			step(1)
			cnt += 1
		}

		assert(cnt < max)
		assert(cnt >= min)
	}

	val cls = runtimeMirror(getClass.getClassLoader).reflect(this)
	val members = cls.symbol.typeSignature.members

	def bfms = members.filter(_.typeSignature <:< typeOf[ChiselBfm])

	def stepSingle(): Unit = {
		for(bfm <- bfms){
			cls.reflectField(bfm.asTerm).get.asInstanceOf[ChiselBfm].update(cnt)
		}
		super.step(1)
	}

	override def step(n: Int): Unit = {
		for(_ <- 0 until n) {
			stepSingle
		}
	}

	val peekf = peek(_: Bits)
	val pokef = poke(_: Bits, _: BigInt)

	val axil_host_master = new AxiLiteMasterBfm(dut.io.host, peekf, pokef, println)
	val axil_controller_master = new AxiLiteMasterBfm(dut.io.controller, peekf, pokef, println)

	val dq = Queue[BigInt]()
	val aq = Queue[BigInt]()
	val rq = Queue[Boolean]()

	for ((addr, _) <- dut.CSRFile.regMap) {
		val data = Random.nextInt(pow(2, 32).toInt)
		val bus = Random.nextBoolean

		rq += bus

		if(bus) {
			println(f"host write to 0x${addr}%x")
			axil_host_master.writePush(addr, data)
		} else {
			println(f"controller write to 0x${addr}%x")
			axil_controller_master.writePush(addr, data)
		}

		dq += data
		aq += addr
	}

	step(1000)

	while(!rq.isEmpty) {
		val bus = rq.dequeue
		if (bus)
			axil_host_master.getResponse()
		else
			axil_controller_master.getResponse()
	}

	while(!aq.isEmpty) {
		val addr = aq.dequeue
		val bus = Random.nextBoolean

		rq += bus

		if (bus)
			axil_host_master.readPush(addr)
		else
			axil_controller_master.readPush(addr)
	}

	step(1000)

	while(!rq.isEmpty) {
		val bus = rq.dequeue
		val exp_data = dq.dequeue
		var rd_data: BigInt = -1

		if (bus)
			axil_host_master.getResponse().foreach(
				r => {rd_data = r.rd_data}
			)
		else
			axil_controller_master.getResponse().foreach(
				r => {rd_data = r.rd_data}
			)

		
		println(f"expected ${exp_data}%x, received ${rd_data}%x")
	}
}
