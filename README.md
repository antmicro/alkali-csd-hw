Restoring the Vivado project
============================

1. Setup Vivado environment:
   ```bash
   source /path/to/Vivado/2019.2/settings64.sh
   ```
   
2. Create `wd-nvme-vivado` directory and move into it:
   ```bash
   mkdir wd-nvme-vivado
   cd wd-nvme-vivado
   ```
3. Clone this repository into `git` folder:
   ```bash
   git clone <repo url> git
   ```

4. Clone submodules:
   ```bash
   pushd git
   git submodule update --init --recursive
   popd
   ```

5. Create project tcl file:
   ```bash
   git/tools/generate_project.sh > project.tcl
   ```

6. Restore the project:
   ```bash
   vivado -mode batch -source project.tcl
   ```

   The project will be restored in the `project_1` folder.
   If order to synthesize the project automatically uncomment the last four lines in the `project.tcl` file.

Building the driver
===================

This assumes that this repository is located in `git` folder and its submodueles are cloned.

1. Make sure that headers for your kernel are installed

2. Move to `git/driver/` directory

3. Build the driver:
   ```bash
   make
   ```

4. Load bitstream onto the board

5. Rescan PCIe bus
   ```bash
   echo "1" | sudo tee /sys/bus/pci/rescan
   ```

6. Load driver
   ```bash
   sudo insmod example.ko
   ```

7. Check `dmesg` for test results

8. If in `dmesg` there are errors related to mapping BARs, you can reboot your PC with the board plugged in and turned on to properly allocated BARs.
