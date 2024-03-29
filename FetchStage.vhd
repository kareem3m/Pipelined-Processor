LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY FetchStage IS
    PORT (
        -- flush : IN std_logic;
        clock : IN std_logic;
        resetPC : IN std_logic;
        noChange : IN std_logic;
        jmp : IN std_logic;
        jumpAddress : IN std_logic_vector(19 DOWNTO 0);
        stageBuffer : OUT std_logic_vector(31 DOWNTO 0);
        PCInput : OUT std_logic_vector(19 DOWNTO 0);
        PCOutput : OUT std_logic_vector(19 DOWNTO 0)

    );
END FetchStage;

ARCHITECTURE rtl OF FetchStage IS
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
    COMPONENT Falling_register IS
        GENERIC (
            REG_SIZE : integer := 32
        );
        PORT (
            clk, rst, enable : IN std_logic;
            d : IN std_logic_vector (REG_SIZE - 1 DOWNTO 0);
            q : OUT std_logic_vector (REG_SIZE - 1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL PCIN : std_logic_vector(19 DOWNTO 0);
    SIGNAL PCOUT : std_logic_vector(19 DOWNTO 0);
    SIGNAL PCEnable : std_logic;
    SIGNAL address : std_logic_vector(19 DOWNTO 0);
    SIGNAL memoryData : std_logic_vector(31 DOWNTO 0);
    SIGNAL opCode : std_logic_vector(5 DOWNTO 0);
    SIGNAL incrementByTwo : boolean;
    SIGNAL bufferIN : std_logic_vector(31 DOWNTO 0);
    SIGNAL resetBuffer : std_logic;
BEGIN
    instructionsMemory : RAM PORT MAP(clock => clock, address => address, dataIN => (OTHERS => '0'), dataOUT => memoryData, writeEnable => '0');
    PC : REG GENERIC MAP(N => 20) PORT MAP(clock => clock, clear => '0', enable => PCEnable, d => PCIN, q => PCOUT);
    fetchBuffer : Falling_register GENERIC MAP(REG_SIZE => 32) PORT MAP(clk => clock, rst => resetBuffer, enable => PCEnable, d => bufferIN, q => stageBuffer);

    PCEnable <= NOT noChange; -- freeze PC
    resetBuffer <= '1' WHEN jmp = '1' OR resetPC = '1'
        ELSE '0';
    bufferIN <= memoryData;

    address <= x"00000" WHEN resetPC = '1'
        ELSE PCOUT;

    PCIN <= "0000" & memoryData(31 DOWNTO 16) WHEN resetPC = '1' -- fetch mem[0]
        ELSE jumpAddress WHEN jmp = '1'
        ELSE std_logic_vector(unsigned(PCOUT) + 2) WHEN incrementByTwo
        ELSE std_logic_vector(unsigned(PCOUT) + 1);
    PCInput <= PCIN;
    PCOutput <= PCOUT;
    opcode <= memoryData(31 DOWNTO 26);

    incrementByTwo <= true WHEN
        opcode = "100010" OR --LDM
        opcode = "100011" OR --LDD
        opcode = "100100" OR --STD
        opcode = "010101" OR --IADD
        opcode = "010110" OR --SHL
        opcode = "010111" --SHR
        ELSE false;
END rtl;