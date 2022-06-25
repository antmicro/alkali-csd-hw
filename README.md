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
   cp pcie_us_axis_cq_demux.v verilog-pcie/rtl/.
   popd
   ```

5. This will help you to generate vivado project for alkali design with vta.
   ```bash
   Run below command to generate vivado project.
   ./git/build_project.sh arg1 arg2
   where arg1 - vta 
         arg2 - BAR size with unit(e.g. 64MB)
   If you are not giving arg2 then it will consider 16MB bar size.
   ```

6. For Debug Prints and Testing UART part please follow **"ReadMe_For_Run_Shell.md"** file.


   The project will be restored in the `project_vta` folder.
   After building and uploading the bitstream to the device make sure you have the NVMe target controller software loaded on the RPU which is necessary for the standard NVMe Linux driver to detect the board as a NVMe device.
   Refer to the [NVMe test platform documentation](https://github.com/antmicro/wd-nvme-tc-sw/releases) for instructions how to build and setup the board. 

