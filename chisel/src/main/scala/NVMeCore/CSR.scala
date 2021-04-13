/*
 * Copyright (c) 2021 Antmicro <www.antmicro.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package NVMeCore

import chisel3._

abstract class RegisterDef extends Bundle {

}

class Register[T <: RegisterDef](gen: T, regWidth: Int) extends MultiIOModule {
    val width = gen.getWidth

    assert(width <= regWidth)

    val io = IO(Flipped(new RegAccessBundle(regWidth)))

    val storage = RegInit(0.U(width.W))

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

class SimpleRegRegister[T <: RegisterDef](gen: T, regWidth: Int) extends Register(gen, regWidth) {
    val fields = IO(Output(gen))

    fields := storage.asTypeOf(gen)
}


class CAP extends RegisterDef {
    val CMBS = Bool()
    val PMRS = Bool()
    val MPSMAX = Bool()
    val MPSMIN = Bool()
    val BPS = Bool()
    val CSS = UInt(8.W)
    val NSSRS = Bool()
    val DSTRD = UInt(4.W)
    val TO = UInt(8.W)
    val AMS = UInt(2.W)
    val CQR = Bool()
    val MQEQ = UInt(16.W)
}


class VS extends Bundle {
    val length = 4
    val MJR = UInt(16.W)
    val MNR = UInt(8.W)
}


class INTMS extends Bundle {
    val length = 4
    val IVMS = UInt(32.W)
}


class INTMC extends Bundle {
    val length = 4
    val IVMC = UInt(32.W)
}


class CC extends Bundle {
    val length = 4
    val IOCQES = UInt(4.W)
    val IOSQES = UInt(4.W)
    val SHN = UInt(2.W)
    val AMS = UInt(2.W)
    val MPS = UInt(4.W)
    val CSS = UInt(3.W)
    val EN = Bool()
}


class CSTS extends Bundle {
    val length = 4
    val PP = Bool()
    val NSSRO = Bool()
    val SHST = UInt(2.W)
    val CFS = Bool()
    val RDY = Bool()
}


class NSSR extends Bundle {
    val length = 4
    val NSSRC = UInt(32.W)
}


class AQA extends Bundle {
    val length = 4
    val ACQS = UInt(12.W)
    val ASQS = UInt(12.W)
}


class ASQ extends Bundle {
    val length = 8
    val ASQB = UInt(52.W)
}


class ACQ extends Bundle {
    val length = 8
    val ACQB = UInt(54.W)
}


class CMBLOC extends Bundle {
    val length = 4
    val OFST = UInt(20.W)
    val CQDA = Bool()
    val CDMMMS = Bool()
    val CDPCILS = Bool()
    val CDPMLS = Bool()
    val CQPDS = Bool()
    val CQMMS = Bool()
    val BIR = UInt(2.W)
}


class CMBSZ extends Bundle {
    val length = 4
    val SZ = UInt(20.W)
    val SZU = UInt(4.W)
    val WDS = Bool()
    val RDS = Bool()
    val LISTS = Bool()
    val CQS = Bool()
    val SQS = Bool()
}


class BPINFO extends Bundle {
    val length = 4
    val ABPID = Bool()
    val BRS = UInt(2.W)
    val BPSZ = UInt(15.W)
}


class BPRSEL extends Bundle {
    val length = 4
    val BPID = Bool()
    val BPROF = UInt(20.W)
    val BPRSZ = UInt(10.W)
}


class BPMBL extends Bundle {
    val length = 8
    val BMBBA = UInt(52.W)
}


class CMBMSC extends Bundle {
    val length = 8
    val CBA = UInt(52.W)
    val CMSE = Bool()
    val CRE = Bool()
}


class CMBSTS extends Bundle {
    val length = 4
    val CBAI = Bool()
}


class PMRCAP extends Bundle {
    val length = 4
    val CMSS = Bool()
    val PMRTO = UInt(8.W)
    val PMTRTU = UInt(2.W)
    val BIR = UInt(3.W)
    val WDS = Bool()
    val RDS = Bool()
}


class PMRCTL extends Bundle {
    val length = 4
    val EN = Bool()
}


class PMRSTS extends Bundle {
    val length = 4
    val CBAI = Bool()
    val HSTS = UInt(3.W)
    val NRDY = Bool()
    val ERR = UInt(8.W)
}


class PMREBS extends Bundle {
    val length = 4
    val PMRWBZ = UInt(24.W)
    val RBB = Bool()
    val PMRSZU = UInt(4.W)
}


class PMRSWTP extends Bundle {
    val length = 4
    val PMRSWTV = UInt(24.W)
    val PMRSWTU = UInt(4.W)
}


class PMRMSC extends Bundle {
    val length = 8
    val CBA = UInt(52.W)
    val CMSE = Bool()
}


class SQ0TDBL extends Bundle {
    val length = 4
}

