// ==============================================================
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2020.1.1 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "xfetch.h"

extern XFetch_Config XFetch_ConfigTable[];

XFetch_Config *XFetch_LookupConfig(u16 DeviceId) {
	XFetch_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XFETCH_NUM_INSTANCES; Index++) {
		if (XFetch_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XFetch_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XFetch_Initialize(XFetch *InstancePtr, u16 DeviceId) {
	XFetch_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XFetch_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XFetch_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

