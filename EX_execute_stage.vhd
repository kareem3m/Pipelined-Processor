Library ieee;
use ieee.std_logic_1164.all;

entity EX_execute_stage is
    generic (ALU_flags_SIZE : integer := 32);
    port( 
        -- muxes
        RdstVal   : in std_logic_vector (ALU_flags_SIZE-1 downto 0);
        RsrcVal   : in std_logic_vector (ALU_flags_SIZE-1 downto 0);
        Offset: in  std_logic_vector (ALU_flags_SIZE-1 downto 0);
        ImmVal: in  std_logic_vector (ALU_flags_SIZE-1 downto 0);
        AluForwarding: in  std_logic_vector (ALU_flags_SIZE-1 downto 0);
        MemForwarding: in  std_logic_vector (ALU_flags_SIZE-1 downto 0);
        InPOrt: in  std_logic_vector (ALU_flags_SIZE-1 downto 0);
        offsetSignal: in std_logic;

        -- forwarding unit
        RdstAddress: in std_logic_vector (3 downto 0);
        RsrcAddress: in std_logic_vector (3 downto 0);
        RdestEM: in std_logic_vector (3 downto 0);
        RdestMW: in std_logic_vector (3 downto 0);
        inPortSignal: in std_logic;
        immSignal: in std_logic;
        WB_EM_Signal: in std_logic;
        WB_MW_Signal: in std_logic;

        -- output port:
        outputPortSignal: std_logic;

        -- alu
        operation : in std_logic_vector (4 downto 0);

        --registers
        clk: in std_logic;

        -- alu out
        result: out std_logic_vector (ALU_flags_SIZE-1 downto 0);

        -- jump unit
        uncondtionalJmp, jmpIfZero: in std_logic;
        jmp: out std_logic
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

        result: out std_logic_vector (ALU_SIZE-1 downto 0);
        flags: out std_logic_vector (ALU_SIZE-1 downto 0)
    );
end component;

--Register
component Ex_register is
    generic (REG_SIZE: integer := 32);
    port(
        clk, rst, enable : in std_logic;
        d : in std_logic_vector (31 downto 0);

        q : out std_logic_vector (31 downto 0)
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
component ForwardingUnit is
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
signal s_aluFlagsOut: std_logic_vector(ALU_flags_SIZE-1 downto 0); 
signal s_flagRegOut: std_logic_vector(ALU_flags_SIZE-1 downto 0);
signal s_result: std_logic_vector(ALU_flags_SIZE-1 downto 0);

--Jump Unit:
signal s_zeroFlag: std_logic;

--Forwarding Unit:
signal s_dstSel: std_logic_vector(1 downto 0);
signal s_srcSel: std_logic_vector(1 downto 0);

--Muxes:
signal s_dstMuxOut: std_logic_vector(ALU_flags_SIZE-1 downto 0);
signal s_op1: std_logic_vector(ALU_flags_SIZE-1 downto 0);
signal s_op2: std_logic_vector(ALU_flags_SIZE-1 downto 0);

--Output Port:
signal s_outputPort: std_logic_vector(ALU_flags_SIZE-1 downto 0);

-------------------Arch---------------------    
begin

    --Forwarding Unit:
    fu: ForwardingUnit port map (RdstAddress, RsrcAddress, RdestEM, RdestMW, inPortSignal, immSignal, WB_EM_Signal, WB_MW_Signal, s_dstSel, s_srcSel);

    --Muxes:
    dstMux: Ex_mux4x4 port map (RdstVal, AluForwarding, MemForwarding, InPOrt, s_dstSel, s_dstMuxOut);
    offMux: Ex_mux2x2 port map (s_dstMuxOut, Offset, offsetSignal, s_op1);
    srcMux: Ex_mux4x4 port map (RsrcVal, AluForwarding, MemForwarding, ImmVal, s_srcSel, s_op2);

    --Alu, flags and result:
    alu: Ex_ALU port map (s_op1, s_op2, operation, s_cin, s_result, s_aluFlagsOut);
    flagReg: Ex_register port map (clk, '0', '1', s_aluFlagsOut, s_flagRegOut);
    s_cin <= s_flagRegOut(0);
    resultReg: Ex_register port map (clk, '0', '1', s_result, result);

    --Jump unit:
    s_zeroFlag <= s_flagRegOut(1);
    ju: Ex_jump_unit port map (uncondtionalJmp, jmpIfZero, s_zeroFlag, jmp);

    --Output port:
    outputPortReg: Ex_register port map (clk, '0', outputPortSignal, s_dstMuxOut, s_outputPort);

end EX_execute_stage_arch;