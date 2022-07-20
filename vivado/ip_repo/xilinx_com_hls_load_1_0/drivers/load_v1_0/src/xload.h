// ==============================================================
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2020.1.1 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XLOAD_H
#define XLOAD_H

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
#include "xload_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#else
typedef struct {
    u16 DeviceId;
    u32 Control_bus_BaseAddress;
} XLoad_Config;
#endif

typedef struct {
    u32 Control_bus_BaseAddress;
    u32 IsReady;
} XLoad;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XLoad_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XLoad_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XLoad_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XLoad_ReadReg(BaseAddress, RegOffset) \
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
int XLoad_Initialize(XLoad *InstancePtr, u16 DeviceId);
XLoad_Config* XLoad_LookupConfig(u16 DeviceId);
int XLoad_CfgInitialize(XLoad *InstancePtr, XLoad_Config *ConfigPtr);
#else
int XLoad_Initialize(XLoad *InstancePtr, const char* InstanceName);
int XLoad_Release(XLoad *InstancePtr);
#endif

void XLoad_Start(XLoad *InstancePtr);
u32 XLoad_IsDone(XLoad *InstancePtr);
u32 XLoad_IsIdle(XLoad *InstancePtr);
u32 XLoad_IsReady(XLoad *InstancePtr);
void XLoad_EnableAutoRestart(XLoad *InstancePtr);
void XLoad_DisableAutoRestart(XLoad *InstancePtr);

void XLoad_Set_inputs_V(XLoad *InstancePtr, u32 Data);
u32 XLoad_Get_inputs_V(XLoad *InstancePtr);
void XLoad_Set_weights_V(XLoad *InstancePtr, u32 Data);
u32 XLoad_Get_weights_V(XLoad *InstancePtr);

void XLoad_InterruptGlobalEnable(XLoad *InstancePtr);
void XLoad_InterruptGlobalDisable(XLoad *InstancePtr);
void XLoad_InterruptEnable(XLoad *InstancePtr, u32 Mask);
void XLoad_InterruptDisable(XLoad *InstancePtr, u32 Mask);
void XLoad_InterruptClear(XLoad *InstancePtr, u32 Mask);
u32 XLoad_InterruptGetEnabled(XLoad *InstancePtr);
u32 XLoad_InterruptGetStatus(XLoad *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
