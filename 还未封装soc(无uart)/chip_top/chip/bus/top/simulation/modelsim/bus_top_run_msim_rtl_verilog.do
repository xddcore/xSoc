transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/FPGA/code/xSoc/chip_top/chip/bus/top {E:/FPGA/code/xSoc/chip_top/chip/bus/top/bus_top.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/code/xSoc/chip_top/chip/bus/bus_slave_mux {E:/FPGA/code/xSoc/chip_top/chip/bus/bus_slave_mux/bus_slave_mux.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/code/xSoc/chip_top/chip/bus/bus_master_mux {E:/FPGA/code/xSoc/chip_top/chip/bus/bus_master_mux/bus_master_mux.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/code/xSoc/chip_top/chip/bus/bus_arbiter {E:/FPGA/code/xSoc/chip_top/chip/bus/bus_arbiter/bus_arbiter.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/code/xSoc/chip_top/chip/bus/bus_addr_dec {E:/FPGA/code/xSoc/chip_top/chip/bus/bus_addr_dec/bus_addr_dec.v}

