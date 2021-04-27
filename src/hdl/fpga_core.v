/*

Copyright (c) 2020 Alex Forencich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * FPGA core logic
 */
module fpga_core #
(
    parameter AXIS_PCIE_DATA_WIDTH = 128,
    parameter AXIS_PCIE_KEEP_WIDTH = (AXIS_PCIE_DATA_WIDTH/32),
    parameter AXIS_PCIE_RC_USER_WIDTH = 75,
    parameter AXIS_PCIE_RQ_USER_WIDTH = 62,
    parameter AXIS_PCIE_CQ_USER_WIDTH = 88,
    parameter AXIS_PCIE_CC_USER_WIDTH = 33
)
(
    /*
     * Clock: 250 MHz
     * Synchronous reset
     */
    input  wire                               clk,
    input  wire                               rst,

    /*
     * GPIO
     */
    input  wire                               btnu,
    input  wire                               btnl,
    input  wire                               btnd,
    input  wire                               btnr,
    input  wire                               btnc,
    input  wire [7:0]                         sw,
    output wire [7:0]                         led,

    /*
     * PCIe
     */
    output wire [AXIS_PCIE_DATA_WIDTH-1:0]    m_axis_rq_tdata,
    output wire [AXIS_PCIE_KEEP_WIDTH-1:0]    m_axis_rq_tkeep,
    output wire                               m_axis_rq_tlast,
    input  wire                               m_axis_rq_tready,
    output wire [AXIS_PCIE_RQ_USER_WIDTH-1:0] m_axis_rq_tuser,
    output wire                               m_axis_rq_tvalid,

    input  wire [AXIS_PCIE_DATA_WIDTH-1:0]    s_axis_rc_tdata,
    input  wire [AXIS_PCIE_KEEP_WIDTH-1:0]    s_axis_rc_tkeep,
    input  wire                               s_axis_rc_tlast,
    output wire                               s_axis_rc_tready,
    input  wire [AXIS_PCIE_RC_USER_WIDTH-1:0] s_axis_rc_tuser,
    input  wire                               s_axis_rc_tvalid,

    input  wire [AXIS_PCIE_DATA_WIDTH-1:0]    s_axis_cq_tdata,
    input  wire [AXIS_PCIE_KEEP_WIDTH-1:0]    s_axis_cq_tkeep,
    input  wire                               s_axis_cq_tlast,
    output wire                               s_axis_cq_tready,
    input  wire [AXIS_PCIE_CQ_USER_WIDTH-1:0] s_axis_cq_tuser,
    input  wire                               s_axis_cq_tvalid,

    output wire [AXIS_PCIE_DATA_WIDTH-1:0]    m_axis_cc_tdata,
    output wire [AXIS_PCIE_KEEP_WIDTH-1:0]    m_axis_cc_tkeep,
    output wire                               m_axis_cc_tlast,
    input  wire                               m_axis_cc_tready,
    output wire [AXIS_PCIE_CC_USER_WIDTH-1:0] m_axis_cc_tuser,
    output wire                               m_axis_cc_tvalid,

    input  wire [2:0]                         cfg_max_payload,
    input  wire [2:0]                         cfg_max_read_req,

    output wire [9:0]                         cfg_mgmt_addr,
    output wire [7:0]                         cfg_mgmt_function_number,
    output wire                               cfg_mgmt_write,
    output wire [31:0]                        cfg_mgmt_write_data,
    output wire [3:0]                         cfg_mgmt_byte_enable,
    output wire                               cfg_mgmt_read,
    input  wire [31:0]                        cfg_mgmt_read_data,
    input  wire                               cfg_mgmt_read_write_done,

    input  wire [3:0]                         cfg_interrupt_msi_enable,
    input  wire [11:0]                        cfg_interrupt_msi_mmenable,
    input  wire                               cfg_interrupt_msi_mask_update,
    input  wire [31:0]                        cfg_interrupt_msi_data,
    output wire [3:0]                         cfg_interrupt_msi_select,
    output wire [31:0]                        cfg_interrupt_msi_int,
    output wire [31:0]                        cfg_interrupt_msi_pending_status,
    output wire                               cfg_interrupt_msi_pending_status_data_enable,
    output wire [3:0]                         cfg_interrupt_msi_pending_status_function_num,
    input  wire                               cfg_interrupt_msi_sent,
    input  wire                               cfg_interrupt_msi_fail,
    output wire [2:0]                         cfg_interrupt_msi_attr,
    output wire                               cfg_interrupt_msi_tph_present,
    output wire [1:0]                         cfg_interrupt_msi_tph_type,
    output wire [8:0]                         cfg_interrupt_msi_tph_st_tag,
    output wire [3:0]                         cfg_interrupt_msi_function_number,

    output wire                               status_error_cor,
    output wire                               status_error_uncor
);

parameter PCIE_ADDR_WIDTH = 64;

parameter AXIL_DATA_WIDTH = 32;
parameter AXIL_STRB_WIDTH = (AXIL_DATA_WIDTH/8);
parameter AXIL_ADDR_WIDTH = 32;

parameter AXI_DATA_WIDTH = AXIS_PCIE_DATA_WIDTH;
parameter AXI_STRB_WIDTH = (AXI_DATA_WIDTH/8);
parameter AXI_ADDR_WIDTH = 32;
parameter AXI_ID_WIDTH = 6;

parameter DMA_TAG_WIDTH = 8;

// Completer mux/demux
wire [AXIS_PCIE_DATA_WIDTH-1:0]    axis_cq_tdata_bar_0;
wire [AXIS_PCIE_KEEP_WIDTH-1:0]    axis_cq_tkeep_bar_0;
wire                               axis_cq_tvalid_bar_0;
wire                               axis_cq_tready_bar_0;
wire                               axis_cq_tlast_bar_0;
wire [AXIS_PCIE_CQ_USER_WIDTH-1:0] axis_cq_tuser_bar_0;

wire [AXIS_PCIE_DATA_WIDTH-1:0]    axis_cc_tdata_bar_0;
wire [AXIS_PCIE_KEEP_WIDTH-1:0]    axis_cc_tkeep_bar_0;
wire                               axis_cc_tvalid_bar_0;
wire                               axis_cc_tready_bar_0;
wire                               axis_cc_tlast_bar_0;
wire [AXIS_PCIE_CC_USER_WIDTH-1:0] axis_cc_tuser_bar_0;

