# ETROC1_TELE4

## ETROC1 Pixel Array board 

4 board telescope for Fermilab Test Beam

Hardware target: Xilinx Dev Board KC705 (XC7K325T-2FFG900C)

NOTE: this is *NOT* a Vivado "Project"... it cannot be loaded in the Vivado GUI. This project is built from the command line by invoking Vivado in batch mode and executing the TCL build script:

$ vivado -mode tcl -source vivado_batch.tcl

## Ethernet Interface

Ryan Rivera's OEI Ethernet Interface is used on this project. Use the KC705 SFP fiber module for the network connection (1000BASE-SX).

Default MAC and IP address is defined in kc705_package.vhd

## IP Modules

There is one IP module that handles a single GTX transceiver and Ethernet PCS/PMA interface. This is used by the OEI Ethernet interface.

There is another IP module that handles four GTX transceivers in one quad. These GTX transceivers are used to receive the 1.28Gbps data streams from the four ETROC1 devices.

JTO

