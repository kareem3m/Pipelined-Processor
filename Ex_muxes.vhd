Library ieee;
use ieee.std_logic_1164.all;

entity Ex_mux4x4 is 
	generic ( n : Integer:=32);
	port ( in0,in1,in2,in3: in std_logic_vector (n-1 downto 0);
			sel: in  std_logic_vector (1 downto 0);
			out1: out std_logic_vector (n-1 downto 0));
end Ex_mux4x4;


architecture Ex_mux4x4_arch of Ex_mux4x4 is
begin
    with Sel select
        out1 <= 
            in0 when "00",
            in1 when "01",
            in2 when "10",
            in3 when others;
END Ex_mux4x4_arch;

-------------------------------

Library ieee;
use ieee.std_logic_1164.all;

entity Ex_mux2x2 is 
	generic ( n : Integer:=32);
	port ( in0,in1: in std_logic_vector (n-1 downto 0);
			sel: in  std_logic;
			out1: out std_logic_vector (n-1 downto 0));
end Ex_mux2x2;


architecture Ex_mux2x2_arch of Ex_mux2x2 is
begin
    with Sel select
        out1 <= 
            in0 when '0',
            in1 when others;
END Ex_mux2x2_arch;