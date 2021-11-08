// ==============================================================
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2020.1.1 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XFETCH_H
#define XFETCH_H

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
#include "xfetch_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#else
typedef struct {
    u16 DeviceId;
    u32 Control_bus_BaseAddress;
} XFetch_Config;
#endif

typedef struct {
    u32 Control_bus_BaseAddress;
    u32 IsReady;
} XFetch;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XFetch_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XFetch_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XFetch_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XFetch_ReadReg(BaseAddress, RegOffset) \
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
int XFetch_Initialize(XFetch *InstancePtr, u16 DeviceId);
XFetch_Config* XFetch_LookupConfig(u16 DeviceId);
int XFetch_CfgInitialize(XFetch *InstancePtr, XFetch_Config *ConfigPtr);
#else
int XFetch_Initialize(XFetch *InstancePtr, const char* InstanceName);
int XFetch_Release(XFetch *InstancePtr);
#endif

void XFetch_Start(XFetch *InstancePtr);
u32 XFetch_IsDone(XFetch *InstancePtr);
u32 XFetch_IsIdle(XFetch *InstancePtr);
u32 XFetch_IsReady(XFetch *InstancePtr);
void XFetch_EnableAutoRestart(XFetch *InstancePtr);
void XFetch_DisableAutoRestart(XFetch *InstancePtr);

void XFetch_Set_insn_count(XFetch *InstancePtr, u32 Data);
u32 XFetch_Get_insn_count(XFetch *InstancePtr);
void XFetch_Set_insns_V(XFetch *InstancePtr, u32 Data);
u32 XFetch_Get_insns_V(XFetch *InstancePtr);

void XFetch_InterruptGlobalEnable(XFetch *InstancePtr);
void XFetch_InterruptGlobalDisable(XFetch *InstancePtr);
void XFetch_InterruptEnable(XFetch *InstancePtr, u32 Mask);
void XFetch_InterruptDisable(XFetch *InstancePtr, u32 Mask);
void XFetch_InterruptClear(XFetch *InstancePtr, u32 Mask);
u32 XFetch_InterruptGetEnabled(XFetch *InstancePtr);
u32 XFetch_InterruptGetStatus(XFetch *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
