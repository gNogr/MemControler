## Generated SDC file "D:/Documentos/CEFET/22.1/TCC/Quartus/install/projects/VerilogWarmup/output_files/TopLevel.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"

## DATE    "Fri Mar 10 08:53:48 2023"

##
## DEVICE  "EP2C35F672C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

derive_pll_clocks -create_base_clocks


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  0.000 [get_ports {KEY[3]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_ADDR[10]}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_CAS_N}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[0]}]  0.000 [get_ports {DRAM_CLK}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_DQ[0]}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_DQ[1]}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_DQ[2]}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_DQ[3]}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_DQ[4]}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_DQ[5]}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_DQ[6]}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_DQ[7]}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_DQ[8]}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_DQ[9]}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_DQ[10]}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_DQ[11]}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_DQ[12]}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_DQ[13]}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_DQ[14]}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_DQ[15]}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_RAS_N}]
set_output_delay -add_delay  -clock [get_clocks {a|altpll_component|pll|clk[1]}]  5.000 [get_ports {DRAM_WE_N}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path -to [get_ports {HEX7[7] HEX0[0] HEX0[1] HEX0[2] HEX0[3] HEX0[4] HEX0[5] HEX0[6] HEX0[7] HEX1[0] HEX1[1] HEX1[2] HEX1[3] HEX1[4] HEX1[5] HEX1[6] HEX1[7] HEX2[0] HEX2[1] HEX2[2] HEX2[3] HEX2[4] HEX2[5] HEX2[6] HEX2[7] HEX3[0] HEX3[1] HEX3[2] HEX3[3] HEX3[4] HEX3[5] HEX3[6] HEX3[7] HEX4[0] HEX4[1] HEX4[2] HEX4[3] HEX4[4] HEX4[5] HEX4[6] HEX4[7] HEX5[0] HEX5[1] HEX5[2] HEX5[3] HEX5[4] HEX5[5] HEX5[6] HEX5[7] HEX6[0] HEX6[1] HEX6[2] HEX6[3] HEX6[4] HEX6[5] HEX6[6] HEX6[7] HEX7[0] HEX7[1] HEX7[2] HEX7[3] HEX7[4] HEX7[5] HEX7[6]}]
set_false_path -to [get_ports {LEDR[17] LEDG[0] LEDG[1] LEDG[2] LEDG[3] LEDG[4] LEDG[5] LEDG[6] LEDG[7] LEDG[8] LEDR[0] LEDR[1] LEDR[2] LEDR[3] LEDR[4] LEDR[5] LEDR[6] LEDR[7] LEDR[8] LEDR[9] LEDR[10] LEDR[11] LEDR[12] LEDR[13] LEDR[14] LEDR[15] LEDR[16]}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************

set_max_delay -from [get_keepers {core_one:c|command[3]}] -to [get_ports {DRAM_RAS_N}] 5.000
set_max_delay -from [get_keepers {core_one:c|command[2]}] -to [get_ports {DRAM_CAS_N}] 5.000
set_max_delay -from [get_keepers {core_one:c|command[1]}] -to [get_ports {DRAM_WE_N}] 5.000
set_max_delay -from [get_keepers {core_one:c|command[0]}] -to [get_ports {DRAM_ADDR[10]}] 5.000


#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

