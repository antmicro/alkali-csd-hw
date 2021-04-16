/*
 * Copyright (c) 2021 Antmicro <www.antmicro.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package NVMeCore

import chisel3._

abstract class RegisterDef extends Bundle {

}

class TDBL extends RegisterDef {
    val Reserved_0 = UInt(16.W)
    val SQT = UInt(16.W)
}

class HDBL extends RegisterDef {
    val Reserved_0 = UInt(16.W)
    val CQH = UInt(16.W)
}

class BaseRegister(regWidth: Int) extends MultiIOModule {
    val io = IO(Flipped(new RegAccessBundle(regWidth)))

    io.dataIn := 0.U
}

class StorageRegister[T <: RegisterDef](gen: T, regWidth: Int) extends BaseRegister(regWidth) {
    val fields = IO(Output(gen))
    val storage = RegInit(0.U(regWidth.W))

    fields := storage.asTypeOf(gen)

    when(io.write) {
        storage := io.dataOut
    }

    io.dataIn := storage
}

class ReadOnlyRegister[T <: RegisterDef](gen: T, regWidth: Int) extends BaseRegister(regWidth) {
    val fields = IO(Input(gen))

    io.dataIn := fields.asUInt
}
