`timescale 1ns / 1ps

module top (
    // GPIO
    input  wire       btnu,
    input  wire       btnl,
    input  wire       btnd,
    input  wire       btnr,
    input  wire       btnc,
    input  wire [7:0] sw,
    output wire [7:0] led,

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

rtl_top rtl_top (
    .BOARD_ID       (3'd00),

    .pcie_rxp       (pcie_rxp),
    .pcie_rxn       (pcie_rxn),
    .pcie_txp       (pcie_txp),
    .pcie_txn       (pcie_txn),
    .pcie_ref_clk_p (pcie_ref_clk_p),
    .pcie_ref_clk_n (pcie_ref_clk_n),
    .pcie_rstn      (pcie_rstn)
);

assign led = 8'd0;

endmodule
