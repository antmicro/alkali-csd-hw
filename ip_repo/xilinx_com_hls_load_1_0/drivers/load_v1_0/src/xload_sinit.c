// ==============================================================
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2020.1.1 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "xload.h"

extern XLoad_Config XLoad_ConfigTable[];

XLoad_Config *XLoad_LookupConfig(u16 DeviceId) {
	XLoad_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XLOAD_NUM_INSTANCES; Index++) {
		if (XLoad_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XLoad_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XLoad_Initialize(XLoad *InstancePtr, u16 DeviceId) {
	XLoad_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XLoad_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XLoad_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

