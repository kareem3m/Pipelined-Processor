LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

ENTITY Integration IS
    PORT (
        clock : IN std_logic;
        RST : IN std_logic
    );
END Integration;

ARCHITECTURE rtl OF Integration IS

    COMPONENT FetchStage IS
    PORT (
        clock : IN std_logic;
        resetPC : IN std_logic;
        noChange : IN std_logic;
        jmp : IN std_logic;
        jumpAddress : IN std_logic_vector(19 DOWNTO 0);
        stageBuffer : OUT std_logic_vector(31 DOWNTO 0);
        PCInput : OUT std_logic_vector(19 DOWNTO 0);
        PCOutput : OUT std_logic_vector(19 DOWNTO 0)

    );
    END COMPONENT;
    COMPONENT DecodeStage IS
    PORT (

        instruction,WB_Data_IN : IN std_logic_vector(31 DOWNTO 0);
        WB_Address_IN,RDest_Ex: IN  std_logic_vector(3 DOWNTO 0);
        WB_Signal,Clk,Mem_Read_Ex,JMP,RST:IN std_logic ;  -- JMP OR RST " ONE SIGNAL OR 2" "FROM WHERE ??????"
        Decode_Buffer:OUT std_logic_vector(127 DOWNTO 0)
    );
    END COMPONENT;
    COMPONENT MemoryStage IS
    PORT (
        clock, memoryRead, memoryWrite, pop, push, RST : IN std_logic;
        dataIN : IN std_logic_vector(31 DOWNTO 0);
        dataOUT : OUT std_logic_vector(31 DOWNTO 0);
        address : IN std_logic_vector(31 DOWNTO 0);
        resetSP : IN std_logic;
        writeAddress: IN std_logic_vector(3 DOWNTO 0);
        Decode_Buffer: OUT std_logic_vector(127 DOWNTO 0)

    );
    END COMPONENT;
    COMPONENT WriteBackStage IS
    PORT (
        clock : IN std_logic;
        memoryOut : IN std_logic_vector (31 DOWNTO 0);
        aluOut : IN std_logic_vector (31 DOWNTO 0);
        memoryToReg : IN std_logic;
        writeAddress : INOUT std_logic_vector (3 DOWNTO 0);
        writeData : OUT std_logic_vector (31 DOWNTO 0)

    );
    END COMPONENT;

    SIGNAL noChange : std_logic; --stall
    SIGNAL jmp : std_logic; --jump
    SIGNAL jumpAddress : std_logic_vector(19 DOWNTO 0);
    SIGNAL PCIN : std_logic_vector(19 DOWNTO 0);
    SIGNAL PCOUT : std_logic_vector(19 DOWNTO 0);

    SIGNAL IR : std_logic_vector(31 DOWNTO 0);-----------input to decode

BEGIN 
    FetchStagePort: FetchStage 
    PORT MAP (
        clock => clock,
        resetPC => RST,
        noChange => noChange,
        jmp => jmp,
        jumpAddress => jumpAddress,
        stageBuffer => IR,
        PCInput => PCIN,
        PCOutput => PCOUT
    );

END rtl;