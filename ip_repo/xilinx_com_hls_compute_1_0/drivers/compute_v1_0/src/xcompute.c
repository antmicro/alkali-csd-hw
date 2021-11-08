// ==============================================================
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2020.1.1 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
/***************************** Include Files *********************************/
#include "xcompute.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XCompute_CfgInitialize(XCompute *InstancePtr, XCompute_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_bus_BaseAddress = ConfigPtr->Control_bus_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XCompute_Start(XCompute *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCompute_ReadReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_AP_CTRL) & 0x80;
    XCompute_WriteReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_AP_CTRL, Data | 0x01);
}

u32 XCompute_IsDone(XCompute *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCompute_ReadReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XCompute_IsIdle(XCompute *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCompute_ReadReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XCompute_IsReady(XCompute *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCompute_ReadReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XCompute_EnableAutoRestart(XCompute *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCompute_WriteReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_AP_CTRL, 0x80);
}

void XCompute_DisableAutoRestart(XCompute *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCompute_WriteReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_AP_CTRL, 0);
}

void XCompute_Set_done_i(XCompute *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCompute_WriteReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_DONE_I_DATA, Data);
}

u32 XCompute_Get_done_i(XCompute *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCompute_ReadReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_DONE_I_DATA);
    return Data;
}

u32 XCompute_Get_done_o(XCompute *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCompute_ReadReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_DONE_O_DATA);
    return Data;
}

u32 XCompute_Get_done_o_vld(XCompute *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCompute_ReadReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_DONE_O_CTRL);
    return Data & 0x1;
}

void XCompute_Set_uops_V(XCompute *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCompute_WriteReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_UOPS_V_DATA, Data);
}

u32 XCompute_Get_uops_V(XCompute *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCompute_ReadReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_UOPS_V_DATA);
    return Data;
}

void XCompute_Set_biases_V(XCompute *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCompute_WriteReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_BIASES_V_DATA, Data);
}

u32 XCompute_Get_biases_V(XCompute *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCompute_ReadReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_BIASES_V_DATA);
    return Data;
}

void XCompute_InterruptGlobalEnable(XCompute *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCompute_WriteReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_GIE, 1);
}

void XCompute_InterruptGlobalDisable(XCompute *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCompute_WriteReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_GIE, 0);
}

void XCompute_InterruptEnable(XCompute *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XCompute_ReadReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_IER);
    XCompute_WriteReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_IER, Register | Mask);
}

void XCompute_InterruptDisable(XCompute *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XCompute_ReadReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_IER);
    XCompute_WriteReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_IER, Register & (~Mask));
}

void XCompute_InterruptClear(XCompute *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCompute_WriteReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_ISR, Mask);
}

u32 XCompute_InterruptGetEnabled(XCompute *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XCompute_ReadReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_IER);
}

u32 XCompute_InterruptGetStatus(XCompute *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XCompute_ReadReg(InstancePtr->Control_bus_BaseAddress, XCOMPUTE_CONTROL_BUS_ADDR_ISR);
}

