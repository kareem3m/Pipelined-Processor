LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY MemoryStage IS
    PORT (
        clock, memoryRead, memoryWrite, pop, push, RST : IN std_logic;
        dataIN : IN std_logic_vector(31 DOWNTO 0);
        dataOUT : OUT std_logic_vector(31 DOWNTO 0);
        address : IN std_logic_vector(31 DOWNTO 0);
        resetSP : IN std_logic;
        writeAddress : IN std_logic_vector(3 DOWNTO 0);
        memoryBuffer : OUT std_logic_vector(36 DOWNTO 0);
        writeBackSignal : IN std_logic

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
    COMPONENT Falling_register
        GENERIC (REG_SIZE : integer := 37);
        PORT (
            clk, rst, enable : IN std_logic;
            d : IN std_logic_vector (REG_SIZE - 1 DOWNTO 0);
            q : OUT std_logic_vector (REG_SIZE - 1 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL Clear_Buffer : std_logic;
    SIGNAL Input_Buffer : std_logic_vector(36 DOWNTO 0);
    SIGNAL Output_Buffer : std_logic_vector(36 DOWNTO 0);
    SIGNAL memoryForwarding : std_logic_vector(31 DOWNTO 0);
    SIGNAL memoryAddress : std_logic_vector(19 DOWNTO 0);
    SIGNAL writeEnable : std_logic;
    SIGNAL SPIN, SPOUT : std_logic_vector(19 DOWNTO 0);
    SIGNAL SPOUTplus2 : std_logic_vector(19 DOWNTO 0);
    SIGNAL SPOUTminus2 : std_logic_vector(19 DOWNTO 0);
    SIGNAL memoryDataOut : std_logic_vector(31 DOWNTO 0);
BEGIN
    memory : RAM PORT MAP(clock => clock, address => memoryAddress, dataIN => dataIN, dataOUT => memoryDataOut, writeEnable => writeEnable);
    SP : Falling_register GENERIC MAP(REG_SIZE => 20) PORT MAP(clk => clock, rst => '0', enable => '1', d => SPIN, q => SPOUT);

    writeEnable <= (memoryWrite OR push) AND NOT pop;

    memoryAddress <= std_logic_vector(unsigned(SPOUT) - 1) WHEN push = '1' AND pop = '0' 
        ELSE std_logic_vector(unsigned(SPOUTplus2) - 1)  WHEN pop = '1' AND push = '0'
        ELSE address(19 DOWNTO 0);

    SPIN <= x"FFFFE" WHEN resetSP = '1'
        ELSE SPOUTminus2 WHEN push = '1' AND pop = '0'
        ELSE SPOUTplus2 WHEN pop = '1' AND push = '0' AND SPOUT /= x"FFFFE"
        ELSE SPOUT;

    SPOUTplus2 <= std_logic_vector(unsigned(SPOUT) + 2);
    SPOUTminus2 <= std_logic_vector(unsigned(SPOUT) - 2);
    dataOUT <= memoryDataOut;

    Input_Buffer(36) <= writeBackSignal;
    Input_Buffer(35 DOWNTO 4) <= memoryForwarding;
    Input_Buffer(3 DOWNTO 0) <= writeAddress;

    Clear_Buffer <= '1' WHEN RST = '1'
        ELSE '0';
    memoryForwarding <= memoryDataOut WHEN memoryRead = '1'
        ELSE address;
    Buff : Falling_register GENERIC MAP(REG_SIZE => 37) PORT MAP(clock, Clear_Buffer, '1', Input_Buffer, Output_Buffer);--enable control???
    memoryBuffer <= Output_Buffer;
END rtl;