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
// 0x10 : Data signal of insn_count
//        bit 31~0 - insn_count[31:0] (Read/Write)
// 0x14 : reserved
// 0x18 : Data signal of insns_V
//        bit 31~0 - insns_V[31:0] (Read/Write)
// 0x1c : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XFETCH_CONTROL_BUS_ADDR_AP_CTRL         0x00
#define XFETCH_CONTROL_BUS_ADDR_GIE             0x04
#define XFETCH_CONTROL_BUS_ADDR_IER             0x08
#define XFETCH_CONTROL_BUS_ADDR_ISR             0x0c
#define XFETCH_CONTROL_BUS_ADDR_INSN_COUNT_DATA 0x10
#define XFETCH_CONTROL_BUS_BITS_INSN_COUNT_DATA 32
#define XFETCH_CONTROL_BUS_ADDR_INSNS_V_DATA    0x18
#define XFETCH_CONTROL_BUS_BITS_INSNS_V_DATA    32

