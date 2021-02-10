# ETROC1_TELE4

## ETROC1 Pixel Array board 

4 board telescope for Fermilab Test Beam

Hardware target: Xilinx Dev Board KC705 (XC7K325T-2FFG900C)

This is NOT a Vivado "Project"... it cannot be loaded in the Vivado GUI.
To build the project invoke Vivado from the command line and execute the TCL script in batch mode:

$ vivado -mode tcl -source vivado_batch.tcl

Ryan Rivera's OEI Ethernet Interface is used on this project. Use the KC705 SFP fiber module for the network connection (1000BASE-SX).



