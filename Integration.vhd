LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Integration IS
    PORT (
        clock : IN std_logic;
        RST : IN std_logic;
        OutPort : OUT std_logic_vector(31 DOWNTO 0);
        InPort : IN std_logic_vector(31 DOWNTO 0)
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
            instruction, WB_Data_IN : IN std_logic_vector(31 DOWNTO 0);
            WB_Address_IN, RDest_Ex : IN std_logic_vector(3 DOWNTO 0);
            WB_Signal, Clk, Mem_Read_Ex, JMP, RST : IN std_logic;
            RD_Buffer : OUT std_logic_vector(31 DOWNTO 0);
            RS_Buffer : OUT std_logic_vector(31 DOWNTO 0);
            SGIN_Buffer : OUT std_logic_vector(31 DOWNTO 0);
            control_Buffer : OUT std_logic_vector(17 DOWNTO 0);
            Address_Buffer : OUT std_logic_vector(13 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT EX_execute_stage 
        generic (EX_STAGE_SIZE : integer := 32);
        port(
            -- Control Signals 
            i_control: in std_logic_vector (17 downto 0);
            
            -- Muxes
            i_RdstVal   : in std_logic_vector (EX_STAGE_SIZE-1 downto 0);
            i_RsrcVal   : in std_logic_vector (EX_STAGE_SIZE-1 downto 0);
            i_Offset_ImmVal: in  std_logic_vector (EX_STAGE_SIZE-1 downto 0);
            i_AluForwarding: in  std_logic_vector (EX_STAGE_SIZE-1 downto 0);
            i_MemForwarding: in  std_logic_vector (EX_STAGE_SIZE-1 downto 0);
            i_InPort: in  std_logic_vector (EX_STAGE_SIZE-1 downto 0);
            -- offsetSignal: in std_logic; -- i_control(16)
            o_RdstValStore: out std_logic_vector (EX_STAGE_SIZE-1 downto 0); -- for store operation
    
            -- Forwarding Unit
            -- RdstAddress: in std_logic_vector (3 downto 0); --i_opDstSrc(7 downto 4)
            -- RsrcAddress: in std_logic_vector (3 downto 0); --i_opDstSrc(3 down to 0)
            i_RdestEM: in std_logic_vector (3 downto 0);
            i_RdestMW: in std_logic_vector (3 downto 0);
            -- inPortSignal: in std_logic; --i_control(8)
            -- immSignal: in std_logic; --i_control(17)
            i_WB_EM_Signal: in std_logic;
            i_WB_MW_Signal: in std_logic;
    
            -- Output Port:
            -- outputPortSignal: in std_logic; --i_control(7)
            o_outputPort: out std_logic_vector(EX_STAGE_SIZE-1 downto 0);
    
            -- Alu
            -- operation: in std_logic_vector(4 downto 0);
            i_opDstSrc: in std_logic_vector (13 downto 0); --decode
    
            -- Registers
            i_clk: in std_logic;
            i_rst: in std_logic; --global
    
            -- Jump Unit
            -- uncondtionalJmp: in std_logic; --i_control(1)
            -- jmpIfZero: in std_logic; --i_control(2)
    
            -- Unit Output
            o_aluResult: out std_logic_vector (EX_STAGE_SIZE-1 downto 0);
            o_jmp: out std_logic;
    
            -- Buffer
            o_buffRdstAddress: out std_logic_vector (3 downto 0);
            o_buffControl: out std_logic_vector (17 downto 0)
    
        );
    end COMPONENT;
    COMPONENT MemoryStage IS
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
    END COMPONENT;
    COMPONENT WriteBackStage IS
        PORT (
            clock : IN std_logic;
            memoryOut : IN std_logic_vector (31 DOWNTO 0);
            writeAddress : INOUT std_logic_vector (3 DOWNTO 0);
            writeBackAddress : OUT std_logic_vector (3 DOWNTO 0);
            writeData : OUT std_logic_vector (31 DOWNTO 0);
            writeBackEnable : OUT std_logic;
            writeEnable : IN std_logic
        );
    END COMPONENT;
    
    --- FETCH STAGE ---
    SIGNAL noChange : std_logic; --stall
    SIGNAL jmp : std_logic; --jump
    SIGNAL PCIN : std_logic_vector(19 DOWNTO 0);
    SIGNAL PCOUT : std_logic_vector(19 DOWNTO 0);
    SIGNAL IR : std_logic_vector(31 DOWNTO 0);-----------input to decode

    --- DECODE STAGE ---
    -- SIGNAL RDest_Ex : std_logic_vector(3 DOWNTO 0);
    -- SIGNAL Mem_Read_Ex : std_logic;

    SIGNAL RD_Buffer : std_logic_vector(31 DOWNTO 0);
    SIGNAL RS_Buffer : std_logic_vector(31 DOWNTO 0);
    SIGNAL SGIN_Buffer : std_logic_vector(31 DOWNTO 0);
    SIGNAL control_Buffer : std_logic_vector(17 DOWNTO 0);
    SIGNAL Address_Buffer : std_logic_vector(13 DOWNTO 0);

    --- Execute ---
    SIGNAL aluResult : std_logic_vector(31 DOWNTO 0);
    SIGNAL control_Buffer_Execute : std_logic_vector(17 DOWNTO 0);

    --- MEMORY STAGE ---
    SIGNAL memoryRead : std_logic;
    SIGNAL memoryWrite : std_logic;
    SIGNAL pop : std_logic;
    SIGNAL push : std_logic;
    SIGNAL memoryIN : std_logic_vector(31 DOWNTO 0);
    SIGNAL memoryOUT : std_logic_vector(31 DOWNTO 0);
    SIGNAL resetSP : std_logic;
    SIGNAL writeAddress : std_logic_vector(3 DOWNTO 0);
    SIGNAL memoryBuffer : std_logic_vector(36 DOWNTO 0);

    --- WRITE BACK STAGE ---
    SIGNAL writeBackData : std_logic_vector(31 DOWNTO 0);
    SIGNAL writeBackAddress : std_logic_vector(3 DOWNTO 0);
    SIGNAL writeBackSignal : std_logic;
BEGIN
    FetchStagePort : FetchStage
    PORT MAP(
        clock => clock,
        resetPC => RST,
        noChange => noChange,
        jmp => jmp,
        jumpAddress => memoryIN(19 DOWNTO 0),
        stageBuffer => IR,
        PCInput => PCIN,
        PCOutput => PCOUT
    );

    DecodeStagePort : DecodeStage
    PORT MAP(
        instruction => IR,
        WB_Data_IN => writeBackData,
        WB_Address_IN => writeBackAddress,
        WB_Signal => writeBackSignal,
        Clk => clock,
        Mem_Read_Ex => control_Buffer(14),
        RDest_Ex => Address_Buffer(7 DOWNTO 4),
        JMP => jmp,
        RST => RST,
        RD_Buffer => RD_Buffer,
        RS_Buffer => RS_Buffer,
        SGIN_Buffer => SGIN_Buffer,
        control_Buffer => control_Buffer,
        Address_Buffer => Address_Buffer
    );
    
    ExecuteStagePort : EX_execute_stage
    PORT MAP(
        i_control => control_Buffer,

        i_RdstVal  => RD_Buffer,
        i_RsrcVal   => RS_Buffer,
        i_Offset_ImmVal => SGIN_Buffer,
        i_AluForwarding => aluResult,
        i_MemForwarding => memoryBuffer(35 DOWNTO 4),
        i_InPort => InPort,

        o_RdstValStore => memoryIN,
        i_RdestEM => writeAddress,
        i_RdestMW => memoryBuffer(3 DOWNTO 0),
        i_WB_EM_Signal => control_Buffer(12),
        i_WB_MW_Signal => memoryBuffer(36),
        o_outputPort => OutPort,
        i_opDstSrc => Address_Buffer,
        i_clk => clock,
        i_rst => RST,
        o_aluResult => aluResult,
        o_jmp => jmp,
        o_buffRdstAddress => writeAddress,
        o_buffControl => control_Buffer_Execute 

    );
    MemoryStagePort : MemoryStage PORT MAP(
        clock => clock,
        RST => RST,
        memoryRead => control_Buffer_Execute(14),
        memoryWrite => control_Buffer_Execute(13),
        pop => control_Buffer_Execute(9),
        push => control_Buffer_Execute(10),
        dataIN => memoryIN,
        dataOUT => memoryOUT,
        address => aluResult,
        resetSP => RST,
        writeAddress => writeAddress,
        memoryBuffer => memoryBuffer,
        writeBackSignal => control_Buffer_Execute(12)

    );

    WriteBackPort : WriteBackStage PORT MAP(
        clock => clock,
        memoryOut => memoryBuffer(35 DOWNTO 4),
        writeAddress => memoryBuffer(3 DOWNTO 0),
        writeEnable => memoryBuffer(36),
        writeBackAddress => writeBackAddress,
        writeData => writeBackData,
        writeBackEnable => writeBackSignal
    );

END rtl;