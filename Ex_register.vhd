Library ieee;
use ieee.std_logic_1164.all;

entity Falling_register is
    generic (REG_SIZE: integer := 32);
    port(
        clk, rst, enable : in std_logic;
        d : in std_logic_vector (REG_SIZE-1 downto 0);
        q : out std_logic_vector (REG_SIZE-1 downto 0)
    );
end Falling_register;

architecture Falling_register_arch of Falling_register is
begin
    process(clk, rst, enable)
    begin
        if(enable = '1') then
            if (rst = '1') then
                q <= (others => '0');
            elsif (falling_edge(clk)) then 
                q <= d;
	        end if;
	    end if;
    end process;
end Falling_register_arch;