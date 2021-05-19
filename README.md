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
   In order to synthesize the project automatically uncomment the last four lines in the `project.tcl` file.
   After building and uploading the bitstream to the device make sure you have the NVMe target controller software loaded on the RPU which is necessary for the standard NVMe Linux driver to detect the board as a NVMe device.
   Refer to the [NVMe test platform documentation](https://github.com/antmicro/wd-nvme-tc-sw/releases) for instructions how to build and setup the board. 

