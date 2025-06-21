vlib work
vlog fpu_simple.sv fpu_simple_tb.sv
vsim fpu_simple_tb

add wave -divider "Entradas"
add wave -hex /fpu_simple_tb/A
add wave -hex /fpu_simple_tb/B
add wave -bin /fpu_simple_tb/op_sel
add wave -bin /fpu_simple_tb/reset_n
add wave /fpu_simple_tb/clk

add wave -divider "Saidas"
add wave -hex /fpu_simple_tb/RESULT
add wave -bin /fpu_simple_tb/STATUS

add wave -divider "Val Inter da FPU"
add wave -hex /fpu_simple_tb/dut.exp_a
add wave -hex /fpu_simple_tb/dut.exp_b
add wave -hex /fpu_simple_tb/dut.mant_a_raw
add wave -hex /fpu_simple_tb/dut.mant_b_raw
add wave -hex /fpu_simple_tb/dut.exp_res
add wave -hex /fpu_simple_tb/dut.mant_res
add wave -bin /fpu_simple_tb/dut.result_sign

run -all

