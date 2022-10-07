//
// Copyright 2021-2022 Western Digital Corporation or its affiliates
// Copyright 2021-2022 Antmicro
//
// SPDX-License-Identifier: Apache-2.0

`timescale 1ns / 1ps

module top (
    // GPIO
    input  wire [2:0] BOARD_ID,
    // PCIe
    input  wire [3:0] pcie_rxp,
    input  wire [3:0] pcie_rxn,
    output wire [3:0] pcie_txp,
    output wire [3:0] pcie_txn,
    input  wire       pcie_ref_clk_p,
    input  wire       pcie_ref_clk_n,
    input  wire       pcie_rstn
);

// ============================================================================

fpga fpga (
    .BOARD_ID       (BOARD_ID),

    .pcie_rxp       (pcie_rxp),
    .pcie_rxn       (pcie_rxn),
    .pcie_txp       (pcie_txp),
    .pcie_txn       (pcie_txn),
    .pcie_ref_clk_p (pcie_ref_clk_p),
    .pcie_ref_clk_n (pcie_ref_clk_n),
    .pcie_rstn      (pcie_rstn)
);

endmodule
