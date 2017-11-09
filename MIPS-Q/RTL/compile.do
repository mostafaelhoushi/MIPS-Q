vlib work
vmap system work

--
--  Compile the VHDL files
--

vcom -2008 -explicit -work work riscpackage.vhd
vcom -2008 -explicit -work work mempartPackage.vhd
vcom -2008 -explicit -work work mempart.vhd
vcom -2008 -explicit -work work controller.vhd
vcom -2008 -explicit -work work intBusSM.vhd
vcom -2008 -explicit -work work ifetch.vhd
vcom -2008 -explicit -work work idecode.vhd
vcom -2008 -explicit -work work execute.vhd
vcom -2008 -explicit -work work memstage.vhd
vcom -2008 -explicit -work work myrisc.vhd
vcom -2008 -explicit -work work test.vhd


