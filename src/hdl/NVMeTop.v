module AXI4LiteCSR(
  input         clock,
  input         reset,
  input  [14:0] io_ctl_aw_awaddr,
  input         io_ctl_aw_awvalid,
  output        io_ctl_aw_awready,
  input  [31:0] io_ctl_w_wdata,
  input         io_ctl_w_wvalid,
  output        io_ctl_w_wready,
  output        io_ctl_b_bvalid,
  input         io_ctl_b_bready,
  input  [14:0] io_ctl_ar_araddr,
  input         io_ctl_ar_arvalid,
  output        io_ctl_ar_arready,
  output [31:0] io_ctl_r_rdata,
  output        io_ctl_r_rvalid,
  input         io_ctl_r_rready,
  input         io_bus_ready,
  output [12:0] io_bus_addr,
  output        io_bus_reg_write,
  output [31:0] io_bus_reg_dataOut,
  output        io_bus_reg_read,
  input  [31:0] io_bus_reg_dataIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
`endif // RANDOMIZE_REG_INIT
  reg [2:0] state; // @[AXI4LiteCSR.scala 24:22]
  reg  awready; // @[AXI4LiteCSR.scala 26:24]
  reg  wready; // @[AXI4LiteCSR.scala 27:23]
  reg  bvalid; // @[AXI4LiteCSR.scala 28:23]
  reg  arready; // @[AXI4LiteCSR.scala 31:24]
  reg  rvalid; // @[AXI4LiteCSR.scala 32:23]
  reg [14:0] addr; // @[AXI4LiteCSR.scala 35:21]
  wire  _T_4 = 3'h0 == state; // @[Conditional.scala 37:30]
  wire  _GEN_2 = io_ctl_ar_arvalid | arready; // @[AXI4LiteCSR.scala 60:36 AXI4LiteCSR.scala 63:17 AXI4LiteCSR.scala 31:24]
  wire  _GEN_5 = io_ctl_aw_awvalid | awready; // @[AXI4LiteCSR.scala 55:30 AXI4LiteCSR.scala 58:17 AXI4LiteCSR.scala 26:24]
  wire  _T_7 = 3'h1 == state; // @[Conditional.scala 37:30]
  wire  _GEN_9 = io_ctl_ar_arvalid & arready | rvalid; // @[AXI4LiteCSR.scala 67:41 AXI4LiteCSR.scala 70:16 AXI4LiteCSR.scala 32:23]
  wire  _T_9 = 3'h2 == state; // @[Conditional.scala 37:30]
  wire [2:0] _GEN_10 = io_ctl_r_rready & io_ctl_r_rvalid ? 3'h0 : state; // @[AXI4LiteCSR.scala 74:47 AXI4LiteCSR.scala 75:15 AXI4LiteCSR.scala 24:22]
  wire  _GEN_11 = io_ctl_r_rready & io_ctl_r_rvalid ? 1'h0 : rvalid; // @[AXI4LiteCSR.scala 74:47 AXI4LiteCSR.scala 76:16 AXI4LiteCSR.scala 32:23]
  wire  _T_11 = 3'h3 == state; // @[Conditional.scala 37:30]
  wire [2:0] _GEN_12 = io_ctl_aw_awvalid & awready ? 3'h4 : state; // @[AXI4LiteCSR.scala 80:41 AXI4LiteCSR.scala 81:15 AXI4LiteCSR.scala 24:22]
  wire  _GEN_13 = io_ctl_aw_awvalid & awready ? 1'h0 : awready; // @[AXI4LiteCSR.scala 80:41 AXI4LiteCSR.scala 82:17 AXI4LiteCSR.scala 26:24]
  wire  _GEN_14 = io_ctl_aw_awvalid & awready | wready; // @[AXI4LiteCSR.scala 80:41 AXI4LiteCSR.scala 83:16 AXI4LiteCSR.scala 27:23]
  wire  _T_13 = 3'h4 == state; // @[Conditional.scala 37:30]
  wire [2:0] _GEN_15 = io_ctl_w_wvalid & io_ctl_w_wready ? 3'h5 : state; // @[AXI4LiteCSR.scala 87:47 AXI4LiteCSR.scala 88:15 AXI4LiteCSR.scala 24:22]
  wire  _GEN_16 = io_ctl_w_wvalid & io_ctl_w_wready ? 1'h0 : wready; // @[AXI4LiteCSR.scala 87:47 AXI4LiteCSR.scala 89:16 AXI4LiteCSR.scala 27:23]
  wire  _GEN_17 = io_ctl_w_wvalid & io_ctl_w_wready | bvalid; // @[AXI4LiteCSR.scala 87:47 AXI4LiteCSR.scala 90:16 AXI4LiteCSR.scala 28:23]
  wire  _T_15 = 3'h5 == state; // @[Conditional.scala 37:30]
  wire [2:0] _GEN_18 = io_ctl_b_bready & bvalid ? 3'h0 : state; // @[AXI4LiteCSR.scala 94:38 AXI4LiteCSR.scala 95:15 AXI4LiteCSR.scala 24:22]
  wire  _GEN_19 = io_ctl_b_bready & bvalid ? 1'h0 : bvalid; // @[AXI4LiteCSR.scala 94:38 AXI4LiteCSR.scala 96:16 AXI4LiteCSR.scala 28:23]
  wire [2:0] _GEN_20 = _T_15 ? _GEN_18 : state; // @[Conditional.scala 39:67 AXI4LiteCSR.scala 24:22]
  wire  _GEN_21 = _T_15 ? _GEN_19 : bvalid; // @[Conditional.scala 39:67 AXI4LiteCSR.scala 28:23]
  wire [2:0] _GEN_22 = _T_13 ? _GEN_15 : _GEN_20; // @[Conditional.scala 39:67]
  wire  _GEN_23 = _T_13 ? _GEN_16 : wready; // @[Conditional.scala 39:67 AXI4LiteCSR.scala 27:23]
  wire  _GEN_24 = _T_13 ? _GEN_17 : _GEN_21; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_25 = _T_11 ? _GEN_12 : _GEN_22; // @[Conditional.scala 39:67]
  wire  _GEN_26 = _T_11 ? _GEN_13 : awready; // @[Conditional.scala 39:67 AXI4LiteCSR.scala 26:24]
  wire  _GEN_27 = _T_11 ? _GEN_14 : _GEN_23; // @[Conditional.scala 39:67]
  wire  _GEN_28 = _T_11 ? bvalid : _GEN_24; // @[Conditional.scala 39:67 AXI4LiteCSR.scala 28:23]
  assign io_ctl_aw_awready = awready; // @[AXI4LiteCSR.scala 40:21]
  assign io_ctl_w_wready = wready & io_bus_ready; // @[AXI4LiteCSR.scala 41:29]
  assign io_ctl_b_bvalid = bvalid; // @[AXI4LiteCSR.scala 42:19]
  assign io_ctl_ar_arready = arready; // @[AXI4LiteCSR.scala 45:21]
  assign io_ctl_r_rdata = io_bus_reg_dataIn; // @[AXI4LiteCSR.scala 37:18]
  assign io_ctl_r_rvalid = rvalid & io_bus_ready; // @[AXI4LiteCSR.scala 46:29]
  assign io_bus_addr = addr[12:0]; // @[AXI4LiteCSR.scala 51:15]
  assign io_bus_reg_write = io_ctl_w_wvalid & wready; // @[AXI4LiteCSR.scala 50:39]
  assign io_bus_reg_dataOut = io_ctl_w_wdata; // @[AXI4LiteCSR.scala 38:22]
  assign io_bus_reg_read = io_ctl_r_rready & rvalid; // @[AXI4LiteCSR.scala 49:38]
  always @(posedge clock) begin
    if (reset) begin // @[AXI4LiteCSR.scala 24:22]
      state <= 3'h0; // @[AXI4LiteCSR.scala 24:22]
    end else if (_T_4) begin // @[Conditional.scala 40:58]
      if (io_ctl_aw_awvalid) begin // @[AXI4LiteCSR.scala 55:30]
        state <= 3'h3; // @[AXI4LiteCSR.scala 56:15]
      end else if (io_ctl_ar_arvalid) begin // @[AXI4LiteCSR.scala 60:36]
        state <= 3'h1; // @[AXI4LiteCSR.scala 61:15]
      end
    end else if (_T_7) begin // @[Conditional.scala 39:67]
      if (io_ctl_ar_arvalid & arready) begin // @[AXI4LiteCSR.scala 67:41]
        state <= 3'h2; // @[AXI4LiteCSR.scala 68:15]
      end
    end else if (_T_9) begin // @[Conditional.scala 39:67]
      state <= _GEN_10;
    end else begin
      state <= _GEN_25;
    end
    if (reset) begin // @[AXI4LiteCSR.scala 26:24]
      awready <= 1'h0; // @[AXI4LiteCSR.scala 26:24]
    end else if (_T_4) begin // @[Conditional.scala 40:58]
      awready <= _GEN_5;
    end else if (!(_T_7)) begin // @[Conditional.scala 39:67]
      if (!(_T_9)) begin // @[Conditional.scala 39:67]
        awready <= _GEN_26;
      end
    end
    if (reset) begin // @[AXI4LiteCSR.scala 27:23]
      wready <= 1'h0; // @[AXI4LiteCSR.scala 27:23]
    end else if (!(_T_4)) begin // @[Conditional.scala 40:58]
      if (!(_T_7)) begin // @[Conditional.scala 39:67]
        if (!(_T_9)) begin // @[Conditional.scala 39:67]
          wready <= _GEN_27;
        end
      end
    end
    if (reset) begin // @[AXI4LiteCSR.scala 28:23]
      bvalid <= 1'h0; // @[AXI4LiteCSR.scala 28:23]
    end else if (!(_T_4)) begin // @[Conditional.scala 40:58]
      if (!(_T_7)) begin // @[Conditional.scala 39:67]
        if (!(_T_9)) begin // @[Conditional.scala 39:67]
          bvalid <= _GEN_28;
        end
      end
    end
    if (reset) begin // @[AXI4LiteCSR.scala 31:24]
      arready <= 1'h0; // @[AXI4LiteCSR.scala 31:24]
    end else if (_T_4) begin // @[Conditional.scala 40:58]
      if (!(io_ctl_aw_awvalid)) begin // @[AXI4LiteCSR.scala 55:30]
        arready <= _GEN_2;
      end
    end else if (_T_7) begin // @[Conditional.scala 39:67]
      if (io_ctl_ar_arvalid & arready) begin // @[AXI4LiteCSR.scala 67:41]
        arready <= 1'h0; // @[AXI4LiteCSR.scala 69:17]
      end
    end
    if (reset) begin // @[AXI4LiteCSR.scala 32:23]
      rvalid <= 1'h0; // @[AXI4LiteCSR.scala 32:23]
    end else if (!(_T_4)) begin // @[Conditional.scala 40:58]
      if (_T_7) begin // @[Conditional.scala 39:67]
        rvalid <= _GEN_9;
      end else if (_T_9) begin // @[Conditional.scala 39:67]
        rvalid <= _GEN_11;
      end
    end
    if (reset) begin // @[AXI4LiteCSR.scala 35:21]
      addr <= 15'h0; // @[AXI4LiteCSR.scala 35:21]
    end else if (_T_4) begin // @[Conditional.scala 40:58]
      if (io_ctl_aw_awvalid) begin // @[AXI4LiteCSR.scala 55:30]
        addr <= {{2'd0}, io_ctl_aw_awaddr[14:2]}; // @[AXI4LiteCSR.scala 57:14]
      end else if (io_ctl_ar_arvalid) begin // @[AXI4LiteCSR.scala 60:36]
        addr <= {{2'd0}, io_ctl_ar_araddr[14:2]}; // @[AXI4LiteCSR.scala 62:14]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  state = _RAND_0[2:0];
  _RAND_1 = {1{`RANDOM}};
  awready = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  wready = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  bvalid = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  arready = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  rvalid = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  addr = _RAND_6[14:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module RegBusArbiter(
  output        io_inBusA_ready,
  input  [12:0] io_inBusA_addr,
  input         io_inBusA_reg_write,
  input  [31:0] io_inBusA_reg_dataOut,
  input         io_inBusA_reg_read,
  output [31:0] io_inBusA_reg_dataIn,
  output        io_inBusB_ready,
  input  [12:0] io_inBusB_addr,
  input         io_inBusB_reg_write,
  input  [31:0] io_inBusB_reg_dataOut,
  input         io_inBusB_reg_read,
  output [31:0] io_inBusB_reg_dataIn,
  output [12:0] io_outBus_addr,
  output        io_outBus_reg_write,
  output [31:0] io_outBus_reg_dataOut,
  output        io_outBus_reg_read,
  input  [31:0] io_outBus_reg_dataIn
);
  wire  validA = io_inBusA_reg_read | io_inBusA_reg_write; // @[CSRArbiter.scala 18:44]
  wire  validB = io_inBusB_reg_read | io_inBusB_reg_write; // @[CSRArbiter.scala 19:44]
  wire [31:0] _GEN_0 = validB ? io_outBus_reg_dataIn : 32'h0; // @[CSRArbiter.scala 34:21 CSRArbiter.scala 35:15 CSRArbiter.scala 30:24]
  wire  _GEN_1 = validB & io_inBusB_reg_read; // @[CSRArbiter.scala 34:21 CSRArbiter.scala 35:15 CSRArbiter.scala 22:22]
  wire [31:0] _GEN_2 = validB ? io_inBusB_reg_dataOut : 32'h0; // @[CSRArbiter.scala 34:21 CSRArbiter.scala 35:15 CSRArbiter.scala 24:25]
  wire  _GEN_3 = validB & io_inBusB_reg_write; // @[CSRArbiter.scala 34:21 CSRArbiter.scala 35:15 CSRArbiter.scala 23:23]
  wire [12:0] _GEN_4 = validB ? io_inBusB_addr : 13'h0; // @[CSRArbiter.scala 34:21 CSRArbiter.scala 35:15 CSRArbiter.scala 21:18]
  assign io_inBusA_ready = io_inBusA_reg_read | io_inBusA_reg_write; // @[CSRArbiter.scala 18:44]
  assign io_inBusA_reg_dataIn = validA ? io_outBus_reg_dataIn : 32'h0; // @[CSRArbiter.scala 32:16 CSRArbiter.scala 33:15 CSRArbiter.scala 27:24]
  assign io_inBusB_ready = validA ? 1'h0 : validB; // @[CSRArbiter.scala 32:16 CSRArbiter.scala 29:19]
  assign io_inBusB_reg_dataIn = validA ? 32'h0 : _GEN_0; // @[CSRArbiter.scala 32:16 CSRArbiter.scala 30:24]
  assign io_outBus_addr = validA ? io_inBusA_addr : _GEN_4; // @[CSRArbiter.scala 32:16 CSRArbiter.scala 33:15]
  assign io_outBus_reg_write = validA ? io_inBusA_reg_write : _GEN_3; // @[CSRArbiter.scala 32:16 CSRArbiter.scala 33:15]
  assign io_outBus_reg_dataOut = validA ? io_inBusA_reg_dataOut : _GEN_2; // @[CSRArbiter.scala 32:16 CSRArbiter.scala 33:15]
  assign io_outBus_reg_read = validA ? io_inBusA_reg_read : _GEN_1; // @[CSRArbiter.scala 32:16 CSRArbiter.scala 33:15]
endmodule
module Queue(
  input         clock,
  input         reset,
  output        io_enq_ready,
  input         io_enq_valid,
  input  [31:0] io_enq_bits,
  input         io_deq_ready,
  output        io_deq_valid,
  output [31:0] io_deq_bits
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] ram [0:127]; // @[Decoupled.scala 218:16]
  wire [31:0] ram_io_deq_bits_MPORT_data; // @[Decoupled.scala 218:16]
  wire [6:0] ram_io_deq_bits_MPORT_addr; // @[Decoupled.scala 218:16]
  wire [31:0] ram_MPORT_data; // @[Decoupled.scala 218:16]
  wire [6:0] ram_MPORT_addr; // @[Decoupled.scala 218:16]
  wire  ram_MPORT_mask; // @[Decoupled.scala 218:16]
  wire  ram_MPORT_en; // @[Decoupled.scala 218:16]
  reg [6:0] enq_ptr_value; // @[Counter.scala 60:40]
  reg [6:0] deq_ptr_value; // @[Counter.scala 60:40]
  reg  maybe_full; // @[Decoupled.scala 221:27]
  wire  ptr_match = enq_ptr_value == deq_ptr_value; // @[Decoupled.scala 223:33]
  wire  empty = ptr_match & ~maybe_full; // @[Decoupled.scala 224:25]
  wire  full = ptr_match & maybe_full; // @[Decoupled.scala 225:24]
  wire  do_enq = io_enq_ready & io_enq_valid; // @[Decoupled.scala 40:37]
  wire  do_deq = io_deq_ready & io_deq_valid; // @[Decoupled.scala 40:37]
  wire [6:0] _value_T_1 = enq_ptr_value + 7'h1; // @[Counter.scala 76:24]
  wire [6:0] _value_T_3 = deq_ptr_value + 7'h1; // @[Counter.scala 76:24]
  assign ram_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_io_deq_bits_MPORT_data = ram[ram_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 218:16]
  assign ram_MPORT_data = io_enq_bits;
  assign ram_MPORT_addr = enq_ptr_value;
  assign ram_MPORT_mask = 1'h1;
  assign ram_MPORT_en = io_enq_ready & io_enq_valid;
  assign io_enq_ready = ~full; // @[Decoupled.scala 241:19]
  assign io_deq_valid = ~empty; // @[Decoupled.scala 240:19]
  assign io_deq_bits = ram_io_deq_bits_MPORT_data; // @[Decoupled.scala 242:15]
  always @(posedge clock) begin
    if(ram_MPORT_en & ram_MPORT_mask) begin
      ram[ram_MPORT_addr] <= ram_MPORT_data; // @[Decoupled.scala 218:16]
    end
    if (reset) begin // @[Counter.scala 60:40]
      enq_ptr_value <= 7'h0; // @[Counter.scala 60:40]
    end else if (do_enq) begin // @[Decoupled.scala 229:17]
      enq_ptr_value <= _value_T_1; // @[Counter.scala 76:15]
    end
    if (reset) begin // @[Counter.scala 60:40]
      deq_ptr_value <= 7'h0; // @[Counter.scala 60:40]
    end else if (do_deq) begin // @[Decoupled.scala 233:17]
      deq_ptr_value <= _value_T_3; // @[Counter.scala 76:15]
    end
    if (reset) begin // @[Decoupled.scala 221:27]
      maybe_full <= 1'h0; // @[Decoupled.scala 221:27]
    end else if (do_enq != do_deq) begin // @[Decoupled.scala 236:28]
      maybe_full <= do_enq; // @[Decoupled.scala 237:16]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    ram[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  enq_ptr_value = _RAND_1[6:0];
  _RAND_2 = {1{`RANDOM}};
  deq_ptr_value = _RAND_2[6:0];
  _RAND_3 = {1{`RANDOM}};
  maybe_full = _RAND_3[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module CSRInterrupt(
  input         clock,
  input         reset,
  output        io_irqReq,
  input         io_csrBus_ready,
  input  [12:0] io_csrBus_addr,
  input         io_csrBus_reg_write,
  input         io_csrLog_ready,
  output        io_csrLog_valid,
  output [31:0] io_csrLog_bits
);
  wire  queue_clock; // @[CSRInterrupt.scala 19:27]
  wire  queue_reset; // @[CSRInterrupt.scala 19:27]
  wire  queue_io_enq_ready; // @[CSRInterrupt.scala 19:27]
  wire  queue_io_enq_valid; // @[CSRInterrupt.scala 19:27]
  wire [31:0] queue_io_enq_bits; // @[CSRInterrupt.scala 19:27]
  wire  queue_io_deq_ready; // @[CSRInterrupt.scala 19:27]
  wire  queue_io_deq_valid; // @[CSRInterrupt.scala 19:27]
  wire [31:0] queue_io_deq_bits; // @[CSRInterrupt.scala 19:27]
  Queue queue ( // @[CSRInterrupt.scala 19:27]
    .clock(queue_clock),
    .reset(queue_reset),
    .io_enq_ready(queue_io_enq_ready),
    .io_enq_valid(queue_io_enq_valid),
    .io_enq_bits(queue_io_enq_bits),
    .io_deq_ready(queue_io_deq_ready),
    .io_deq_valid(queue_io_deq_valid),
    .io_deq_bits(queue_io_deq_bits)
  );
  assign io_irqReq = queue_io_deq_valid; // @[CSRInterrupt.scala 26:19]
  assign io_csrLog_valid = queue_io_deq_valid; // @[CSRInterrupt.scala 24:19]
  assign io_csrLog_bits = queue_io_deq_bits; // @[CSRInterrupt.scala 24:19]
  assign queue_clock = clock;
  assign queue_reset = reset;
  assign queue_io_enq_valid = io_csrBus_reg_write & io_csrBus_ready; // @[CSRInterrupt.scala 21:51]
  assign queue_io_enq_bits = {{19'd0}, io_csrBus_addr}; // @[CSRInterrupt.scala 22:27]
  assign queue_io_deq_ready = io_csrLog_ready; // @[CSRInterrupt.scala 24:19]
endmodule
module StorageRegister(
  input         clock,
  input         reset,
  input         io_write,
  input  [31:0] io_dataOut,
  output [31:0] io_dataIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] storage; // @[CSR.scala 48:26]
  assign io_dataIn = storage; // @[CSR.scala 56:15]
  always @(posedge clock) begin
    if (reset) begin // @[CSR.scala 48:26]
      storage <= 32'h0; // @[CSR.scala 48:26]
    end else if (io_write) begin // @[CSR.scala 52:20]
      storage <= io_dataOut; // @[CSR.scala 53:17]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  storage = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StorageRegister_2(
  input         clock,
  input         reset,
  input         io_write,
  input  [31:0] io_dataOut,
  output [31:0] io_dataIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] storage; // @[CSR.scala 48:26]
  assign io_dataIn = storage; // @[CSR.scala 56:15]
  always @(posedge clock) begin
    if (reset) begin // @[CSR.scala 48:26]
      storage <= 32'h0; // @[CSR.scala 48:26]
    end else if (io_write) begin // @[CSR.scala 52:20]
      storage <= io_dataOut; // @[CSR.scala 53:17]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  storage = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StorageRegister_3(
  input         clock,
  input         reset,
  input         io_write,
  input  [31:0] io_dataOut,
  output [31:0] io_dataIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] storage; // @[CSR.scala 48:26]
  assign io_dataIn = storage; // @[CSR.scala 56:15]
  always @(posedge clock) begin
    if (reset) begin // @[CSR.scala 48:26]
      storage <= 32'h0; // @[CSR.scala 48:26]
    end else if (io_write) begin // @[CSR.scala 52:20]
      storage <= io_dataOut; // @[CSR.scala 53:17]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  storage = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StorageRegister_5(
  input         clock,
  input         reset,
  input         io_write,
  input  [31:0] io_dataOut,
  output [31:0] io_dataIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] storage; // @[CSR.scala 48:26]
  assign io_dataIn = storage; // @[CSR.scala 56:15]
  always @(posedge clock) begin
    if (reset) begin // @[CSR.scala 48:26]
      storage <= 32'h0; // @[CSR.scala 48:26]
    end else if (io_write) begin // @[CSR.scala 52:20]
      storage <= io_dataOut; // @[CSR.scala 53:17]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  storage = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StorageRegister_6(
  input         clock,
  input         reset,
  input         io_write,
  input  [31:0] io_dataOut,
  output [31:0] io_dataIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] storage; // @[CSR.scala 48:26]
  assign io_dataIn = storage; // @[CSR.scala 56:15]
  always @(posedge clock) begin
    if (reset) begin // @[CSR.scala 48:26]
      storage <= 32'h0; // @[CSR.scala 48:26]
    end else if (io_write) begin // @[CSR.scala 52:20]
      storage <= io_dataOut; // @[CSR.scala 53:17]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  storage = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StorageRegister_10(
  input         clock,
  input         reset,
  input         io_write,
  input  [31:0] io_dataOut,
  output [31:0] io_dataIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] storage; // @[CSR.scala 48:26]
  assign io_dataIn = storage; // @[CSR.scala 56:15]
  always @(posedge clock) begin
    if (reset) begin // @[CSR.scala 48:26]
      storage <= 32'h0; // @[CSR.scala 48:26]
    end else if (io_write) begin // @[CSR.scala 52:20]
      storage <= io_dataOut; // @[CSR.scala 53:17]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  storage = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StorageRegister_11(
  input         clock,
  input         reset,
  input         io_write,
  input  [31:0] io_dataOut,
  output [31:0] io_dataIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] storage; // @[CSR.scala 48:26]
  assign io_dataIn = storage; // @[CSR.scala 56:15]
  always @(posedge clock) begin
    if (reset) begin // @[CSR.scala 48:26]
      storage <= 32'h0; // @[CSR.scala 48:26]
    end else if (io_write) begin // @[CSR.scala 52:20]
      storage <= io_dataOut; // @[CSR.scala 53:17]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  storage = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StorageRegister_12(
  input         clock,
  input         reset,
  input         io_write,
  input  [31:0] io_dataOut,
  output [31:0] io_dataIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] storage; // @[CSR.scala 48:26]
  assign io_dataIn = storage; // @[CSR.scala 56:15]
  always @(posedge clock) begin
    if (reset) begin // @[CSR.scala 48:26]
      storage <= 32'h0; // @[CSR.scala 48:26]
    end else if (io_write) begin // @[CSR.scala 52:20]
      storage <= io_dataOut; // @[CSR.scala 53:17]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  storage = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StorageRegister_13(
  input         clock,
  input         reset,
  input         io_write,
  input  [31:0] io_dataOut,
  output [31:0] io_dataIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] storage; // @[CSR.scala 48:26]
  assign io_dataIn = storage; // @[CSR.scala 56:15]
  always @(posedge clock) begin
    if (reset) begin // @[CSR.scala 48:26]
      storage <= 32'h0; // @[CSR.scala 48:26]
    end else if (io_write) begin // @[CSR.scala 52:20]
      storage <= io_dataOut; // @[CSR.scala 53:17]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  storage = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StorageRegister_16(
  input         clock,
  input         reset,
  input         io_write,
  input  [31:0] io_dataOut,
  output [31:0] io_dataIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] storage; // @[CSR.scala 48:26]
  assign io_dataIn = storage; // @[CSR.scala 56:15]
  always @(posedge clock) begin
    if (reset) begin // @[CSR.scala 48:26]
      storage <= 32'h0; // @[CSR.scala 48:26]
    end else if (io_write) begin // @[CSR.scala 52:20]
      storage <= io_dataOut; // @[CSR.scala 53:17]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  storage = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StorageRegister_18(
  input         clock,
  input         reset,
  input         io_write,
  input  [31:0] io_dataOut,
  output [31:0] io_dataIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] storage; // @[CSR.scala 48:26]
  assign io_dataIn = storage; // @[CSR.scala 56:15]
  always @(posedge clock) begin
    if (reset) begin // @[CSR.scala 48:26]
      storage <= 32'h0; // @[CSR.scala 48:26]
    end else if (io_write) begin // @[CSR.scala 52:20]
      storage <= io_dataOut; // @[CSR.scala 53:17]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  storage = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StorageRegister_19(
  input         clock,
  input         reset,
  input         io_write,
  input  [31:0] io_dataOut,
  output [31:0] io_dataIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] storage; // @[CSR.scala 48:26]
  assign io_dataIn = storage; // @[CSR.scala 56:15]
  always @(posedge clock) begin
    if (reset) begin // @[CSR.scala 48:26]
      storage <= 32'h0; // @[CSR.scala 48:26]
    end else if (io_write) begin // @[CSR.scala 52:20]
      storage <= io_dataOut; // @[CSR.scala 53:17]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  storage = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StorageRegister_21(
  input         clock,
  input         reset,
  input         io_write,
  input  [31:0] io_dataOut,
  output [31:0] io_dataIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] storage; // @[CSR.scala 48:26]
  assign io_dataIn = storage; // @[CSR.scala 56:15]
  always @(posedge clock) begin
    if (reset) begin // @[CSR.scala 48:26]
      storage <= 32'h0; // @[CSR.scala 48:26]
    end else if (io_write) begin // @[CSR.scala 52:20]
      storage <= io_dataOut; // @[CSR.scala 53:17]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  storage = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StorageRegister_22(
  input         clock,
  input         reset,
  input         io_write,
  input  [31:0] io_dataOut,
  output [31:0] io_dataIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] storage; // @[CSR.scala 48:26]
  assign io_dataIn = storage; // @[CSR.scala 56:15]
  always @(posedge clock) begin
    if (reset) begin // @[CSR.scala 48:26]
      storage <= 32'h0; // @[CSR.scala 48:26]
    end else if (io_write) begin // @[CSR.scala 52:20]
      storage <= io_dataOut; // @[CSR.scala 53:17]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  storage = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StorageRegister_23(
  input         clock,
  input         reset,
  input         io_write,
  input  [31:0] io_dataOut,
  output [31:0] io_dataIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] storage; // @[CSR.scala 48:26]
  assign io_dataIn = storage; // @[CSR.scala 56:15]
  always @(posedge clock) begin
    if (reset) begin // @[CSR.scala 48:26]
      storage <= 32'h0; // @[CSR.scala 48:26]
    end else if (io_write) begin // @[CSR.scala 52:20]
      storage <= io_dataOut; // @[CSR.scala 53:17]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  storage = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StorageRegister_26(
  input         clock,
  input         reset,
  input         io_write,
  input  [31:0] io_dataOut,
  output [31:0] io_dataIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] storage; // @[CSR.scala 48:26]
  assign io_dataIn = storage; // @[CSR.scala 56:15]
  always @(posedge clock) begin
    if (reset) begin // @[CSR.scala 48:26]
      storage <= 32'h0; // @[CSR.scala 48:26]
    end else if (io_write) begin // @[CSR.scala 52:20]
      storage <= io_dataOut; // @[CSR.scala 53:17]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  storage = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ReadOnlyRegister_3(
  output [31:0] io_dataIn,
  input         fields_VALID
);
  assign io_dataIn = {31'h0,fields_VALID}; // @[CSR.scala 62:25]
endmodule
module ReadOnlyRegister_4(
  output [31:0] io_dataIn,
  input  [31:0] fields_DATA
);
  assign io_dataIn = fields_DATA; // @[CSR.scala 62:15]
endmodule
module AutoClearingRegister(
  input         clock,
  input         reset,
  input         io_write,
  input  [31:0] io_dataOut,
  output [31:0] io_dataIn,
  output [31:0] fields_REQ
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] storage; // @[CSR.scala 48:26]
  assign io_dataIn = storage; // @[CSR.scala 56:15]
  assign fields_REQ = storage; // @[CSR.scala 50:31]
  always @(posedge clock) begin
    if (reset) begin // @[CSR.scala 48:26]
      storage <= 32'h0; // @[CSR.scala 48:26]
    end else if (io_write) begin // @[CSR.scala 67:20]
      storage <= io_dataOut; // @[CSR.scala 68:17]
    end else begin
      storage <= 32'h0; // @[CSR.scala 70:17]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  storage = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module CSRFile(
  input         clock,
  input         reset,
  output        io_bus_ready,
  input  [12:0] io_bus_addr,
  input         io_bus_reg_write,
  input  [31:0] io_bus_reg_dataOut,
  input         io_bus_reg_read,
  output [31:0] io_bus_reg_dataIn,
  output        io_csrLog_ready,
  input         io_csrLog_valid,
  input  [31:0] io_csrLog_bits,
  output [31:0] io_irqHost
);
  wire  StorageRegister_clock; // @[CSRRegMap.scala 11:31]
  wire  StorageRegister_reset; // @[CSRRegMap.scala 11:31]
  wire  StorageRegister_io_write; // @[CSRRegMap.scala 11:31]
  wire [31:0] StorageRegister_io_dataOut; // @[CSRRegMap.scala 11:31]
  wire [31:0] StorageRegister_io_dataIn; // @[CSRRegMap.scala 11:31]
  wire  StorageRegister_1_clock; // @[CSRRegMap.scala 12:32]
  wire  StorageRegister_1_reset; // @[CSRRegMap.scala 12:32]
  wire  StorageRegister_1_io_write; // @[CSRRegMap.scala 12:32]
  wire [31:0] StorageRegister_1_io_dataOut; // @[CSRRegMap.scala 12:32]
  wire [31:0] StorageRegister_1_io_dataIn; // @[CSRRegMap.scala 12:32]
  wire  StorageRegister_2_clock; // @[CSRRegMap.scala 13:32]
  wire  StorageRegister_2_reset; // @[CSRRegMap.scala 13:32]
  wire  StorageRegister_2_io_write; // @[CSRRegMap.scala 13:32]
  wire [31:0] StorageRegister_2_io_dataOut; // @[CSRRegMap.scala 13:32]
  wire [31:0] StorageRegister_2_io_dataIn; // @[CSRRegMap.scala 13:32]
  wire  StorageRegister_3_clock; // @[CSRRegMap.scala 14:32]
  wire  StorageRegister_3_reset; // @[CSRRegMap.scala 14:32]
  wire  StorageRegister_3_io_write; // @[CSRRegMap.scala 14:32]
  wire [31:0] StorageRegister_3_io_dataOut; // @[CSRRegMap.scala 14:32]
  wire [31:0] StorageRegister_3_io_dataIn; // @[CSRRegMap.scala 14:32]
  wire  StorageRegister_4_clock; // @[CSRRegMap.scala 15:32]
  wire  StorageRegister_4_reset; // @[CSRRegMap.scala 15:32]
  wire  StorageRegister_4_io_write; // @[CSRRegMap.scala 15:32]
  wire [31:0] StorageRegister_4_io_dataOut; // @[CSRRegMap.scala 15:32]
  wire [31:0] StorageRegister_4_io_dataIn; // @[CSRRegMap.scala 15:32]
  wire  StorageRegister_5_clock; // @[CSRRegMap.scala 16:32]
  wire  StorageRegister_5_reset; // @[CSRRegMap.scala 16:32]
  wire  StorageRegister_5_io_write; // @[CSRRegMap.scala 16:32]
  wire [31:0] StorageRegister_5_io_dataOut; // @[CSRRegMap.scala 16:32]
  wire [31:0] StorageRegister_5_io_dataIn; // @[CSRRegMap.scala 16:32]
  wire  StorageRegister_6_clock; // @[CSRRegMap.scala 17:32]
  wire  StorageRegister_6_reset; // @[CSRRegMap.scala 17:32]
  wire  StorageRegister_6_io_write; // @[CSRRegMap.scala 17:32]
  wire [31:0] StorageRegister_6_io_dataOut; // @[CSRRegMap.scala 17:32]
  wire [31:0] StorageRegister_6_io_dataIn; // @[CSRRegMap.scala 17:32]
  wire  StorageRegister_7_clock; // @[CSRRegMap.scala 18:32]
  wire  StorageRegister_7_reset; // @[CSRRegMap.scala 18:32]
  wire  StorageRegister_7_io_write; // @[CSRRegMap.scala 18:32]
  wire [31:0] StorageRegister_7_io_dataOut; // @[CSRRegMap.scala 18:32]
  wire [31:0] StorageRegister_7_io_dataIn; // @[CSRRegMap.scala 18:32]
  wire  StorageRegister_8_clock; // @[CSRRegMap.scala 19:32]
  wire  StorageRegister_8_reset; // @[CSRRegMap.scala 19:32]
  wire  StorageRegister_8_io_write; // @[CSRRegMap.scala 19:32]
  wire [31:0] StorageRegister_8_io_dataOut; // @[CSRRegMap.scala 19:32]
  wire [31:0] StorageRegister_8_io_dataIn; // @[CSRRegMap.scala 19:32]
  wire  StorageRegister_9_clock; // @[CSRRegMap.scala 20:32]
  wire  StorageRegister_9_reset; // @[CSRRegMap.scala 20:32]
  wire  StorageRegister_9_io_write; // @[CSRRegMap.scala 20:32]
  wire [31:0] StorageRegister_9_io_dataOut; // @[CSRRegMap.scala 20:32]
  wire [31:0] StorageRegister_9_io_dataIn; // @[CSRRegMap.scala 20:32]
  wire  StorageRegister_10_clock; // @[CSRRegMap.scala 21:32]
  wire  StorageRegister_10_reset; // @[CSRRegMap.scala 21:32]
  wire  StorageRegister_10_io_write; // @[CSRRegMap.scala 21:32]
  wire [31:0] StorageRegister_10_io_dataOut; // @[CSRRegMap.scala 21:32]
  wire [31:0] StorageRegister_10_io_dataIn; // @[CSRRegMap.scala 21:32]
  wire  StorageRegister_11_clock; // @[CSRRegMap.scala 22:32]
  wire  StorageRegister_11_reset; // @[CSRRegMap.scala 22:32]
  wire  StorageRegister_11_io_write; // @[CSRRegMap.scala 22:32]
  wire [31:0] StorageRegister_11_io_dataOut; // @[CSRRegMap.scala 22:32]
  wire [31:0] StorageRegister_11_io_dataIn; // @[CSRRegMap.scala 22:32]
  wire  StorageRegister_12_clock; // @[CSRRegMap.scala 23:32]
  wire  StorageRegister_12_reset; // @[CSRRegMap.scala 23:32]
  wire  StorageRegister_12_io_write; // @[CSRRegMap.scala 23:32]
  wire [31:0] StorageRegister_12_io_dataOut; // @[CSRRegMap.scala 23:32]
  wire [31:0] StorageRegister_12_io_dataIn; // @[CSRRegMap.scala 23:32]
  wire  StorageRegister_13_clock; // @[CSRRegMap.scala 24:32]
  wire  StorageRegister_13_reset; // @[CSRRegMap.scala 24:32]
  wire  StorageRegister_13_io_write; // @[CSRRegMap.scala 24:32]
  wire [31:0] StorageRegister_13_io_dataOut; // @[CSRRegMap.scala 24:32]
  wire [31:0] StorageRegister_13_io_dataIn; // @[CSRRegMap.scala 24:32]
  wire  StorageRegister_14_clock; // @[CSRRegMap.scala 25:32]
  wire  StorageRegister_14_reset; // @[CSRRegMap.scala 25:32]
  wire  StorageRegister_14_io_write; // @[CSRRegMap.scala 25:32]
  wire [31:0] StorageRegister_14_io_dataOut; // @[CSRRegMap.scala 25:32]
  wire [31:0] StorageRegister_14_io_dataIn; // @[CSRRegMap.scala 25:32]
  wire  StorageRegister_15_clock; // @[CSRRegMap.scala 26:32]
  wire  StorageRegister_15_reset; // @[CSRRegMap.scala 26:32]
  wire  StorageRegister_15_io_write; // @[CSRRegMap.scala 26:32]
  wire [31:0] StorageRegister_15_io_dataOut; // @[CSRRegMap.scala 26:32]
  wire [31:0] StorageRegister_15_io_dataIn; // @[CSRRegMap.scala 26:32]
  wire  StorageRegister_16_clock; // @[CSRRegMap.scala 27:32]
  wire  StorageRegister_16_reset; // @[CSRRegMap.scala 27:32]
  wire  StorageRegister_16_io_write; // @[CSRRegMap.scala 27:32]
  wire [31:0] StorageRegister_16_io_dataOut; // @[CSRRegMap.scala 27:32]
  wire [31:0] StorageRegister_16_io_dataIn; // @[CSRRegMap.scala 27:32]
  wire  StorageRegister_17_clock; // @[CSRRegMap.scala 28:32]
  wire  StorageRegister_17_reset; // @[CSRRegMap.scala 28:32]
  wire  StorageRegister_17_io_write; // @[CSRRegMap.scala 28:32]
  wire [31:0] StorageRegister_17_io_dataOut; // @[CSRRegMap.scala 28:32]
  wire [31:0] StorageRegister_17_io_dataIn; // @[CSRRegMap.scala 28:32]
  wire  StorageRegister_18_clock; // @[CSRRegMap.scala 29:32]
  wire  StorageRegister_18_reset; // @[CSRRegMap.scala 29:32]
  wire  StorageRegister_18_io_write; // @[CSRRegMap.scala 29:32]
  wire [31:0] StorageRegister_18_io_dataOut; // @[CSRRegMap.scala 29:32]
  wire [31:0] StorageRegister_18_io_dataIn; // @[CSRRegMap.scala 29:32]
  wire  StorageRegister_19_clock; // @[CSRRegMap.scala 30:33]
  wire  StorageRegister_19_reset; // @[CSRRegMap.scala 30:33]
  wire  StorageRegister_19_io_write; // @[CSRRegMap.scala 30:33]
  wire [31:0] StorageRegister_19_io_dataOut; // @[CSRRegMap.scala 30:33]
  wire [31:0] StorageRegister_19_io_dataIn; // @[CSRRegMap.scala 30:33]
  wire  StorageRegister_20_clock; // @[CSRRegMap.scala 31:33]
  wire  StorageRegister_20_reset; // @[CSRRegMap.scala 31:33]
  wire  StorageRegister_20_io_write; // @[CSRRegMap.scala 31:33]
  wire [31:0] StorageRegister_20_io_dataOut; // @[CSRRegMap.scala 31:33]
  wire [31:0] StorageRegister_20_io_dataIn; // @[CSRRegMap.scala 31:33]
  wire  StorageRegister_21_clock; // @[CSRRegMap.scala 32:33]
  wire  StorageRegister_21_reset; // @[CSRRegMap.scala 32:33]
  wire  StorageRegister_21_io_write; // @[CSRRegMap.scala 32:33]
  wire [31:0] StorageRegister_21_io_dataOut; // @[CSRRegMap.scala 32:33]
  wire [31:0] StorageRegister_21_io_dataIn; // @[CSRRegMap.scala 32:33]
  wire  StorageRegister_22_clock; // @[CSRRegMap.scala 33:33]
  wire  StorageRegister_22_reset; // @[CSRRegMap.scala 33:33]
  wire  StorageRegister_22_io_write; // @[CSRRegMap.scala 33:33]
  wire [31:0] StorageRegister_22_io_dataOut; // @[CSRRegMap.scala 33:33]
  wire [31:0] StorageRegister_22_io_dataIn; // @[CSRRegMap.scala 33:33]
  wire  StorageRegister_23_clock; // @[CSRRegMap.scala 34:33]
  wire  StorageRegister_23_reset; // @[CSRRegMap.scala 34:33]
  wire  StorageRegister_23_io_write; // @[CSRRegMap.scala 34:33]
  wire [31:0] StorageRegister_23_io_dataOut; // @[CSRRegMap.scala 34:33]
  wire [31:0] StorageRegister_23_io_dataIn; // @[CSRRegMap.scala 34:33]
  wire  StorageRegister_24_clock; // @[CSRRegMap.scala 35:33]
  wire  StorageRegister_24_reset; // @[CSRRegMap.scala 35:33]
  wire  StorageRegister_24_io_write; // @[CSRRegMap.scala 35:33]
  wire [31:0] StorageRegister_24_io_dataOut; // @[CSRRegMap.scala 35:33]
  wire [31:0] StorageRegister_24_io_dataIn; // @[CSRRegMap.scala 35:33]
  wire  StorageRegister_25_clock; // @[CSRRegMap.scala 36:33]
  wire  StorageRegister_25_reset; // @[CSRRegMap.scala 36:33]
  wire  StorageRegister_25_io_write; // @[CSRRegMap.scala 36:33]
  wire [31:0] StorageRegister_25_io_dataOut; // @[CSRRegMap.scala 36:33]
  wire [31:0] StorageRegister_25_io_dataIn; // @[CSRRegMap.scala 36:33]
  wire  StorageRegister_26_clock; // @[CSRFile.scala 33:26]
  wire  StorageRegister_26_reset; // @[CSRFile.scala 33:26]
  wire  StorageRegister_26_io_write; // @[CSRFile.scala 33:26]
  wire [31:0] StorageRegister_26_io_dataOut; // @[CSRFile.scala 33:26]
  wire [31:0] StorageRegister_26_io_dataIn; // @[CSRFile.scala 33:26]
  wire  StorageRegister_27_clock; // @[CSRFile.scala 34:30]
  wire  StorageRegister_27_reset; // @[CSRFile.scala 34:30]
  wire  StorageRegister_27_io_write; // @[CSRFile.scala 34:30]
  wire [31:0] StorageRegister_27_io_dataOut; // @[CSRFile.scala 34:30]
  wire [31:0] StorageRegister_27_io_dataIn; // @[CSRFile.scala 34:30]
  wire  StorageRegister_28_clock; // @[CSRFile.scala 33:26]
  wire  StorageRegister_28_reset; // @[CSRFile.scala 33:26]
  wire  StorageRegister_28_io_write; // @[CSRFile.scala 33:26]
  wire [31:0] StorageRegister_28_io_dataOut; // @[CSRFile.scala 33:26]
  wire [31:0] StorageRegister_28_io_dataIn; // @[CSRFile.scala 33:26]
  wire  StorageRegister_29_clock; // @[CSRFile.scala 34:30]
  wire  StorageRegister_29_reset; // @[CSRFile.scala 34:30]
  wire  StorageRegister_29_io_write; // @[CSRFile.scala 34:30]
  wire [31:0] StorageRegister_29_io_dataOut; // @[CSRFile.scala 34:30]
  wire [31:0] StorageRegister_29_io_dataIn; // @[CSRFile.scala 34:30]
  wire  StorageRegister_30_clock; // @[CSRFile.scala 33:26]
  wire  StorageRegister_30_reset; // @[CSRFile.scala 33:26]
  wire  StorageRegister_30_io_write; // @[CSRFile.scala 33:26]
  wire [31:0] StorageRegister_30_io_dataOut; // @[CSRFile.scala 33:26]
  wire [31:0] StorageRegister_30_io_dataIn; // @[CSRFile.scala 33:26]
  wire  StorageRegister_31_clock; // @[CSRFile.scala 34:30]
  wire  StorageRegister_31_reset; // @[CSRFile.scala 34:30]
  wire  StorageRegister_31_io_write; // @[CSRFile.scala 34:30]
  wire [31:0] StorageRegister_31_io_dataOut; // @[CSRFile.scala 34:30]
  wire [31:0] StorageRegister_31_io_dataIn; // @[CSRFile.scala 34:30]
  wire  StorageRegister_32_clock; // @[CSRFile.scala 33:26]
  wire  StorageRegister_32_reset; // @[CSRFile.scala 33:26]
  wire  StorageRegister_32_io_write; // @[CSRFile.scala 33:26]
  wire [31:0] StorageRegister_32_io_dataOut; // @[CSRFile.scala 33:26]
  wire [31:0] StorageRegister_32_io_dataIn; // @[CSRFile.scala 33:26]
  wire  StorageRegister_33_clock; // @[CSRFile.scala 34:30]
  wire  StorageRegister_33_reset; // @[CSRFile.scala 34:30]
  wire  StorageRegister_33_io_write; // @[CSRFile.scala 34:30]
  wire [31:0] StorageRegister_33_io_dataOut; // @[CSRFile.scala 34:30]
  wire [31:0] StorageRegister_33_io_dataIn; // @[CSRFile.scala 34:30]
  wire  StorageRegister_34_clock; // @[CSRFile.scala 33:26]
  wire  StorageRegister_34_reset; // @[CSRFile.scala 33:26]
  wire  StorageRegister_34_io_write; // @[CSRFile.scala 33:26]
  wire [31:0] StorageRegister_34_io_dataOut; // @[CSRFile.scala 33:26]
  wire [31:0] StorageRegister_34_io_dataIn; // @[CSRFile.scala 33:26]
  wire  StorageRegister_35_clock; // @[CSRFile.scala 34:30]
  wire  StorageRegister_35_reset; // @[CSRFile.scala 34:30]
  wire  StorageRegister_35_io_write; // @[CSRFile.scala 34:30]
  wire [31:0] StorageRegister_35_io_dataOut; // @[CSRFile.scala 34:30]
  wire [31:0] StorageRegister_35_io_dataIn; // @[CSRFile.scala 34:30]
  wire [31:0] irqSta_io_dataIn; // @[CSRFile.scala 41:22]
  wire  irqSta_fields_VALID; // @[CSRFile.scala 41:22]
  wire [31:0] irqDat_io_dataIn; // @[CSRFile.scala 50:22]
  wire [31:0] irqDat_fields_DATA; // @[CSRFile.scala 50:22]
  wire  irqHost_clock; // @[CSRFile.scala 59:23]
  wire  irqHost_reset; // @[CSRFile.scala 59:23]
  wire  irqHost_io_write; // @[CSRFile.scala 59:23]
  wire [31:0] irqHost_io_dataOut; // @[CSRFile.scala 59:23]
  wire [31:0] irqHost_io_dataIn; // @[CSRFile.scala 59:23]
  wire [31:0] irqHost_fields_REQ; // @[CSRFile.scala 59:23]
  wire  _T = io_bus_addr == 13'h40b; // @[CSRBundles.scala 25:46]
  wire  _T_1 = io_bus_ready & io_bus_reg_read; // @[CSRBundles.scala 24:27]
  wire [31:0] _GEN_0 = io_bus_addr == 13'h384 ? StorageRegister_23_io_dataIn : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 26:21]
  wire [31:0] _GEN_4 = io_bus_addr == 13'h11 ? StorageRegister_13_io_dataIn : _GEN_0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_8 = io_bus_addr == 13'h8 ? StorageRegister_4_io_dataIn : _GEN_4; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_12 = io_bus_addr == 13'h40c ? irqHost_io_dataIn : _GEN_8; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_16 = io_bus_addr == 13'h2 ? 32'h10400 : _GEN_12; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_20 = io_bus_addr == 13'hb ? StorageRegister_7_io_dataIn : _GEN_16; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_24 = io_bus_addr == 13'h14 ? StorageRegister_16_io_dataIn : _GEN_20; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_28 = io_bus_addr == 13'h403 ? StorageRegister_29_io_dataIn : _GEN_24; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_32 = io_bus_addr == 13'h381 ? StorageRegister_20_io_dataIn : _GEN_28; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_36 = io_bus_addr == 13'h406 ? StorageRegister_32_io_dataIn : _GEN_32; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_40 = io_bus_addr == 13'he ? StorageRegister_10_io_dataIn : _GEN_36; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_44 = io_bus_addr == 13'h5 ? StorageRegister_2_io_dataIn : _GEN_40; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_48 = io_bus_addr == 13'h409 ? StorageRegister_35_io_dataIn : _GEN_44; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_52 = io_bus_addr == 13'h400 ? StorageRegister_26_io_dataIn : _GEN_48; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_56 = io_bus_addr == 13'h386 ? StorageRegister_25_io_dataIn : _GEN_52; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_60 = io_bus_addr == 13'h10 ? StorageRegister_12_io_dataIn : _GEN_56; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_64 = io_bus_addr == 13'ha ? StorageRegister_6_io_dataIn : _GEN_60; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_68 = io_bus_addr == 13'h1 ? 32'h20 : _GEN_64; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_72 = _T ? irqDat_io_dataIn : _GEN_68; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_76 = io_bus_addr == 13'h380 ? StorageRegister_19_io_dataIn : _GEN_72; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_80 = io_bus_addr == 13'h13 ? StorageRegister_15_io_dataIn : _GEN_76; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_84 = io_bus_addr == 13'h4 ? StorageRegister_1_io_dataIn : _GEN_80; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_88 = io_bus_addr == 13'hd ? StorageRegister_9_io_dataIn : _GEN_84; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_92 = io_bus_addr == 13'h16 ? StorageRegister_18_io_dataIn : _GEN_88; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_96 = io_bus_addr == 13'h405 ? StorageRegister_31_io_dataIn : _GEN_92; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_100 = io_bus_addr == 13'h383 ? StorageRegister_22_io_dataIn : _GEN_96; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_104 = io_bus_addr == 13'h408 ? StorageRegister_34_io_dataIn : _GEN_100; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_108 = io_bus_addr == 13'h7 ? StorageRegister_3_io_dataIn : _GEN_104; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_112 = io_bus_addr == 13'h402 ? StorageRegister_28_io_dataIn : _GEN_108; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_116 = io_bus_addr == 13'hf ? StorageRegister_11_io_dataIn : _GEN_112; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_120 = io_bus_addr == 13'h385 ? StorageRegister_24_io_dataIn : _GEN_116; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_124 = io_bus_addr == 13'h12 ? StorageRegister_14_io_dataIn : _GEN_120; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_128 = io_bus_addr == 13'h9 ? StorageRegister_5_io_dataIn : _GEN_124; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_132 = io_bus_addr == 13'h15 ? StorageRegister_17_io_dataIn : _GEN_128; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_136 = io_bus_addr == 13'h3 ? StorageRegister_io_dataIn : _GEN_132; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_140 = io_bus_addr == 13'hc ? StorageRegister_8_io_dataIn : _GEN_136; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_144 = io_bus_addr == 13'h404 ? StorageRegister_30_io_dataIn : _GEN_140; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_148 = io_bus_addr == 13'h382 ? StorageRegister_21_io_dataIn : _GEN_144; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_152 = io_bus_addr == 13'h407 ? StorageRegister_33_io_dataIn : _GEN_148; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_156 = io_bus_addr == 13'h40a ? irqSta_io_dataIn : _GEN_152; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  wire [31:0] _GEN_160 = io_bus_addr == 13'h401 ? StorageRegister_27_io_dataIn : _GEN_156; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  StorageRegister StorageRegister ( // @[CSRRegMap.scala 11:31]
    .clock(StorageRegister_clock),
    .reset(StorageRegister_reset),
    .io_write(StorageRegister_io_write),
    .io_dataOut(StorageRegister_io_dataOut),
    .io_dataIn(StorageRegister_io_dataIn)
  );
  StorageRegister StorageRegister_1 ( // @[CSRRegMap.scala 12:32]
    .clock(StorageRegister_1_clock),
    .reset(StorageRegister_1_reset),
    .io_write(StorageRegister_1_io_write),
    .io_dataOut(StorageRegister_1_io_dataOut),
    .io_dataIn(StorageRegister_1_io_dataIn)
  );
  StorageRegister_2 StorageRegister_2 ( // @[CSRRegMap.scala 13:32]
    .clock(StorageRegister_2_clock),
    .reset(StorageRegister_2_reset),
    .io_write(StorageRegister_2_io_write),
    .io_dataOut(StorageRegister_2_io_dataOut),
    .io_dataIn(StorageRegister_2_io_dataIn)
  );
  StorageRegister_3 StorageRegister_3 ( // @[CSRRegMap.scala 14:32]
    .clock(StorageRegister_3_clock),
    .reset(StorageRegister_3_reset),
    .io_write(StorageRegister_3_io_write),
    .io_dataOut(StorageRegister_3_io_dataOut),
    .io_dataIn(StorageRegister_3_io_dataIn)
  );
  StorageRegister StorageRegister_4 ( // @[CSRRegMap.scala 15:32]
    .clock(StorageRegister_4_clock),
    .reset(StorageRegister_4_reset),
    .io_write(StorageRegister_4_io_write),
    .io_dataOut(StorageRegister_4_io_dataOut),
    .io_dataIn(StorageRegister_4_io_dataIn)
  );
  StorageRegister_5 StorageRegister_5 ( // @[CSRRegMap.scala 16:32]
    .clock(StorageRegister_5_clock),
    .reset(StorageRegister_5_reset),
    .io_write(StorageRegister_5_io_write),
    .io_dataOut(StorageRegister_5_io_dataOut),
    .io_dataIn(StorageRegister_5_io_dataIn)
  );
  StorageRegister_6 StorageRegister_6 ( // @[CSRRegMap.scala 17:32]
    .clock(StorageRegister_6_clock),
    .reset(StorageRegister_6_reset),
    .io_write(StorageRegister_6_io_write),
    .io_dataOut(StorageRegister_6_io_dataOut),
    .io_dataIn(StorageRegister_6_io_dataIn)
  );
  StorageRegister StorageRegister_7 ( // @[CSRRegMap.scala 18:32]
    .clock(StorageRegister_7_clock),
    .reset(StorageRegister_7_reset),
    .io_write(StorageRegister_7_io_write),
    .io_dataOut(StorageRegister_7_io_dataOut),
    .io_dataIn(StorageRegister_7_io_dataIn)
  );
  StorageRegister_6 StorageRegister_8 ( // @[CSRRegMap.scala 19:32]
    .clock(StorageRegister_8_clock),
    .reset(StorageRegister_8_reset),
    .io_write(StorageRegister_8_io_write),
    .io_dataOut(StorageRegister_8_io_dataOut),
    .io_dataIn(StorageRegister_8_io_dataIn)
  );
  StorageRegister StorageRegister_9 ( // @[CSRRegMap.scala 20:32]
    .clock(StorageRegister_9_clock),
    .reset(StorageRegister_9_reset),
    .io_write(StorageRegister_9_io_write),
    .io_dataOut(StorageRegister_9_io_dataOut),
    .io_dataIn(StorageRegister_9_io_dataIn)
  );
  StorageRegister_10 StorageRegister_10 ( // @[CSRRegMap.scala 21:32]
    .clock(StorageRegister_10_clock),
    .reset(StorageRegister_10_reset),
    .io_write(StorageRegister_10_io_write),
    .io_dataOut(StorageRegister_10_io_dataOut),
    .io_dataIn(StorageRegister_10_io_dataIn)
  );
  StorageRegister_11 StorageRegister_11 ( // @[CSRRegMap.scala 22:32]
    .clock(StorageRegister_11_clock),
    .reset(StorageRegister_11_reset),
    .io_write(StorageRegister_11_io_write),
    .io_dataOut(StorageRegister_11_io_dataOut),
    .io_dataIn(StorageRegister_11_io_dataIn)
  );
  StorageRegister_12 StorageRegister_12 ( // @[CSRRegMap.scala 23:32]
    .clock(StorageRegister_12_clock),
    .reset(StorageRegister_12_reset),
    .io_write(StorageRegister_12_io_write),
    .io_dataOut(StorageRegister_12_io_dataOut),
    .io_dataIn(StorageRegister_12_io_dataIn)
  );
  StorageRegister_13 StorageRegister_13 ( // @[CSRRegMap.scala 24:32]
    .clock(StorageRegister_13_clock),
    .reset(StorageRegister_13_reset),
    .io_write(StorageRegister_13_io_write),
    .io_dataOut(StorageRegister_13_io_dataOut),
    .io_dataIn(StorageRegister_13_io_dataIn)
  );
  StorageRegister_6 StorageRegister_14 ( // @[CSRRegMap.scala 25:32]
    .clock(StorageRegister_14_clock),
    .reset(StorageRegister_14_reset),
    .io_write(StorageRegister_14_io_write),
    .io_dataOut(StorageRegister_14_io_dataOut),
    .io_dataIn(StorageRegister_14_io_dataIn)
  );
  StorageRegister StorageRegister_15 ( // @[CSRRegMap.scala 26:32]
    .clock(StorageRegister_15_clock),
    .reset(StorageRegister_15_reset),
    .io_write(StorageRegister_15_io_write),
    .io_dataOut(StorageRegister_15_io_dataOut),
    .io_dataIn(StorageRegister_15_io_dataIn)
  );
  StorageRegister_16 StorageRegister_16 ( // @[CSRRegMap.scala 27:32]
    .clock(StorageRegister_16_clock),
    .reset(StorageRegister_16_reset),
    .io_write(StorageRegister_16_io_write),
    .io_dataOut(StorageRegister_16_io_dataOut),
    .io_dataIn(StorageRegister_16_io_dataIn)
  );
  StorageRegister StorageRegister_17 ( // @[CSRRegMap.scala 28:32]
    .clock(StorageRegister_17_clock),
    .reset(StorageRegister_17_reset),
    .io_write(StorageRegister_17_io_write),
    .io_dataOut(StorageRegister_17_io_dataOut),
    .io_dataIn(StorageRegister_17_io_dataIn)
  );
  StorageRegister_18 StorageRegister_18 ( // @[CSRRegMap.scala 29:32]
    .clock(StorageRegister_18_clock),
    .reset(StorageRegister_18_reset),
    .io_write(StorageRegister_18_io_write),
    .io_dataOut(StorageRegister_18_io_dataOut),
    .io_dataIn(StorageRegister_18_io_dataIn)
  );
  StorageRegister_19 StorageRegister_19 ( // @[CSRRegMap.scala 30:33]
    .clock(StorageRegister_19_clock),
    .reset(StorageRegister_19_reset),
    .io_write(StorageRegister_19_io_write),
    .io_dataOut(StorageRegister_19_io_dataOut),
    .io_dataIn(StorageRegister_19_io_dataIn)
  );
  StorageRegister_18 StorageRegister_20 ( // @[CSRRegMap.scala 31:33]
    .clock(StorageRegister_20_clock),
    .reset(StorageRegister_20_reset),
    .io_write(StorageRegister_20_io_write),
    .io_dataOut(StorageRegister_20_io_dataOut),
    .io_dataIn(StorageRegister_20_io_dataIn)
  );
  StorageRegister_21 StorageRegister_21 ( // @[CSRRegMap.scala 32:33]
    .clock(StorageRegister_21_clock),
    .reset(StorageRegister_21_reset),
    .io_write(StorageRegister_21_io_write),
    .io_dataOut(StorageRegister_21_io_dataOut),
    .io_dataIn(StorageRegister_21_io_dataIn)
  );
  StorageRegister_22 StorageRegister_22 ( // @[CSRRegMap.scala 33:33]
    .clock(StorageRegister_22_clock),
    .reset(StorageRegister_22_reset),
    .io_write(StorageRegister_22_io_write),
    .io_dataOut(StorageRegister_22_io_dataOut),
    .io_dataIn(StorageRegister_22_io_dataIn)
  );
  StorageRegister_23 StorageRegister_23 ( // @[CSRRegMap.scala 34:33]
    .clock(StorageRegister_23_clock),
    .reset(StorageRegister_23_reset),
    .io_write(StorageRegister_23_io_write),
    .io_dataOut(StorageRegister_23_io_dataOut),
    .io_dataIn(StorageRegister_23_io_dataIn)
  );
  StorageRegister_16 StorageRegister_24 ( // @[CSRRegMap.scala 35:33]
    .clock(StorageRegister_24_clock),
    .reset(StorageRegister_24_reset),
    .io_write(StorageRegister_24_io_write),
    .io_dataOut(StorageRegister_24_io_dataOut),
    .io_dataIn(StorageRegister_24_io_dataIn)
  );
  StorageRegister StorageRegister_25 ( // @[CSRRegMap.scala 36:33]
    .clock(StorageRegister_25_clock),
    .reset(StorageRegister_25_reset),
    .io_write(StorageRegister_25_io_write),
    .io_dataOut(StorageRegister_25_io_dataOut),
    .io_dataIn(StorageRegister_25_io_dataIn)
  );
  StorageRegister_26 StorageRegister_26 ( // @[CSRFile.scala 33:26]
    .clock(StorageRegister_26_clock),
    .reset(StorageRegister_26_reset),
    .io_write(StorageRegister_26_io_write),
    .io_dataOut(StorageRegister_26_io_dataOut),
    .io_dataIn(StorageRegister_26_io_dataIn)
  );
  StorageRegister_26 StorageRegister_27 ( // @[CSRFile.scala 34:30]
    .clock(StorageRegister_27_clock),
    .reset(StorageRegister_27_reset),
    .io_write(StorageRegister_27_io_write),
    .io_dataOut(StorageRegister_27_io_dataOut),
    .io_dataIn(StorageRegister_27_io_dataIn)
  );
  StorageRegister_26 StorageRegister_28 ( // @[CSRFile.scala 33:26]
    .clock(StorageRegister_28_clock),
    .reset(StorageRegister_28_reset),
    .io_write(StorageRegister_28_io_write),
    .io_dataOut(StorageRegister_28_io_dataOut),
    .io_dataIn(StorageRegister_28_io_dataIn)
  );
  StorageRegister_26 StorageRegister_29 ( // @[CSRFile.scala 34:30]
    .clock(StorageRegister_29_clock),
    .reset(StorageRegister_29_reset),
    .io_write(StorageRegister_29_io_write),
    .io_dataOut(StorageRegister_29_io_dataOut),
    .io_dataIn(StorageRegister_29_io_dataIn)
  );
  StorageRegister_26 StorageRegister_30 ( // @[CSRFile.scala 33:26]
    .clock(StorageRegister_30_clock),
    .reset(StorageRegister_30_reset),
    .io_write(StorageRegister_30_io_write),
    .io_dataOut(StorageRegister_30_io_dataOut),
    .io_dataIn(StorageRegister_30_io_dataIn)
  );
  StorageRegister_26 StorageRegister_31 ( // @[CSRFile.scala 34:30]
    .clock(StorageRegister_31_clock),
    .reset(StorageRegister_31_reset),
    .io_write(StorageRegister_31_io_write),
    .io_dataOut(StorageRegister_31_io_dataOut),
    .io_dataIn(StorageRegister_31_io_dataIn)
  );
  StorageRegister_26 StorageRegister_32 ( // @[CSRFile.scala 33:26]
    .clock(StorageRegister_32_clock),
    .reset(StorageRegister_32_reset),
    .io_write(StorageRegister_32_io_write),
    .io_dataOut(StorageRegister_32_io_dataOut),
    .io_dataIn(StorageRegister_32_io_dataIn)
  );
  StorageRegister_26 StorageRegister_33 ( // @[CSRFile.scala 34:30]
    .clock(StorageRegister_33_clock),
    .reset(StorageRegister_33_reset),
    .io_write(StorageRegister_33_io_write),
    .io_dataOut(StorageRegister_33_io_dataOut),
    .io_dataIn(StorageRegister_33_io_dataIn)
  );
  StorageRegister_26 StorageRegister_34 ( // @[CSRFile.scala 33:26]
    .clock(StorageRegister_34_clock),
    .reset(StorageRegister_34_reset),
    .io_write(StorageRegister_34_io_write),
    .io_dataOut(StorageRegister_34_io_dataOut),
    .io_dataIn(StorageRegister_34_io_dataIn)
  );
  StorageRegister_26 StorageRegister_35 ( // @[CSRFile.scala 34:30]
    .clock(StorageRegister_35_clock),
    .reset(StorageRegister_35_reset),
    .io_write(StorageRegister_35_io_write),
    .io_dataOut(StorageRegister_35_io_dataOut),
    .io_dataIn(StorageRegister_35_io_dataIn)
  );
  ReadOnlyRegister_3 irqSta ( // @[CSRFile.scala 41:22]
    .io_dataIn(irqSta_io_dataIn),
    .fields_VALID(irqSta_fields_VALID)
  );
  ReadOnlyRegister_4 irqDat ( // @[CSRFile.scala 50:22]
    .io_dataIn(irqDat_io_dataIn),
    .fields_DATA(irqDat_fields_DATA)
  );
  AutoClearingRegister irqHost ( // @[CSRFile.scala 59:23]
    .clock(irqHost_clock),
    .reset(irqHost_reset),
    .io_write(irqHost_io_write),
    .io_dataOut(irqHost_io_dataOut),
    .io_dataIn(irqHost_io_dataIn),
    .fields_REQ(irqHost_fields_REQ)
  );
  assign io_bus_ready = 1'h1; // @[CSRFile.scala 25:16]
  assign io_bus_reg_dataIn = io_bus_addr == 13'h0 ? 32'h8010fff : _GEN_160; // @[CSRFile.scala 68:50 CSRFile.scala 69:14]
  assign io_csrLog_ready = io_bus_addr == 13'h40b & _T_1; // @[CSRBundles.scala 25:59]
  assign io_irqHost = irqHost_fields_REQ; // @[CSRFile.scala 64:14]
  assign StorageRegister_clock = clock;
  assign StorageRegister_reset = reset;
  assign StorageRegister_io_write = io_bus_addr == 13'h3 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_io_dataOut = io_bus_addr == 13'h3 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_1_clock = clock;
  assign StorageRegister_1_reset = reset;
  assign StorageRegister_1_io_write = io_bus_addr == 13'h4 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_1_io_dataOut = io_bus_addr == 13'h4 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_2_clock = clock;
  assign StorageRegister_2_reset = reset;
  assign StorageRegister_2_io_write = io_bus_addr == 13'h5 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_2_io_dataOut = io_bus_addr == 13'h5 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_3_clock = clock;
  assign StorageRegister_3_reset = reset;
  assign StorageRegister_3_io_write = io_bus_addr == 13'h7 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_3_io_dataOut = io_bus_addr == 13'h7 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_4_clock = clock;
  assign StorageRegister_4_reset = reset;
  assign StorageRegister_4_io_write = io_bus_addr == 13'h8 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_4_io_dataOut = io_bus_addr == 13'h8 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_5_clock = clock;
  assign StorageRegister_5_reset = reset;
  assign StorageRegister_5_io_write = io_bus_addr == 13'h9 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_5_io_dataOut = io_bus_addr == 13'h9 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_6_clock = clock;
  assign StorageRegister_6_reset = reset;
  assign StorageRegister_6_io_write = io_bus_addr == 13'ha & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_6_io_dataOut = io_bus_addr == 13'ha ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_7_clock = clock;
  assign StorageRegister_7_reset = reset;
  assign StorageRegister_7_io_write = io_bus_addr == 13'hb & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_7_io_dataOut = io_bus_addr == 13'hb ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_8_clock = clock;
  assign StorageRegister_8_reset = reset;
  assign StorageRegister_8_io_write = io_bus_addr == 13'hc & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_8_io_dataOut = io_bus_addr == 13'hc ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_9_clock = clock;
  assign StorageRegister_9_reset = reset;
  assign StorageRegister_9_io_write = io_bus_addr == 13'hd & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_9_io_dataOut = io_bus_addr == 13'hd ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_10_clock = clock;
  assign StorageRegister_10_reset = reset;
  assign StorageRegister_10_io_write = io_bus_addr == 13'he & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_10_io_dataOut = io_bus_addr == 13'he ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_11_clock = clock;
  assign StorageRegister_11_reset = reset;
  assign StorageRegister_11_io_write = io_bus_addr == 13'hf & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_11_io_dataOut = io_bus_addr == 13'hf ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_12_clock = clock;
  assign StorageRegister_12_reset = reset;
  assign StorageRegister_12_io_write = io_bus_addr == 13'h10 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_12_io_dataOut = io_bus_addr == 13'h10 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_13_clock = clock;
  assign StorageRegister_13_reset = reset;
  assign StorageRegister_13_io_write = io_bus_addr == 13'h11 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_13_io_dataOut = io_bus_addr == 13'h11 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_14_clock = clock;
  assign StorageRegister_14_reset = reset;
  assign StorageRegister_14_io_write = io_bus_addr == 13'h12 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_14_io_dataOut = io_bus_addr == 13'h12 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_15_clock = clock;
  assign StorageRegister_15_reset = reset;
  assign StorageRegister_15_io_write = io_bus_addr == 13'h13 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_15_io_dataOut = io_bus_addr == 13'h13 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_16_clock = clock;
  assign StorageRegister_16_reset = reset;
  assign StorageRegister_16_io_write = io_bus_addr == 13'h14 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_16_io_dataOut = io_bus_addr == 13'h14 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_17_clock = clock;
  assign StorageRegister_17_reset = reset;
  assign StorageRegister_17_io_write = io_bus_addr == 13'h15 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_17_io_dataOut = io_bus_addr == 13'h15 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_18_clock = clock;
  assign StorageRegister_18_reset = reset;
  assign StorageRegister_18_io_write = io_bus_addr == 13'h16 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_18_io_dataOut = io_bus_addr == 13'h16 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_19_clock = clock;
  assign StorageRegister_19_reset = reset;
  assign StorageRegister_19_io_write = io_bus_addr == 13'h380 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_19_io_dataOut = io_bus_addr == 13'h380 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_20_clock = clock;
  assign StorageRegister_20_reset = reset;
  assign StorageRegister_20_io_write = io_bus_addr == 13'h381 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_20_io_dataOut = io_bus_addr == 13'h381 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_21_clock = clock;
  assign StorageRegister_21_reset = reset;
  assign StorageRegister_21_io_write = io_bus_addr == 13'h382 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_21_io_dataOut = io_bus_addr == 13'h382 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_22_clock = clock;
  assign StorageRegister_22_reset = reset;
  assign StorageRegister_22_io_write = io_bus_addr == 13'h383 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_22_io_dataOut = io_bus_addr == 13'h383 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_23_clock = clock;
  assign StorageRegister_23_reset = reset;
  assign StorageRegister_23_io_write = io_bus_addr == 13'h384 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_23_io_dataOut = io_bus_addr == 13'h384 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_24_clock = clock;
  assign StorageRegister_24_reset = reset;
  assign StorageRegister_24_io_write = io_bus_addr == 13'h385 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_24_io_dataOut = io_bus_addr == 13'h385 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_25_clock = clock;
  assign StorageRegister_25_reset = reset;
  assign StorageRegister_25_io_write = io_bus_addr == 13'h386 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_25_io_dataOut = io_bus_addr == 13'h386 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_26_clock = clock;
  assign StorageRegister_26_reset = reset;
  assign StorageRegister_26_io_write = io_bus_addr == 13'h400 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_26_io_dataOut = io_bus_addr == 13'h400 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_27_clock = clock;
  assign StorageRegister_27_reset = reset;
  assign StorageRegister_27_io_write = io_bus_addr == 13'h401 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_27_io_dataOut = io_bus_addr == 13'h401 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_28_clock = clock;
  assign StorageRegister_28_reset = reset;
  assign StorageRegister_28_io_write = io_bus_addr == 13'h402 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_28_io_dataOut = io_bus_addr == 13'h402 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_29_clock = clock;
  assign StorageRegister_29_reset = reset;
  assign StorageRegister_29_io_write = io_bus_addr == 13'h403 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_29_io_dataOut = io_bus_addr == 13'h403 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_30_clock = clock;
  assign StorageRegister_30_reset = reset;
  assign StorageRegister_30_io_write = io_bus_addr == 13'h404 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_30_io_dataOut = io_bus_addr == 13'h404 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_31_clock = clock;
  assign StorageRegister_31_reset = reset;
  assign StorageRegister_31_io_write = io_bus_addr == 13'h405 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_31_io_dataOut = io_bus_addr == 13'h405 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_32_clock = clock;
  assign StorageRegister_32_reset = reset;
  assign StorageRegister_32_io_write = io_bus_addr == 13'h406 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_32_io_dataOut = io_bus_addr == 13'h406 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_33_clock = clock;
  assign StorageRegister_33_reset = reset;
  assign StorageRegister_33_io_write = io_bus_addr == 13'h407 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_33_io_dataOut = io_bus_addr == 13'h407 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_34_clock = clock;
  assign StorageRegister_34_reset = reset;
  assign StorageRegister_34_io_write = io_bus_addr == 13'h408 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_34_io_dataOut = io_bus_addr == 13'h408 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign StorageRegister_35_clock = clock;
  assign StorageRegister_35_reset = reset;
  assign StorageRegister_35_io_write = io_bus_addr == 13'h409 & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign StorageRegister_35_io_dataOut = io_bus_addr == 13'h409 ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
  assign irqSta_fields_VALID = io_csrLog_valid; // @[CSRFile.scala 45:23]
  assign irqDat_fields_DATA = io_csrLog_bits; // @[CSRFile.scala 52:22]
  assign irqHost_clock = clock;
  assign irqHost_reset = reset;
  assign irqHost_io_write = io_bus_addr == 13'h40c & io_bus_reg_write; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 71:20]
  assign irqHost_io_dataOut = io_bus_addr == 13'h40c ? io_bus_reg_dataOut : 32'h0; // @[CSRFile.scala 68:50 CSRFile.scala 69:14 CSRFile.scala 73:22]
