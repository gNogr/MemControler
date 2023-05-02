set_global_assignment -entity "qsys_teste" -library "lib_qsys_teste" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "qsys_teste" -library "lib_qsys_teste" -name IP_TOOL_VERSION "13.0sp1"
set_global_assignment -entity "qsys_teste" -library "lib_qsys_teste" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_qsys_teste" -name SPD_FILE [file join $::quartus(sip_path) "../../qsys_teste.spd"]
set_global_assignment -library "lib_qsys_teste" -name MISC_FILE [file join $::quartus(sip_path) "../../qsys_teste.qsys"]

set_global_assignment -library "lib_qsys_teste" -name MISC_FILE [file join $::quartus(sip_path) "qsys_teste.v"]
set_global_assignment -library "lib_qsys_teste" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_controller.v"]
set_global_assignment -library "lib_qsys_teste" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_synchronizer.v"]
set_global_assignment -library "lib_qsys_teste" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_controller.sdc"]
set_global_assignment -library "lib_qsys_teste" -name MISC_FILE [file join $::quartus(sip_path) "submodules/qsys_teste_new_sdram_controller_0.v"]
set_global_assignment -library "lib_qsys_teste" -name MISC_FILE [file join $::quartus(sip_path) "submodules/qsys_teste_new_sdram_controller_0_test_component.v"]
