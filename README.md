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
* [**Testbench for TinyCPU IP Package**](https://github.com/isabelgarciav/CPU-en-FPGA/blob/main/tb_tiny_CPU.vhd)
* [**Testbench for the entire block diagram**](https://github.com/isabelgarciav/CPU-in-FPGA/blob/main/tb_general.vhd)
* [**Vitis Application**](https://github.com/isabelgarciav/CPU-en-FPGA/blob/main/helloworld.c) (still working on it)

## Steps
Follow the same steps described in the repository with the following changes:
### In Vivado
* In the source file from the repository *tiny_CPU.vhd* assigned a default value to *instream_tinycpu_enable* signal. This line should look like this:

  > instream_tinycpu_enable:   in std_logic:='1';
* Delete the DDR external pin of the ZYNQ Processing System Block.
* After adding the preset from the repository in Run Block Automatio deselect *Apply Board Preset*.
* Before creating a wrapper *Generate Output Products* of the block design.

## Top level design
![image](https://github.com/user-attachments/assets/87beab06-dd04-4640-8b3c-736e3d2c7741)

## Testbench results
![image](https://github.com/user-attachments/assets/4ce229cf-cc4d-4d39-91fa-d13969a8c465)
![image](https://github.com/user-attachments/assets/a99af467-5264-4c86-b770-ce89b7b6784e)



