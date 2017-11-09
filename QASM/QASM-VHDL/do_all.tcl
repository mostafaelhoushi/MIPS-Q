vlib work
#cp ../QASM-Interpreter/program.mem .
vcom txt_util.vhd COMPLEX.vhd QUANTUM_SYSTEMS.vhd q_generator.vhd qgate1.vhd qgate2.vhd Rkqgate1.vhd CRkqgate2.vhd qmeasure.vhd qalu.vhd qprocessor.vhd testbench.vhd

for { set i 1 } { $i <= 100 } { incr i } {
   quietly set seed1 [expr {int(1 + 2147483562*rand())}]; # [1,2147483562]
   quietly set seed2 [expr {int(1 + 2147483398*rand())}]; # [1,2147483398]

   quietly set options ""

   eval vsim -novopt testbench -GgSEED1=$seed1 -GgSEED2=$seed2 qmeasure

   do wave.do

   run 2000
}