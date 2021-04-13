/*
 * Copyright (c) 2021 Antmicro <www.antmicro.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package NVMeCore

import chisel3._

abstract class RegisterDef extends Bundle {

}

class Register(regWidth: Int) extends MultiIOModule {
    val io = IO(Flipped(new RegAccessBundle(regWidth)))

    val storage = RegInit(0.U(regWidth.W))

    def write(d: UInt) = {
        storage := d
    }

    def read() : UInt = storage

    when(io.write) {
        write(io.dataOut)
    }

    when(io.read) {
        io.dataIn := read
    }.otherwise{
        io.dataIn := 0.U
    }
}

class SimpleRegRegister[T <: RegisterDef](gen: T, regWidth: Int) extends Register(regWidth) {
    val fields = IO(Output(gen))

    fields := storage.asTypeOf(gen)
}
