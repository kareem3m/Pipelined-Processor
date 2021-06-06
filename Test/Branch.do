vsim -gui work.integration(rtl)
add wave -position insertpoint  \
sim:/integration/clock \
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
mem load -i {D:/CMP/CMP 3/CMP 302/Architecture/phase2/Pipelined-Processor/Assembler/output.mem} /integration/FetchStagePort/instructionsMemory/ram_block
add wave -position insertpoint  \
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
#force -freeze sim:/integration/s_jmp 0 0
force -freeze sim:/integration/InPort 32'h30 0
force -freeze sim:/integration/clock 1 0, 0 {50 ps} -r 100
run
force -freeze sim:/integration/RST 0 0
run 
run
run
force -freeze sim:/integration/InPort 32'h50 0
run
force -freeze sim:/integration/InPort 32'h100 0
run
force -freeze sim:/integration/InPort 32'h300 0
run 1000
















vsim -gui work.integration(rtl)
add wave -position insertpoint  \
sim:/integration/clock \
sim:/integration/PCIN \
sim:/integration/PCOUT \
sim:/integration/IR \
sim:/integration/aluResult \
sim:/integration/control_Buffer \
sim:/integration/DecodeStagePort/R0/q \
sim:/integration/DecodeStagePort/R1/q \
sim:/integration/DecodeStagePort/R2/q \
sim:/integration/DecodeStagePort/R3/q \
sim:/integration/DecodeStagePort/R4/q \
sim:/integration/DecodeStagePort/R5/q \
sim:/integration/DecodeStagePort/R6/q \
sim:/integration/DecodeStagePort/R7/q \
sim:/integration/jmp \
sim:/integration/flagRegister \
sim:/integration/memoryIN \
sim:/integration/memoryOUT \
sim:/integration/memoryBuffer \
sim:/integration/RST \
sim:/integration/OutPort \
sim:/integration/InPort \
sim:/integration/RD_Buffer \
sim:/integration/RS_Buffer \
sim:/integration/SGIN_Buffer \
sim:/integration/Address_Buffer \
sim:/integration/memoryRead \
sim:/integration/memoryWrite \
sim:/integration/pop \
sim:/integration/push \
sim:/integration/resetSP \
sim:/integration/writeAddress \
sim:/integration/writeBackData \
sim:/integration/writeBackAddress \
sim:/integration/writeBackSignal\
mem load -i {D:/CMP/CMP 3/CMP 302/Architecture/phase2/Pipelined-Processor/Assembler/output.mem} /integration/FetchStagePort/instructionsMemory/ram_block
add wave -position insertpoint  \
sim:/integration/noChange 


force -freeze sim:/integration/RST 1 0
#force -freeze sim:/integration/noChange 0 0
#force -freeze sim:/integration/jmp 0 0
force -freeze sim:/integration/InPort 32'h30 0
force -freeze sim:/integration/clock 1 0, 0 {50 ps} -r 100
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
run 1000





