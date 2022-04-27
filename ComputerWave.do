onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /computer_tb/clock_TB
add wave -noupdate -divider {Control Unit}
add wave -noupdate /computer_tb/DUT1/uCPU/uControlUnit/CurrentState
add wave -noupdate -divider {Instruction Register}
add wave -noupdate /computer_tb/DUT1/uCPU/IR_Load
add wave -noupdate /computer_tb/DUT1/uCPU/IR
add wave -noupdate -divider {Memory Address Register}
add wave -noupdate /computer_tb/DUT1/uCPU/MAR_Load
add wave -noupdate /computer_tb/DUT1/uCPU/uDataPath/MAR
add wave -noupdate -divider {Program Counter}
add wave -noupdate /computer_tb/DUT1/uCPU/PC_Load
add wave -noupdate /computer_tb/DUT1/uCPU/PC_Inc
add wave -noupdate /computer_tb/DUT1/uCPU/uDataPath/PC
add wave -noupdate -divider {General Purpose Registers}
add wave -noupdate /computer_tb/DUT1/uCPU/A_Load
add wave -noupdate /computer_tb/DUT1/uCPU/uDataPath/A
add wave -noupdate /computer_tb/DUT1/uCPU/B_Load
add wave -noupdate /computer_tb/DUT1/uCPU/uDataPath/B
add wave -noupdate -divider {Bus System}
add wave -noupdate -radix binary /computer_tb/DUT1/uCPU/Bus1_Sel
add wave -noupdate /computer_tb/DUT1/uCPU/uDataPath/Bus1
add wave -noupdate -radix binary /computer_tb/DUT1/uCPU/Bus2_Sel
add wave -noupdate /computer_tb/DUT1/uCPU/uDataPath/Bus2
add wave -noupdate -divider {Memory System}
add wave -noupdate /computer_tb/DUT1/address
add wave -noupdate /computer_tb/DUT1/uMemory/offset_address
add wave -noupdate /computer_tb/DUT1/memory_input
add wave -noupdate -radix binary /computer_tb/DUT1/uMemory/write_enable
add wave -noupdate /computer_tb/DUT1/write
add wave -noupdate /computer_tb/DUT1/memory_output
add wave -noupdate /computer_tb/DUT1/uMemory/rom_data
add wave -noupdate /computer_tb/DUT1/uMemory/rw_data
add wave -noupdate /computer_tb/DUT1/uMemory/port_in_data
add wave -noupdate -divider {ALU Signals}
add wave -noupdate /computer_tb/DUT1/uCPU/uDataPath/uALU/In1
add wave -noupdate /computer_tb/DUT1/uCPU/uDataPath/uALU/In2
add wave -noupdate -radix binary /computer_tb/DUT1/uCPU/ALU_Sel
add wave -noupdate /computer_tb/DUT1/uCPU/uDataPath/ALU_Result
add wave -noupdate /computer_tb/DUT1/uCPU/CCR_Load
add wave -noupdate -radix binary /computer_tb/DUT1/uCPU/CCR
add wave -noupdate -divider Ports
add wave -noupdate -group {Input Ports} /computer_tb/port_in_00_TB
add wave -noupdate -group {Input Ports} /computer_tb/port_in_01_TB
add wave -noupdate -group {Input Ports} /computer_tb/port_in_02_TB
add wave -noupdate -group {Input Ports} /computer_tb/port_in_03_TB
add wave -noupdate -group {Input Ports} /computer_tb/port_in_04_TB
add wave -noupdate -group {Input Ports} /computer_tb/port_in_05_TB
add wave -noupdate -group {Input Ports} /computer_tb/port_in_06_TB
add wave -noupdate -group {Input Ports} /computer_tb/port_in_07_TB
add wave -noupdate -group {Input Ports} /computer_tb/port_in_08_TB
add wave -noupdate -group {Input Ports} /computer_tb/port_in_09_TB
add wave -noupdate -group {Input Ports} /computer_tb/port_in_10_TB
add wave -noupdate -group {Input Ports} /computer_tb/port_in_11_TB
add wave -noupdate -group {Input Ports} /computer_tb/port_in_12_TB
add wave -noupdate -group {Input Ports} /computer_tb/port_in_13_TB
add wave -noupdate -group {Input Ports} /computer_tb/port_in_14_TB
add wave -noupdate -group {Input Ports} /computer_tb/port_in_15_TB
add wave -noupdate -group {Output Ports} /computer_tb/port_out_00_TB
add wave -noupdate -group {Output Ports} /computer_tb/port_out_01_TB
add wave -noupdate -group {Output Ports} /computer_tb/port_out_02_TB
add wave -noupdate -group {Output Ports} /computer_tb/port_out_03_TB
add wave -noupdate -group {Output Ports} /computer_tb/port_out_04_TB
add wave -noupdate -group {Output Ports} /computer_tb/port_out_05_TB
add wave -noupdate -group {Output Ports} /computer_tb/port_out_06_TB
add wave -noupdate -group {Output Ports} /computer_tb/port_out_07_TB
add wave -noupdate -group {Output Ports} /computer_tb/port_out_08_TB
add wave -noupdate -group {Output Ports} /computer_tb/port_out_09_TB
add wave -noupdate -group {Output Ports} /computer_tb/port_out_10_TB
add wave -noupdate -group {Output Ports} /computer_tb/port_out_11_TB
add wave -noupdate -group {Output Ports} /computer_tb/port_out_12_TB
add wave -noupdate -group {Output Ports} /computer_tb/port_out_13_TB
add wave -noupdate -group {Output Ports} /computer_tb/port_out_14_TB
add wave -noupdate -group {Output Ports} /computer_tb/port_out_15_TB
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -datasetprefix 0
update
