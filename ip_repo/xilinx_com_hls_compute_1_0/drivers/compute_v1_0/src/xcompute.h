// ==============================================================
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2020.1.1 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XCOMPUTE_H
#define XCOMPUTE_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xcompute_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#else
typedef struct {
    u16 DeviceId;
    u32 Control_bus_BaseAddress;
} XCompute_Config;
#endif

typedef struct {
    u32 Control_bus_BaseAddress;
    u32 IsReady;
} XCompute;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XCompute_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XCompute_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XCompute_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XCompute_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
int XCompute_Initialize(XCompute *InstancePtr, u16 DeviceId);
XCompute_Config* XCompute_LookupConfig(u16 DeviceId);
int XCompute_CfgInitialize(XCompute *InstancePtr, XCompute_Config *ConfigPtr);
#else
int XCompute_Initialize(XCompute *InstancePtr, const char* InstanceName);
int XCompute_Release(XCompute *InstancePtr);
#endif

void XCompute_Start(XCompute *InstancePtr);
u32 XCompute_IsDone(XCompute *InstancePtr);
u32 XCompute_IsIdle(XCompute *InstancePtr);
u32 XCompute_IsReady(XCompute *InstancePtr);
void XCompute_EnableAutoRestart(XCompute *InstancePtr);
void XCompute_DisableAutoRestart(XCompute *InstancePtr);

void XCompute_Set_done_i(XCompute *InstancePtr, u32 Data);
u32 XCompute_Get_done_i(XCompute *InstancePtr);
u32 XCompute_Get_done_o(XCompute *InstancePtr);
u32 XCompute_Get_done_o_vld(XCompute *InstancePtr);
void XCompute_Set_uops_V(XCompute *InstancePtr, u32 Data);
u32 XCompute_Get_uops_V(XCompute *InstancePtr);
void XCompute_Set_biases_V(XCompute *InstancePtr, u32 Data);
u32 XCompute_Get_biases_V(XCompute *InstancePtr);

void XCompute_InterruptGlobalEnable(XCompute *InstancePtr);
void XCompute_InterruptGlobalDisable(XCompute *InstancePtr);
void XCompute_InterruptEnable(XCompute *InstancePtr, u32 Mask);
void XCompute_InterruptDisable(XCompute *InstancePtr, u32 Mask);
void XCompute_InterruptClear(XCompute *InstancePtr, u32 Mask);
u32 XCompute_InterruptGetEnabled(XCompute *InstancePtr);
u32 XCompute_InterruptGetStatus(XCompute *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
