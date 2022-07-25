# alkali-csd-hw

This repository contains sources of the alkali-csd-hw project, which can be
used to generate the bitstream for the Western Digital NVMe accelerator test
platform (Basalt board). The project includes a chisel module containing
the logic for the NVMe registers and the main design with VTA accelerator
created for Xilinx Vivado 2019.2.

The register description is auto-generated from the NVMe documentation and,
together with the rest of the chisel design, is converted to Verilog.
Finally all the Verilog sources are attached to the Vivado project and
are used to generate the bitstream for the Basalt board.

# Repository structure

The diagram below presents the simplified structure of this repository and
includes the most important files and directories.

```
.
├── chisel
│   ├── build.sbt
│   ├── Makefile
│   └── src
│      ├── main
│      │   └── scala
│      │       └── NVMeCore
│      │           ├── NVMeTop.scala
│      │           └── ...
│      └── test
│          └── scala
│              └── NVMeCore
│                  └── ...
├── docs
├── hw.dockerfile
├── Makefile
├── tests
├── third-party
│   ├── registers-generator
│   └── verilog-pcie
└── vivado
    ├── build_project.sh
    ├── ip_repo
    ├── src
    │   ├── bd
    │   ├── constrs
    │   ├── hdl
    │   │   ├── top.v
    │   │   └── ...
    │   └── ip
    └── tools
```

* `chisel/` - contains chisel code of the logic implementing NVMe registers.
  `build.sbt` is the build configuration for the scala package with the design.
  The `Makefile` inside this directory contains main rules for launching
  the Verilog generation and running the tests. The main design sources and
  tests can be found inside the `src/` directory in the `main/` and `test/`
  subdirectories respectively.

* `docs/` - contains the documentation related to the `alkali-csd-hw` project.

* `hw.dockerfile` - a Dockerfile for building docker images with all the
  tools required to build and test the project.

* `Makefile` - file containing all the rules used to manage the repository.
  Type `make help` to display all the documented rules that can be used
  inside the project.

* `tests/` - contains test software that can help developing
  the hardware setup for Basalt boards.

* `third-party/` - the directory used to store all external projects used as
  a part of the `alkali-csd-hw` project. The `register-generator` directory
  contains scripts used to parse the NVMe specification and generate
  the NVMe registers in chisel. The `verilog-pcie`, on the other hand,
  holds the PCIe IP-cores used in the design for the Basat board.

* `vivado` - contains the main Vivado design. The `build_project.sh` is
  a helper script used to build the Vivado design. The `ip_repo/` subdirectory
  contains the sources of the custom IP-cores added to the design including
  the VTA accelerator. The `src` holds the most important files required
  for Vivado to build the entire project, including block design
  specification (`bd`), constraints (`constrs`),
  Vivado IP-core definitions (`ip`) and custom HDL sources (`hdl`).

# Prerequisites

To build the design you have to have `Vivado 2019.2` binary available in your
system path. Additionally, you will need a few system packages.
You can install them using the following commands:

```
sudo apt update -y
sudo apt install -y curl default-jdk git make python3 python3-pip wget
```

Then, install the required python packages:
```
pip3 install -r requirements.txt
```

# Usage

To generate the bitstream for the alkali board simply use:
```
make all
```
The final `project_vta.bit` bitstream can be found inside the `build` directory
after the `make all` completes.

Other useful targets that allow the various parts of the project to be built,
can be listed using `make help`.
