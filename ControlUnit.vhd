LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY ControlUnit IS
    PORT (
        OpCode:IN std_logic_vector(5 DOWNTO 0);
        Immediate,Offset,Alu_EN,Mem_Read,Mem_Write,WB,Mem_To_Reg,Push,Pop,Port_in, Port_out, JMPZ, JMPU:OUT std_logic

    );
END ControlUnit;
ARCHITECTURE Control OF ControlUnit IS
begin 
-- check these values again after changing
    Mem_Read <= '1'  WHEN OpCode="100001" OR OpCode="100011"
    ELSE '0';
    Mem_Write <= '1' WHEN Opcode="100000" OR OpCode="100100"
    ELSE '0';
    Mem_To_Reg <= '1' WHEN OpCode="100001" OR OpCode="100011"
    ELSE '0';
    Push <='1' WHEN OpCode="100000" 
    ELSE '0';
    Pop <='1' WHEN OpCode="100001"
    ELSE '0';
    Offset <= '1' WHEN OpCode="100011" OR OpCode="100100"
    ELSE '0';
    Immediate <='1' WHEN Opcode="010101" OR Opcode="010110" OR OpCode="010111" OR OpCode="100010" --load immediate need aluenable to make it go through the excute buffer 1000010 ???????????
    ELSE '0';
    Alu_EN <= '1' WHEN OpCode(5 DOWNTO 4)="01" OR (OpCode(5 DOWNTO 4)= "00" AND OpCode(3 DOWNTO 0) /= "0000") OR (OpCode(5 DOWNTO 4)="10" AND (NOT(OpCode(3 DOWNTO 0) = "0000" OR OpCode(3 DOWNTO 0) = "0001")))
    ELSE '0';
    WB <='1' WHEN OpCode(5 DOWNTO 4) = "01" OR (OpCode(5 DOWNTO 4)="00" AND (NOT(OpCode(3 DOWNTO 0) = "0000" OR OpCode(3 DOWNTO 0) = "0001" OR OpCode(3 DOWNTO 0) = "0010" OR OpCode(3 DOWNTO 0) = "1000"))) OR (OpCode(5 DOWNTO 4)="10" AND (NOT(OpCode(3 DOWNTO 0) = "0000" OR OpCode(3 DOWNTO 0) = "0100"))) --out port doesn't need WB 001000
    ELSE '0';
    Port_in <= '1' WHEN OpCode = "001001"
    ELSE '0';
    Port_out <= '1' WHEN OpCode = "001000" --do we need alu enable??????????????
    ELSE '0';
    JMPZ <= '1' WHEN OpCode = "110000" 
    ELSE '0';
    JMPU <= '1' WHEN OpCode = "110011" 
    ELSE '0';
end Control;