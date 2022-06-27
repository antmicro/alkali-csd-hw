Using Alkl_shell.py file we can debug u-boot/linux (zynqmp/buildroot) console without use of JTAG USB cable. 

For Run Script, We need to use below Command. 

1. We need u-boot (zynqmp) console for boot linux for this use below command. 
   
   ```bash
   cd testing_uart
   make 
   ./alkl_shell.py zynqmp 

   After Run this Script press " ENTER " and write " boot " (For boot linux) 
   ```
   
   E.g.  
   root@joy-Z390-D:/mnt/Joy/repo_alkali# ./alkl_shell.py zynqmp
   Press ENTER for Console
   ff00000
   Bootmode: QSPI_MODE
   Reset reason:	EXTERNAL 
   Net:   No
   
   ZynqMP> 
   ```bash
   ZynqMP> boot
   ```

```bash   
Note : Do Not close this script and terminal. Please use another terminal or tab for run below command. 
```

2. We need to open buildroot(linux) console for load NVMe driver. 
   
   ```bash
   ./alkl_shell.py buildroot
   ```

   After run this command below message is coming and use "root" as password. 
   
   ```bash
   Welcome to Buildroot
   buildroot login: root
   ```
   ```bash   
   For Load NVMe driver run command in console.
    reload.sh
   ```

3. Now open new terminal to see basalt NVMe device, use below commands.
   ```bash
   lspci | grep "Western Digital Device"
   ```
   Note: 01:00.0 Non-Volatile memory controller: Western Digital Device 0001
         01:00.1 Serial controller: Western Digital Device 1234
         Check your device number as per above prints.
   ```bash
   echo "1" | sudo tee /sys/bus/pci/devices/0000\:01(device number)\:00.0/remove
   echo "1" | sudo tee /sys/bus/pci/rescan
   nvme list
   
   Note:Node             SN                   Model                                    Namespace Usage                      Format           FW Rev  
        ---------------- -------------------- ---------------------------------------- --------- -------------------------- ---------------- --------
        /dev/nvme0n1     0123456789           DEADBEEF                                 1           0.00   B / 402.65  MB    512   B +  0 B   12.34
   Check your dev/nvme0n1 from above print and run below command:
   ```
Now, For VTA Testing use wd-nvme-host-app(https://github.com/antmicro/wd-nvme-host-app) Repo. 
We can see debug prints in both console. 


   
   
   
