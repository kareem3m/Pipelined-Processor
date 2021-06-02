Library ieee;
use ieee.std_logic_1164.all;

entity Ex_jump_unit is 
	port (
        uncondtionalJmp: in std_logic;
        jmpIfZero: in std_logic;
        zeroFlag: in std_logic;
        jmp: out std_logic
    );
end Ex_jump_unit;


architecture Ex_jump_unit_arch of Ex_jump_unit is
begin
    jmp <= 
    '1' when (uncondtionalJmp = '1') or (jmpIfZero = '1' and zeroFlag = '1')
    else '0';
END Ex_jump_unit_arch;