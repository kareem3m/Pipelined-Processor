Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;  

entity Ex_ALU is
    generic (ALU_SIZE : integer := 32);
    port( 
        op1   : in std_logic_vector (ALU_SIZE-1 downto 0); --Rdst
        op2   : in std_logic_vector (ALU_SIZE-1 downto 0); --Rsrc
        operation : in std_logic_vector (4 downto 0);
        cin: in std_logic;
        jmpzero:in std_logic;
        result: out std_logic_vector (ALU_SIZE-1 downto 0);
        flags: out std_logic_vector (2 downto 0)
    );
end Ex_ALU;

architecture Ex_ALU_Arch of Ex_ALU is

component Ex_ripple_adder is
generic (ADDER_SIZE : integer := 32);
port   (a, b : in std_logic_vector(ADDER_SIZE-1 downto 0) ;
        cin : in std_logic;
        sum : out std_logic_vector(ADDER_SIZE-1 downto 0);
        cout : out std_logic);
end component;


signal resultSignal: std_logic_vector(ALU_SIZE-1 downto 0);
signal sumSignal: std_logic_vector(ALU_SIZE-1 downto 0);
signal subSignal: std_logic_vector(ALU_SIZE-1 downto 0);
signal notOp1: std_logic_vector(ALU_SIZE-1 downto 0);
signal sumCarrySignal: std_logic;
signal subCarrySignal: std_logic;

signal zeroresult: std_logic;

begin
    add: Ex_ripple_adder generic map (ALU_SIZE) port map (op1, op2, '0', sumSignal, sumCarrySignal);
    notOp1 <= not op1;
    sub: Ex_ripple_adder generic map (ALU_SIZE) port map (op2, notOp1, '1', subSignal, subCarrySignal); -- Rsrc - Rdst

    -- freg:
    resultSignal <= 
    (others => '0') when operation = "00011" -- CLR
    else (not op1) when operation = "00100" -- NOT
    else std_logic_vector(to_signed(to_integer(signed(op1)) + 1, ALU_SIZE)) when operation = "00101" --INC
    else std_logic_vector(to_signed(to_integer(signed(op1)) - 1, ALU_SIZE)) when operation = "00110" -- DEC
    else std_logic_vector(to_signed(to_integer(signed(not op1)) + 1, ALU_SIZE)) when operation = "00111" -- Neg
    else op1 when operation = "01001" -- IN
    else op2 when operation = "10000" -- MOV
    else sumSignal when operation = "10001" -- ADD
    else subSignal when operation = "10010" -- SUB
    else (op2 and op1) when operation = "10011" -- AND
    else (op2 or op1) when operation = "10100" -- OR
    else std_logic_vector(shift_left(unsigned(op1), to_integer(unsigned(op2)))) when operation = "10110" -- SHL
    else std_logic_vector(shift_right(unsigned(op1), to_integer(unsigned(op2)))) when operation = "10111" -- SHR
    else (op1(ALU_SIZE-2 downto 0) & cin) when operation = "11000" -- RLC
    else (cin & op1(ALU_SIZE-1 downto 1)) when operation = "11001" -- RRC
    else (others=>'1') when jmpzero='1'
    else resultSignal;
    result <= resultSignal;

    flags(0) <= --carry flag
    '1' when operation = "00001" -- SETC
    else '0'  when operation = "00010" -- CLRC
    else sumCarrySignal                             when operation = "10001"  -- ADD
    else subCarrySignal                             when operation = "10010"  -- SUB
    else op1(ALU_SIZE-to_integer(unsigned(op2(4 downto 0))+1)-1)    when operation = "10110"  -- SHL
    else op1(to_integer(unsigned(op2(4 downto 0))-1))           when operation = "10111"  -- SHR
    else op1(ALU_SIZE-1)                            when operation = "11000"  -- RLC
    else op1(0)                                     when operation = "11001"; -- RRC

    -- process (all)
    -- begin
        
    -- end process;
    zeroresult<=nor_reduce(resultSignal);
    flags(1) <= '0'when (jmpzero='1'or(not(zeroresult)='1')) 
    else '1';
    flags(2) <= resultSignal(ALU_SIZE-1); --negative flag

end Ex_ALU_Arch;