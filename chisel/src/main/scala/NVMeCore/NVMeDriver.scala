/*
 * Copyright (c) 2021 Antmicro <www.antmicro.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package NVMeCore

object NVMeDriver extends App{
  chisel3.Driver.execute(args, () => new NVMeTop)
}
