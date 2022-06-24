Using Alkl_shell.py file we can debug u-boot/linux (zynqmp/buildroot) console without use of JTAG USB cable. 

For Run Script, We need to use below Command. 

1. We need u-boot (zynqmp) console for boot linux for this use below command. 
   
   ```bash 
   ./alkl_shell.py zynqmp 
   ```

   After Run this Script press " ENTER " and write " boot " (For boot linux) 

   E.g.  
   root@joy-Z390-D:/mnt/Joy/repo_alkali# ./alkl_shell.py zynqmp
   Press ENTER for Console
   ff00000
   Bootmode: QSPI_MODE
   Reset reason:	EXTERNAL 
   Net:   No
   
   ZynqMP> 
   
   ZynqMP> boot
   boot
   SF: Detected n25q00a with page size 256 Bytes, erase size 64 KiB,total 128 MiB
   device 0 offset 0x3080000, size 0x80000
   SF: 524288 bytes @ 0x3080000 Read: OK
   ## Executing script at 20000000
   ## Loading init Ramdisk from Legacy Image at 02100000 ...
      Imae Name:   
      Image Type:   AArch64 Linux RAMDisk Image (uncompressed)
      Data Size:    21121471 Bytes = 20.1 MiB
      Load Address: 00000000
      Entry Point:  00000000
      Verifying Checksum ... OK
   ## Flattened Device Tree blob at 40000000
      Booting using te fdt blob at 0x40000000
      Loading Ramdisk to 5ebdb000, end 5ffff9bf ... OK
   ERROR: reserving fdt memory region failed (addr=60000000 size=1ff0000)
      Loading Device Tree to 000000005ebd1000, end 000000005ebdacd9 ... OK
   
   Starting kernel ...

```bash   
Note : Do Not close this this script and terminal. Please use another terminal or tab for run below command. 
```

2. We need to open buildroot(linux) console for load NVMe driver. 
   
   ```bash
   ./alkl_shell.py buildroot
   ```

   After run this command below message is coming and use "root" as password. 

   Welcome to Buildroot
   buildroot login: root
   
   For Load NVMe driver run command in console.

   # reload.sh

   reload.sh
   killall: apu-app: no process killed
   sh:[   11.578278] remoteproc remoteproc0: powering up r5@0
   [   11.579302] remoteproc remoteproc0: Booting fw image zephyr.elf, size 1072824
   [   11.585142]  r5@0: RPU boot from TCM.
   [   11.588534] virtio_rpmsg_bus virtio0: rpmsg host is online
   [   11.588647] remoteproc remoteproc0: registered virtio0 (type 7)
   [   11.588701] remoteproc remoteproc0: remote processor r5@0 is now up
    write error: Invalid argument
   [   19.355299] virtio_rpmsg_bus virtio0: creating channel rpmsg-openamp-nvme-channel addr 0x0
   # rpmsg initialization start
   Opening file rpmsg_ctrl0.
   checking /sys/class/rpmsg/rpmsg_ctrl0/rpmsg0/name
   svc_name: rpmsg-openamp-nvme-channel
   .
   Succesfully opened XLNK device (/dev/xlnk, 6)

Now, For VTA Testing use wd-nvme-host-app(https://github.com/antmicro/wd-nvme-host-app) Repo. 
We can see debug prints in both console. 


   
   
   