wire [AXIS_PCIE_DATA_WIDTH-1:0]    axis_cq_tdata_bar_1;
wire [AXIS_PCIE_KEEP_WIDTH-1:0]    axis_cq_tkeep_bar_1;
wire                               axis_cq_tvalid_bar_1;
wire                               axis_cq_tready_bar_1;
wire                               axis_cq_tlast_bar_1;
wire [AXIS_PCIE_CQ_USER_WIDTH-1:0] axis_cq_tuser_bar_1;

wire [AXIS_PCIE_DATA_WIDTH-1:0]    axis_cc_tdata_bar_1;
wire [AXIS_PCIE_KEEP_WIDTH-1:0]    axis_cc_tkeep_bar_1;
wire                               axis_cc_tvalid_bar_1;
wire                               axis_cc_tready_bar_1;
wire                               axis_cc_tlast_bar_1;
wire [AXIS_PCIE_CC_USER_WIDTH-1:0] axis_cc_tuser_bar_1;

wire [2:0] bar_id;
wire [1:0] select;

pcie_us_axis_cq_demux #(
    .M_COUNT(2),
    .AXIS_PCIE_DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
    .AXIS_PCIE_KEEP_WIDTH(AXIS_PCIE_KEEP_WIDTH),
    .AXIS_PCIE_CQ_USER_WIDTH(AXIS_PCIE_CQ_USER_WIDTH)
)
cq_demux_inst (
    .clk(clk),
    .rst(rst),

    /*
     * AXI input (CQ)
     */
    .s_axis_cq_tdata(s_axis_cq_tdata),
    .s_axis_cq_tkeep(s_axis_cq_tkeep),
    .s_axis_cq_tvalid(s_axis_cq_tvalid),
    .s_axis_cq_tready(s_axis_cq_tready),
    .s_axis_cq_tlast(s_axis_cq_tlast),
    .s_axis_cq_tuser(s_axis_cq_tuser),

    /*
     * AXI output (CQ)
     */
    .m_axis_cq_tdata({axis_cq_tdata_bar_1, axis_cq_tdata_bar_0}),
    .m_axis_cq_tkeep({axis_cq_tkeep_bar_1, axis_cq_tkeep_bar_0}),
    .m_axis_cq_tvalid({axis_cq_tvalid_bar_1, axis_cq_tvalid_bar_0}),
    .m_axis_cq_tready({axis_cq_tready_bar_1, axis_cq_tready_bar_0}),
    .m_axis_cq_tlast({axis_cq_tlast_bar_1, axis_cq_tlast_bar_0}),
    .m_axis_cq_tuser({axis_cq_tuser_bar_1, axis_cq_tuser_bar_0}),

    /*
     * Fields
     */
    .req_type(),
    .target_function(),
    .bar_id(bar_id),
    .msg_code(),
    .msg_routing(),

    /*
     * Control
     */
    .enable(1),
    .drop(0),
    .select(select)
);

assign select[1] = bar_id == 3'd1;
assign select[0] = bar_id == 3'd0;

axis_arb_mux #(
    .S_COUNT(2),
    .DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
    .KEEP_ENABLE(1),
    .KEEP_WIDTH(AXIS_PCIE_KEEP_WIDTH),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(AXIS_PCIE_CC_USER_WIDTH)
)
cc_mux_inst (
    .clk(clk),
    .rst(rst),

    /*
     * AXI inputs
     */
    .s_axis_tdata({axis_cc_tdata_bar_1, axis_cc_tdata_bar_0}),
    .s_axis_tkeep({axis_cc_tkeep_bar_1, axis_cc_tkeep_bar_0}),
    .s_axis_tvalid({axis_cc_tvalid_bar_1, axis_cc_tvalid_bar_0}),
    .s_axis_tready({axis_cc_tready_bar_1, axis_cc_tready_bar_0}),
    .s_axis_tlast({axis_cc_tlast_bar_1, axis_cc_tlast_bar_0}),
    .s_axis_tid(0),
    .s_axis_tdest(0),
    .s_axis_tuser({axis_cc_tuser_bar_1, axis_cc_tuser_bar_0}),

    /*
     * AXI output
     */
    .m_axis_tdata(m_axis_cc_tdata),
    .m_axis_tkeep(m_axis_cc_tkeep),
    .m_axis_tvalid(m_axis_cc_tvalid),
    .m_axis_tready(m_axis_cc_tready),
    .m_axis_tlast(m_axis_cc_tlast),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(m_axis_cc_tuser)
);

wire [AXIL_ADDR_WIDTH-1:0] axil_host_awaddr;
wire [2:0]                 axil_host_awprot;
wire                       axil_host_awvalid;
wire                       axil_host_awready;
wire [AXIL_DATA_WIDTH-1:0] axil_host_wdata;
wire [AXIL_STRB_WIDTH-1:0] axil_host_wstrb;
wire                       axil_host_wvalid;
wire                       axil_host_wready;
wire [1:0]                 axil_host_bresp;
wire                       axil_host_bvalid;
wire                       axil_host_bready;
wire [AXIL_ADDR_WIDTH-1:0] axil_host_araddr;
wire [2:0]                 axil_host_arprot;
wire                       axil_host_arvalid;
wire                       axil_host_arready;
wire [AXIL_DATA_WIDTH-1:0] axil_host_rdata;
wire [1:0]                 axil_host_rresp;
wire                       axil_host_rvalid;
wire                       axil_host_rready;

wire [AXIL_ADDR_WIDTH-1:0] axil_ctrl_awaddr;
wire [2:0]                 axil_ctrl_awprot;
wire                       axil_ctrl_awvalid;
wire                       axil_ctrl_awready;
wire [AXIL_DATA_WIDTH-1:0] axil_ctrl_wdata;
wire [AXIL_STRB_WIDTH-1:0] axil_ctrl_wstrb;
wire                       axil_ctrl_wvalid;
wire                       axil_ctrl_wready;
wire [1:0]                 axil_ctrl_bresp;
wire                       axil_ctrl_bvalid;
wire                       axil_ctrl_bready;
wire [AXIL_ADDR_WIDTH-1:0] axil_ctrl_araddr;
wire [2:0]                 axil_ctrl_arprot;
wire                       axil_ctrl_arvalid;
wire                       axil_ctrl_arready;
wire [AXIL_DATA_WIDTH-1:0] axil_ctrl_rdata;
wire [1:0]                 axil_ctrl_rresp;
wire                       axil_ctrl_rvalid;
wire                       axil_ctrl_rready;

