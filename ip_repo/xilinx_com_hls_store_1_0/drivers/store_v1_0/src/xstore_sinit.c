// ==============================================================
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2020.1.1 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "xstore.h"

extern XStore_Config XStore_ConfigTable[];

XStore_Config *XStore_LookupConfig(u16 DeviceId) {
	XStore_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XSTORE_NUM_INSTANCES; Index++) {
		if (XStore_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XStore_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XStore_Initialize(XStore *InstancePtr, u16 DeviceId) {
	XStore_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XStore_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XStore_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

