# Alkali FPGA design

This repository contains FPGA design sources of the Alkali project, which can be
used to generate the bitstream for the Western Digital NVMe accelerator test
platform (AN300 board) or Xilinx ZCU106 evaluation platform.
The project includes a chisel module containing logic for the NVMe
registers and the main design with VTA accelerator
created for Xilinx Vivado 2019.2.

The register description is auto-generated from the NVMe documentation and,
together with the rest of the chisel design, is converted to Verilog.
Finally all the Verilog sources are attached to the Vivado project and
are used to generate the bitstream for the AN300 board.

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
├── registers-generator
├── third-party
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

* `docs/` - contains the documentation related to the `Alkali FPGA design`.

* `hw.dockerfile` - a Dockerfile for building docker images with all the
  tools required to build and test the project.

* `Makefile` - file containing all the rules used to manage the repository.
  Type `make help` to display all the documented rules that can be used
  inside the project.

* `tests/` - contains test software that can help developing
  the hardware setup for AN300 boards.

* `registers-generator` - contains scripts used to parse the NVMe specification
   and generate the NVMe registers in chisel.

* `third-party/` - the directory used to store all external projects used as
  a part of the `Alkali FPGA design`. The `verilog-pcie` directory holds
  the PCIe IP-cores used in the design for the Basat board.

* `vivado` - contains the main Vivado design. The `build_project.sh` is
  a helper script used to build the Vivado design. The `ip_repo/` subdirectory
  contains the sources of the custom IP-cores added to the design including
  the VTA accelerator. The `src` holds the most important files required
  for Vivado to build the entire project, including block design
  specification (`bd`), constraints (`constrs`),
  Vivado IP-core definitions (`ip`) and custom HDL sources (`hdl`).

# Prerequisites

To build this project it is recommended to use a dedicated docker container
with all the prerequisites installed. The appropriate docker image can be
created using `hw.dockerfile` provided in the `docker` directory.

Note that to build the image, you have to provide a tarball with Vivado 2019.2
installer. This file has to be placed in the
`docker/Xilinx_Vivado_2019.2_1106_2127.tar.gz` path before building the image.
It can be [downloaded](https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_Vivado_2019.2_1106_2127.tar.gz)
from the Official Xilinx Website.

After placing the file in the specified location use `make docker` to build
the image. In case you want to install all the prerequisites directly on
your machine, follow the instructions from the `hw.dockerfile`.

Use `make enter` to open the container and then execute the rest of
the commands inside it.

# Usage

**NOTE: You have to be in the dedicated docker container or have all
the prerequisites installed locally to use the instructions below correctly.
Refer to the [#Prerequisites](#prerequisites) section in case of any problems
with building the project**

Before building any target choose the desired board (`an300` or ` zcu106`),
by setting the `BOARD` environment variable:
```
export BOARD=an300
```

Then run the target that you want to compile. The list of targets is available
after running `make help`. To build all output products use:
```
make all
```