wire [AXIL_ADDR_WIDTH-1:0] axil_dma_awaddr;
wire [2:0]                 axil_dma_awprot;
wire                       axil_dma_awvalid;
wire                       axil_dma_awready;
wire [AXIL_DATA_WIDTH-1:0] axil_dma_wdata;
wire [AXIL_STRB_WIDTH-1:0] axil_dma_wstrb;
wire                       axil_dma_wvalid;
wire                       axil_dma_wready;
wire [1:0]                 axil_dma_bresp;
wire                       axil_dma_bvalid;
wire                       axil_dma_bready;
wire [AXIL_ADDR_WIDTH-1:0] axil_dma_araddr;
wire [2:0]                 axil_dma_arprot;
wire                       axil_dma_arvalid;
wire                       axil_dma_arready;
wire [AXIL_DATA_WIDTH-1:0] axil_dma_rdata;
wire [1:0]                 axil_dma_rresp;
wire                       axil_dma_rvalid;
wire                       axil_dma_rready;

wire [AXI_ID_WIDTH-1:0]    axi_dma_awid;
wire [AXI_ADDR_WIDTH-1:0]  axi_dma_awaddr;
wire [7:0]                 axi_dma_awlen;
wire [2:0]                 axi_dma_awsize;
wire [1:0]                 axi_dma_awburst;
wire                       axi_dma_awlock;
wire [3:0]                 axi_dma_awcache;
wire [2:0]                 axi_dma_awprot;
wire                       axi_dma_awvalid;
wire                       axi_dma_awready;
wire [AXI_DATA_WIDTH-1:0]  axi_dma_wdata;
wire [AXI_STRB_WIDTH-1:0]  axi_dma_wstrb;
wire                       axi_dma_wlast;
wire                       axi_dma_wvalid;
wire                       axi_dma_wready;
wire [AXI_ID_WIDTH-1:0]    axi_dma_bid;
wire [1:0]                 axi_dma_bresp;
wire                       axi_dma_bvalid;
wire                       axi_dma_bready;
wire [AXI_ID_WIDTH-1:0]    axi_dma_arid;
wire [AXI_ADDR_WIDTH-1:0]  axi_dma_araddr;
wire [7:0]                 axi_dma_arlen;
wire [2:0]                 axi_dma_arsize;
wire [1:0]                 axi_dma_arburst;
wire                       axi_dma_arlock;
wire [3:0]                 axi_dma_arcache;
wire [2:0]                 axi_dma_arprot;
wire                       axi_dma_arvalid;
wire                       axi_dma_arready;
wire [AXI_ID_WIDTH-1:0]    axi_dma_rid;
wire [AXI_DATA_WIDTH-1:0]  axi_dma_rdata;
wire [1:0]                 axi_dma_rresp;
wire                       axi_dma_rlast;
wire                       axi_dma_rvalid;
wire                       axi_dma_rready;

// PCIe DMA control
wire [PCIE_ADDR_WIDTH-1:0] pcie_dma_read_desc_pcie_addr;
wire [AXI_ADDR_WIDTH-1:0]  pcie_dma_read_desc_axi_addr;
wire [15:0]                pcie_dma_read_desc_len;
wire [DMA_TAG_WIDTH-1:0]   pcie_dma_read_desc_tag;
wire                       pcie_dma_read_desc_valid;
wire                       pcie_dma_read_desc_ready;

wire [DMA_TAG_WIDTH-1:0]   pcie_dma_read_desc_status_tag;
wire                       pcie_dma_read_desc_status_valid;
wire                       pcie_dma_read_desc_status_ready;

wire [PCIE_ADDR_WIDTH-1:0] pcie_dma_write_desc_pcie_addr;
wire [AXI_ADDR_WIDTH-1:0]  pcie_dma_write_desc_axi_addr;
wire [15:0]                pcie_dma_write_desc_len;
wire [DMA_TAG_WIDTH-1:0]   pcie_dma_write_desc_tag;
wire                       pcie_dma_write_desc_valid;
wire                       pcie_dma_write_desc_ready;

wire [DMA_TAG_WIDTH-1:0]   pcie_dma_write_desc_status_tag;
wire                       pcie_dma_write_desc_status_valid;
wire                       pcie_dma_write_desc_status_ready;

wire                       pcie_dma_enable;

// Error handling
wire [2:0] status_error_uncor_int;
wire [2:0] status_error_cor_int;

wire [31:0] msi_irq;

wire ext_tag_enable;

