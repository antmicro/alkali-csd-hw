// ==============================================================
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2020.1.1 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
/***************************** Include Files *********************************/
#include "xstore.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XStore_CfgInitialize(XStore *InstancePtr, XStore_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_bus_BaseAddress = ConfigPtr->Control_bus_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XStore_Start(XStore *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XStore_ReadReg(InstancePtr->Control_bus_BaseAddress, XSTORE_CONTROL_BUS_ADDR_AP_CTRL) & 0x80;
    XStore_WriteReg(InstancePtr->Control_bus_BaseAddress, XSTORE_CONTROL_BUS_ADDR_AP_CTRL, Data | 0x01);
}

u32 XStore_IsDone(XStore *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XStore_ReadReg(InstancePtr->Control_bus_BaseAddress, XSTORE_CONTROL_BUS_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XStore_IsIdle(XStore *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XStore_ReadReg(InstancePtr->Control_bus_BaseAddress, XSTORE_CONTROL_BUS_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XStore_IsReady(XStore *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XStore_ReadReg(InstancePtr->Control_bus_BaseAddress, XSTORE_CONTROL_BUS_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XStore_EnableAutoRestart(XStore *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XStore_WriteReg(InstancePtr->Control_bus_BaseAddress, XSTORE_CONTROL_BUS_ADDR_AP_CTRL, 0x80);
}

void XStore_DisableAutoRestart(XStore *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XStore_WriteReg(InstancePtr->Control_bus_BaseAddress, XSTORE_CONTROL_BUS_ADDR_AP_CTRL, 0);
}

void XStore_Set_outputs_V(XStore *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XStore_WriteReg(InstancePtr->Control_bus_BaseAddress, XSTORE_CONTROL_BUS_ADDR_OUTPUTS_V_DATA, Data);
}

u32 XStore_Get_outputs_V(XStore *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XStore_ReadReg(InstancePtr->Control_bus_BaseAddress, XSTORE_CONTROL_BUS_ADDR_OUTPUTS_V_DATA);
    return Data;
}

void XStore_InterruptGlobalEnable(XStore *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XStore_WriteReg(InstancePtr->Control_bus_BaseAddress, XSTORE_CONTROL_BUS_ADDR_GIE, 1);
}

void XStore_InterruptGlobalDisable(XStore *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XStore_WriteReg(InstancePtr->Control_bus_BaseAddress, XSTORE_CONTROL_BUS_ADDR_GIE, 0);
}

void XStore_InterruptEnable(XStore *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XStore_ReadReg(InstancePtr->Control_bus_BaseAddress, XSTORE_CONTROL_BUS_ADDR_IER);
    XStore_WriteReg(InstancePtr->Control_bus_BaseAddress, XSTORE_CONTROL_BUS_ADDR_IER, Register | Mask);
}

void XStore_InterruptDisable(XStore *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XStore_ReadReg(InstancePtr->Control_bus_BaseAddress, XSTORE_CONTROL_BUS_ADDR_IER);
    XStore_WriteReg(InstancePtr->Control_bus_BaseAddress, XSTORE_CONTROL_BUS_ADDR_IER, Register & (~Mask));
}

void XStore_InterruptClear(XStore *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XStore_WriteReg(InstancePtr->Control_bus_BaseAddress, XSTORE_CONTROL_BUS_ADDR_ISR, Mask);
}

u32 XStore_InterruptGetEnabled(XStore *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XStore_ReadReg(InstancePtr->Control_bus_BaseAddress, XSTORE_CONTROL_BUS_ADDR_IER);
}

u32 XStore_InterruptGetStatus(XStore *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XStore_ReadReg(InstancePtr->Control_bus_BaseAddress, XSTORE_CONTROL_BUS_ADDR_ISR);
}

