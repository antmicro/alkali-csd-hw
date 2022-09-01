/*
 * Copyright 2021-2022 Western Digital Corporation or its affiliates
 * Copyright 2021-2022 Antmicro
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package NVMeCore

import org.scalatest.{FlatSpec, Matchers}

class CoreSpec extends FlatSpec  with Matchers{
	behavior of "CoreSpec"

	it should "perform reads and writes to registers" in {
		chisel3.iotesters.Driver.execute(Array("--generate-vcd-output", "on", "--target-dir", "test_run_dir/RegAccessTest"),
			() => new NVMeTop) { dut => new NVMeRegAccessTest(dut) } should be(true)
	}
}
