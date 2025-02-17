# TCL File Generated by Component Editor 18.0
# Fri Feb 07 22:40:33 EST 2020
# DO NOT MODIFY


# 
# lda_system "lda_system" v1.0
#  2020.02.07.22:40:33
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module lda_system
# 
set_module_property DESCRIPTION ""
set_module_property NAME lda_system
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME lda_system
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL lda_system
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file asc_control.sv SYSTEM_VERILOG PATH lda/asc_control.sv
add_fileset_file asc_datapath.sv SYSTEM_VERILOG PATH lda/asc_datapath.sv
add_fileset_file avalon_slave_controller.sv SYSTEM_VERILOG PATH lda/avalon_slave_controller.sv
add_fileset_file lda_control.sv SYSTEM_VERILOG PATH lda/lda_control.sv
add_fileset_file lda_datapath.sv SYSTEM_VERILOG PATH lda/lda_datapath.sv
add_fileset_file lda_system.sv SYSTEM_VERILOG PATH lda/lda_system.sv TOP_LEVEL_FILE
add_fileset_file line_drawing_algorithm.sv SYSTEM_VERILOG PATH lda/line_drawing_algorithm.sv
add_fileset_file vga_adapter.sdc SDC PATH lda/vga_adapter.sdc
add_fileset_file vga_adapter.sv SYSTEM_VERILOG PATH lda/vga_adapter.sv
add_fileset_file vga_input.sv SYSTEM_VERILOG PATH lda/vga_input.sv
add_fileset_file vga_memory.sv SYSTEM_VERILOG PATH lda/vga_memory.sv
add_fileset_file vga_output.sv SYSTEM_VERILOG PATH lda/vga_output.sv
add_fileset_file vgapll.v VERILOG PATH lda/vgapll.v


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point s1
# 
add_interface s1 avalon end
set_interface_property s1 addressUnits WORDS
set_interface_property s1 associatedClock clock
set_interface_property s1 associatedReset reset
set_interface_property s1 bitsPerSymbol 8
set_interface_property s1 burstOnBurstBoundariesOnly false
set_interface_property s1 burstcountUnits WORDS
set_interface_property s1 explicitAddressSpan 0
set_interface_property s1 holdTime 0
set_interface_property s1 linewrapBursts false
set_interface_property s1 maximumPendingReadTransactions 0
set_interface_property s1 maximumPendingWriteTransactions 0
set_interface_property s1 readLatency 0
set_interface_property s1 readWaitTime 1
set_interface_property s1 setupTime 0
set_interface_property s1 timingUnits Cycles
set_interface_property s1 writeWaitTime 0
set_interface_property s1 ENABLED true
set_interface_property s1 EXPORT_OF ""
set_interface_property s1 PORT_NAME_MAP ""
set_interface_property s1 CMSIS_SVD_VARIABLES ""
set_interface_property s1 SVD_ADDRESS_GROUP ""

add_interface_port s1 avs_s1_address address Input 3
add_interface_port s1 avs_s1_read read Input 1
add_interface_port s1 avs_s1_write write Input 1
add_interface_port s1 avs_s1_readdata readdata Output 32
add_interface_port s1 avs_s1_writedata writedata Input 32
add_interface_port s1 avs_s1_waitrequest waitrequest Output 1
set_interface_assignment s1 embeddedsw.configuration.isFlash 0
set_interface_assignment s1 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment s1 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment s1 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point vga_r
# 
add_interface vga_r conduit end
set_interface_property vga_r associatedClock clock
set_interface_property vga_r associatedReset ""
set_interface_property vga_r ENABLED true
set_interface_property vga_r EXPORT_OF ""
set_interface_property vga_r PORT_NAME_MAP ""
set_interface_property vga_r CMSIS_SVD_VARIABLES ""
set_interface_property vga_r SVD_ADDRESS_GROUP ""

add_interface_port vga_r coe_VGA_R_export export Output 8


