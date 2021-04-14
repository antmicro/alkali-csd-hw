// Generated on 14/04/2021 16:42:49
package NVMeCore

import chisel3._

class CAP_0 extends RegisterDef {
	val TO = UInt(8.W)
	val Reserved_2 = UInt(5.W)
	val AMS = UInt(2.W)
	val CQR = Bool()
	val MQES = UInt(16.W)
}


class CAP_1 extends RegisterDef {
	val Reserved_0 = UInt(6.W)
	val CMBS = Bool()
	val PMRS = Bool()
	val MPSMAX = UInt(4.W)
	val MPSMIN = UInt(4.W)
	val Reserved_1 = UInt(2.W)
	val BPS = Bool()
	val CSS = UInt(8.W)
	val NSSRS = Bool()
	val DSTRD = UInt(4.W)
}


class VS extends RegisterDef {
	val MJR = UInt(16.W)
	val MNR = UInt(8.W)
	val Reserved_0 = UInt(8.W)
}


class INTMS extends RegisterDef {
	val IVMS = UInt(32.W)
}


class INTMC extends RegisterDef {
	val IVMC = UInt(32.W)
}


class CC extends RegisterDef {
	val Reserved_0 = UInt(8.W)
	val IOCQES = UInt(4.W)
	val IOSQES = UInt(4.W)
	val SHN = UInt(2.W)
	val AMS = UInt(3.W)
	val MPS = UInt(4.W)
	val CSS = UInt(3.W)
	val Reserved_1 = UInt(3.W)
	val EN = Bool()
}


class CSTS extends RegisterDef {
	val Reserved_0 = UInt(26.W)
	val PP = Bool()
	val NSSRO = Bool()
	val SHST = UInt(2.W)
	val CFS = Bool()
	val RDY = Bool()
}


class NSSR extends RegisterDef {
	val NSSRC = UInt(32.W)
}


class AQA extends RegisterDef {
	val Reserved_0 = UInt(4.W)
	val ACQS = UInt(12.W)
	val Reserved_1 = UInt(4.W)
	val ASQS = UInt(12.W)
}


class ASQ_0 extends RegisterDef {
	val ASQB = UInt(20.W)
	val Reserved_0 = UInt(12.W)
}


class ASQ_1 extends RegisterDef {
	val ASQB = UInt(32.W)
}


class ACQ_0 extends RegisterDef {
	val ACQB = UInt(20.W)
	val Reserved_0 = UInt(12.W)
}


class ACQ_1 extends RegisterDef {
	val ACQB = UInt(32.W)
}


class CMBLOC extends RegisterDef {
	val OFST = UInt(20.W)
	val Reserved_0 = UInt(3.W)
	val CQDA = Bool()
	val CDMMMS = Bool()
	val CDPCILS = Bool()
	val CDPMLS = Bool()
	val CQPDS = Bool()
	val CQMMS = Bool()
	val BIR = UInt(3.W)
}


class CMBSZ extends RegisterDef {
	val SZ = UInt(20.W)
	val SZU = UInt(4.W)
	val Reserved_0 = UInt(3.W)
	val WDS = Bool()
	val RDS = Bool()
	val LISTS = Bool()
	val CQS = Bool()
	val SQS = Bool()
}


class BPINFO extends RegisterDef {
	val ABPID = Bool()
	val Reserved_0 = UInt(5.W)
	val BRS = UInt(2.W)
	val Reserved_1 = UInt(9.W)
	val BPSZ = UInt(15.W)
}


class BPRSEL extends RegisterDef {
	val BPID = Bool()
	val Reserved_0 = Bool()
	val BPROF = UInt(20.W)
	val BPRSZ = UInt(10.W)
}


class BPMBL_0 extends RegisterDef {
	val BMBBA = UInt(20.W)
	val Reserved_0 = UInt(12.W)
}


class BPMBL_1 extends RegisterDef {
	val BMBBA = UInt(32.W)
}


class CMBMSC_0 extends RegisterDef {
	val CBA = UInt(20.W)
	val Reserved_0 = UInt(10.W)
	val CMSE = Bool()
	val CRE = Bool()
}


class CMBMSC_1 extends RegisterDef {
	val CBA = UInt(32.W)
}


class CMBSTS extends RegisterDef {
	val Reserved_0 = UInt(31.W)
	val CBAI = Bool()
}


class PMRCAP extends RegisterDef {
	val Reserved_0 = UInt(7.W)
	val CMSS = Bool()
	val PMRTO = UInt(8.W)
	val Reserved_1 = UInt(2.W)
	val PMRWBM = UInt(4.W)
	val PMRTU = UInt(2.W)
	val BIR = UInt(3.W)
	val WDS = Bool()
	val RDS = Bool()
	val Reserved_2 = UInt(3.W)
}


class PMRCTL extends RegisterDef {
	val Reserved_0 = UInt(31.W)
	val EN = Bool()
}


class PMRSTS extends RegisterDef {
	val Reserved_0 = UInt(19.W)
	val CBAI = Bool()
	val HSTS = UInt(3.W)
	val NRDY = Bool()
	val ERR = UInt(8.W)
}


class PMREBS extends RegisterDef {
	val PMRWBZ = UInt(24.W)
	val Reserved_0 = UInt(3.W)
	val RBB = Bool()
	val PMRSZU = UInt(4.W)
}


class PMRSWTP extends RegisterDef {
	val PMRSWTV = UInt(24.W)
	val Reserved_0 = UInt(4.W)
	val PMRSWTU = UInt(4.W)
}


class PMRMSC_0 extends RegisterDef {
	val CBA = UInt(20.W)
	val Reserved_0 = UInt(10.W)
	val CMSE = Bool()
	val Reserved_1 = Bool()
}


class PMRMSC_1 extends RegisterDef {
	val CBA = UInt(32.W)
}


class SQ0TDBL extends RegisterDef {
	val Reserved_0 = UInt(16.W)
	val SQT = UInt(16.W)
}


