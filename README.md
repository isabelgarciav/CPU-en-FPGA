# CPU-in-FPGA
### FPGA with Xilinx Vivado 2021.1

**Authors:** Pilar Qin Ruiz Ortega and Isabel García Vázquez

**University:** University of Granada

## Materials
* The PYNQ-Z2 board featuring the ZYNQ XC7Z020-1CLG400C SoC
* Inspired by https://github.com/hajin-kim/FPGA_TinyCPU
* Vivado Design Suite 2021.1

## Codes
All source files are from the repository. We have modified those ones:
* [**Testbench**](https://github.com/isabelgarciav/CPU-en-FPGA/blob/main/tb_tiny_CPU.vhd)
* [**Vitis Application**]()

## Steps
Follow the same steps described in the repository with the following changes:
* Delete the DDR external pin of the ZYNQ Processing System Block.
* In the source file from the repository *tiny_CPU.vhd* assigned a default value to *instream_tinycpu_enable* signal. This line should look like this:

  > instream_tinycpu_enable:   in std_logic:='1';
