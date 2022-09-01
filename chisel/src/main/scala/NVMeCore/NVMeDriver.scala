/*
 * Copyright 2021-2022 Western Digital Corporation or its affiliates
 * Copyright 2021-2022 Antmicro
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package NVMeCore

object NVMeDriver extends App{
  chisel3.Driver.execute(args, () => new NVMeTop)
}
