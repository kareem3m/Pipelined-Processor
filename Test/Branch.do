vsim -gui work.integration(rtl)
# vsim 
# Start time: 02:56:56 on Jun 05,2021
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.integration(rtl)
# Loading work.fetchstage(rtl)
# Loading work.ram(rtl)
# Loading work.reg(rtl)
# Loading work.falling_register(falling_register_arch)
# Loading work.decodestage(dec)
# Loading work.controlunit(control)
# Loading work.hazarddetectionunit(hazarddetection)
# Loading work.ex_execute_stage(ex_execute_stage_arch)
# Loading work.ex_forwarding_unit(rtl)
# Loading work.ex_mux4x4(ex_mux4x4_arch)
# Loading work.ex_mux2x2(ex_mux2x2_arch)
# Loading synopsys.attributes
# Loading ieee.std_logic_misc(body)
# Loading work.ex_alu(ex_alu_arch)
# Loading work.ex_ripple_adder(arch_ripple_adder)
# Loading work.full_adder(arch_full_adder)
# Loading work.ex_jump_unit(ex_jump_unit_arch)
# ** Warning: Design size of 11287 statements or 100 leaf instances exceeds ModelSim PE Student Edition recommended capacity.
# Expect performance to be quite adversely affected.
add wave -position insertpoint  \
sim:/integration/clock \
sim:/integration/RST \
sim:/integration/OutPort \
sim:/integration/InPort \
sim:/integration/noChange \
sim:/integration/PCIN \
sim:/integration/PCOUT \
sim:/integration/IR \
sim:/integration/RD_Buffer \
sim:/integration/RS_Buffer \
sim:/integration/SGIN_Buffer \
sim:/integration/control_Buffer \
sim:/integration/Address_Buffer \
sim:/integration/flagRegister \
sim:/integration/aluResult \
sim:/integration/memoryRead \
sim:/integration/memoryWrite \
sim:/integration/pop \
sim:/integration/push \
sim:/integration/memoryIN \
sim:/integration/memoryOUT \
sim:/integration/resetSP \
sim:/integration/writeAddress \
sim:/integration/memoryBuffer \
sim:/integration/writeBackData \
sim:/integration/writeBackAddress \
sim:/integration/writeBackSignal
mem load -i N:/3rdyear/Pipelined-Processor/Assembler/output.mem /integration/FetchStagePort/instructionsMemory/ram_block
add wave -position insertpoint  \
sim:/integration/RST \
sim:/integration/OutPort \
sim:/integration/InPort \
sim:/integration/noChange \
sim:/integration/s_jmp \
sim:/integration/PCIN \
sim:/integration/PCOUT \
sim:/integration/IR \
sim:/integration/RD_Buffer \
sim:/integration/RS_Buffer \
sim:/integration/SGIN_Buffer \
sim:/integration/control_Buffer \
sim:/integration/Address_Buffer \
sim:/integration/aluResult \
sim:/integration/memoryRead \
sim:/integration/memoryWrite \
sim:/integration/pop \
sim:/integration/push \
sim:/integration/memoryIN \
sim:/integration/memoryOUT \
sim:/integration/resetSP \
sim:/integration/writeAddress \
sim:/integration/memoryBuffer \
sim:/integration/writeBackData \
sim:/integration/writeBackAddress \
sim:/integration/writeBackSignal \
sim:/integration/DecodeStagePort/R0/q \
sim:/integration/DecodeStagePort/R1/q \
sim:/integration/DecodeStagePort/R2/q \
sim:/integration/DecodeStagePort/R3/q \
sim:/integration/DecodeStagePort/R4/q \
sim:/integration/DecodeStagePort/R5/q \
sim:/integration/DecodeStagePort/R6/q \
sim:/integration/DecodeStagePort/R7/q 

force -freeze sim:/integration/RST 1 0
force -freeze sim:/integration/noChange 0 0
force -freeze sim:/integration/InPort 32'h30 0
force -freeze sim:/integration/clock 1 0, 0 {50 ns} -r 100
run
force -freeze sim:/integration/RST 0 0
run 
run
run
force -freeze sim:/integration/InPort 32'h50 0
run
force -freeze sim:/integration/InPort 32'hF100 0

run
force -freeze sim:/integration/InPort 32'h300 0

# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 250 ns  Iteration: 2  Instance: /integration/ExecuteStagePort/l_alu
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 250 ns  Iteration: 2  Instance: /integration/ExecuteStagePort/l_alu
# ** Fatal: (vsim-3734) Index value 32 is out of range 31 downto 0.
#    Time: 250 ns  Iteration: 2  Process: /integration/ExecuteStagePort/l_alu/line__60 File: N:/3rdyear/Pipelined-Processor/Ex_ALU.vhd
# Fatal error in Architecture Ex_ALU_Arch at N:/3rdyear/Pipelined-Processor/Ex_ALU.vhd line 66
# 
# HDL call sequence:
# Stopped at N:/3rdyear/Pipelined-Processor/Ex_ALU.vhd 66 Architecture Ex_ALU_Arch
# 
# Compile of ControlUnit.vhd was successful.
# Compile of DecodeStage.vhd was successful.
# Compile of Ex_ALU.vhd was successful.
# Compile of EX_execute_stage.vhd was successful.
# Compile of Ex_forwarding_unit.vhd was successful.
# Compile of Ex_jump_unit.vhd was successful.
# Compile of Ex_muxes.vhd was successful.
# Compile of Ex_register.vhd was successful.
# Compile of Ex_ripple_adder.vhd was successful.
# Compile of FetchStage.vhd was successful.
# Compile of HazardDetectionUnit.vhd was successful.
# Compile of MemoryStage.vhd was successful.
# Compile of RAM.vhd was successful.
# Compile of Reg.vhd was successful.
# Compile of WriteBackStage.vhd was successful.
# Compile of Integration.vhd was successful.
# 16 compiles, 0 failed with no errors.




