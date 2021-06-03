vsim -gui work.decodestage
# vsim -gui work.decodestage 
# Start time: 05:46:02 on Jun 03,2021
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.decodestage(dec)
# Loading work.reg(rtl)
# Loading work.controlunit(control)
# Loading work.hazarddetectionunit(hazarddetection)
# Loading work.falling_register(falling_register_arch)
add wave -position insertpoint  \
sim:/decodestage/Clk \
sim:/decodestage/Decode_Buffer \
sim:/decodestage/Input_Buffer \
sim:/decodestage/instruction \
sim:/decodestage/Output_Buffer \
sim:/decodestage/R0_OUT \
sim:/decodestage/R1_OUT \
sim:/decodestage/R2_OUT \
sim:/decodestage/R3_OUT \
sim:/decodestage/R4_OUT \
sim:/decodestage/R5_OUT \
sim:/decodestage/R6_OUT \
sim:/decodestage/R7_OUT \
sim:/decodestage/RD \
sim:/decodestage/RDest_Ex \
sim:/decodestage/RS \
sim:/decodestage/RST \
sim:/decodestage/SignExtend_OUT \
sim:/decodestage/WB_Address_IN \
sim:/decodestage/WB_Data_IN \
sim:/decodestage/WB_Signal
force -freeze sim:/decodestage/R0_OUT 0 0
# Value length (1) does not equal array index length (32).
# ** UI-Msg: (vsim-4011) Invalid force value: 0 0.
# 
force -freeze sim:/decodestage/R1_OUT 1 0
# Value length (1) does not equal array index length (32).
# ** UI-Msg: (vsim-4011) Invalid force value: 1 0.
# 
force -freeze sim:/decodestage/RST 0 0
force -freeze sim:/decodestage/WB_Signal 1 0
noforce sim:/decodestage/R0_OUT
noforce sim:/decodestage/R1_OUT
noforce sim:/decodestage/R2_OUT
force -freeze sim:/decodestage/Clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/decodestage/WB_Data_IN 111 0
# Value length (3) does not equal array index length (32).
# ** UI-Msg: (vsim-4011) Invalid force value: 111 0.
# 
force -freeze sim:/decodestage/WB_Data_IN 32'd7 0
force -freeze sim:/decodestage/WB_Address_IN 0000 0
run
force -freeze sim:/decodestage/WB_Data_IN 32'd9 0
force -freeze sim:/decodestage/WB_Address_IN 0010 0
run
force -freeze sim:/decodestage/instruction 00000000100000000000000000000000 0
run
run
force -freeze sim:/decodestage/instruction 10000100100000000000000000000000 0
force -freeze sim:/decodestage/instruction 10000100110000000000000000000000 0
force -freeze sim:/decodestage/WB_Data_IN 00000000000000000000000000011001 0
force -freeze sim:/decodestage/WB_Address_IN 0011 0
run
run