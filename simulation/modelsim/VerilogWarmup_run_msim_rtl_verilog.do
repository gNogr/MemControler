transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Documentos/CEFET/22.1/TCC/Quartus/install/projects/VerilogWarmup {D:/Documentos/CEFET/22.1/TCC/Quartus/install/projects/VerilogWarmup/TopLevel.v}
vlog -vlog01compat -work work +incdir+D:/Documentos/CEFET/22.1/TCC/Quartus/install/projects/VerilogWarmup {D:/Documentos/CEFET/22.1/TCC/Quartus/install/projects/VerilogWarmup/apll.v}
vlog -vlog01compat -work work +incdir+D:/Documentos/CEFET/22.1/TCC/Quartus/install/projects/VerilogWarmup {D:/Documentos/CEFET/22.1/TCC/Quartus/install/projects/VerilogWarmup/Core_one.v}
vlog -vlog01compat -work work +incdir+D:/Documentos/CEFET/22.1/TCC/Quartus/install/projects/VerilogWarmup {D:/Documentos/CEFET/22.1/TCC/Quartus/install/projects/VerilogWarmup/Teste_1.v}

