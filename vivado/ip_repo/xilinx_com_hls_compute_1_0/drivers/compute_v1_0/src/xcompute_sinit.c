// ==============================================================
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2020.1.1 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "xcompute.h"

extern XCompute_Config XCompute_ConfigTable[];

XCompute_Config *XCompute_LookupConfig(u16 DeviceId) {
	XCompute_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XCOMPUTE_NUM_INSTANCES; Index++) {
		if (XCompute_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XCompute_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XCompute_Initialize(XCompute *InstancePtr, u16 DeviceId) {
	XCompute_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XCompute_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XCompute_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

