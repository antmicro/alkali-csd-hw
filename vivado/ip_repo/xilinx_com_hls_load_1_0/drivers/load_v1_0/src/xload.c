// ==============================================================
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2020.1.1 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
/***************************** Include Files *********************************/
#include "xload.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XLoad_CfgInitialize(XLoad *InstancePtr, XLoad_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_bus_BaseAddress = ConfigPtr->Control_bus_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XLoad_Start(XLoad *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XLoad_ReadReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_AP_CTRL) & 0x80;
    XLoad_WriteReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_AP_CTRL, Data | 0x01);
}

u32 XLoad_IsDone(XLoad *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XLoad_ReadReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XLoad_IsIdle(XLoad *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XLoad_ReadReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XLoad_IsReady(XLoad *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XLoad_ReadReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XLoad_EnableAutoRestart(XLoad *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XLoad_WriteReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_AP_CTRL, 0x80);
}

void XLoad_DisableAutoRestart(XLoad *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XLoad_WriteReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_AP_CTRL, 0);
}

void XLoad_Set_inputs_V(XLoad *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XLoad_WriteReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_INPUTS_V_DATA, Data);
}

u32 XLoad_Get_inputs_V(XLoad *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XLoad_ReadReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_INPUTS_V_DATA);
    return Data;
}

void XLoad_Set_weights_V(XLoad *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XLoad_WriteReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_WEIGHTS_V_DATA, Data);
}

u32 XLoad_Get_weights_V(XLoad *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XLoad_ReadReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_WEIGHTS_V_DATA);
    return Data;
}

void XLoad_InterruptGlobalEnable(XLoad *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XLoad_WriteReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_GIE, 1);
}

void XLoad_InterruptGlobalDisable(XLoad *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XLoad_WriteReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_GIE, 0);
}

void XLoad_InterruptEnable(XLoad *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XLoad_ReadReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_IER);
    XLoad_WriteReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_IER, Register | Mask);
}

void XLoad_InterruptDisable(XLoad *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XLoad_ReadReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_IER);
    XLoad_WriteReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_IER, Register & (~Mask));
}

void XLoad_InterruptClear(XLoad *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XLoad_WriteReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_ISR, Mask);
}

u32 XLoad_InterruptGetEnabled(XLoad *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XLoad_ReadReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_IER);
}

u32 XLoad_InterruptGetStatus(XLoad *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XLoad_ReadReg(InstancePtr->Control_bus_BaseAddress, XLOAD_CONTROL_BUS_ADDR_ISR);
}

