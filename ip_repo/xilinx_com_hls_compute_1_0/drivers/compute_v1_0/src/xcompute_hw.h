// ==============================================================
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2020.1.1 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
// CONTROL_BUS
// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read/COR)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read)
//        bit 7  - auto_restart (Read/Write)
//        others - reserved
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0  - Channel 0 (ap_done)
//        bit 1  - Channel 1 (ap_ready)
//        others - reserved
// 0x0c : IP Interrupt Status Register (Read/TOW)
//        bit 0  - Channel 0 (ap_done)
//        bit 1  - Channel 1 (ap_ready)
//        others - reserved
// 0x10 : Data signal of done_i
//        bit 31~0 - done_i[31:0] (Read/Write)
// 0x14 : reserved
// 0x18 : Data signal of done_o
//        bit 31~0 - done_o[31:0] (Read)
// 0x1c : Control signal of done_o
//        bit 0  - done_o_ap_vld (Read/COR)
//        others - reserved
// 0x20 : Data signal of uops_V
//        bit 31~0 - uops_V[31:0] (Read/Write)
// 0x24 : reserved
// 0x28 : Data signal of biases_V
//        bit 31~0 - biases_V[31:0] (Read/Write)
// 0x2c : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XCOMPUTE_CONTROL_BUS_ADDR_AP_CTRL       0x00
#define XCOMPUTE_CONTROL_BUS_ADDR_GIE           0x04
#define XCOMPUTE_CONTROL_BUS_ADDR_IER           0x08
#define XCOMPUTE_CONTROL_BUS_ADDR_ISR           0x0c
#define XCOMPUTE_CONTROL_BUS_ADDR_DONE_I_DATA   0x10
#define XCOMPUTE_CONTROL_BUS_BITS_DONE_I_DATA   32
#define XCOMPUTE_CONTROL_BUS_ADDR_DONE_O_DATA   0x18
#define XCOMPUTE_CONTROL_BUS_BITS_DONE_O_DATA   32
#define XCOMPUTE_CONTROL_BUS_ADDR_DONE_O_CTRL   0x1c
#define XCOMPUTE_CONTROL_BUS_ADDR_UOPS_V_DATA   0x20
#define XCOMPUTE_CONTROL_BUS_BITS_UOPS_V_DATA   32
#define XCOMPUTE_CONTROL_BUS_ADDR_BIASES_V_DATA 0x28
#define XCOMPUTE_CONTROL_BUS_BITS_BIASES_V_DATA 32

