vsim -gui work.ex_execute_stage
# vsim -gui work.ex_execute_stage 
# Start time: 23:13:06 on May 30,2021
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.ex_execute_stage(ex_execute_stage_arch)
# Loading ieee.numeric_std(body)
# Loading work.forwardingunit(rtl)
# Loading work.ex_mux4x4(ex_mux4x4_arch)
# Loading work.ex_mux2x2(ex_mux2x2_arch)
# Loading synopsys.attributes
# Loading ieee.std_logic_misc(body)
# Loading work.ex_alu(ex_alu_arch)
# Loading work.ex_ripple_adder(arch_ripple_adder)
# Loading work.full_adder(arch_full_adder)
# Loading work.ex_register(ex_register_arch)
# Loading work.ex_jump_unit(ex_jump_unit_arch)
# ** Warning: (vsim-8684) No drivers exist on out port /ex_execute_stage/alu/flags(31 downto 3), and its initial value is not used.
# 
# Therefore, simulation behavior may occur that is not in compliance with
# 
# the VHDL standard as the initial values come from the base signal /ex_execute_stage/s_aluFlagsOut(31 downto 3).
add wave -position insertpoint  \
sim:/ex_execute_stage/AluForwarding \
sim:/ex_execute_stage/ImmVal \
sim:/ex_execute_stage/InPOrt \
sim:/ex_execute_stage/MemForwarding \
sim:/ex_execute_stage/Offset \
sim:/ex_execute_stage/RdestEM \
sim:/ex_execute_stage/RdestMW \
sim:/ex_execute_stage/RdstAddress \
sim:/ex_execute_stage/RdstVal \
sim:/ex_execute_stage/RsrcAddress \
sim:/ex_execute_stage/RsrcVal \
sim:/ex_execute_stage/WB_EM_Signal \
sim:/ex_execute_stage/WB_MW_Signal \
sim:/ex_execute_stage/clk \
sim:/ex_execute_stage/immSignal \
sim:/ex_execute_stage/inPortSignal \
sim:/ex_execute_stage/jmp \
sim:/ex_execute_stage/jmpIfZero \
sim:/ex_execute_stage/offsetSignal \
sim:/ex_execute_stage/operation \
sim:/ex_execute_stage/outputPortSignal \
sim:/ex_execute_stage/result \
sim:/ex_execute_stage/uncondtionalJmp
force -freeze sim:/ex_execute_stage/RdstAddress 0000 0
force -freeze sim:/ex_execute_stage/RdstVal 16#00000004 0
force -freeze sim:/ex_execute_stage/RsrcAddress 0001 0
force -freeze sim:/ex_execute_stage/RsrcVal 16#00000002 0
force -freeze sim:/ex_execute_stage/WB_EM_Signal 0 0
force -freeze sim:/ex_execute_stage/WB_MW_Signal 0 0
force -freeze sim:/ex_execute_stage/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/ex_execute_stage/immSignal 0 0
force -freeze sim:/ex_execute_stage/inPortSignal 0 0
force -freeze sim:/ex_execute_stage/jmpIfZero 0 0
force -freeze sim:/ex_execute_stage/offsetSignal 0 0
force -freeze sim:/ex_execute_stage/operation 01011 0
force -freeze sim:/ex_execute_stage/outputPortSignal 0 0
force -freeze sim:/ex_execute_stage/uncondtionalJmp 0 0
force -freeze sim:/ex_execute_stage/AluForwarding 16#00000005 0
force -freeze sim:/ex_execute_stage/ImmVal 16#00000006 0
force -freeze sim:/ex_execute_stage/InPOrt 16#00000007 0
force -freeze sim:/ex_execute_stage/MemForwarding 16#00000008 0
force -freeze sim:/ex_execute_stage/Offset 16#00000009 0
force -freeze sim:/ex_execute_stage/RdestEM 1000 0
force -freeze sim:/ex_execute_stage/RdestMW 1001 0
run

force -freeze sim:/ex_execute_stage/RsrcAddress 1000 0
run
force -freeze sim:/ex_execute_stage/WB_EM_Signal 1 0
run
force -freeze sim:/ex_execute_stage/WB_MW_Signal 1 0
force -freeze sim:/ex_execute_stage/RsrcAddress 1001 0
force -freeze sim:/ex_execute_stage/operation 01101 0
run
force -freeze sim:/ex_execute_stage/jmpIfZero 1 0
run

