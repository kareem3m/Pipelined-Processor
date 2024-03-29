Library ieee;
use ieee.std_logic_1164.all;

entity EX_execute_stage is
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
        o_RdstValStore: out std_logic_vector (EX_STAGE_SIZE-1 downto 0); -- for store operation -- async for fetch?

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
        o_flag_reg: out std_logic_vector(2 downto 0);




        -- Buffer
        o_buffRdstAddress: out std_logic_vector (3 downto 0);
        o_buffControl: out std_logic_vector (17 downto 0);
        o_wow:out std_logic_vector (EX_STAGE_SIZE-1 downto 0)

    );
end EX_execute_stage;

architecture EX_execute_stage_arch of EX_execute_stage is
--------------------Components------------------
--ALU
component Ex_ALU is
    generic (ALU_SIZE : integer := 32);
    port( 
        op1   : in std_logic_vector (ALU_SIZE-1 downto 0);
        op2   : in std_logic_vector (ALU_SIZE-1 downto 0);
        operation : in std_logic_vector (4 downto 0);
        cin: in std_logic;
        jmpzero:in std_logic;
        result: out std_logic_vector (ALU_SIZE-1 downto 0);
        flags: out std_logic_vector (2 downto 0)
    );
end component;

--Register
component Falling_register is
    generic (REG_SIZE: integer := 32);
    port(
        clk, rst, enable : in std_logic;
        d : in std_logic_vector (REG_SIZE-1 downto 0);
        q : out std_logic_vector (REG_SIZE-1 downto 0)
    );
end component;

component Reg is
    generic (
        N : integer
    );
    port (
        clock, clear, enable : in std_logic;
        d : IN std_logic_vector(N - 1 downto 0);
        q : OUT std_logic_vector(N - 1 downto 0)
    );
end component;

--Jump Uint
component Ex_jump_unit is 
	port (
        uncondtionalJmp: in std_logic;
        jmpIfZero: in std_logic;
        zeroFlag: in std_logic;
        jmp: out std_logic
    );
end component;

--Forwaring Unit:
component Ex_forwarding_unit is
    port (
        RdestAddress : in std_logic_vector (3 downto 0);
        RsrcAddress : in std_logic_vector (3 downto 0);
        RdestExecuteMemAddress : in std_logic_vector (3 downto 0);
        RdestMemWriteBackAddress : in std_logic_vector (3 downto 0);
        inPortSignal : in std_logic;
        immediateSignal : in std_logic;
        WBExecuteMemSignal : in std_logic;
        WBMemWriteBackSignal : in std_logic;
        DestSel : out std_logic_vector (1 downto 0);
        SrcSel : out std_logic_vector (1 downto 0)

    );
end component;

--Mux:
component Ex_mux4x4 is 
	generic ( n : Integer:=32);
	port (
        in0,in1,in2,in3: in std_logic_vector (n-1 downto 0);
		sel: in  std_logic_vector (1 downto 0);
		out1: out std_logic_vector (n-1 downto 0)
    );
end component;
component Ex_mux2x2 is 
	generic ( n : Integer:=32);
	port ( 
        in0,in1: in std_logic_vector (n-1 downto 0);
		sel: in  std_logic;
		out1: out std_logic_vector (n-1 downto 0)
    );
end component;

-------------------Signals--------------------
--ALU, FlagReg, ResultReg
signal s_cin: std_logic;
signal s_aluFlagsOut: std_logic_vector(2 downto 0); 
signal s_flagRegOut: std_logic_vector(2 downto 0);
signal s_result: std_logic_vector(EX_STAGE_SIZE-1 downto 0);

--Jump Unit:
signal s_zeroFlag: std_logic;

--Forwarding Unit:
signal s_dstSel: std_logic_vector(1 downto 0);
signal s_srcSel: std_logic_vector(1 downto 0);

--Muxes:
signal s_dstMuxOut: std_logic_vector(EX_STAGE_SIZE-1 downto 0);
signal s_op1: std_logic_vector(EX_STAGE_SIZE-1 downto 0);
signal s_op2: std_logic_vector(EX_STAGE_SIZE-1 downto 0);

signal s_sjmp:std_logic_vector(0 downto 0);
signal s_ojmp:std_logic_vector(0 downto 0);

signal s_clear:std_logic;
-------------------Arch---------------------    
begin

    --Forwarding Unit:
    l_fu: Ex_forwarding_unit port map (i_opDstSrc(7 downto 4), i_opDstSrc(3 downto 0), i_RdestEM, i_RdestMW, i_control(8), i_control(17), i_WB_EM_Signal, i_WB_MW_Signal, s_dstSel, s_srcSel);

    --Muxes:
    l_dstMux: Ex_mux4x4 port map (i_RdstVal, i_AluForwarding, i_MemForwarding, i_InPort, s_dstSel, s_dstMuxOut);
    l_offMux: Ex_mux2x2 port map (s_dstMuxOut, i_Offset_ImmVal, i_control(16), s_op1);
    l_srcMux: Ex_mux4x4 port map (i_RsrcVal, i_AluForwarding, i_MemForwarding, i_Offset_ImmVal, s_srcSel, s_op2);

    --Alu, flags and result:
    l_alu: Ex_ALU port map (s_op1, s_op2, i_opDstSrc(12 downto 8), s_flagRegOut(0),i_control(2), s_result, s_aluFlagsOut);
    l_flagReg: Falling_register generic map(3) port map (i_clk, i_rst, '1', s_aluFlagsOut, s_flagRegOut);
    o_flag_reg <= s_flagRegOut;

    l_resultReg: Falling_register generic map(EX_STAGE_SIZE) port map (i_clk, i_rst, '1', s_result, o_aluResult);

    --Jump unit:
    s_zeroFlag <= s_flagRegOut(1);
    l_ju: Ex_jump_unit port map (i_control(1), i_control(2), s_zeroFlag, s_sjmp(0));

    --Output port:
    l_outputPortReg: Reg generic map(EX_STAGE_SIZE) port map (i_clk, i_rst, i_control(7), s_dstMuxOut, o_outputPort);

    -- Buffer:
    l_buffRdst: Falling_register generic map(4) port map (i_clk, i_rst, '1', i_opDstSrc(7 downto 4), o_buffRdstAddress);
    l_buffControl: Falling_register generic map(18) port map (i_clk, i_rst, '1', i_control, o_buffControl);
    l_storeReg: Falling_register generic map(EX_STAGE_SIZE) port map (i_clk, i_rst, '1', s_dstMuxOut, o_RdstValStore);

    -- o_jmpreg: Falling_register generic map(1) port map(i_clk, s_clear, '1', s_sjmp,s_ojmp);
    o_jmp <=s_sjmp(0);
process (i_clk)
begin
    if ((rising_edge(i_clk)) and s_ojmp(0)='1') or (i_rst='1') then
        s_clear<='1';
        else
            s_clear<='0';
    end if;
    
end process;
o_wow <= s_dstMuxOut;
    -- s_clear <=
    -- '1' WHEN (s_ojmp(0)='1' AND(NOT(i_clk)='1')) OR i_rst='1'
    -- ELSE '0';
end EX_execute_stage_arch;