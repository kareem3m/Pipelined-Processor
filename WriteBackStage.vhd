LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

ENTITY WriteBackStage IS
    PORT (
        clock : IN std_logic;
        memoryOut : IN std_logic_vector (31 DOWNTO 0);
        writeAddress : IN std_logic_vector (3 DOWNTO 0);
        writeBackAddress : OUT std_logic_vector (3 DOWNTO 0);
        writeData : OUT std_logic_vector (31 DOWNTO 0);
        writeBackEnable : OUT std_logic;
        writeEnable : IN std_logic

    );
END WriteBackStage;

ARCHITECTURE rtl OF WriteBackStage IS

BEGIN
    -- PROCESS (clock)
    -- BEGIN
            writeData <= memoryOut;
            writeBackAddress <= writeAddress;
            writeBackEnable <= writeEnable;
            
    -- END PROCESS;
END rtl;
