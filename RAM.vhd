LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

ENTITY RAM IS
    PORT (
        clock : IN std_logic;
        address : IN std_logic_vector (19 DOWNTO 0);
        dataIN : IN std_logic_vector (31 DOWNTO 0);
        dataOUT : OUT std_logic_vector (31 DOWNTO 0);
        writeEnable : IN std_logic
    );
END RAM;

ARCHITECTURE rtl OF RAM IS
    TYPE mem IS ARRAY(0 TO 1024 * 1024 - 1) OF std_logic_vector(15 DOWNTO 0);
    SIGNAL ram_block : mem;
BEGIN
    PROCESS (clock)
    BEGIN
        IF rising_edge(clock) THEN
            IF (writeEnable = '1') THEN
                ram_block(to_integer(unsigned(address))) <= dataIN(31 downto 16);
                ram_block(to_integer(unsigned(address) + 1)) <= dataIN(15 downto 0);
            END IF;

        END IF;
    END PROCESS;
    dataOUT <= ram_block(to_integer(unsigned(address))) & ram_block(to_integer(unsigned(address)) + 1);
END rtl;