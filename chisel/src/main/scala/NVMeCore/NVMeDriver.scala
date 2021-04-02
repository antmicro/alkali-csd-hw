package NVMeCore

object NVMeDriver extends App{
  chisel3.Driver.execute(args, () => new NVMeTop)
}
