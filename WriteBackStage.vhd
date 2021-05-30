LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

ENTITY WriteBackStage IS
    PORT (
        clock : IN std_logic;
        memoryOut : IN std_logic_vector (31 DOWNTO 0);
        aluOut : IN std_logic_vector (31 DOWNTO 0);
        memoryToReg : IN std_logic;
        writeAddress : INOUT std_logic_vector (3 DOWNTO 0);
        writeData : OUT std_logic_vector (31 DOWNTO 0)

    );
END WriteBackStage;

ARCHITECTURE rtl OF WriteBackStage IS
    
BEGIN
    PROCESS (clock)
    BEGIN
        IF falling_edge(clock) THEN
            IF memoryToReg = '1' THEN
                writeData <= memoryOut;
            ELSE 
                writeData <= aluOut;
            END IF;
        END IF;
    END PROCESS;
END rtl;