endmodule
module NVMeTop(
  input         clock,
  input         reset,
  input  [31:0] io_host_aw_awaddr,
  input  [2:0]  io_host_aw_awprot,
  input         io_host_aw_awvalid,
  output        io_host_aw_awready,
  input  [31:0] io_host_w_wdata,
  input  [3:0]  io_host_w_wstrb,
  input         io_host_w_wvalid,
  output        io_host_w_wready,
  output [1:0]  io_host_b_bresp,
  output        io_host_b_bvalid,
  input         io_host_b_bready,
  input  [31:0] io_host_ar_araddr,
  input  [2:0]  io_host_ar_arprot,
  input         io_host_ar_arvalid,
  output        io_host_ar_arready,
  output [31:0] io_host_r_rdata,
  output [1:0]  io_host_r_rresp,
  output        io_host_r_rvalid,
  input         io_host_r_rready,
  input  [31:0] io_controller_aw_awaddr,
  input  [2:0]  io_controller_aw_awprot,
  input         io_controller_aw_awvalid,
  output        io_controller_aw_awready,
  input  [31:0] io_controller_w_wdata,
  input  [3:0]  io_controller_w_wstrb,
  input         io_controller_w_wvalid,
  output        io_controller_w_wready,
  output [1:0]  io_controller_b_bresp,
  output        io_controller_b_bvalid,
  input         io_controller_b_bready,
  input  [31:0] io_controller_ar_araddr,
  input  [2:0]  io_controller_ar_arprot,
  input         io_controller_ar_arvalid,
  output        io_controller_ar_arready,
  output [31:0] io_controller_r_rdata,
  output [1:0]  io_controller_r_rresp,
  output        io_controller_r_rvalid,
  input         io_controller_r_rready,
  output        io_irqReq,
  output [31:0] io_irqHost
);
  wire  hostCSRAxi_clock; // @[NVMeTop.scala 23:26]
  wire  hostCSRAxi_reset; // @[NVMeTop.scala 23:26]
  wire [14:0] hostCSRAxi_io_ctl_aw_awaddr; // @[NVMeTop.scala 23:26]
  wire  hostCSRAxi_io_ctl_aw_awvalid; // @[NVMeTop.scala 23:26]
  wire  hostCSRAxi_io_ctl_aw_awready; // @[NVMeTop.scala 23:26]
  wire [31:0] hostCSRAxi_io_ctl_w_wdata; // @[NVMeTop.scala 23:26]
  wire  hostCSRAxi_io_ctl_w_wvalid; // @[NVMeTop.scala 23:26]
  wire  hostCSRAxi_io_ctl_w_wready; // @[NVMeTop.scala 23:26]
  wire  hostCSRAxi_io_ctl_b_bvalid; // @[NVMeTop.scala 23:26]
  wire  hostCSRAxi_io_ctl_b_bready; // @[NVMeTop.scala 23:26]
  wire [14:0] hostCSRAxi_io_ctl_ar_araddr; // @[NVMeTop.scala 23:26]
  wire  hostCSRAxi_io_ctl_ar_arvalid; // @[NVMeTop.scala 23:26]
  wire  hostCSRAxi_io_ctl_ar_arready; // @[NVMeTop.scala 23:26]
  wire [31:0] hostCSRAxi_io_ctl_r_rdata; // @[NVMeTop.scala 23:26]
  wire  hostCSRAxi_io_ctl_r_rvalid; // @[NVMeTop.scala 23:26]
  wire  hostCSRAxi_io_ctl_r_rready; // @[NVMeTop.scala 23:26]
  wire  hostCSRAxi_io_bus_ready; // @[NVMeTop.scala 23:26]
  wire [12:0] hostCSRAxi_io_bus_addr; // @[NVMeTop.scala 23:26]
  wire  hostCSRAxi_io_bus_reg_write; // @[NVMeTop.scala 23:26]
  wire [31:0] hostCSRAxi_io_bus_reg_dataOut; // @[NVMeTop.scala 23:26]
  wire  hostCSRAxi_io_bus_reg_read; // @[NVMeTop.scala 23:26]
  wire [31:0] hostCSRAxi_io_bus_reg_dataIn; // @[NVMeTop.scala 23:26]
  wire  controllerCSRAxi_clock; // @[NVMeTop.scala 28:32]
  wire  controllerCSRAxi_reset; // @[NVMeTop.scala 28:32]
  wire [14:0] controllerCSRAxi_io_ctl_aw_awaddr; // @[NVMeTop.scala 28:32]
  wire  controllerCSRAxi_io_ctl_aw_awvalid; // @[NVMeTop.scala 28:32]
  wire  controllerCSRAxi_io_ctl_aw_awready; // @[NVMeTop.scala 28:32]
  wire [31:0] controllerCSRAxi_io_ctl_w_wdata; // @[NVMeTop.scala 28:32]
  wire  controllerCSRAxi_io_ctl_w_wvalid; // @[NVMeTop.scala 28:32]
  wire  controllerCSRAxi_io_ctl_w_wready; // @[NVMeTop.scala 28:32]
  wire  controllerCSRAxi_io_ctl_b_bvalid; // @[NVMeTop.scala 28:32]
  wire  controllerCSRAxi_io_ctl_b_bready; // @[NVMeTop.scala 28:32]
  wire [14:0] controllerCSRAxi_io_ctl_ar_araddr; // @[NVMeTop.scala 28:32]
  wire  controllerCSRAxi_io_ctl_ar_arvalid; // @[NVMeTop.scala 28:32]
  wire  controllerCSRAxi_io_ctl_ar_arready; // @[NVMeTop.scala 28:32]
  wire [31:0] controllerCSRAxi_io_ctl_r_rdata; // @[NVMeTop.scala 28:32]
  wire  controllerCSRAxi_io_ctl_r_rvalid; // @[NVMeTop.scala 28:32]
  wire  controllerCSRAxi_io_ctl_r_rready; // @[NVMeTop.scala 28:32]
  wire  controllerCSRAxi_io_bus_ready; // @[NVMeTop.scala 28:32]
  wire [12:0] controllerCSRAxi_io_bus_addr; // @[NVMeTop.scala 28:32]
  wire  controllerCSRAxi_io_bus_reg_write; // @[NVMeTop.scala 28:32]
  wire [31:0] controllerCSRAxi_io_bus_reg_dataOut; // @[NVMeTop.scala 28:32]
  wire  controllerCSRAxi_io_bus_reg_read; // @[NVMeTop.scala 28:32]
  wire [31:0] controllerCSRAxi_io_bus_reg_dataIn; // @[NVMeTop.scala 28:32]
  wire  CSRArbiter_io_inBusA_ready; // @[NVMeTop.scala 33:26]
  wire [12:0] CSRArbiter_io_inBusA_addr; // @[NVMeTop.scala 33:26]
  wire  CSRArbiter_io_inBusA_reg_write; // @[NVMeTop.scala 33:26]
  wire [31:0] CSRArbiter_io_inBusA_reg_dataOut; // @[NVMeTop.scala 33:26]
  wire  CSRArbiter_io_inBusA_reg_read; // @[NVMeTop.scala 33:26]
  wire [31:0] CSRArbiter_io_inBusA_reg_dataIn; // @[NVMeTop.scala 33:26]
  wire  CSRArbiter_io_inBusB_ready; // @[NVMeTop.scala 33:26]
  wire [12:0] CSRArbiter_io_inBusB_addr; // @[NVMeTop.scala 33:26]
  wire  CSRArbiter_io_inBusB_reg_write; // @[NVMeTop.scala 33:26]
  wire [31:0] CSRArbiter_io_inBusB_reg_dataOut; // @[NVMeTop.scala 33:26]
  wire  CSRArbiter_io_inBusB_reg_read; // @[NVMeTop.scala 33:26]
  wire [31:0] CSRArbiter_io_inBusB_reg_dataIn; // @[NVMeTop.scala 33:26]
  wire [12:0] CSRArbiter_io_outBus_addr; // @[NVMeTop.scala 33:26]
  wire  CSRArbiter_io_outBus_reg_write; // @[NVMeTop.scala 33:26]
  wire [31:0] CSRArbiter_io_outBus_reg_dataOut; // @[NVMeTop.scala 33:26]
  wire  CSRArbiter_io_outBus_reg_read; // @[NVMeTop.scala 33:26]
  wire [31:0] CSRArbiter_io_outBus_reg_dataIn; // @[NVMeTop.scala 33:26]
  wire  Interrupts_clock; // @[NVMeTop.scala 38:26]
  wire  Interrupts_reset; // @[NVMeTop.scala 38:26]
  wire  Interrupts_io_irqReq; // @[NVMeTop.scala 38:26]
  wire  Interrupts_io_csrBus_ready; // @[NVMeTop.scala 38:26]
  wire [12:0] Interrupts_io_csrBus_addr; // @[NVMeTop.scala 38:26]
  wire  Interrupts_io_csrBus_reg_write; // @[NVMeTop.scala 38:26]
  wire  Interrupts_io_csrLog_ready; // @[NVMeTop.scala 38:26]
  wire  Interrupts_io_csrLog_valid; // @[NVMeTop.scala 38:26]
  wire [31:0] Interrupts_io_csrLog_bits; // @[NVMeTop.scala 38:26]
  wire  CSRFile_clock; // @[NVMeTop.scala 44:23]
  wire  CSRFile_reset; // @[NVMeTop.scala 44:23]
  wire  CSRFile_io_bus_ready; // @[NVMeTop.scala 44:23]
  wire [12:0] CSRFile_io_bus_addr; // @[NVMeTop.scala 44:23]
  wire  CSRFile_io_bus_reg_write; // @[NVMeTop.scala 44:23]
  wire [31:0] CSRFile_io_bus_reg_dataOut; // @[NVMeTop.scala 44:23]
  wire  CSRFile_io_bus_reg_read; // @[NVMeTop.scala 44:23]
  wire [31:0] CSRFile_io_bus_reg_dataIn; // @[NVMeTop.scala 44:23]
  wire  CSRFile_io_csrLog_ready; // @[NVMeTop.scala 44:23]
  wire  CSRFile_io_csrLog_valid; // @[NVMeTop.scala 44:23]
  wire [31:0] CSRFile_io_csrLog_bits; // @[NVMeTop.scala 44:23]
  wire [31:0] CSRFile_io_irqHost; // @[NVMeTop.scala 44:23]
  AXI4LiteCSR hostCSRAxi ( // @[NVMeTop.scala 23:26]
    .clock(hostCSRAxi_clock),
    .reset(hostCSRAxi_reset),
    .io_ctl_aw_awaddr(hostCSRAxi_io_ctl_aw_awaddr),
    .io_ctl_aw_awvalid(hostCSRAxi_io_ctl_aw_awvalid),
    .io_ctl_aw_awready(hostCSRAxi_io_ctl_aw_awready),
    .io_ctl_w_wdata(hostCSRAxi_io_ctl_w_wdata),
    .io_ctl_w_wvalid(hostCSRAxi_io_ctl_w_wvalid),
    .io_ctl_w_wready(hostCSRAxi_io_ctl_w_wready),
    .io_ctl_b_bvalid(hostCSRAxi_io_ctl_b_bvalid),
    .io_ctl_b_bready(hostCSRAxi_io_ctl_b_bready),
    .io_ctl_ar_araddr(hostCSRAxi_io_ctl_ar_araddr),
    .io_ctl_ar_arvalid(hostCSRAxi_io_ctl_ar_arvalid),
    .io_ctl_ar_arready(hostCSRAxi_io_ctl_ar_arready),
    .io_ctl_r_rdata(hostCSRAxi_io_ctl_r_rdata),
    .io_ctl_r_rvalid(hostCSRAxi_io_ctl_r_rvalid),
    .io_ctl_r_rready(hostCSRAxi_io_ctl_r_rready),
    .io_bus_ready(hostCSRAxi_io_bus_ready),
    .io_bus_addr(hostCSRAxi_io_bus_addr),
    .io_bus_reg_write(hostCSRAxi_io_bus_reg_write),
    .io_bus_reg_dataOut(hostCSRAxi_io_bus_reg_dataOut),
    .io_bus_reg_read(hostCSRAxi_io_bus_reg_read),
    .io_bus_reg_dataIn(hostCSRAxi_io_bus_reg_dataIn)
  );
  AXI4LiteCSR controllerCSRAxi ( // @[NVMeTop.scala 28:32]
    .clock(controllerCSRAxi_clock),
    .reset(controllerCSRAxi_reset),
    .io_ctl_aw_awaddr(controllerCSRAxi_io_ctl_aw_awaddr),
    .io_ctl_aw_awvalid(controllerCSRAxi_io_ctl_aw_awvalid),
    .io_ctl_aw_awready(controllerCSRAxi_io_ctl_aw_awready),
    .io_ctl_w_wdata(controllerCSRAxi_io_ctl_w_wdata),
    .io_ctl_w_wvalid(controllerCSRAxi_io_ctl_w_wvalid),
    .io_ctl_w_wready(controllerCSRAxi_io_ctl_w_wready),
    .io_ctl_b_bvalid(controllerCSRAxi_io_ctl_b_bvalid),
    .io_ctl_b_bready(controllerCSRAxi_io_ctl_b_bready),
    .io_ctl_ar_araddr(controllerCSRAxi_io_ctl_ar_araddr),
    .io_ctl_ar_arvalid(controllerCSRAxi_io_ctl_ar_arvalid),
    .io_ctl_ar_arready(controllerCSRAxi_io_ctl_ar_arready),
    .io_ctl_r_rdata(controllerCSRAxi_io_ctl_r_rdata),
    .io_ctl_r_rvalid(controllerCSRAxi_io_ctl_r_rvalid),
    .io_ctl_r_rready(controllerCSRAxi_io_ctl_r_rready),
    .io_bus_ready(controllerCSRAxi_io_bus_ready),
    .io_bus_addr(controllerCSRAxi_io_bus_addr),
    .io_bus_reg_write(controllerCSRAxi_io_bus_reg_write),
    .io_bus_reg_dataOut(controllerCSRAxi_io_bus_reg_dataOut),
    .io_bus_reg_read(controllerCSRAxi_io_bus_reg_read),
    .io_bus_reg_dataIn(controllerCSRAxi_io_bus_reg_dataIn)
  );
  RegBusArbiter CSRArbiter ( // @[NVMeTop.scala 33:26]
    .io_inBusA_ready(CSRArbiter_io_inBusA_ready),
    .io_inBusA_addr(CSRArbiter_io_inBusA_addr),
    .io_inBusA_reg_write(CSRArbiter_io_inBusA_reg_write),
    .io_inBusA_reg_dataOut(CSRArbiter_io_inBusA_reg_dataOut),
    .io_inBusA_reg_read(CSRArbiter_io_inBusA_reg_read),
    .io_inBusA_reg_dataIn(CSRArbiter_io_inBusA_reg_dataIn),
    .io_inBusB_ready(CSRArbiter_io_inBusB_ready),
    .io_inBusB_addr(CSRArbiter_io_inBusB_addr),
    .io_inBusB_reg_write(CSRArbiter_io_inBusB_reg_write),
    .io_inBusB_reg_dataOut(CSRArbiter_io_inBusB_reg_dataOut),
    .io_inBusB_reg_read(CSRArbiter_io_inBusB_reg_read),
    .io_inBusB_reg_dataIn(CSRArbiter_io_inBusB_reg_dataIn),
    .io_outBus_addr(CSRArbiter_io_outBus_addr),
    .io_outBus_reg_write(CSRArbiter_io_outBus_reg_write),
    .io_outBus_reg_dataOut(CSRArbiter_io_outBus_reg_dataOut),
    .io_outBus_reg_read(CSRArbiter_io_outBus_reg_read),
    .io_outBus_reg_dataIn(CSRArbiter_io_outBus_reg_dataIn)
  );
  CSRInterrupt Interrupts ( // @[NVMeTop.scala 38:26]
    .clock(Interrupts_clock),
    .reset(Interrupts_reset),
    .io_irqReq(Interrupts_io_irqReq),
    .io_csrBus_ready(Interrupts_io_csrBus_ready),
    .io_csrBus_addr(Interrupts_io_csrBus_addr),
    .io_csrBus_reg_write(Interrupts_io_csrBus_reg_write),
    .io_csrLog_ready(Interrupts_io_csrLog_ready),
    .io_csrLog_valid(Interrupts_io_csrLog_valid),
    .io_csrLog_bits(Interrupts_io_csrLog_bits)
  );
  CSRFile CSRFile ( // @[NVMeTop.scala 44:23]
    .clock(CSRFile_clock),
    .reset(CSRFile_reset),
    .io_bus_ready(CSRFile_io_bus_ready),
    .io_bus_addr(CSRFile_io_bus_addr),
    .io_bus_reg_write(CSRFile_io_bus_reg_write),
    .io_bus_reg_dataOut(CSRFile_io_bus_reg_dataOut),
    .io_bus_reg_read(CSRFile_io_bus_reg_read),
    .io_bus_reg_dataIn(CSRFile_io_bus_reg_dataIn),
    .io_csrLog_ready(CSRFile_io_csrLog_ready),
    .io_csrLog_valid(CSRFile_io_csrLog_valid),
    .io_csrLog_bits(CSRFile_io_csrLog_bits),
    .io_irqHost(CSRFile_io_irqHost)
  );
  assign io_host_aw_awready = hostCSRAxi_io_ctl_aw_awready; // @[NVMeTop.scala 25:21]
  assign io_host_w_wready = hostCSRAxi_io_ctl_w_wready; // @[NVMeTop.scala 25:21]
  assign io_host_b_bresp = 2'h0; // @[NVMeTop.scala 25:21]
  assign io_host_b_bvalid = hostCSRAxi_io_ctl_b_bvalid; // @[NVMeTop.scala 25:21]
  assign io_host_ar_arready = hostCSRAxi_io_ctl_ar_arready; // @[NVMeTop.scala 25:21]
  assign io_host_r_rdata = hostCSRAxi_io_ctl_r_rdata; // @[NVMeTop.scala 25:21]
  assign io_host_r_rresp = 2'h0; // @[NVMeTop.scala 25:21]
  assign io_host_r_rvalid = hostCSRAxi_io_ctl_r_rvalid; // @[NVMeTop.scala 25:21]
  assign io_controller_aw_awready = controllerCSRAxi_io_ctl_aw_awready; // @[NVMeTop.scala 30:27]
  assign io_controller_w_wready = controllerCSRAxi_io_ctl_w_wready; // @[NVMeTop.scala 30:27]
  assign io_controller_b_bresp = 2'h0; // @[NVMeTop.scala 30:27]
  assign io_controller_b_bvalid = controllerCSRAxi_io_ctl_b_bvalid; // @[NVMeTop.scala 30:27]
  assign io_controller_ar_arready = controllerCSRAxi_io_ctl_ar_arready; // @[NVMeTop.scala 30:27]
  assign io_controller_r_rdata = controllerCSRAxi_io_ctl_r_rdata; // @[NVMeTop.scala 30:27]
  assign io_controller_r_rresp = 2'h0; // @[NVMeTop.scala 30:27]
  assign io_controller_r_rvalid = controllerCSRAxi_io_ctl_r_rvalid; // @[NVMeTop.scala 30:27]
  assign io_irqReq = Interrupts_io_irqReq; // @[NVMeTop.scala 40:13]
  assign io_irqHost = CSRFile_io_irqHost; // @[NVMeTop.scala 46:14]
  assign hostCSRAxi_clock = clock;
  assign hostCSRAxi_reset = reset;
  assign hostCSRAxi_io_ctl_aw_awaddr = io_host_aw_awaddr[14:0]; // @[NVMeTop.scala 25:21]
  assign hostCSRAxi_io_ctl_aw_awvalid = io_host_aw_awvalid; // @[NVMeTop.scala 25:21]
  assign hostCSRAxi_io_ctl_w_wdata = io_host_w_wdata; // @[NVMeTop.scala 25:21]
  assign hostCSRAxi_io_ctl_w_wvalid = io_host_w_wvalid; // @[NVMeTop.scala 25:21]
  assign hostCSRAxi_io_ctl_b_bready = io_host_b_bready; // @[NVMeTop.scala 25:21]
  assign hostCSRAxi_io_ctl_ar_araddr = io_host_ar_araddr[14:0]; // @[NVMeTop.scala 25:21]
  assign hostCSRAxi_io_ctl_ar_arvalid = io_host_ar_arvalid; // @[NVMeTop.scala 25:21]
  assign hostCSRAxi_io_ctl_r_rready = io_host_r_rready; // @[NVMeTop.scala 25:21]
  assign hostCSRAxi_io_bus_ready = CSRArbiter_io_inBusB_ready; // @[NVMeTop.scala 36:24]
  assign hostCSRAxi_io_bus_reg_dataIn = CSRArbiter_io_inBusB_reg_dataIn; // @[NVMeTop.scala 36:24]
  assign controllerCSRAxi_clock = clock;
  assign controllerCSRAxi_reset = reset;
  assign controllerCSRAxi_io_ctl_aw_awaddr = io_controller_aw_awaddr[14:0]; // @[NVMeTop.scala 30:27]
  assign controllerCSRAxi_io_ctl_aw_awvalid = io_controller_aw_awvalid; // @[NVMeTop.scala 30:27]
  assign controllerCSRAxi_io_ctl_w_wdata = io_controller_w_wdata; // @[NVMeTop.scala 30:27]
  assign controllerCSRAxi_io_ctl_w_wvalid = io_controller_w_wvalid; // @[NVMeTop.scala 30:27]
  assign controllerCSRAxi_io_ctl_b_bready = io_controller_b_bready; // @[NVMeTop.scala 30:27]
  assign controllerCSRAxi_io_ctl_ar_araddr = io_controller_ar_araddr[14:0]; // @[NVMeTop.scala 30:27]
  assign controllerCSRAxi_io_ctl_ar_arvalid = io_controller_ar_arvalid; // @[NVMeTop.scala 30:27]
  assign controllerCSRAxi_io_ctl_r_rready = io_controller_r_rready; // @[NVMeTop.scala 30:27]
  assign controllerCSRAxi_io_bus_ready = CSRArbiter_io_inBusA_ready; // @[NVMeTop.scala 35:24]
  assign controllerCSRAxi_io_bus_reg_dataIn = CSRArbiter_io_inBusA_reg_dataIn; // @[NVMeTop.scala 35:24]
  assign CSRArbiter_io_inBusA_addr = controllerCSRAxi_io_bus_addr; // @[NVMeTop.scala 35:24]
  assign CSRArbiter_io_inBusA_reg_write = controllerCSRAxi_io_bus_reg_write; // @[NVMeTop.scala 35:24]
  assign CSRArbiter_io_inBusA_reg_dataOut = controllerCSRAxi_io_bus_reg_dataOut; // @[NVMeTop.scala 35:24]
  assign CSRArbiter_io_inBusA_reg_read = controllerCSRAxi_io_bus_reg_read; // @[NVMeTop.scala 35:24]
  assign CSRArbiter_io_inBusB_addr = hostCSRAxi_io_bus_addr; // @[NVMeTop.scala 36:24]
  assign CSRArbiter_io_inBusB_reg_write = hostCSRAxi_io_bus_reg_write; // @[NVMeTop.scala 36:24]
  assign CSRArbiter_io_inBusB_reg_dataOut = hostCSRAxi_io_bus_reg_dataOut; // @[NVMeTop.scala 36:24]
  assign CSRArbiter_io_inBusB_reg_read = hostCSRAxi_io_bus_reg_read; // @[NVMeTop.scala 36:24]
  assign CSRArbiter_io_outBus_reg_dataIn = CSRFile_io_bus_reg_dataIn; // @[NVMeTop.scala 48:18]
  assign Interrupts_clock = clock;
  assign Interrupts_reset = reset;
  assign Interrupts_io_csrBus_ready = hostCSRAxi_io_bus_ready; // @[NVMeTop.scala 41:24]
  assign Interrupts_io_csrBus_addr = hostCSRAxi_io_bus_addr; // @[NVMeTop.scala 41:24]
  assign Interrupts_io_csrBus_reg_write = hostCSRAxi_io_bus_reg_write; // @[NVMeTop.scala 41:24]
  assign Interrupts_io_csrLog_ready = CSRFile_io_csrLog_ready; // @[NVMeTop.scala 49:21]
  assign CSRFile_clock = clock;
  assign CSRFile_reset = reset;
  assign CSRFile_io_bus_addr = CSRArbiter_io_outBus_addr; // @[NVMeTop.scala 48:18]
  assign CSRFile_io_bus_reg_write = CSRArbiter_io_outBus_reg_write; // @[NVMeTop.scala 48:18]
  assign CSRFile_io_bus_reg_dataOut = CSRArbiter_io_outBus_reg_dataOut; // @[NVMeTop.scala 48:18]
  assign CSRFile_io_bus_reg_read = CSRArbiter_io_outBus_reg_read; // @[NVMeTop.scala 48:18]
  assign CSRFile_io_csrLog_valid = Interrupts_io_csrLog_valid; // @[NVMeTop.scala 49:21]
  assign CSRFile_io_csrLog_bits = Interrupts_io_csrLog_bits; // @[NVMeTop.scala 49:21]
endmodule
