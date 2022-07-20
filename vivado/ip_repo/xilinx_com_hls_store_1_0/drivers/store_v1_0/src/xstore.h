// ==============================================================
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2020.1.1 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XSTORE_H
#define XSTORE_H

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
#include "xstore_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#else
typedef struct {
    u16 DeviceId;
    u32 Control_bus_BaseAddress;
} XStore_Config;
#endif

typedef struct {
    u32 Control_bus_BaseAddress;
    u32 IsReady;
} XStore;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XStore_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XStore_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XStore_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XStore_ReadReg(BaseAddress, RegOffset) \
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
int XStore_Initialize(XStore *InstancePtr, u16 DeviceId);
XStore_Config* XStore_LookupConfig(u16 DeviceId);
int XStore_CfgInitialize(XStore *InstancePtr, XStore_Config *ConfigPtr);
#else
int XStore_Initialize(XStore *InstancePtr, const char* InstanceName);
int XStore_Release(XStore *InstancePtr);
#endif

void XStore_Start(XStore *InstancePtr);
u32 XStore_IsDone(XStore *InstancePtr);
u32 XStore_IsIdle(XStore *InstancePtr);
u32 XStore_IsReady(XStore *InstancePtr);
void XStore_EnableAutoRestart(XStore *InstancePtr);
void XStore_DisableAutoRestart(XStore *InstancePtr);

void XStore_Set_outputs_V(XStore *InstancePtr, u32 Data);
u32 XStore_Get_outputs_V(XStore *InstancePtr);

void XStore_InterruptGlobalEnable(XStore *InstancePtr);
void XStore_InterruptGlobalDisable(XStore *InstancePtr);
void XStore_InterruptEnable(XStore *InstancePtr, u32 Mask);
void XStore_InterruptDisable(XStore *InstancePtr, u32 Mask);
void XStore_InterruptClear(XStore *InstancePtr, u32 Mask);
u32 XStore_InterruptGetEnabled(XStore *InstancePtr);
u32 XStore_InterruptGetStatus(XStore *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