// control registers
reg axil_dma_awready_reg = 1'b0, axil_dma_awready_next;
reg axil_dma_wready_reg = 1'b0, axil_dma_wready_next;
reg [1:0] axil_dma_bresp_reg = 2'b00, axil_dma_bresp_next;
reg axil_dma_bvalid_reg = 1'b0, axil_dma_bvalid_next;
reg axil_dma_arready_reg = 1'b0, axil_dma_arready_next;
reg [AXIL_DATA_WIDTH-1:0] axil_dma_rdata_reg = {AXIL_DATA_WIDTH{1'b0}}, axil_dma_rdata_next;
reg [1:0] axil_dma_rresp_reg = 2'b00, axil_dma_rresp_next;
reg axil_dma_rvalid_reg = 1'b0, axil_dma_rvalid_next;

reg [PCIE_ADDR_WIDTH-1:0] pcie_dma_read_desc_pcie_addr_reg = 0, pcie_dma_read_desc_pcie_addr_next;
reg [AXI_ADDR_WIDTH-1:0] pcie_dma_read_desc_axi_addr_reg = 0, pcie_dma_read_desc_axi_addr_next;
reg [15:0] pcie_dma_read_desc_len_reg = 0, pcie_dma_read_desc_len_next;
reg [DMA_TAG_WIDTH-1:0] pcie_dma_read_desc_tag_reg = 0, pcie_dma_read_desc_tag_next;
reg pcie_dma_read_desc_valid_reg = 0, pcie_dma_read_desc_valid_next;

reg pcie_dma_read_desc_status_ready_reg = 0, pcie_dma_read_desc_status_ready_next;

reg [PCIE_ADDR_WIDTH-1:0] pcie_dma_write_desc_pcie_addr_reg = 0, pcie_dma_write_desc_pcie_addr_next;
reg [AXI_ADDR_WIDTH-1:0] pcie_dma_write_desc_axi_addr_reg = 0, pcie_dma_write_desc_axi_addr_next;
reg [15:0] pcie_dma_write_desc_len_reg = 0, pcie_dma_write_desc_len_next;
reg [DMA_TAG_WIDTH-1:0] pcie_dma_write_desc_tag_reg = 0, pcie_dma_write_desc_tag_next;
reg pcie_dma_write_desc_valid_reg = 0, pcie_dma_write_desc_valid_next;

reg pcie_dma_write_desc_status_ready_reg = 0, pcie_dma_write_desc_status_ready_next;

reg pcie_dma_enable_reg = 0, pcie_dma_enable_next;

reg [31:0] pcie_rq_count_reg = 0;
reg [31:0] pcie_rc_count_reg = 0;
reg [31:0] pcie_cq_count_reg = 0;
reg [31:0] pcie_cc_count_reg = 0;

assign axil_dma_awready = axil_dma_awready_reg;
assign axil_dma_wready = axil_dma_wready_reg;
assign axil_dma_bresp = axil_dma_bresp_reg;
assign axil_dma_bvalid = axil_dma_bvalid_reg;
assign axil_dma_arready = axil_dma_arready_reg;
assign axil_dma_rdata = axil_dma_rdata_reg;
assign axil_dma_rresp = axil_dma_rresp_reg;
assign axil_dma_rvalid = axil_dma_rvalid_reg;

assign pcie_dma_read_desc_pcie_addr = pcie_dma_read_desc_pcie_addr_reg;
assign pcie_dma_read_desc_axi_addr = pcie_dma_read_desc_axi_addr_reg;
assign pcie_dma_read_desc_len = pcie_dma_read_desc_len_reg;
assign pcie_dma_read_desc_tag = pcie_dma_read_desc_tag_reg;
assign pcie_dma_read_desc_valid = pcie_dma_read_desc_valid_reg;
assign pcie_dma_read_desc_status_ready = pcie_dma_read_desc_status_ready_reg;
assign pcie_dma_write_desc_pcie_addr = pcie_dma_write_desc_pcie_addr_reg;
assign pcie_dma_write_desc_axi_addr = pcie_dma_write_desc_axi_addr_reg;
assign pcie_dma_write_desc_len = pcie_dma_write_desc_len_reg;
assign pcie_dma_write_desc_tag = pcie_dma_write_desc_tag_reg;
assign pcie_dma_write_desc_valid = pcie_dma_write_desc_valid_reg;
assign pcie_dma_write_desc_status_ready = pcie_dma_write_desc_status_ready_reg;
assign pcie_dma_enable = pcie_dma_enable_reg;

wire dma_irq = pcie_dma_read_desc_status_valid || pcie_dma_write_desc_status_valid;
assign msi_irq = 0;

always @* begin
    axil_dma_awready_next = 1'b0;
    axil_dma_wready_next = 1'b0;
    axil_dma_bresp_next = 2'b00;
    axil_dma_bvalid_next = axil_dma_bvalid_reg && !axil_dma_bready;
    axil_dma_arready_next = 1'b0;
    axil_dma_rdata_next = {AXIL_DATA_WIDTH{1'b0}};
    axil_dma_rresp_next = 2'b00;
    axil_dma_rvalid_next = axil_dma_rvalid_reg && !axil_dma_rready;

    pcie_dma_read_desc_pcie_addr_next = pcie_dma_read_desc_pcie_addr_reg;
    pcie_dma_read_desc_axi_addr_next = pcie_dma_read_desc_axi_addr_reg;
    pcie_dma_read_desc_len_next = pcie_dma_read_desc_len_reg;
    pcie_dma_read_desc_tag_next = pcie_dma_read_desc_tag_reg;
    pcie_dma_read_desc_valid_next = pcie_dma_read_desc_valid_reg && !pcie_dma_read_desc_ready;
    pcie_dma_read_desc_status_ready_next = 1'b0;

    pcie_dma_write_desc_pcie_addr_next = pcie_dma_write_desc_pcie_addr_reg;
    pcie_dma_write_desc_axi_addr_next = pcie_dma_write_desc_axi_addr_reg;
    pcie_dma_write_desc_len_next = pcie_dma_write_desc_len_reg;
    pcie_dma_write_desc_tag_next = pcie_dma_write_desc_tag_reg;
    pcie_dma_write_desc_valid_next = pcie_dma_write_desc_valid_reg && !pcie_dma_read_desc_ready;
    pcie_dma_write_desc_status_ready_next = 1'b0;

    pcie_dma_enable_next = pcie_dma_enable_reg;

    if (axil_dma_awvalid && axil_dma_wvalid && !axil_dma_bvalid) begin
        // write operation
        axil_dma_awready_next = 1'b1;
        axil_dma_wready_next = 1'b1;
        axil_dma_bresp_next = 2'b00;
        axil_dma_bvalid_next = 1'b1;

        case ({axil_dma_awaddr[15:2], 2'b00})
            16'h0000: pcie_dma_enable_next = axil_dma_wdata;
            16'h0100: pcie_dma_read_desc_pcie_addr_next[31:0] = axil_dma_wdata;
            16'h0104: pcie_dma_read_desc_pcie_addr_next[63:32] = axil_dma_wdata;
            16'h0108: pcie_dma_read_desc_axi_addr_next[31:0] = axil_dma_wdata;
            //16'h010C: pcie_dma_read_desc_axi_addr_next[63:32] = axil_dma_wdata;
            16'h0110: pcie_dma_read_desc_len_next = axil_dma_wdata;
            16'h0114: begin
                pcie_dma_read_desc_tag_next = axil_dma_wdata;
                pcie_dma_read_desc_valid_next = 1'b1;
            end
            16'h0200: pcie_dma_write_desc_pcie_addr_next[31:0] = axil_dma_wdata;
            16'h0204: pcie_dma_write_desc_pcie_addr_next[63:32] = axil_dma_wdata;
            16'h0208: pcie_dma_write_desc_axi_addr_next[31:0] = axil_dma_wdata;
            //16'h020C: pcie_dma_write_desc_axi_addr_next[63:32] = axil_dma_wdata;
            16'h0210: pcie_dma_write_desc_len_next = axil_dma_wdata;
            16'h0214: begin
                pcie_dma_write_desc_tag_next = axil_dma_wdata;
                pcie_dma_write_desc_valid_next = 1'b1;
            end
        endcase
    end

    if (axil_dma_arvalid && !axil_dma_rvalid) begin
        // read operation
        axil_dma_arready_next = 1'b1;
        axil_dma_rresp_next = 2'b00;
        axil_dma_rvalid_next = 1'b1;

        case ({axil_dma_araddr[15:2], 2'b00})
            16'h0000: axil_dma_rdata_next = pcie_dma_enable_reg;
            16'h0118: begin
                axil_dma_rdata_next = pcie_dma_read_desc_status_tag | (pcie_dma_read_desc_status_valid ? 32'h80000000 : 32'd0);
                pcie_dma_read_desc_status_ready_next = pcie_dma_read_desc_status_valid;
            end
            16'h0218: begin
                axil_dma_rdata_next = pcie_dma_write_desc_status_tag | (pcie_dma_write_desc_status_valid ? 32'h80000000 : 32'd0);
                pcie_dma_write_desc_status_ready_next = pcie_dma_write_desc_status_valid;
            end
            16'h0400: axil_dma_rdata_next = pcie_rq_count_reg;
            16'h0404: axil_dma_rdata_next = pcie_rc_count_reg;
            16'h0408: axil_dma_rdata_next = pcie_cq_count_reg;
            16'h040C: axil_dma_rdata_next = pcie_cc_count_reg;
        endcase
    end
end

always @(posedge clk) begin
    if (rst) begin
        axil_dma_awready_reg <= 1'b0;
        axil_dma_wready_reg <= 1'b0;
        axil_dma_bvalid_reg <= 1'b0;
        axil_dma_arready_reg <= 1'b0;
        axil_dma_rvalid_reg <= 1'b0;

        pcie_dma_read_desc_valid_reg <= 1'b0;
        pcie_dma_read_desc_status_ready_reg <= 1'b0;
        pcie_dma_write_desc_valid_reg <= 1'b0;
        pcie_dma_write_desc_status_ready_reg <= 1'b0;
        pcie_dma_enable_reg <= 1'b0;

        pcie_rq_count_reg <= 0;
        pcie_rc_count_reg <= 0;
        pcie_cq_count_reg <= 0;
        pcie_cc_count_reg <= 0;
    end else begin
        axil_dma_awready_reg <= axil_dma_awready_next;
        axil_dma_wready_reg <= axil_dma_wready_next;
        axil_dma_bvalid_reg <= axil_dma_bvalid_next;
        axil_dma_arready_reg <= axil_dma_arready_next;
        axil_dma_rvalid_reg <= axil_dma_rvalid_next;

        pcie_dma_read_desc_valid_reg <= pcie_dma_read_desc_valid_next;
        pcie_dma_read_desc_status_ready_reg <= pcie_dma_read_desc_status_ready_next;
        pcie_dma_write_desc_valid_reg <= pcie_dma_write_desc_valid_next;
        pcie_dma_write_desc_status_ready_reg <= pcie_dma_write_desc_status_ready_next;
        pcie_dma_enable_reg <= pcie_dma_enable_next;

        if (m_axis_rq_tready && m_axis_rq_tvalid && m_axis_rq_tlast) begin
            pcie_rq_count_reg <= pcie_rq_count_reg + 1;
        end

        if (s_axis_rc_tready && s_axis_rc_tvalid && s_axis_rc_tlast) begin
            pcie_rc_count_reg <= pcie_rc_count_reg + 1;
        end

        if (s_axis_cq_tready && s_axis_cq_tvalid && s_axis_cq_tlast) begin
            pcie_cq_count_reg <= pcie_cq_count_reg + 1;
        end

        if (m_axis_cc_tready && m_axis_cc_tvalid && m_axis_cc_tlast) begin
            pcie_cc_count_reg <= pcie_cc_count_reg + 1;
        end
    end

    axil_dma_bresp_reg <= axil_dma_bresp_next;
    axil_dma_rdata_reg <= axil_dma_rdata_next;
    axil_dma_rresp_reg <= axil_dma_rresp_next;

    pcie_dma_read_desc_pcie_addr_reg <= pcie_dma_read_desc_pcie_addr_next;
    pcie_dma_read_desc_axi_addr_reg <= pcie_dma_read_desc_axi_addr_next;
    pcie_dma_read_desc_len_reg <= pcie_dma_read_desc_len_next;
    pcie_dma_read_desc_tag_reg <= pcie_dma_read_desc_tag_next;
    pcie_dma_write_desc_pcie_addr_reg <= pcie_dma_write_desc_pcie_addr_next;
    pcie_dma_write_desc_axi_addr_reg <= pcie_dma_write_desc_axi_addr_next;
    pcie_dma_write_desc_len_reg <= pcie_dma_write_desc_len_next;
    pcie_dma_write_desc_tag_reg <= pcie_dma_write_desc_tag_next;
end

assign led = 8'd0;

pcie_us_cfg #(
    .PF_COUNT(1),
    .VF_COUNT(0),
    .VF_OFFSET(4),
    .PCIE_CAP_OFFSET(12'h070)
)
pcie_us_cfg_inst (
    .clk(clk),
    .rst(rst),

    /*
     * Configuration outputs
     */
    .ext_tag_enable(ext_tag_enable),
    .max_read_request_size(),
    .max_payload_size(),

    /*
     * Interface to Ultrascale PCIe IP core
     */
    .cfg_mgmt_addr(cfg_mgmt_addr),
    .cfg_mgmt_function_number(cfg_mgmt_function_number),
    .cfg_mgmt_write(cfg_mgmt_write),
    .cfg_mgmt_write_data(cfg_mgmt_write_data),
    .cfg_mgmt_byte_enable(cfg_mgmt_byte_enable),
    .cfg_mgmt_read(cfg_mgmt_read),
    .cfg_mgmt_read_data(cfg_mgmt_read_data),
    .cfg_mgmt_read_write_done(cfg_mgmt_read_write_done)
);

pcie_us_axil_master #(
    .AXIS_PCIE_DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
    .AXIS_PCIE_KEEP_WIDTH(AXIS_PCIE_KEEP_WIDTH),
    .AXIS_PCIE_CQ_USER_WIDTH(AXIS_PCIE_CQ_USER_WIDTH),
    .AXIS_PCIE_CC_USER_WIDTH(AXIS_PCIE_CC_USER_WIDTH),
    .AXI_DATA_WIDTH(AXIL_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXIL_ADDR_WIDTH),
    .ENABLE_PARITY(0)
)
pcie_us_axil_master_inst (
    .clk(clk),
    .rst(rst),

    /*
     * AXI input (CQ)
     */
    .s_axis_cq_tdata(axis_cq_tdata_bar_0),
    .s_axis_cq_tkeep(axis_cq_tkeep_bar_0),
    .s_axis_cq_tvalid(axis_cq_tvalid_bar_0),
    .s_axis_cq_tready(axis_cq_tready_bar_0),
    .s_axis_cq_tlast(axis_cq_tlast_bar_0),
    .s_axis_cq_tuser(axis_cq_tuser_bar_0),

    /*
     * AXI input (CC)
     */
    .m_axis_cc_tdata(axis_cc_tdata_bar_0),
    .m_axis_cc_tkeep(axis_cc_tkeep_bar_0),
    .m_axis_cc_tvalid(axis_cc_tvalid_bar_0),
    .m_axis_cc_tready(axis_cc_tready_bar_0),
    .m_axis_cc_tlast(axis_cc_tlast_bar_0),
    .m_axis_cc_tuser(axis_cc_tuser_bar_0),

    /*
     * AXI Lite Master output
     */
    .m_axil_awaddr(axil_host_awaddr),
    .m_axil_awprot(axil_host_awprot),
    .m_axil_awvalid(axil_host_awvalid),
    .m_axil_awready(axil_host_awready),
    .m_axil_wdata(axil_host_wdata),
    .m_axil_wstrb(axil_host_wstrb),
    .m_axil_wvalid(axil_host_wvalid),
    .m_axil_wready(axil_host_wready),
    .m_axil_bresp(axil_host_bresp),
    .m_axil_bvalid(axil_host_bvalid),
    .m_axil_bready(axil_host_bready),
    .m_axil_araddr(axil_host_araddr),
    .m_axil_arprot(axil_host_arprot),
    .m_axil_arvalid(axil_host_arvalid),
    .m_axil_arready(axil_host_arready),
    .m_axil_rdata(axil_host_rdata),
    .m_axil_rresp(axil_host_rresp),
    .m_axil_rvalid(axil_host_rvalid),
    .m_axil_rready(axil_host_rready),

    /*
     * Configuration
     */
    .completer_id({8'd0, 5'd0, 3'd0}),
    .completer_id_enable(1'b0),

    /*
     * Status
     */
    .status_error_cor(status_error_cor_int[0]),
    .status_error_uncor(status_error_uncor_int[0])
);

wire nvme_irq;

NVMeTop nvmetop_inst (
    .clock(clk),
    .reset(rst),
    .io_irqReq(nvme_irq),

    .io_host_aw_awaddr(axil_host_awaddr),
    .io_host_aw_awprot(axil_host_awprot),
    .io_host_aw_awvalid(axil_host_awvalid),
    .io_host_aw_awready(axil_host_awready),
    .io_host_w_wdata(axil_host_wdata),
    .io_host_w_wstrb(axil_host_wstrb),
    .io_host_w_wvalid(axil_host_wvalid),
    .io_host_w_wready(axil_host_wready),
    .io_host_b_bresp(axil_host_bresp),
    .io_host_b_bvalid(axil_host_bvalid),
    .io_host_b_bready(axil_host_bready),
    .io_host_ar_araddr(axil_host_araddr),
    .io_host_ar_arprot(axil_host_arprot),
    .io_host_ar_arvalid(axil_host_arvalid),
    .io_host_ar_arready(axil_host_arready),
    .io_host_r_rdata(axil_host_rdata),
    .io_host_r_rresp(axil_host_rresp),
    .io_host_r_rvalid(axil_host_rvalid),
    .io_host_r_rready(axil_host_rready),

    .io_controller_aw_awaddr(axil_ctrl_awaddr),
    .io_controller_aw_awprot(axil_ctrl_awprot),
    .io_controller_aw_awvalid(axil_ctrl_awvalid),
    .io_controller_aw_awready(axil_ctrl_awready),
    .io_controller_w_wdata(axil_ctrl_wdata),
    .io_controller_w_wstrb(axil_ctrl_wstrb),
    .io_controller_w_wvalid(axil_ctrl_wvalid),
    .io_controller_w_wready(axil_ctrl_wready),
    .io_controller_b_bresp(axil_ctrl_bresp),
    .io_controller_b_bvalid(axil_ctrl_bvalid),
    .io_controller_b_bready(axil_ctrl_bready),
    .io_controller_ar_araddr(axil_ctrl_araddr),
    .io_controller_ar_arprot(axil_ctrl_arprot),
    .io_controller_ar_arvalid(axil_ctrl_arvalid),
    .io_controller_ar_arready(axil_ctrl_arready),
    .io_controller_r_rdata(axil_ctrl_rdata),
    .io_controller_r_rresp(axil_ctrl_rresp),
    .io_controller_r_rvalid(axil_ctrl_rvalid),
    .io_controller_r_rready(axil_ctrl_rready)
);

design_1 design_1_i (
    .dma_irq(dma_irq),
    .nvme_irq(nvme_irq),
    .pcie_clk(clk),

    /* DMA control bus */

    .M_AXI_DMA_awaddr(axil_dma_awaddr),
    .M_AXI_DMA_awprot(axil_dma_awprot),
    .M_AXI_DMA_awvalid(axil_dma_awvalid),
    .M_AXI_DMA_awready(axil_dma_awready),
    .M_AXI_DMA_wdata(axil_dma_wdata),
    .M_AXI_DMA_wstrb(axil_dma_wstrb),
    .M_AXI_DMA_wvalid(axil_dma_wvalid),
    .M_AXI_DMA_wready(axil_dma_wready),
    .M_AXI_DMA_bresp(axil_dma_bresp),
    .M_AXI_DMA_bvalid(axil_dma_bvalid),
    .M_AXI_DMA_bready(axil_dma_bready),
    .M_AXI_DMA_araddr(axil_dma_araddr),
    .M_AXI_DMA_arprot(axil_dma_arprot),
    .M_AXI_DMA_arvalid(axil_dma_arvalid),
    .M_AXI_DMA_arready(axil_dma_arready),
    .M_AXI_DMA_rdata(axil_dma_rdata),
    .M_AXI_DMA_rresp(axil_dma_rresp),
    .M_AXI_DMA_rvalid(axil_dma_rvalid),
    .M_AXI_DMA_rready(axil_dma_rready),

    /* NVMe control bus */

    .M_AXI_NVME_awaddr(axil_ctrl_awaddr),
    .M_AXI_NVME_awprot(axil_ctrl_awprot),
    .M_AXI_NVME_awvalid(axil_ctrl_awvalid),
    .M_AXI_NVME_awready(axil_ctrl_awready),
    .M_AXI_NVME_wdata(axil_ctrl_wdata),
    .M_AXI_NVME_wstrb(axil_ctrl_wstrb),
    .M_AXI_NVME_wvalid(axil_ctrl_wvalid),
    .M_AXI_NVME_wready(axil_ctrl_wready),
    .M_AXI_NVME_bresp(axil_ctrl_bresp),
    .M_AXI_NVME_bvalid(axil_ctrl_bvalid),
    .M_AXI_NVME_bready(axil_ctrl_bready),
    .M_AXI_NVME_araddr(axil_ctrl_araddr),
    .M_AXI_NVME_arprot(axil_ctrl_arprot),
    .M_AXI_NVME_arvalid(axil_ctrl_arvalid),
    .M_AXI_NVME_arready(axil_ctrl_arready),
    .M_AXI_NVME_rdata(axil_ctrl_rdata),
    .M_AXI_NVME_rresp(axil_ctrl_rresp),
    .M_AXI_NVME_rvalid(axil_ctrl_rvalid),
    .M_AXI_NVME_rready(axil_ctrl_rready),

    /* DMA memory bus */

    .S_AXI_DMA_awid(axi_dma_awid),
    .S_AXI_DMA_awaddr(axi_dma_awaddr),
    .S_AXI_DMA_awlen(axi_dma_awlen),
    .S_AXI_DMA_awsize(axi_dma_awsize),
    .S_AXI_DMA_awburst(axi_dma_awburst),
    .S_AXI_DMA_awlock(axi_dma_awlock),
    .S_AXI_DMA_awcache(axi_dma_awcache),
    .S_AXI_DMA_awprot(axi_dma_awprot),
    .S_AXI_DMA_awvalid(axi_dma_awvalid),
    .S_AXI_DMA_awready(axi_dma_awready),
    .S_AXI_DMA_wdata(axi_dma_wdata),
    .S_AXI_DMA_wstrb(axi_dma_wstrb),
    .S_AXI_DMA_wlast(axi_dma_wlast),
    .S_AXI_DMA_wvalid(axi_dma_wvalid),
    .S_AXI_DMA_wready(axi_dma_wready),
    .S_AXI_DMA_bid(axi_dma_bid),
    .S_AXI_DMA_bresp(axi_dma_bresp),
    .S_AXI_DMA_bvalid(axi_dma_bvalid),
    .S_AXI_DMA_bready(axi_dma_bready),
    .S_AXI_DMA_arid(axi_dma_arid),
    .S_AXI_DMA_araddr(axi_dma_araddr),
    .S_AXI_DMA_arlen(axi_dma_arlen),
    .S_AXI_DMA_arsize(axi_dma_arsize),
    .S_AXI_DMA_arburst(axi_dma_arburst),
    .S_AXI_DMA_arlock(axi_dma_arlock),
    .S_AXI_DMA_arcache(axi_dma_arcache),
    .S_AXI_DMA_arprot(axi_dma_arprot),
    .S_AXI_DMA_arvalid(axi_dma_arvalid),
    .S_AXI_DMA_arready(axi_dma_arready),
    .S_AXI_DMA_rid(axi_dma_rid),
    .S_AXI_DMA_rdata(axi_dma_rdata),
    .S_AXI_DMA_rresp(axi_dma_rresp),
    .S_AXI_DMA_rlast(axi_dma_rlast),
    .S_AXI_DMA_rvalid(axi_dma_rvalid),
    .S_AXI_DMA_rready(axi_dma_rready)
);

wire [AXIS_PCIE_DATA_WIDTH-1:0]    axis_rc_tdata_r;
wire [AXIS_PCIE_KEEP_WIDTH-1:0]    axis_rc_tkeep_r;
wire                               axis_rc_tlast_r;
wire                               axis_rc_tready_r;
wire [AXIS_PCIE_RC_USER_WIDTH-1:0] axis_rc_tuser_r;
wire                               axis_rc_tvalid_r;

axis_register #(
    .DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
    .KEEP_ENABLE(1),
    .KEEP_WIDTH(AXIS_PCIE_KEEP_WIDTH),
    .LAST_ENABLE(1),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(AXIS_PCIE_RC_USER_WIDTH)
)
rc_reg (
    .clk(clk),
    .rst(rst),

    /*
     * AXI input
     */
    .s_axis_tdata(s_axis_rc_tdata),
    .s_axis_tkeep(s_axis_rc_tkeep),
    .s_axis_tvalid(s_axis_rc_tvalid),
    .s_axis_tready(s_axis_rc_tready),
    .s_axis_tlast(s_axis_rc_tlast),
    .s_axis_tid(0),
    .s_axis_tdest(0),
    .s_axis_tuser(s_axis_rc_tuser),

    /*
     * AXI output
     */
    .m_axis_tdata(axis_rc_tdata_r),
    .m_axis_tkeep(axis_rc_tkeep_r),
    .m_axis_tvalid(axis_rc_tvalid_r),
    .m_axis_tready(axis_rc_tready_r),
    .m_axis_tlast(axis_rc_tlast_r),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(axis_rc_tuser_r)
);

pcie_us_axi_dma #(
    .AXIS_PCIE_DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
    .AXIS_PCIE_KEEP_WIDTH(AXIS_PCIE_KEEP_WIDTH),
    .AXIS_PCIE_RC_USER_WIDTH(AXIS_PCIE_RC_USER_WIDTH),
    .AXIS_PCIE_RQ_USER_WIDTH(AXIS_PCIE_RQ_USER_WIDTH),
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
    .AXI_STRB_WIDTH(AXI_STRB_WIDTH),
    .AXI_ID_WIDTH(AXI_ID_WIDTH),
    .AXI_MAX_BURST_LEN(256),
    .PCIE_ADDR_WIDTH(PCIE_ADDR_WIDTH),
    .PCIE_TAG_COUNT(256),
    .LEN_WIDTH(16),
    .TAG_WIDTH(DMA_TAG_WIDTH)
)
pcie_us_axi_dma_inst (
    .clk(clk),
    .rst(rst),

    /*
     * AXI input (RC)
     */
    .s_axis_rc_tdata(axis_rc_tdata_r),
    .s_axis_rc_tkeep(axis_rc_tkeep_r),
    .s_axis_rc_tvalid(axis_rc_tvalid_r),
    .s_axis_rc_tready(axis_rc_tready_r),
    .s_axis_rc_tlast(axis_rc_tlast_r),
    .s_axis_rc_tuser(axis_rc_tuser_r),

    /*
     * AXI output (RQ)
     */
    .m_axis_rq_tdata(m_axis_rq_tdata),
    .m_axis_rq_tkeep(m_axis_rq_tkeep),
    .m_axis_rq_tvalid(m_axis_rq_tvalid),
    .m_axis_rq_tready(m_axis_rq_tready),
    .m_axis_rq_tlast(m_axis_rq_tlast),
    .m_axis_rq_tuser(m_axis_rq_tuser),

    /*
     * AXI read descriptor input
     */
    .s_axis_read_desc_pcie_addr(pcie_dma_read_desc_pcie_addr),
    .s_axis_read_desc_axi_addr(pcie_dma_read_desc_axi_addr),
    .s_axis_read_desc_len(pcie_dma_read_desc_len),
    .s_axis_read_desc_tag(pcie_dma_read_desc_tag),
    .s_axis_read_desc_valid(pcie_dma_read_desc_valid),
    .s_axis_read_desc_ready(pcie_dma_read_desc_ready),

    /*
     * AXI read descriptor status output
     */
    .m_axis_read_desc_status_tag(pcie_dma_read_desc_status_tag),
    .m_axis_read_desc_status_valid(pcie_dma_read_desc_status_valid),

    /*
     * AXI write descriptor input
     */
    .s_axis_write_desc_pcie_addr(pcie_dma_write_desc_pcie_addr),
    .s_axis_write_desc_axi_addr(pcie_dma_write_desc_axi_addr),
    .s_axis_write_desc_len(pcie_dma_write_desc_len),
    .s_axis_write_desc_tag(pcie_dma_write_desc_tag),
    .s_axis_write_desc_valid(pcie_dma_write_desc_valid),
    .s_axis_write_desc_ready(pcie_dma_write_desc_ready),

    /*
     * AXI write descriptor status output
     */
    .m_axis_write_desc_status_tag(pcie_dma_write_desc_status_tag),
    .m_axis_write_desc_status_valid(pcie_dma_write_desc_status_valid),

    /*
     * AXI Master output
     */
    .m_axi_awid(axi_dma_awid),
    .m_axi_awaddr(axi_dma_awaddr),
    .m_axi_awlen(axi_dma_awlen),
    .m_axi_awsize(axi_dma_awsize),
    .m_axi_awburst(axi_dma_awburst),
    .m_axi_awlock(axi_dma_awlock),
    .m_axi_awcache(axi_dma_awcache),
    .m_axi_awprot(axi_dma_awprot),
    .m_axi_awvalid(axi_dma_awvalid),
    .m_axi_awready(axi_dma_awready),
    .m_axi_wdata(axi_dma_wdata),
    .m_axi_wstrb(axi_dma_wstrb),
    .m_axi_wlast(axi_dma_wlast),
    .m_axi_wvalid(axi_dma_wvalid),
    .m_axi_wready(axi_dma_wready),
    .m_axi_bid(axi_dma_bid),
    .m_axi_bresp(axi_dma_bresp),
    .m_axi_bvalid(axi_dma_bvalid),
    .m_axi_bready(axi_dma_bready),
    .m_axi_arid(axi_dma_arid),
    .m_axi_araddr(axi_dma_araddr),
    .m_axi_arlen(axi_dma_arlen),
    .m_axi_arsize(axi_dma_arsize),
    .m_axi_arburst(axi_dma_arburst),
    .m_axi_arlock(axi_dma_arlock),
    .m_axi_arcache(axi_dma_arcache),
    .m_axi_arprot(axi_dma_arprot),
    .m_axi_arvalid(axi_dma_arvalid),
    .m_axi_arready(axi_dma_arready),
    .m_axi_rid(axi_dma_rid),
    .m_axi_rdata(axi_dma_rdata),
    .m_axi_rresp(axi_dma_rresp),
    .m_axi_rlast(axi_dma_rlast),
    .m_axi_rvalid(axi_dma_rvalid),
    .m_axi_rready(axi_dma_rready),

    /*
     * Configuration
     */
    .read_enable(pcie_dma_enable),
    .write_enable(pcie_dma_enable),
    .ext_tag_enable(ext_tag_enable),
    .requester_id({8'd0, 5'd0, 3'd0}),
    .requester_id_enable(1'b0),
    .max_read_request_size(cfg_max_read_req),
    .max_payload_size(cfg_max_payload),

    /*
     * Status
     */
    .status_error_cor(status_error_cor_int[2]),
    .status_error_uncor(status_error_uncor_int[2])
);

pulse_merge #(
    .INPUT_WIDTH(3),
    .COUNT_WIDTH(4)
)
status_error_cor_pm_inst (
    .clk(clk),
    .rst(rst),

    .pulse_in(status_error_cor_int),
    .count_out(),
    .pulse_out(status_error_cor)
);

pulse_merge #(
    .INPUT_WIDTH(3),
    .COUNT_WIDTH(4)
)
status_error_uncor_pm_inst (
    .clk(clk),
    .rst(rst),

    .pulse_in(status_error_uncor_int),
    .count_out(),
    .pulse_out(status_error_uncor)
);

pcie_us_msi #(
    .MSI_COUNT(32)
)
pcie_us_msi_inst (
    .clk(clk),
    .rst(rst),

    .msi_irq(msi_irq),

    .cfg_interrupt_msi_enable(cfg_interrupt_msi_enable),
    .cfg_interrupt_msi_vf_enable(0),
    .cfg_interrupt_msi_mmenable(cfg_interrupt_msi_mmenable),
    .cfg_interrupt_msi_mask_update(cfg_interrupt_msi_mask_update),
    .cfg_interrupt_msi_data(cfg_interrupt_msi_data),
    .cfg_interrupt_msi_select(cfg_interrupt_msi_select),
    .cfg_interrupt_msi_int(cfg_interrupt_msi_int),
    .cfg_interrupt_msi_pending_status(cfg_interrupt_msi_pending_status),
    .cfg_interrupt_msi_pending_status_data_enable(cfg_interrupt_msi_pending_status_data_enable),
    .cfg_interrupt_msi_pending_status_function_num(cfg_interrupt_msi_pending_status_function_num),
    .cfg_interrupt_msi_sent(cfg_interrupt_msi_sent),
    .cfg_interrupt_msi_fail(cfg_interrupt_msi_fail),
    .cfg_interrupt_msi_attr(cfg_interrupt_msi_attr),
    .cfg_interrupt_msi_tph_present(cfg_interrupt_msi_tph_present),
    .cfg_interrupt_msi_tph_type(cfg_interrupt_msi_tph_type),
    .cfg_interrupt_msi_tph_st_tag(cfg_interrupt_msi_tph_st_tag),
    .cfg_interrupt_msi_function_number(cfg_interrupt_msi_function_number)
);

endmodule
