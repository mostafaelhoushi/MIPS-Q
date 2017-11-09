onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /test/clk
add wave -noupdate -format Logic /test/reset
add wave -noupdate -format Literal -radix hexadecimal /test/dut/bus_data
add wave -noupdate -format Literal -radix hexadecimal /test/dut/bus_addr
add wave -noupdate -format Logic /test/dut/bus_rd_n
add wave -noupdate -format Logic /test/dut/bus_wr_n
add wave -noupdate -format Logic /test/dut/init_n
add wave -noupdate -format Logic /test/dut/rdy_n
add wave -noupdate -divider {Instruction Fetch}
add wave -noupdate -format Literal -radix hexadecimal /test/dut/if_instr
add wave -noupdate -format Literal -radix hexadecimal /test/dut/if_ip
add wave -noupdate -format Literal /test/dut/ifetch1/intpc
add wave -noupdate -format Literal /test/dut/ifetch1/nextpc
add wave -noupdate -divider Controller
add wave -noupdate -format Literal /test/dut/ctrl_ex
add wave -noupdate -format Literal /test/dut/ctrl_id
add wave -noupdate -format Literal /test/dut/ctrl_if
add wave -noupdate -format Literal /test/dut/ctrl_mem
add wave -noupdate -format Literal /test/dut/ctrl_wb
add wave -noupdate -divider {Instruction Decode}
add wave -noupdate -format Logic /test/dut/idecode1/stall
add wave -noupdate -format Literal /test/dut/idecode1/op
add wave -noupdate -format Literal /test/dut/idecode1/rs
add wave -noupdate -format Literal /test/dut/idecode1/rt
add wave -noupdate -format Literal /test/dut/idecode1/rd
add wave -noupdate -format Literal /test/dut/idecode1/shift
add wave -noupdate -format Literal /test/dut/idecode1/funct
add wave -noupdate -format Literal -radix hexadecimal /test/dut/idecode1/rf_regs
add wave -noupdate -format Literal /test/dut/id_a
add wave -noupdate -format Literal /test/dut/id_b
add wave -noupdate -format Literal /test/dut/id_baddr
add wave -noupdate -format Literal /test/dut/id_ctrl_ex
add wave -noupdate -format Literal /test/dut/id_ctrl_mem
add wave -noupdate -format Literal /test/dut/id_ctrl_q
add wave -noupdate -format Literal /test/dut/id_ctrl_wb
add wave -noupdate -format Literal /test/dut/id_destreg
add wave -noupdate -format Literal /test/dut/id_imm
add wave -noupdate -format Literal /test/dut/id_ip
add wave -noupdate -format Literal /test/dut/id_qaddress1
add wave -noupdate -format Literal /test/dut/id_qaddress2
add wave -noupdate -format Literal /test/dut/id_qopcode
add wave -noupdate -format Literal /test/dut/id_qparameter1
add wave -noupdate -format Logic /test/dut/id_req
add wave -noupdate -format Literal /test/dut/id_shift
add wave -noupdate -format Logic /test/dut/id_stall
add wave -noupdate -divider Execute
add wave -noupdate -format Literal /test/dut/ex_alu
add wave -noupdate -format Literal /test/dut/ex_ctrl_mem
add wave -noupdate -format Literal /test/dut/ex_ctrl_q
add wave -noupdate -format Literal /test/dut/ex_ctrl_wb
add wave -noupdate -format Literal /test/dut/ex_data
add wave -noupdate -format Literal /test/dut/ex_destreg
add wave -noupdate -format Literal /test/dut/ex_qaddress1
add wave -noupdate -format Literal /test/dut/ex_qaddress2
add wave -noupdate -format Literal /test/dut/ex_qopcode
add wave -noupdate -format Literal /test/dut/ex_qparameter1
add wave -noupdate -divider {Memory Stage}
add wave -noupdate -format Literal /test/dut/mem_ctrl_wb
add wave -noupdate -format Literal /test/dut/mem_data
add wave -noupdate -format Literal /test/dut/mem_destreg
add wave -noupdate -divider {Quantum Processor}
add wave -noupdate -format Logic /test/dut/qprocessor1/clock
add wave -noupdate -format Logic /test/dut/qprocessor1/exec
add wave -noupdate -format Literal /test/dut/qprocessor1/measurement_reg
add wave -noupdate -format Literal /test/dut/qprocessor1/qopcode
add wave -noupdate -format Literal /test/dut/qprocessor1/parameter1
add wave -noupdate -format Literal /test/dut/qprocessor1/address1
add wave -noupdate -format Literal /test/dut/qprocessor1/address2
add wave -noupdate -format Literal /test/dut/qprocessor1/qinstruction
add wave -noupdate -format Literal /test/dut/qprocessor1/qalu1/cs
add wave -noupdate -format Literal /test/dut/qprocessor1/qalu1/qmemory
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {22341 ns} 0}
configure wave -namecolwidth 193
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {21749 ns} {22431 ns}