# 
# connection point vga_g
# 
add_interface vga_g conduit end
set_interface_property vga_g associatedClock clock
set_interface_property vga_g associatedReset ""
set_interface_property vga_g ENABLED true
set_interface_property vga_g EXPORT_OF ""
set_interface_property vga_g PORT_NAME_MAP ""
set_interface_property vga_g CMSIS_SVD_VARIABLES ""
set_interface_property vga_g SVD_ADDRESS_GROUP ""

add_interface_port vga_g coe_VGA_G_export export Output 8


# 
# connection point vga_b
# 
add_interface vga_b conduit end
set_interface_property vga_b associatedClock clock
set_interface_property vga_b associatedReset ""
set_interface_property vga_b ENABLED true
set_interface_property vga_b EXPORT_OF ""
set_interface_property vga_b PORT_NAME_MAP ""
set_interface_property vga_b CMSIS_SVD_VARIABLES ""
set_interface_property vga_b SVD_ADDRESS_GROUP ""

add_interface_port vga_b coe_VGA_B_export export Output 8


# 
# connection point vga_hs
# 
add_interface vga_hs conduit end
set_interface_property vga_hs associatedClock clock
set_interface_property vga_hs associatedReset ""
set_interface_property vga_hs ENABLED true
set_interface_property vga_hs EXPORT_OF ""
set_interface_property vga_hs PORT_NAME_MAP ""
set_interface_property vga_hs CMSIS_SVD_VARIABLES ""
set_interface_property vga_hs SVD_ADDRESS_GROUP ""

add_interface_port vga_hs coe_VGA_HS_export export Output 1


# 
# connection point vga_vs
# 
add_interface vga_vs conduit end
set_interface_property vga_vs associatedClock clock
set_interface_property vga_vs associatedReset ""
set_interface_property vga_vs ENABLED true
set_interface_property vga_vs EXPORT_OF ""
set_interface_property vga_vs PORT_NAME_MAP ""
set_interface_property vga_vs CMSIS_SVD_VARIABLES ""
set_interface_property vga_vs SVD_ADDRESS_GROUP ""

add_interface_port vga_vs coe_VGA_VS_export export Output 1


# 
# connection point vga_sync_n
# 
add_interface vga_sync_n conduit end
set_interface_property vga_sync_n associatedClock clock
set_interface_property vga_sync_n associatedReset ""
set_interface_property vga_sync_n ENABLED true
set_interface_property vga_sync_n EXPORT_OF ""
set_interface_property vga_sync_n PORT_NAME_MAP ""
set_interface_property vga_sync_n CMSIS_SVD_VARIABLES ""
set_interface_property vga_sync_n SVD_ADDRESS_GROUP ""

add_interface_port vga_sync_n coe_VGA_SYNC_N_export export Output 1


# 
# connection point vga_blank_n
# 
add_interface vga_blank_n conduit end
set_interface_property vga_blank_n associatedClock clock
set_interface_property vga_blank_n associatedReset ""
set_interface_property vga_blank_n ENABLED true
set_interface_property vga_blank_n EXPORT_OF ""
set_interface_property vga_blank_n PORT_NAME_MAP ""
set_interface_property vga_blank_n CMSIS_SVD_VARIABLES ""
set_interface_property vga_blank_n SVD_ADDRESS_GROUP ""

add_interface_port vga_blank_n coe_VGA_BLANK_N_export export Output 1


# 
# connection point vga_clk
# 
add_interface vga_clk conduit end
set_interface_property vga_clk associatedClock clock
set_interface_property vga_clk associatedReset ""
set_interface_property vga_clk ENABLED true
set_interface_property vga_clk EXPORT_OF ""
set_interface_property vga_clk PORT_NAME_MAP ""
set_interface_property vga_clk CMSIS_SVD_VARIABLES ""
set_interface_property vga_clk SVD_ADDRESS_GROUP ""

add_interface_port vga_clk coe_VGA_CLK_export export Output 1

