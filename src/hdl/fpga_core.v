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
`include "defines.v"

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

wire [AXIS_PCIE_DATA_WIDTH-1:0]    axis_cq_tdata_bar_2;
wire [AXIS_PCIE_KEEP_WIDTH-1:0]    axis_cq_tkeep_bar_2;
wire                               axis_cq_tvalid_bar_2;
wire                               axis_cq_tready_bar_2;
wire                               axis_cq_tlast_bar_2;
wire [AXIS_PCIE_CQ_USER_WIDTH-1:0] axis_cq_tuser_bar_2;

wire [AXIS_PCIE_DATA_WIDTH-1:0]    axis_cc_tdata_bar_2;
wire [AXIS_PCIE_KEEP_WIDTH-1:0]    axis_cc_tkeep_bar_2;
wire                               axis_cc_tvalid_bar_2;
wire                               axis_cc_tready_bar_2;
wire                               axis_cc_tlast_bar_2;
wire [AXIS_PCIE_CC_USER_WIDTH-1:0] axis_cc_tuser_bar_2;

wire [2:0] bar_id;
wire [2:0] select;
wire [2:0] func_no_out;

pcie_us_axis_cq_demux #(
    .M_COUNT(3),
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
    .m_axis_cq_tdata({axis_cq_tdata_bar_2,axis_cq_tdata_bar_1, axis_cq_tdata_bar_0}),
    .m_axis_cq_tkeep({axis_cq_tkeep_bar_2,axis_cq_tkeep_bar_1, axis_cq_tkeep_bar_0}),
    .m_axis_cq_tvalid({axis_cq_tvalid_bar_2,axis_cq_tvalid_bar_1, axis_cq_tvalid_bar_0}),
    .m_axis_cq_tready({axis_cq_tready_bar_2,axis_cq_tready_bar_1, axis_cq_tready_bar_0}),
    .m_axis_cq_tlast({axis_cq_tlast_bar_2,axis_cq_tlast_bar_1, axis_cq_tlast_bar_0}),
    .m_axis_cq_tuser({axis_cq_tuser_bar_2,axis_cq_tuser_bar_1, axis_cq_tuser_bar_0}),

    /*
     * Fields
     */
    .req_type(),
    .target_function(),
    .bar_id(bar_id),
    .msg_code(),
    .msg_routing(),
    .func_no(func_no_out),

    /*
     * Control
     */
    .enable(1),
    .drop(0),
    .select(select)
);
assign select[2] = bar_id == 3'd2;
assign select[1] = bar_id == 3'd1;
assign select[0] = bar_id == 3'd0;

axis_arb_mux #(
    .S_COUNT(3),
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
    .s_axis_tdata({axis_cc_tdata_bar_2,axis_cc_tdata_bar_1, axis_cc_tdata_bar_0}),
    .s_axis_tkeep({axis_cc_tkeep_bar_2,axis_cc_tkeep_bar_1, axis_cc_tkeep_bar_0}),
    .s_axis_tvalid({axis_cc_tvalid_bar_2,axis_cc_tvalid_bar_1, axis_cc_tvalid_bar_0}),
    .s_axis_tready({axis_cc_tready_bar_2,axis_cc_tready_bar_1, axis_cc_tready_bar_0}),
    .s_axis_tlast({axis_cc_tlast_bar_2,axis_cc_tlast_bar_1, axis_cc_tlast_bar_0}),
    .s_axis_tid(0),
    .s_axis_tdest(0),
    .s_axis_tuser({axis_cc_tuser_bar_2,axis_cc_tuser_bar_1, axis_cc_tuser_bar_0}),

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

reg dma_write_irq = 1'b0, dma_read_irq = 1'b0;

wire dma_irq = dma_write_irq || dma_read_irq;

always @(posedge clk) begin
	if(rst) begin
		dma_write_irq <= 1'b0;
		dma_read_irq <= 1'b0;
	end else begin
		if(pcie_dma_write_desc_status_valid)
			dma_write_irq <= 1'b1;
		else if(pcie_dma_write_desc_status_ready)
			dma_write_irq <= 1'b0;

		if(pcie_dma_read_desc_status_valid)
			dma_read_irq <= 1'b1;
		else if(pcie_dma_read_desc_status_ready)
			dma_read_irq <= 1'b0;
	end
end

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
                axil_dma_rdata_next = pcie_dma_read_desc_status_tag | (dma_read_irq ? 32'h80000000 : 32'd0);
                pcie_dma_read_desc_status_ready_next = 1'b1;
            end
            16'h0218: begin
                axil_dma_rdata_next = pcie_dma_write_desc_status_tag | (dma_write_irq ? 32'h80000000 : 32'd0);
                pcie_dma_write_desc_status_ready_next = 1'b1;
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

wire [AXIL_ADDR_WIDTH-1:0] axil_uart_awaddr;
wire [2:0]                 axil_uart_awprot;
wire                       axil_uart_awvalid;
wire                       axil_uart_awready;
wire [AXIL_DATA_WIDTH-1:0] axil_uart_wdata;
wire [AXIL_STRB_WIDTH-1:0] axil_uart_wstrb;
wire                       axil_uart_wvalid;
wire                       axil_uart_wready;
wire [1:0]                 axil_uart_bresp;
wire                       axil_uart_bvalid;
wire                       axil_uart_bready;
wire [AXIL_ADDR_WIDTH-1:0] axil_uart_araddr;
wire [2:0]                 axil_uart_arprot;
wire                       axil_uart_arvalid;
wire                       axil_uart_arready;
wire [AXIL_DATA_WIDTH-1:0] axil_uart_rdata;
wire [1:0]                 axil_uart_rresp;
wire                       axil_uart_rvalid;
wire                       axil_uart_rready;
pcie_us_axil_master #(
    .AXIS_PCIE_DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
    .AXIS_PCIE_KEEP_WIDTH(AXIS_PCIE_KEEP_WIDTH),
    .AXIS_PCIE_CQ_USER_WIDTH(AXIS_PCIE_CQ_USER_WIDTH),
    .AXIS_PCIE_CC_USER_WIDTH(AXIS_PCIE_CC_USER_WIDTH),
    .AXI_DATA_WIDTH(AXIL_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXIL_ADDR_WIDTH),
    .ENABLE_PARITY(0)
)
pcie_us_axil_master_inst_0 (
    .clk(clk),
    .rst(rst),

    /*
     * AXI input (CQ)
     */
    .s_axis_cq_tdata(axis_cq_tdata_bar_2),
    .s_axis_cq_tkeep(axis_cq_tkeep_bar_2),
    .s_axis_cq_tvalid(axis_cq_tvalid_bar_2),
    .s_axis_cq_tready(axis_cq_tready_bar_2),
    .s_axis_cq_tlast(axis_cq_tlast_bar_2),
    .s_axis_cq_tuser(axis_cq_tuser_bar_2),

    /*
     * AXI input (CC)
     */
    .m_axis_cc_tdata(axis_cc_tdata_bar_2),
    .m_axis_cc_tkeep(axis_cc_tkeep_bar_2),
    .m_axis_cc_tvalid(axis_cc_tvalid_bar_2),
    .m_axis_cc_tready(axis_cc_tready_bar_2),
    .m_axis_cc_tlast(axis_cc_tlast_bar_2),
    .m_axis_cc_tuser(axis_cc_tuser_bar_2),

    /*
     * AXI Lite Master output
     */
    .m_axil_awaddr (axil_uart_awaddr),
    .m_axil_awprot (axil_uart_awprot),
    .m_axil_awvalid(axil_uart_awvalid),
    .m_axil_awready(axil_uart_awready),
    .m_axil_wdata  (axil_uart_wdata),
    .m_axil_wstrb  (axil_uart_wstrb),
    .m_axil_wvalid (axil_uart_wvalid),
    .m_axil_wready (axil_uart_wready),
    .m_axil_bresp  (axil_uart_bresp),
    .m_axil_bvalid (axil_uart_bvalid),
    .m_axil_bready (axil_uart_bready),
    .m_axil_araddr (axil_uart_araddr),
    .m_axil_arprot (axil_uart_arprot),
    .m_axil_arvalid(axil_uart_arvalid),
    .m_axil_arready(axil_uart_arready),
    .m_axil_rdata  (axil_uart_rdata),
    .m_axil_rresp  (axil_uart_rresp),
    .m_axil_rvalid (axil_uart_rvalid),
    .m_axil_rready (axil_uart_rready),

    /*
     * Configuration
     */
    .completer_id({8'd0, 5'd0, 3'd2}),
    .completer_id_enable(1'b0),

    /*
     * Status
     */
    .status_error_cor(status_error_cor_int[2]),
    .status_error_uncor(status_error_uncor_int[2])
);
reg [AXI_ID_WIDTH-1:0]    axi_awid_ram;
reg [AXI_ADDR_WIDTH-1:0]  axi_awaddr_ram;
reg [7:0]                 axi_awlen_ram;
reg [2:0]                 axi_awsize_ram;
reg [1:0]                 axi_awburst_ram;
reg                       axi_awlock_ram;
reg [3:0]                 axi_awcache_ram;
reg [2:0]                 axi_awprot_ram;
reg                       axi_awvalid_ram;
wire                       axi_awready_ram;
reg [AXI_DATA_WIDTH-1:0]  axi_wdata_ram;
reg [AXI_STRB_WIDTH-1:0]  axi_wstrb_ram;
reg                       axi_wlast_ram;
reg                       axi_wvalid_ram;
wire                       axi_wready_ram;
wire [AXI_ID_WIDTH-1:0]    axi_bid_ram;
wire [1:0]                 axi_bresp_ram;
wire                       axi_bvalid_ram;
reg                       axi_bready_ram;
reg [AXI_ID_WIDTH-1:0]    axi_arid_ram;
reg [AXI_ADDR_WIDTH-1:0]  axi_araddr_ram;
reg [7:0]                 axi_arlen_ram;
reg [2:0]                 axi_arsize_ram;
reg [1:0]                 axi_arburst_ram;
reg                       axi_arlock_ram;
reg [3:0]                 axi_arcache_ram;
reg [2:0]                 axi_arprot_ram;
reg                       axi_arvalid_ram;
wire                       axi_arready_ram;
wire [AXI_ID_WIDTH-1:0]    axi_rid_ram;
wire [AXI_DATA_WIDTH-1:0]  axi_rdata_ram;
wire [1:0]                 axi_rresp_ram;
wire                       axi_rlast_ram;
wire                       axi_rvalid_ram;
reg                       axi_rready_ram;

//axi_protocol_converter_0 inst(
//  .aclk          (clk),
//  .aresetn       (rst),
//  .s_axi_awaddr  (axil_uart_awaddr),
//  .s_axi_awprot  (axil_uart_awprot),
//  .s_axi_awvalid (axil_uart_awvalid),
//  .s_axi_awready (axil_uart_awready),
//  .s_axi_wdata   (axil_uart_wdata),
//  .s_axi_wstrb   (axil_uart_wstrb),
//  .s_axi_wvalid  (axil_uart_wvalid),
//  .s_axi_wready  (axil_uart_wready),
//  .s_axi_bresp   (axil_uart_bresp),
//  .s_axi_bvalid  (axil_uart_bvalid),
//  .s_axi_bready  (axil_uart_bready),
//  .s_axi_araddr  (axil_uart_araddr),
//  .s_axi_arprot  (axil_uart_arprot),
//  .s_axi_arvalid (axil_uart_arvalid),
//  .s_axi_arready (axil_uart_arready),
//  .s_axi_rdata   (axil_uart_rdata),
//  .s_axi_rresp   (axil_uart_rresp),
//  .s_axi_rvalid  (axil_uart_rvalid),
//  .s_axi_rready  (axil_uart_rready),
//  .m_axi_awaddr  (axi_awid_ram),
//  .m_axi_awlen   (axi_awaddr_ram),
//  .m_axi_awsize  (axi_awlen_ram),
//  .m_axi_awburst (axi_awsize_ram),
//  .m_axi_awlock  (axi_awburst_ram),
//  .m_axi_awcache (axi_awlock_ram),
//  .m_axi_awprot  (axi_awcache_ram),
//  .m_axi_awregion(axi_awprot_ram),
//  .m_axi_awqos   (axi_awvalid_ram),
//  .m_axi_awvalid (axi_awready_ram),
//  .m_axi_awready (axi_wdata_ram),
//  .m_axi_wdata   (axi_wstrb_ram),
//  .m_axi_wstrb   (axi_wlast_ram),
//  .m_axi_wlast   (axi_wvalid_ram),
//  .m_axi_wvalid  (axi_wready_ram),
//  .m_axi_wready  (axi_bid_ram),
//  .m_axi_bresp   (axi_bresp_ram),
//  .m_axi_bvalid  (axi_bvalid_ram),
//  .m_axi_bready  (axi_bready_ram),
//  .m_axi_araddr  (axi_arid_ram),
//  .m_axi_arlen   (axi_araddr_ram),
//  .m_axi_arsize  (axi_arlen_ram),
//  .m_axi_arburst (axi_arsize_ram),
//  .m_axi_arlock  (axi_arburst_ram),
//  .m_axi_arcache (axi_arlock_ram),
//  .m_axi_arprot  (axi_arcache_ram),
//  .m_axi_arregion(axi_arprot_ram),
//  .m_axi_arqos   (axi_arvalid_ram),
//  .m_axi_arvalid (axi_arready_ram),
//  .m_axi_arready (axi_rid_ram),
//  .m_axi_rdata   (axi_rdata_ram),
//  .m_axi_rresp   (axi_rresp_ram),
//  .m_axi_rlast   (axi_rlast_ram),
//  .m_axi_rvalid  (axi_rvalid_ram),
//  .m_axi_rready  (axi_rready_ram)
//);

//ila_2 ila_2_inst(
//.clk(clk),
//.probe0(axis_cq_tdata_bar_2),
//.probe1(axis_cq_tkeep_bar_2),
//.probe2(axis_cq_tuser_bar_2),
//.probe3(axis_cq_tlast_bar_2),
//.probe4(axis_cq_tready_bar_2),
//.probe5(axis_cq_tvalid_bar_2),
//.probe6(bar_id),
//.probe7(select)
//);

//ila_3 ila_3_inst (
//.clk(clk),
//.probe0(axis_cc_tdata_bar_2),
//.probe1(axis_cc_tkeep_bar_2),
//.probe2(axis_cc_tuser_bar_2),
//.probe3(axis_cc_tlast_bar_2),
//.probe4(axis_cc_tready_bar_2),
//.probe5(axis_cc_tvalid)
//);
//axi_master Added
//signal
wire [AXI_ID_WIDTH-1:0]    axi_awid;    
wire [AXI_ADDR_WIDTH-1:0]  axi_awaddr;
wire [7:0]                 axi_awlen;
wire [2:0]                 axi_awsize;
wire [1:0]                 axi_awburst;
wire                       axi_awlock;
wire [3:0]                 axi_awcache;
wire [2:0]                 axi_awprot;
wire                       axi_awvalid;
reg                       axi_awready;
wire [AXI_DATA_WIDTH-1:0]  axi_wdata;
wire [AXI_STRB_WIDTH-1:0]  axi_wstrb;
wire                       axi_wlast;
wire                       axi_wvalid;
reg                       axi_wready;
reg [AXI_ID_WIDTH-1:0]    axi_bid;
reg [1:0]                 axi_bresp;
reg                       axi_bvalid;
wire                       axi_bready;
wire [AXI_ID_WIDTH-1:0]    axi_arid;
wire [AXI_ADDR_WIDTH-1:0]  axi_araddr;
wire [7:0]                 axi_arlen;
wire [2:0]                 axi_arsize;
wire [1:0]                 axi_arburst;
wire                       axi_arlock;
wire [3:0]                 axi_arcache;
wire [2:0]                 axi_arprot;
wire                       axi_arvalid;
reg                       axi_arready;
reg [AXI_ID_WIDTH-1:0]    axi_rid;
reg [AXI_DATA_WIDTH-1:0]  axi_rdata;
reg [1:0]                 axi_rresp;
reg                       axi_rlast;
reg                       axi_rvalid;
wire                       axi_rready;

reg [AXI_ID_WIDTH-1:0]    s_axi_hp1_fpd_awid;
reg [AXI_ADDR_WIDTH-1:0]  s_axi_hp1_fpd_awaddr;
reg [7:0]                 s_axi_hp1_fpd_awlen;
reg [2:0]                 s_axi_hp1_fpd_awsize;
reg [1:0]                 s_axi_hp1_fpd_awburst;
reg                       s_axi_hp1_fpd_awlock;
reg [3:0]                 s_axi_hp1_fpd_awcache;
reg [2:0]                 s_axi_hp1_fpd_awprot;
reg                       s_axi_hp1_fpd_awvalid;
wire                       s_axi_hp1_fpd_awready;
reg [AXI_DATA_WIDTH-1:0]  s_axi_hp1_fpd_wdata;
reg [AXI_STRB_WIDTH-1:0]  s_axi_hp1_fpd_wstrb;
reg                       s_axi_hp1_fpd_wlast;
reg                       s_axi_hp1_fpd_wvalid;
wire                       s_axi_hp1_fpd_wready;
wire [AXI_ID_WIDTH-1:0]    s_axi_hp1_fpd_bid;
wire [1:0]                 s_axi_hp1_fpd_bresp;
wire                       s_axi_hp1_fpd_bvalid;
reg                       s_axi_hp1_fpd_bready;
reg [AXI_ID_WIDTH-1:0]    s_axi_hp1_fpd_arid;
reg [AXI_ADDR_WIDTH-1:0]  s_axi_hp1_fpd_araddr;
reg [7:0]                 s_axi_hp1_fpd_arlen;
reg [2:0]                 s_axi_hp1_fpd_arsize;
reg [1:0]                 s_axi_hp1_fpd_arburst;
reg                       s_axi_hp1_fpd_arlock;
reg [3:0]                 s_axi_hp1_fpd_arcache;
reg [2:0]                 s_axi_hp1_fpd_arprot;
reg                       s_axi_hp1_fpd_arvalid;
wire                       s_axi_hp1_fpd_arready;
wire [AXI_ID_WIDTH-1:0]    s_axi_hp1_fpd_rid;
wire [AXI_DATA_WIDTH-1:0]  s_axi_hp1_fpd_rdata;
wire [1:0]                 s_axi_hp1_fpd_rresp;
wire                       s_axi_hp1_fpd_rlast;
wire                       s_axi_hp1_fpd_rvalid;
reg                       s_axi_hp1_fpd_rready;

reg [AXI_ID_WIDTH-1:0]    s_axi_hp2_fpd_awid;
reg [AXI_ADDR_WIDTH-1:0]  s_axi_hp2_fpd_awaddr;
reg [7:0]                 s_axi_hp2_fpd_awlen;
reg [2:0]                 s_axi_hp2_fpd_awsize;
reg [1:0]                 s_axi_hp2_fpd_awburst;
reg                       s_axi_hp2_fpd_awlock;
reg [3:0]                 s_axi_hp2_fpd_awcache;
reg [2:0]                 s_axi_hp2_fpd_awprot;
reg                       s_axi_hp2_fpd_awvalid;
wire                       s_axi_hp2_fpd_awready;
reg [AXI_DATA_WIDTH-1:0]  s_axi_hp2_fpd_wdata;
reg [AXI_STRB_WIDTH-1:0]  s_axi_hp2_fpd_wstrb;
reg                       s_axi_hp2_fpd_wlast;
reg                       s_axi_hp2_fpd_wvalid;
wire                       s_axi_hp2_fpd_wready;
wire [AXI_ID_WIDTH-1:0]    s_axi_hp2_fpd_bid;
wire [1:0]                 s_axi_hp2_fpd_bresp;
wire                       s_axi_hp2_fpd_bvalid;
reg                       s_axi_hp2_fpd_bready;
reg [AXI_ID_WIDTH-1:0]    s_axi_hp2_fpd_arid;
reg [AXI_ADDR_WIDTH-1:0]  s_axi_hp2_fpd_araddr;
reg [7:0]                 s_axi_hp2_fpd_arlen;
reg [2:0]                 s_axi_hp2_fpd_arsize;
reg [1:0]                 s_axi_hp2_fpd_arburst;
reg                       s_axi_hp2_fpd_arlock;
reg [3:0]                 s_axi_hp2_fpd_arcache;
reg [2:0]                 s_axi_hp2_fpd_arprot;
reg                       s_axi_hp2_fpd_arvalid;
wire                       s_axi_hp2_fpd_arready;
wire [AXI_ID_WIDTH-1:0]    s_axi_hp2_fpd_rid;
wire [AXI_DATA_WIDTH-1:0]  s_axi_hp2_fpd_rdata;
wire [1:0]                 s_axi_hp2_fpd_rresp;
wire                       s_axi_hp2_fpd_rlast;
wire                       s_axi_hp2_fpd_rvalid;
reg                       s_axi_hp2_fpd_rready;

pcie_us_axi_master #(
    .AXIS_PCIE_DATA_WIDTH(AXIS_PCIE_DATA_WIDTH),
    .AXIS_PCIE_KEEP_WIDTH(AXIS_PCIE_KEEP_WIDTH),
    .AXIS_PCIE_CQ_USER_WIDTH(AXIS_PCIE_CQ_USER_WIDTH),
    .AXIS_PCIE_CC_USER_WIDTH(AXIS_PCIE_CC_USER_WIDTH),
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
    .AXI_STRB_WIDTH(AXI_STRB_WIDTH),
    .AXI_ID_WIDTH(AXI_ID_WIDTH)
)
pcie_us_axi_master_inst (
    .clk(clk),
    .rst(rst),

    /*
     * AXI input (CQ)
     */
    .s_axis_cq_tdata(axis_cq_tdata_bar_1),
    .s_axis_cq_tkeep(axis_cq_tkeep_bar_1),
    .s_axis_cq_tvalid(axis_cq_tvalid_bar_1),
    .s_axis_cq_tready(axis_cq_tready_bar_1),
    .s_axis_cq_tlast(axis_cq_tlast_bar_1),
    .s_axis_cq_tuser(axis_cq_tuser_bar_1),

    /*
     * AXI output (CC)
     */
    .m_axis_cc_tdata(axis_cc_tdata_bar_1),
    .m_axis_cc_tkeep(axis_cc_tkeep_bar_1),
    .m_axis_cc_tvalid(axis_cc_tvalid_bar_1),
    .m_axis_cc_tready(axis_cc_tready_bar_1),
    .m_axis_cc_tlast(axis_cc_tlast_bar_1),
    .m_axis_cc_tuser(axis_cc_tuser_bar_1),

    /*
     * AXI Master output
     */
    .m_axi_awid(axi_awid),
    .m_axi_awaddr(axi_awaddr),
    .m_axi_awlen(axi_awlen),
    .m_axi_awsize(axi_awsize),
    .m_axi_awburst(axi_awburst),
    .m_axi_awlock(axi_awlock),
    .m_axi_awcache(axi_awcache),
    .m_axi_awprot(axi_awprot),
    .m_axi_awvalid(axi_awvalid),
    .m_axi_awready(axi_awready),
    .m_axi_wdata(axi_wdata),
    .m_axi_wstrb(axi_wstrb),
    .m_axi_wlast(axi_wlast),
    .m_axi_wvalid(axi_wvalid),
    .m_axi_wready(axi_wready),
    .m_axi_bid(axi_bid),
    .m_axi_bresp(axi_bresp),
    .m_axi_bvalid(axi_bvalid),
    .m_axi_bready(axi_bready),
    .m_axi_arid(axi_arid),
    .m_axi_araddr(axi_araddr),
    .m_axi_arlen(axi_arlen),
    .m_axi_arsize(axi_arsize),
    .m_axi_arburst(axi_arburst),
    .m_axi_arlock(axi_arlock),
    .m_axi_arcache(axi_arcache),
    .m_axi_arprot(axi_arprot),
    .m_axi_arvalid(axi_arvalid),
    .m_axi_arready(axi_arready),
    .m_axi_rid(axi_rid),
    .m_axi_rdata(axi_rdata),
    .m_axi_rresp(axi_rresp),
    .m_axi_rlast(axi_rlast),
    .m_axi_rvalid(axi_rvalid),
    .m_axi_rready(axi_rready),

    /*
     * Configuration
     */
    .completer_id({8'd0, 5'd0, 3'd1}),
    .completer_id_enable(1'b0),
    .max_payload_size(cfg_max_payload),

    /*
     * Status
     */
    .status_error_cor(status_error_cor_int[1]),
    .status_error_uncor(status_error_uncor_int[1])
);

//wire ps_ddr0_offset;
//wire ps_ddr1_offset;
//wire ps_ddr0_size;
//wire ps_ddr1_size;
wire [31:0] base_addr_ps_ddr_0_lsb;
wire [31:0] base_addr_ps_ddr_1_lsb;
wire [31:0] base_addr_ps_ddr_0_msb;
wire [31:0] base_addr_ps_ddr_1_msb;
wire [31:0] addr_tri_offset_0; 
wire [31:0] size_tri_offset_0;
wire [31:0] addr_tri_offset_1; 
wire [31:0] size_tri_offset_1;

//logic for address decoding BAR0 & BAR1 :  
wire [31:0] wr_addr;
wire [31:0] rd_addr;
wire [31:0] wr_addr_axil;
wire [31:0] rd_addr_axil;
wire [31:0] wr_addr_axil_2;
wire [31:0] rd_addr_axil_2;
wire [31:0] base_addr_gpio_0;
wire [31:0] base_addr_gpio_1;
  
//ila_2 ila_addr (
//               .clk(clk),
//               .probe0(wr_addr),
//               .probe1(rd_addr),
//               .probe2(bar1_offset_0),
//               .probe3(bar1_offset_1)
//);      
   
    assign base_addr_gpio_0 = (addr_tri_offset_0 == 32'h0) ? base_addr_ps_ddr_0_lsb :`PS_DDR0_OFFSET;
    assign base_addr_gpio_1 = (addr_tri_offset_1 == 32'h0) ? base_addr_ps_ddr_1_lsb :`PS_DDR1_OFFSET; 
    
    assign wr_addr = (func_no_out == 3'b1) ? (base_addr_gpio_1 + (`EIGHT_BIT_MASK & axi_awaddr)) : ((func_no_out == 3'b0) ? (base_addr_gpio_0 + (`EIGHT_BIT_MASK & axi_awaddr)) : axi_awaddr);
	assign rd_addr = (func_no_out == 3'b1) ? (base_addr_gpio_1 + (`EIGHT_BIT_MASK & axi_araddr)) : ((func_no_out == 3'b0) ? (base_addr_gpio_0 + (`EIGHT_BIT_MASK & axi_araddr)) : axi_araddr); 
 
    assign wr_addr_axil = (func_no_out == 3'b0) ? ((axil_host_awaddr & `EIGHT_BIT_MASK) + `NVME_OFFSET) :((func_no_out == 3'b1) ? ( 
                          ((axil_host_awaddr[23] == 1'b1) ? ((axil_host_awaddr &  `ELEVEN_BIT_MASK) + `VTA_OFFSET) : 
                          ((axil_host_awaddr[22:21] == 2'b00) ? ((axil_host_awaddr &  `ELEVEN_BIT_MASK) + `SYSMON_OFFSET) : 
                          ((axil_host_awaddr[22:21] == 2'b01) ? ((axil_host_awaddr & `ELEVEN_BIT_MASK) + `GPIO_DDR0_OFFSET) : 
                          ((axil_host_awaddr[22:21] == 2'b10) ? ((axil_host_awaddr &  `ELEVEN_BIT_MASK) + `GPIO_DDR1_OFFSET) : axil_host_awaddr))))): axil_host_awaddr);
    
    assign rd_addr_axil = (func_no_out == 3'b0) ? ((axil_host_araddr &  `EIGHT_BIT_MASK) + `NVME_OFFSET) : ((func_no_out == 3'b1) ? (
                          ((axil_host_araddr[23] == 1'b1) ? ((axil_host_araddr &  `ELEVEN_BIT_MASK) + `VTA_OFFSET) : 
                          ((axil_host_araddr[22:21] == 2'b00) ? ((axil_host_araddr &  `ELEVEN_BIT_MASK) + `SYSMON_OFFSET) : 
                          ((axil_host_araddr[22:21] == 2'b01) ? ((axil_host_araddr &  `ELEVEN_BIT_MASK) + `GPIO_DDR0_OFFSET) : 
                          ((axil_host_araddr[22:21] == 2'b10) ? ((axil_host_araddr &  `ELEVEN_BIT_MASK) + `GPIO_DDR1_OFFSET) : axil_host_araddr))))): axil_host_araddr);
                          
    assign wr_addr_axil_2 = (func_no_out == 3'b1) ? ((axil_uart_awaddr[23] == 1'b1) ? ((axil_uart_awaddr & `NINE_BIT_MASK) + `UART0_OFFSET): ((axil_uart_awaddr & `NINE_BIT_MASK) + `UART2_OFFSET)) :
	                      (func_no_out == 3'b0) ? axil_uart_awaddr : axil_uart_awaddr ;
	                      
	assign rd_addr_axil_2 = (func_no_out == 3'b1) ? ((axil_uart_araddr[23] == 1'b1) ? ((axil_uart_araddr & `NINE_BIT_MASK) + `UART0_OFFSET): ((axil_uart_araddr & `NINE_BIT_MASK) + `UART2_OFFSET)) :
	                      (func_no_out == 3'b0) ? axil_uart_araddr : axil_uart_araddr ;
   
always @(posedge clk) begin
if ((wr_addr == (base_addr_gpio_1 + (`EIGHT_BIT_MASK & axi_awaddr)) || rd_addr == (base_addr_gpio_1 + (`EIGHT_BIT_MASK & axi_araddr))) & (wr_addr < `MAX_RANGE_PS_DDR || rd_addr < `MAX_RANGE_PS_DDR)) begin
      s_axi_hp1_fpd_awid      <= axi_awid;            
      s_axi_hp1_fpd_awaddr    <= wr_addr;   
      s_axi_hp1_fpd_awlen     <= axi_awlen;     
      s_axi_hp1_fpd_awsize    <= axi_awsize;            
      s_axi_hp1_fpd_awburst   <= axi_awburst;               
      s_axi_hp1_fpd_awlock    <= axi_awlock;                        
      s_axi_hp1_fpd_awcache   <= axi_awcache;                    
      s_axi_hp1_fpd_awprot    <= axi_awprot;                  
      s_axi_hp1_fpd_awvalid   <= axi_awvalid;                   
      axi_awready             <= s_axi_hp1_fpd_awready;                   
      s_axi_hp1_fpd_wdata     <= axi_wdata;                
      s_axi_hp1_fpd_wstrb     <= axi_wstrb;          
      s_axi_hp1_fpd_wlast     <= axi_wlast;          
      s_axi_hp1_fpd_wvalid    <= axi_wvalid;            
      axi_wready              <= s_axi_hp1_fpd_wready;            
      axi_bid                 <= s_axi_hp1_fpd_bid;                             
      axi_bresp               <= s_axi_hp1_fpd_bresp;            
      axi_bvalid              <= s_axi_hp1_fpd_bvalid;             
      s_axi_hp1_fpd_bready    <= axi_bready;                   
      s_axi_hp1_fpd_arid      <= axi_arid;                    
      s_axi_hp1_fpd_araddr    <= rd_addr;              
      s_axi_hp1_fpd_arlen     <= axi_arlen;                  
      s_axi_hp1_fpd_arsize    <= axi_arsize;              
      s_axi_hp1_fpd_arburst   <= axi_arburst;                   
      s_axi_hp1_fpd_arlock    <= axi_arlock;                    
      s_axi_hp1_fpd_arcache   <= axi_arcache;                    
      s_axi_hp1_fpd_arprot    <= axi_arprot;              
      s_axi_hp1_fpd_arvalid   <= axi_arvalid;        
      axi_arready             <= s_axi_hp1_fpd_arready;          
      axi_rid                 <= s_axi_hp1_fpd_rid;         
      axi_rdata               <= s_axi_hp1_fpd_rdata ;   
      axi_rresp               <= s_axi_hp1_fpd_rresp; 
      axi_rlast               <= s_axi_hp1_fpd_rlast;   
      axi_rvalid              <= s_axi_hp1_fpd_rvalid; 
      s_axi_hp1_fpd_rready    <= axi_rready;
end
else if ((wr_addr == (base_addr_gpio_0 + (`EIGHT_BIT_MASK & axi_awaddr)) || rd_addr == (base_addr_gpio_0 + (`EIGHT_BIT_MASK & axi_araddr))) & (wr_addr < `MAX_RANGE_PS_DDR || rd_addr < `MAX_RANGE_PS_DDR)) begin
      s_axi_hp2_fpd_awid      <= axi_awid;            
      s_axi_hp2_fpd_awaddr    <= wr_addr;   
      s_axi_hp2_fpd_awlen     <= axi_awlen;     
      s_axi_hp2_fpd_awsize    <= axi_awsize;            
      s_axi_hp2_fpd_awburst   <= axi_awburst;               
      s_axi_hp2_fpd_awlock    <= axi_awlock;                        
      s_axi_hp2_fpd_awcache   <= axi_awcache;                    
      s_axi_hp2_fpd_awprot    <= axi_awprot;                  
      s_axi_hp2_fpd_awvalid   <= axi_awvalid;                   
      axi_awready             <= s_axi_hp2_fpd_awready;                   
      s_axi_hp2_fpd_wdata     <= axi_wdata;                
      s_axi_hp2_fpd_wstrb     <= axi_wstrb;          
      s_axi_hp2_fpd_wlast     <= axi_wlast;          
      s_axi_hp2_fpd_wvalid    <= axi_wvalid;            
      axi_wready              <= s_axi_hp2_fpd_wready;            
      axi_bid                 <= s_axi_hp2_fpd_bid;                             
      axi_bresp               <= s_axi_hp2_fpd_bresp;            
      axi_bvalid              <= s_axi_hp2_fpd_bvalid;             
      s_axi_hp2_fpd_bready    <= axi_bready;                   
      s_axi_hp2_fpd_arid      <= axi_arid;                    
      s_axi_hp2_fpd_araddr    <= rd_addr;              
      s_axi_hp2_fpd_arlen     <= axi_arlen;                  
      s_axi_hp2_fpd_arsize    <= axi_arsize;              
      s_axi_hp2_fpd_arburst   <= axi_arburst;                   
      s_axi_hp2_fpd_arlock    <= axi_arlock;                    
      s_axi_hp2_fpd_arcache   <= axi_arcache;                    
      s_axi_hp2_fpd_arprot    <= axi_arprot;              
      s_axi_hp2_fpd_arvalid   <= axi_arvalid;        
      axi_arready             <= s_axi_hp2_fpd_arready;          
      axi_rid                 <= s_axi_hp2_fpd_rid;         
      axi_rdata               <= s_axi_hp2_fpd_rdata ;   
      axi_rresp               <= s_axi_hp2_fpd_rresp; 
      axi_rlast               <= s_axi_hp2_fpd_rlast;   
      axi_rvalid              <= s_axi_hp2_fpd_rvalid; 
      s_axi_hp2_fpd_rready    <= axi_rready;
end
else
begin
      axi_awid_ram      <= axi_awid;            
      axi_awaddr_ram    <= 32'h0;   
      axi_awlen_ram     <= axi_awlen;     
      axi_awsize_ram    <= axi_awsize;            
      axi_awburst_ram   <= axi_awburst;               
      axi_awlock_ram    <= axi_awlock;                        
      axi_awcache_ram   <= axi_awcache;                    
      axi_awprot_ram    <= axi_awprot;                  
      axi_awvalid_ram   <= axi_awvalid;                   
      axi_awready             <= axi_awready_ram;                   
      axi_wdata_ram     <= 32'hDEC0DE00;                
      axi_wstrb_ram     <= axi_wstrb;          
      axi_wlast_ram     <= axi_wlast;          
      axi_wvalid_ram    <= axi_wvalid;            
      axi_wready              <= axi_wready_ram;            
      axi_bid                 <= axi_bid_ram;                             
      axi_bresp               <= axi_bresp_ram;            
      axi_bvalid              <= axi_bvalid_ram;             
      axi_bready_ram    <= axi_bready;                   
      axi_arid_ram      <= axi_arid;                    
      axi_araddr_ram    <= 32'h0;              
      axi_arlen_ram     <= axi_arlen;                  
      axi_arsize_ram    <= axi_arsize;              
      axi_arburst_ram   <= axi_arburst;                   
      axi_arlock_ram    <= axi_arlock;                    
      axi_arcache_ram   <= axi_arcache;                    
      axi_arprot_ram    <= axi_arprot;              
      axi_arvalid_ram   <= axi_arvalid;        
      axi_arready             <= axi_arready_ram;          
      axi_rid                 <= axi_rid_ram;         
      axi_rdata               <= axi_rdata_ram ;   
      axi_rresp               <= axi_rresp_ram; 
      axi_rlast               <= axi_rlast_ram;   
      axi_rvalid              <= axi_rvalid_ram; 
      axi_rready_ram    <= axi_rready;
      end
end
//signals for NVMe top from design_1
wire [AXIL_ADDR_WIDTH-1:0] axil_nvme_awaddr;
wire [2:0]                 axil_nvme_awprot;
wire                       axil_nvme_awvalid;
wire                       axil_nvme_awready;
wire [AXIL_DATA_WIDTH-1:0] axil_nvme_wdata;
wire [AXIL_STRB_WIDTH-1:0] axil_nvme_wstrb;
wire                       axil_nvme_wvalid;
wire                       axil_nvme_wready;
wire [1:0]                 axil_nvme_bresp;
wire                       axil_nvme_bvalid;
wire                       axil_nvme_bready;
wire [AXIL_ADDR_WIDTH-1:0] axil_nvme_araddr;
wire [2:0]                 axil_nvme_arprot;
wire                       axil_nvme_arvalid;
wire                       axil_nvme_arready;
wire [AXIL_DATA_WIDTH-1:0] axil_nvme_rdata;
wire [1:0]                 axil_nvme_rresp;
wire                       axil_nvme_rvalid;
wire                       axil_nvme_rready;


//signals for RAM BAR0 - AXI4
wire [AXI_ID_WIDTH-1:0]    axil_ram_awid;
wire [AXIL_ADDR_WIDTH-1:0]  axil_ram_awaddr;
wire [7:0]                 axil_ram_awlen;
wire [2:0]                 axil_ram_awsize;
wire [1:0]                 axil_ram_awburst;
wire                       axil_ram_awlock;
wire [3:0]                 axil_ram_awcache;
wire [2:0]                 axil_ram_awprot;
wire                       axil_ram_awvalid;
wire                       axil_ram_awready;
wire [AXIL_DATA_WIDTH-1:0]  axil_ram_wdata;
wire [AXIL_STRB_WIDTH-1:0]  axil_ram_wstrb;
wire                       axil_ram_wlast;
wire                       axil_ram_wvalid;
wire                       axil_ram_wready;
wire [AXI_ID_WIDTH-1:0]    axil_ram_bid;
wire [1:0]                 axil_ram_bresp;
wire                       axil_ram_bvalid;
wire                       axil_ram_bready;
wire [AXI_ID_WIDTH-1:0]    axil_ram_arid;
wire [AXIL_ADDR_WIDTH-1:0]  axil_ram_araddr;
wire [7:0]                 axil_ram_arlen;
wire [2:0]                 axil_ram_arsize;
wire [1:0]                 axil_ram_arburst;
wire                       axil_ram_arlock;
wire [3:0]                 axil_ram_arcache;
wire [2:0]                 axil_ram_arprot;
wire                       axil_ram_arvalid;
wire                       axil_ram_arready;
wire [AXI_ID_WIDTH-1:0]    axil_ram_rid;
wire [AXIL_DATA_WIDTH-1:0]  axil_ram_rdata;
wire [1:0]                 axil_ram_rresp;
wire                       axil_ram_rlast;
wire                       axil_ram_rvalid;
wire                       axil_ram_rready;


wire nvme_irq;

NVMeTop nvmetop_inst (
    .clock(clk),
    .reset(rst),
    .io_irqReq(nvme_irq),
    
    .io_irqHost(msi_irq),

    .io_host_aw_awaddr(axil_nvme_awaddr),
    .io_host_aw_awprot(axil_nvme_awprot),
    .io_host_aw_awvalid(axil_nvme_awvalid),
    .io_host_aw_awready(axil_nvme_awready),
    .io_host_w_wdata(axil_nvme_wdata),
    .io_host_w_wstrb(axil_nvme_wstrb),
    .io_host_w_wvalid(axil_nvme_wvalid),
    .io_host_w_wready(axil_nvme_wready),
    .io_host_b_bresp(axil_nvme_bresp),
    .io_host_b_bvalid(axil_nvme_bvalid),
    .io_host_b_bready(axil_nvme_bready),
    .io_host_ar_araddr(axil_nvme_araddr),
    .io_host_ar_arprot(axil_nvme_arprot),
    .io_host_ar_arvalid(axil_nvme_arvalid),
    .io_host_ar_arready(axil_nvme_arready),
    .io_host_r_rdata(axil_nvme_rdata),
    .io_host_r_rresp(axil_nvme_rresp),
    .io_host_r_rvalid(axil_nvme_rvalid),
    .io_host_r_rready(axil_nvme_rready),

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
    .ps_ddr0_offset(`PS_DDR0_OFFSET),
    .ps_ddr0_msb(`PS_DDR0_MSB),
    .ps_ddr1_offset(`PS_DDR1_OFFSET),
    .ps_ddr1_msb(`PS_DDR1_MSB),
    .base_addr_ps_ddr_0_lsb(base_addr_ps_ddr_0_lsb),
    .base_addr_ps_ddr_0_msb(base_addr_ps_ddr_0_msb),
    .base_addr_ps_ddr_1_lsb(base_addr_ps_ddr_1_lsb),
    .base_addr_ps_ddr_1_msb(base_addr_ps_ddr_1_msb),
    .addr_tri_offset_0 (addr_tri_offset_0 ),
    .size_tri_offset_0(size_tri_offset_0),
    .addr_tri_offset_1 (addr_tri_offset_1),
    .size_tri_offset_1(size_tri_offset_1),
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
    .S_AXI_DMA_rready(axi_dma_rready),

 //axi_master to design_1 (interconnect) (BAR1)
      // .S_AXI_MASTER_awid(axi_awid),
//    .S_AXI_MASTER_awaddr(wr_addr),
//    .S_AXI_MASTER_awlen(axi_awlen),
//    .S_AXI_MASTER_awsize(axi_awsize),
//    .S_AXI_MASTER_awburst(axi_awburst),
//    .S_AXI_MASTER_awlock(axi_awlock),
//    .S_AXI_MASTER_awcache(axi_awcache),
//    .S_AXI_MASTER_awprot(axi_awprot),
//    .S_AXI_MASTER_awvalid(axi_awvalid),
//    .S_AXI_MASTER_awready(axi_awready),    
//    .S_AXI_MASTER_wdata(axi_wdata),
//    .S_AXI_MASTER_wstrb(axi_wstrb),
//    .S_AXI_MASTER_wlast(axi_wlast),
//    .S_AXI_MASTER_wvalid(axi_wvalid),
//    .S_AXI_MASTER_wready(axi_wready),
//     //  .S_AXI_MASTER_bid(axi_bid),
//    .S_AXI_MASTER_bresp(axi_bresp),
//    .S_AXI_MASTER_bvalid(axi_bvalid),
//    .S_AXI_MASTER_bready(axi_bready),
//     // .S_AXI_MASTER_arid(axi_arid),
//    .S_AXI_MASTER_araddr(rd_addr),
//    .S_AXI_MASTER_arlen(axi_arlen),
//    .S_AXI_MASTER_arsize(axi_arsize),
//    .S_AXI_MASTER_arburst(axi_arburst),
//    .S_AXI_MASTER_arlock(axi_arlock),
//    .S_AXI_MASTER_arcache(axi_arcache),
//    .S_AXI_MASTER_arprot(axi_arprot),
//    .S_AXI_MASTER_arvalid(axi_arvalid),
//    .S_AXI_MASTER_arready(axi_arready),
//     //  .S_AXI_MASTER_rid(axi_rid),
//    .S_AXI_MASTER_rdata(axi_rdata),
//    .S_AXI_MASTER_rresp(axi_rresp),
//    .S_AXI_MASTER_rlast(axi_rlast),
//    .S_AXI_MASTER_rvalid(axi_rvalid),
//    .S_AXI_MASTER_rready(axi_rready),
    .S_AXI_HP1_FPD_0_araddr  (s_axi_hp1_fpd_araddr ),
    .S_AXI_HP1_FPD_0_arburst (s_axi_hp1_fpd_arburst),
    .S_AXI_HP1_FPD_0_arcache (s_axi_hp1_fpd_arcache),
    .S_AXI_HP1_FPD_0_arid    (s_axi_hp1_fpd_arid   ),
    .S_AXI_HP1_FPD_0_arlen   (s_axi_hp1_fpd_arlen  ),
    .S_AXI_HP1_FPD_0_arlock  (s_axi_hp1_fpd_arlock ),
    .S_AXI_HP1_FPD_0_arprot  (s_axi_hp1_fpd_arprot ),
    .S_AXI_HP1_FPD_0_arqos   (s_axi_hp1_fpd_arqos  ),
    .S_AXI_HP1_FPD_0_arready (s_axi_hp1_fpd_arready),
    .S_AXI_HP1_FPD_0_arsize  (s_axi_hp1_fpd_arsize ),
    .S_AXI_HP1_FPD_0_aruser  (s_axi_hp1_fpd_aruser ),
    .S_AXI_HP1_FPD_0_arvalid (s_axi_hp1_fpd_arvalid),
    .S_AXI_HP1_FPD_0_awaddr  (s_axi_hp1_fpd_awaddr ),
    .S_AXI_HP1_FPD_0_awburst (s_axi_hp1_fpd_awburst),
    .S_AXI_HP1_FPD_0_awcache (s_axi_hp1_fpd_awcache),
    .S_AXI_HP1_FPD_0_awid    (s_axi_hp1_fpd_awid   ),
    .S_AXI_HP1_FPD_0_awlen   (s_axi_hp1_fpd_awlen  ),
    .S_AXI_HP1_FPD_0_awlock  (s_axi_hp1_fpd_awlock ),
    .S_AXI_HP1_FPD_0_awprot  (s_axi_hp1_fpd_awprot ),
    .S_AXI_HP1_FPD_0_awqos   (s_axi_hp1_fpd_awqos  ),
    .S_AXI_HP1_FPD_0_awready (s_axi_hp1_fpd_awready),
    .S_AXI_HP1_FPD_0_awsize  (s_axi_hp1_fpd_awsize ),
    .S_AXI_HP1_FPD_0_awuser  (s_axi_hp1_fpd_awuser ),
    .S_AXI_HP1_FPD_0_awvalid (s_axi_hp1_fpd_awvalid),
    .S_AXI_HP1_FPD_0_bid     (s_axi_hp1_fpd_bid    ),
    .S_AXI_HP1_FPD_0_bready  (s_axi_hp1_fpd_bready ),
    .S_AXI_HP1_FPD_0_bresp   (s_axi_hp1_fpd_bresp  ),
    .S_AXI_HP1_FPD_0_bvalid  (s_axi_hp1_fpd_bvalid ),
    .S_AXI_HP1_FPD_0_rdata   (s_axi_hp1_fpd_rdata  ),
    .S_AXI_HP1_FPD_0_rid     (s_axi_hp1_fpd_rid    ),
    .S_AXI_HP1_FPD_0_rlast   (s_axi_hp1_fpd_rlast  ),
    .S_AXI_HP1_FPD_0_rready  (s_axi_hp1_fpd_rready ),
    .S_AXI_HP1_FPD_0_rresp   (s_axi_hp1_fpd_rresp  ),
    .S_AXI_HP1_FPD_0_rvalid  (s_axi_hp1_fpd_rvalid ),
    .S_AXI_HP1_FPD_0_wdata   (s_axi_hp1_fpd_wdata  ),
    .S_AXI_HP1_FPD_0_wlast   (s_axi_hp1_fpd_wlast  ),
    .S_AXI_HP1_FPD_0_wready  (s_axi_hp1_fpd_wready ),
    .S_AXI_HP1_FPD_0_wstrb   (s_axi_hp1_fpd_wstrb  ),
    .S_AXI_HP1_FPD_0_wvalid  (s_axi_hp1_fpd_wvalid ),

    .S_AXI_HP2_FPD_0_araddr  (s_axi_hp2_fpd_araddr ),
    .S_AXI_HP2_FPD_0_arburst (s_axi_hp2_fpd_arburst),
    .S_AXI_HP2_FPD_0_arcache (s_axi_hp2_fpd_arcache),
    .S_AXI_HP2_FPD_0_arid    (s_axi_hp2_fpd_arid   ),
    .S_AXI_HP2_FPD_0_arlen   (s_axi_hp2_fpd_arlen  ),
    .S_AXI_HP2_FPD_0_arlock  (s_axi_hp2_fpd_arlock ),
    .S_AXI_HP2_FPD_0_arprot  (s_axi_hp2_fpd_arprot ),
    .S_AXI_HP2_FPD_0_arqos   (s_axi_hp2_fpd_arqos  ),
    .S_AXI_HP2_FPD_0_arready (s_axi_hp2_fpd_arready),
    .S_AXI_HP2_FPD_0_arsize  (s_axi_hp2_fpd_arsize ),
    .S_AXI_HP2_FPD_0_aruser  (s_axi_hp2_fpd_aruser ),
    .S_AXI_HP2_FPD_0_arvalid (s_axi_hp2_fpd_arvalid),
    .S_AXI_HP2_FPD_0_awaddr  (s_axi_hp2_fpd_awaddr ),
    .S_AXI_HP2_FPD_0_awburst (s_axi_hp2_fpd_awburst),
    .S_AXI_HP2_FPD_0_awcache (s_axi_hp2_fpd_awcache),
    .S_AXI_HP2_FPD_0_awid    (s_axi_hp2_fpd_awid   ),
    .S_AXI_HP2_FPD_0_awlen   (s_axi_hp2_fpd_awlen  ),
    .S_AXI_HP2_FPD_0_awlock  (s_axi_hp2_fpd_awlock ),
    .S_AXI_HP2_FPD_0_awprot  (s_axi_hp2_fpd_awprot ),
    .S_AXI_HP2_FPD_0_awqos   (s_axi_hp2_fpd_awqos  ),
    .S_AXI_HP2_FPD_0_awready (s_axi_hp2_fpd_awready),
    .S_AXI_HP2_FPD_0_awsize  (s_axi_hp2_fpd_awsize ),
    .S_AXI_HP2_FPD_0_awuser  (s_axi_hp2_fpd_awuser ),
    .S_AXI_HP2_FPD_0_awvalid (s_axi_hp2_fpd_awvalid),
    .S_AXI_HP2_FPD_0_bid     (s_axi_hp2_fpd_bid    ),
    .S_AXI_HP2_FPD_0_bready  (s_axi_hp2_fpd_bready ),
    .S_AXI_HP2_FPD_0_bresp   (s_axi_hp2_fpd_bresp  ),
    .S_AXI_HP2_FPD_0_bvalid  (s_axi_hp2_fpd_bvalid ),
    .S_AXI_HP2_FPD_0_rdata   (s_axi_hp2_fpd_rdata  ),
    .S_AXI_HP2_FPD_0_rid     (s_axi_hp2_fpd_rid    ),
    .S_AXI_HP2_FPD_0_rlast   (s_axi_hp2_fpd_rlast  ),
    .S_AXI_HP2_FPD_0_rready  (s_axi_hp2_fpd_rready ),
    .S_AXI_HP2_FPD_0_rresp   (s_axi_hp2_fpd_rresp  ),
    .S_AXI_HP2_FPD_0_rvalid  (s_axi_hp2_fpd_rvalid ),
    .S_AXI_HP2_FPD_0_wdata   (s_axi_hp2_fpd_wdata  ),
    .S_AXI_HP2_FPD_0_wlast   (s_axi_hp2_fpd_wlast  ),
    .S_AXI_HP2_FPD_0_wready  (s_axi_hp2_fpd_wready ),
    .S_AXI_HP2_FPD_0_wstrb   (s_axi_hp2_fpd_wstrb  ),
    .S_AXI_HP2_FPD_0_wvalid  (s_axi_hp2_fpd_wvalid ),
    
 //output from design_1 to axi ram  (BAR1)
       // .M_AXI_RAM_awid(axi_awid_ram),
//    .M_AXI_RAM_awaddr(axi_awaddr_ram),
//    .M_AXI_RAM_awlen(axi_awlen_ram),
//    .M_AXI_RAM_awsize(axi_awsize_ram),
//    .M_AXI_RAM_awburst(axi_awburst_ram),
//    .M_AXI_RAM_awlock(axi_awlock_ram),
//    .M_AXI_RAM_awcache(axi_awcache_ram),
//    .M_AXI_RAM_awprot(axi_awprot_ram),
//    .M_AXI_RAM_awvalid(axi_awvalid_ram),
//    .M_AXI_RAM_awready(axi_awready_ram),    
//    .M_AXI_RAM_wdata(axi_wdata_ram),
//    .M_AXI_RAM_wstrb(axi_wstrb_ram),
//    .M_AXI_RAM_wlast(axi_wlast_ram),
//    .M_AXI_RAM_wvalid(axi_wvalid_ram),
//    .M_AXI_RAM_wready(axi_wready_ram),
//     // .M_AXI_RAM_bid(axi_bid_ram),
//    .M_AXI_RAM_bresp(axi_bresp_ram),
//    .M_AXI_RAM_bvalid(axi_bvalid_ram),
//    .M_AXI_RAM_bready(axi_bready_ram),
//     // .M_AXI_RAM_arid(axi_arid_ram),
//    .M_AXI_RAM_araddr(axi_araddr_ram),
//    .M_AXI_RAM_arlen(axi_arlen_ram),
//    .M_AXI_RAM_arsize(axi_arsize_ram),
//    .M_AXI_RAM_arburst(axi_arburst_ram),
//    .M_AXI_RAM_arlock(axi_arlock_ram),
//    .M_AXI_RAM_arcache(axi_arcache_ram),
//    .M_AXI_RAM_arprot(axi_arprot_ram),
//    .M_AXI_RAM_arvalid(axi_arvalid_ram),
//    .M_AXI_RAM_arready(axi_arready_ram),
//     // .M_AXI_RAM_rid(axi_rid_ram),
//    .M_AXI_RAM_rdata(axi_rdata_ram),
//    .M_AXI_RAM_rresp(axi_rresp_ram),
//    .M_AXI_RAM_rlast(axi_rlast_ram),
//    .M_AXI_RAM_rvalid(axi_rvalid_ram),
//    .M_AXI_RAM_rready(axi_rready_ram),
    
//AXIL master to design_1 (Interconnect) (BAR0)
    .S_AXIL_MASTER_awaddr(wr_addr_axil),
    .S_AXIL_MASTER_awprot(axil_host_awprot),
    .S_AXIL_MASTER_awvalid(axil_host_awvalid),
    .S_AXIL_MASTER_awready(axil_host_awready),
    .S_AXIL_MASTER_wdata(axil_host_wdata),
    .S_AXIL_MASTER_wstrb(axil_host_wstrb),
    .S_AXIL_MASTER_wvalid(axil_host_wvalid),
    .S_AXIL_MASTER_wready(axil_host_wready),
    .S_AXIL_MASTER_bresp(axil_host_bresp),
    .S_AXIL_MASTER_bvalid(axil_host_bvalid),
    .S_AXIL_MASTER_bready(axil_host_bready),
    .S_AXIL_MASTER_araddr(rd_addr_axil),
    .S_AXIL_MASTER_arprot(axil_host_arprot),
    .S_AXIL_MASTER_arvalid(axil_host_arvalid),
    .S_AXIL_MASTER_arready(axil_host_arready),
    .S_AXIL_MASTER_rdata(axil_host_rdata),
    .S_AXIL_MASTER_rresp(axil_host_rresp),
    .S_AXIL_MASTER_rvalid(axil_host_rvalid),
    .S_AXIL_MASTER_rready(axil_host_rready),
   
    .S_AXIL_MASTER_2_awaddr (wr_addr_axil_2),
    //.S_AXIL_MASTER_2_awprot (axil_uart_awprot),
    .S_AXIL_MASTER_2_awvalid(axil_uart_awvalid),
    .S_AXIL_MASTER_2_awready(axil_uart_awready),
    .S_AXIL_MASTER_2_wdata  (axil_uart_wdata),
    .S_AXIL_MASTER_2_wstrb  (axil_uart_wstrb),
    .S_AXIL_MASTER_2_wvalid (axil_uart_wvalid),
    .S_AXIL_MASTER_2_wready (axil_uart_wready),
    .S_AXIL_MASTER_2_bresp  (axil_uart_bresp),
    .S_AXIL_MASTER_2_bvalid (axil_uart_bvalid),
    .S_AXIL_MASTER_2_bready (axil_uart_bready),
    .S_AXIL_MASTER_2_araddr (rd_addr_axil_2),
    //.S_AXIL_MASTER_2_arprot (axil_uart_arprot),
    .S_AXIL_MASTER_2_arvalid(axil_uart_arvalid),
    .S_AXIL_MASTER_2_arready(axil_uart_arready),
    .S_AXIL_MASTER_2_rdata  (axil_uart_rdata),
    .S_AXIL_MASTER_2_rresp  (axil_uart_rresp),
    .S_AXIL_MASTER_2_rvalid (axil_uart_rvalid),
    .S_AXIL_MASTER_2_rready (axil_uart_rready), 
//Output from design_1 to NVMe top (BAR0)
    .M_AXIL_NVME_awaddr(axil_nvme_awaddr),
    .M_AXIL_NVME_awprot(axil_nvme_awprot),
    .M_AXIL_NVME_awvalid(axil_nvme_awvalid),
    .M_AXIL_NVME_awready(axil_nvme_awready),
    .M_AXIL_NVME_wdata(axil_nvme_wdata),
    .M_AXIL_NVME_wstrb(axil_nvme_wstrb),
    .M_AXIL_NVME_wvalid(axil_nvme_wvalid),
    .M_AXIL_NVME_wready(axil_nvme_wready),
    .M_AXIL_NVME_bresp(axil_nvme_bresp),
    .M_AXIL_NVME_bvalid(axil_nvme_bvalid),
    .M_AXIL_NVME_bready(axil_nvme_bready),
    .M_AXIL_NVME_araddr(axil_nvme_araddr),
    .M_AXIL_NVME_arprot(axil_nvme_arprot),
    .M_AXIL_NVME_arvalid(axil_nvme_arvalid),
    .M_AXIL_NVME_arready(axil_nvme_arready),
    .M_AXIL_NVME_rdata(axil_nvme_rdata),
    .M_AXIL_NVME_rresp(axil_nvme_rresp),
    .M_AXIL_NVME_rvalid(axil_nvme_rvalid),
    .M_AXIL_NVME_rready(axil_nvme_rready)
);   
   
 //Output from design_1 to axi_ram (BAR0)  //axi4
     // .M_AXI_RAM_awid(axi_awid_ram),
//    .M_AXIL_RAM_awaddr(axil_ram_awaddr),
//    .M_AXIL_RAM_awlen(axil_ram_awlen),
//    .M_AXIL_RAM_awsize(axil_ram_awsize),
//    .M_AXIL_RAM_awburst(axil_ram_awburst),
//    .M_AXIL_RAM_awlock(axil_ram_awlock),
//    .M_AXIL_RAM_awcache(axil_ram_awcache),
//    .M_AXIL_RAM_awprot(axil_ram_awprot),
//    .M_AXIL_RAM_awvalid(axil_ram_awvalid),
//    .M_AXIL_RAM_awready(axil_ram_awready),    
//    .M_AXIL_RAM_wdata(axil_ram_wdata),
//    .M_AXIL_RAM_wstrb(axil_ram_wstrb),
//    .M_AXIL_RAM_wlast(axil_ram_wlast),
//    .M_AXIL_RAM_wvalid(axil_ram_wvalid),
//    .M_AXIL_RAM_wready(axil_ram_wready),
//     // .M_AXI_RAM_bid(axil_ram_bid),
//    .M_AXIL_RAM_bresp(axil_ram_bresp),
//    .M_AXIL_RAM_bvalid(axil_ram_bvalid),
//    .M_AXIL_RAM_bready(axil_ram_bready),
//     // .M_AXI_RAM_arid(axil_ram_arid),
//    .M_AXIL_RAM_araddr(axil_ram_araddr),
//    .M_AXIL_RAM_arlen(axil_ram_arlen),
//    .M_AXIL_RAM_arsize(axil_ram_arsize),
//    .M_AXIL_RAM_arburst(axil_ram_arburst),
//    .M_AXIL_RAM_arlock(axil_ram_arlock),
//    .M_AXIL_RAM_arcache(axil_ram_arcache),
//    .M_AXIL_RAM_arprot(axil_ram_arprot),
//    .M_AXIL_RAM_arvalid(axil_ram_arvalid),
//    .M_AXIL_RAM_arready(axil_ram_arready),
//     // .M_AXI_RAM_rid(axil_ram_rid),
//    .M_AXIL_RAM_rdata(axil_ram_rdata),
//    .M_AXIL_RAM_rresp(axil_ram_rresp),
//    .M_AXIL_RAM_rlast(axil_ram_rlast),
//    .M_AXIL_RAM_rvalid(axil_ram_rvalid),
//    .M_AXIL_RAM_rready(axil_ram_rready)
    
//    );



//internal ram BAR1
axi_ram #(
    .DATA_WIDTH(AXI_DATA_WIDTH),
    .ADDR_WIDTH(16),
    .ID_WIDTH(AXI_ID_WIDTH),
    .PIPELINE_OUTPUT(1)
)
axi_ram_inst (
    .clk(clk),
    .rst(rst),
    .s_axi_awid(axi_awid_ram),
    .s_axi_awaddr(axi_awaddr_ram),
    .s_axi_awlen(axi_awlen_ram),
    .s_axi_awsize(axi_awsize_ram),
    .s_axi_awburst(axi_awburst_ram),
    .s_axi_awlock(axi_awlock_ram),
    .s_axi_awcache(axi_awcache_ram),
    .s_axi_awprot(axi_awprot_ram),
    .s_axi_awvalid(axi_awvalid_ram),
    .s_axi_awready(axi_awready_ram),  
    .s_axi_wdata(axi_wdata_ram),
    .s_axi_wstrb(axi_wstrb_ram),
    .s_axi_wlast(axi_wlast_ram),
    .s_axi_wvalid(axi_wvalid_ram),
    .s_axi_wready(axi_wready_ram),
    .s_axi_bid(axi_bid_ram),
    .s_axi_bresp(axi_bresp_ram),
    .s_axi_bvalid(axi_bvalid_ram),
    .s_axi_bready(axi_bready_ram),
    .s_axi_arid(axi_arid_ram),
    .s_axi_araddr(axi_araddr_ram),
    .s_axi_arlen(axi_arlen_ram),
    .s_axi_arsize(axi_arsize_ram),
    .s_axi_arburst(axi_arburst_ram),
    .s_axi_arlock(axi_arlock_ram),
    .s_axi_arcache(axi_arcache_ram),
    .s_axi_arprot(axi_arprot_ram),
    .s_axi_arvalid(axi_arvalid_ram),
    .s_axi_arready(axi_arready_ram),
    .s_axi_rid(axi_rid_ram),
    .s_axi_rdata(axi_rdata_ram),
    .s_axi_rresp(axi_rresp_ram),
    .s_axi_rlast(axi_rlast_ram),
    .s_axi_rvalid(axi_rvalid_ram),
    .s_axi_rready(axi_rready_ram)
);



//AXI RAM BAR0 - AXI4
//axi_ram #(
//    .DATA_WIDTH(AXIL_DATA_WIDTH),
//    .ADDR_WIDTH(16),
//    .ID_WIDTH(AXI_ID_WIDTH),
//    .PIPELINE_OUTPUT(1)
//)
//axi_ram_bar0 (
//    .clk(clk),
//    .rst(rst),
//    .s_axi_awid(axil_ram_awid),
//    .s_axi_awaddr(axil_ram_awaddr),
//    .s_axi_awlen(axil_ram_awlen),
//    .s_axi_awsize(axil_ram_awsize),
//    .s_axi_awburst(axil_ram_awburst),
//    .s_axi_awlock(axil_ram_awlock),
//    .s_axi_awcache(axil_ram_awcache),
//    .s_axi_awprot(axil_ram_awprot),
//    .s_axi_awvalid(axil_ram_awvalid),
//    .s_axi_awready(axil_ram_awready),  
//    .s_axi_wdata(axil_ram_wdata),
//    .s_axi_wstrb(axil_ram_wstrb),
//    .s_axi_wlast(axil_ram_wlast),
//    .s_axi_wvalid(axil_ram_wvalid),
//    .s_axi_wready(axil_ram_wready),
//    .s_axi_bid(axil_ram_bid),
//    .s_axi_bresp(axil_ram_bresp),
//    .s_axi_bvalid(axil_ram_bvalid),
//    .s_axi_bready(axil_ram_bready),
//    .s_axi_arid(axil_ram_arid),
//    .s_axi_araddr(axil_ram_araddr),
//    .s_axi_arlen(axil_ram_arlen),
//    .s_axi_arsize(axil_ram_arsize),
//    .s_axi_arburst(axil_ram_arburst),
//    .s_axi_arlock(axil_ram_arlock),
//    .s_axi_arcache(axil_ram_arcache),
//    .s_axi_arprot(axil_ram_arprot),
//    .s_axi_arvalid(axil_ram_arvalid),
//    .s_axi_arready(axil_ram_arready),
//    .s_axi_rid(axil_ram_rid),
//    .s_axi_rdata(axil_ram_rdata),
//    .s_axi_rresp(axil_ram_rresp),
//    .s_axi_rlast(axil_ram_rlast),
//    .s_axi_rvalid(axil_ram_rvalid),
//    .s_axi_rready(axil_ram_rready)
//);
        
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
    .status_error_cor(status_error_cor_int[3]),
    .status_error_uncor(status_error_uncor_int[3])
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
