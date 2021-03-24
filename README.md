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
   
4. Create project tcl file:
   ```bash
   git/tools/generate_project.sh > project.tcl
   ```

5. Restore the project:
   ```bash
   vivado -mode batch -source project.tcl
   ```

   The project will be restored in the `project_1` folder.
   If order to synthesize the project automatically uncomment the last four lines in the `project.tcl` file.

