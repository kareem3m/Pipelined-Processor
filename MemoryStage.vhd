LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY MemoryStage IS
    PORT (
        clock, memoryWrite, pop, push : IN std_logic;
        dataIN : IN std_logic_vector(31 DOWNTO 0);
        dataOUT : OUT std_logic_vector(31 DOWNTO 0);
        address : IN std_logic_vector(19 DOWNTO 0);
        resetSP : IN std_logic
    );
END MemoryStage;

ARCHITECTURE rtl OF MemoryStage IS
    COMPONENT RAM
        PORT (
            clock : IN std_logic;
            address : IN std_logic_vector (19 DOWNTO 0);
            dataIN : IN std_logic_vector (31 DOWNTO 0);
            dataOUT : OUT std_logic_vector (31 DOWNTO 0);
            writeEnable : IN std_logic
        );
    END COMPONENT;
    COMPONENT REG
        GENERIC (
            N : integer
        );
        PORT (
            clock, clear, enable : IN std_logic;
            d : IN std_logic_vector(N - 1 DOWNTO 0);
            q : OUT std_logic_vector(N - 1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL memoryAddress : std_logic_vector(19 DOWNTO 0);
    SIGNAL writeEnable : std_logic;
    SIGNAL SPIN, SPOUT : std_logic_vector(19 DOWNTO 0);
    SIGNAL SPOUTplus2 : std_logic_vector(19 DOWNTO 0);
    SIGNAL SPOUTminus2 : std_logic_vector(19 DOWNTO 0);
BEGIN
    memory : RAM PORT MAP(clock => clock, address => memoryAddress, dataIN => dataIN, dataOUT => dataOUT, writeEnable => writeEnable);
    SP : REG GENERIC MAP(N => 20) PORT MAP(clock => clock, clear => '0', enable => '1', d => SPIN, q => SPOUT);

    writeEnable <= memoryWrite OR push;

    memoryAddress <= SPOUT WHEN pop = '1' AND push = '0'
        ELSE SPOUTminus2 WHEN push = '1' AND pop = '0'
        ELSE address;

    SPIN <= x"FFFFD" WHEN resetSP = '1'
        ELSE SPOUTminus2 WHEN push = '1'
        ELSE SPOUTplus2 WHEN pop = '1'
        ELSE SPOUT;

    SPOUTplus2 <= std_logic_vector(unsigned(SPOUT) + 2);
    SPOUTminus2 <= std_logic_vector(unsigned(SPOUT) - 2);
END rtl;