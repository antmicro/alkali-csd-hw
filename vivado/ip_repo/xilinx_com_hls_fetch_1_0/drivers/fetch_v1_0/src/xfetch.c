// ==============================================================
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2020.1.1 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
/***************************** Include Files *********************************/
#include "xfetch.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XFetch_CfgInitialize(XFetch *InstancePtr, XFetch_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_bus_BaseAddress = ConfigPtr->Control_bus_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XFetch_Start(XFetch *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XFetch_ReadReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_AP_CTRL) & 0x80;
    XFetch_WriteReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_AP_CTRL, Data | 0x01);
}

u32 XFetch_IsDone(XFetch *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XFetch_ReadReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XFetch_IsIdle(XFetch *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XFetch_ReadReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XFetch_IsReady(XFetch *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XFetch_ReadReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XFetch_EnableAutoRestart(XFetch *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XFetch_WriteReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_AP_CTRL, 0x80);
}

void XFetch_DisableAutoRestart(XFetch *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XFetch_WriteReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_AP_CTRL, 0);
}

void XFetch_Set_insn_count(XFetch *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XFetch_WriteReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_INSN_COUNT_DATA, Data);
}

u32 XFetch_Get_insn_count(XFetch *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XFetch_ReadReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_INSN_COUNT_DATA);
    return Data;
}

void XFetch_Set_insns_V(XFetch *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XFetch_WriteReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_INSNS_V_DATA, Data);
}

u32 XFetch_Get_insns_V(XFetch *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XFetch_ReadReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_INSNS_V_DATA);
    return Data;
}

void XFetch_InterruptGlobalEnable(XFetch *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XFetch_WriteReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_GIE, 1);
}

void XFetch_InterruptGlobalDisable(XFetch *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XFetch_WriteReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_GIE, 0);
}

void XFetch_InterruptEnable(XFetch *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XFetch_ReadReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_IER);
    XFetch_WriteReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_IER, Register | Mask);
}

void XFetch_InterruptDisable(XFetch *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XFetch_ReadReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_IER);
    XFetch_WriteReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_IER, Register & (~Mask));
}

void XFetch_InterruptClear(XFetch *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XFetch_WriteReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_ISR, Mask);
}

u32 XFetch_InterruptGetEnabled(XFetch *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XFetch_ReadReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_IER);
}

u32 XFetch_InterruptGetStatus(XFetch *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XFetch_ReadReg(InstancePtr->Control_bus_BaseAddress, XFETCH_CONTROL_BUS_ADDR_ISR);
}

