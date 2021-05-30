LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY DecodeStage IS
    PORT (

        instruction,WB_Data_IN : IN std_logic_vector(31 DOWNTO 0);
        WB_Address_IN: IN  std_logic_vector(3 DOWNTO 0);
        WB_Signal,Clk:IN std_logic ;
        RS,RD,SignExtend_OUT:OUT std_logic_vector(31 DOWNTO 0)

    );
END DecodeStage;
ARCHITECTURE Dec OF DecodeStage IS

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
SIGNAL R0_EN :std_logic;
SIGNAL R1_EN :std_logic;
SIGNAL R2_EN :std_logic;
SIGNAL R3_EN :std_logic;
SIGNAL R4_EN :std_logic;
SIGNAL R5_EN :std_logic;
SIGNAL R6_EN :std_logic;
SIGNAL R7_EN :std_logic;

SIGNAL R0_OUT:std_logic_vector(31 DOWNTO 0);
SIGNAL R1_OUT:std_logic_vector(31 DOWNTO 0);
SIGNAL R2_OUT:std_logic_vector(31 DOWNTO 0);
SIGNAL R3_OUT:std_logic_vector(31 DOWNTO 0);
SIGNAL R4_OUT:std_logic_vector(31 DOWNTO 0);
SIGNAL R5_OUT:std_logic_vector(31 DOWNTO 0);
SIGNAL R6_OUT:std_logic_vector(31 DOWNTO 0);
SIGNAL R7_OUT:std_logic_vector(31 DOWNTO 0);
begin
    
    R0 : REG GENERIC MAP(N => 32) PORT MAP(Clk,'0',R0_EN,WB_Data_IN,R0_OUT);
    R1 : REG GENERIC MAP(N => 32) PORT MAP(Clk,'0',R1_EN,WB_Data_IN,R1_OUT);
    R2 : REG GENERIC MAP(N => 32) PORT MAP(Clk,'0',R2_EN,WB_Data_IN,R2_OUT);
    R3 : REG GENERIC MAP(N => 32) PORT MAP(Clk,'0',R3_EN,WB_Data_IN,R3_OUT);
    R4 : REG GENERIC MAP(N => 32) PORT MAP(Clk,'0',R4_EN,WB_Data_IN,R4_OUT);
    R5 : REG GENERIC MAP(N => 32) PORT MAP(Clk,'0',R5_EN,WB_Data_IN,R5_OUT);
    R6 : REG GENERIC MAP(N => 32) PORT MAP(Clk,'0',R6_EN,WB_Data_IN,R6_OUT);
    R7 : REG GENERIC MAP(N => 32) PORT MAP(Clk,'0',R7_EN,WB_Data_IN,R7_OUT);
    
    R0_EN  <='1'  WHEN WB_Address_IN = "0000" AND WB_Signal = '1' 
    ELSE '0';
    R1_EN  <= '1' WHEN WB_Address_IN = "0001" AND WB_Signal = '1' 
    ELSE '0';
    R2_EN  <= '1' WHEN WB_Address_IN = "0010" AND WB_Signal = '1' 
    ELSE '0';
    R3_EN  <= '1' WHEN WB_Address_IN = "0011" AND WB_Signal = '1' 
    ELSE '0';
    R4_EN  <= '1' WHEN WB_Address_IN = "0100" AND WB_Signal = '1' 
    ELSE '0';
    R5_EN  <= '1' WHEN WB_Address_IN = "0101" AND WB_Signal = '1'
    ELSE '0';
    R6_EN  <= '1' WHEN WB_Address_IN = "0110" AND WB_Signal = '1' 
    ELSE '0';
    R7_EN  <= '1' WHEN WB_Address_IN = "0111" AND WB_Signal = '1' 
    ELSE '0';

    RD <= R0_OUT  WHEN instruction(25 DOWNTO 22)="0000"
    ELSE  R1_OUT  WHEN instruction(25 DOWNTO 22)="0001"
    ELSE  R2_OUT  WHEN instruction(25 DOWNTO 22)="0010"
    ELSE  R3_OUT  WHEN instruction(25 DOWNTO 22)="0011"
    ELSE  R4_OUT  WHEN instruction(25 DOWNTO 22)="0100"
    ELSE  R5_OUT  WHEN instruction(25 DOWNTO 22)="0101"
    ELSE  R6_OUT  WHEN instruction(25 DOWNTO 22)="0110"
    ELSE  R7_OUT  WHEN instruction(25 DOWNTO 22)="0111";

    RS <= R0_OUT  WHEN instruction(21 DOWNTO 18)="0000"
    ELSE  R1_OUT  WHEN instruction(21 DOWNTO 18)="0001"
    ELSE  R2_OUT  WHEN instruction(21 DOWNTO 18)="0010"
    ELSE  R3_OUT  WHEN instruction(21 DOWNTO 18)="0011"
    ELSE  R4_OUT  WHEN instruction(21 DOWNTO 18)="0100"
    ELSE  R5_OUT  WHEN instruction(21 DOWNTO 18)="0101"
    ELSE  R6_OUT  WHEN instruction(21 DOWNTO 18)="0110"
    ELSE  R7_OUT  WHEN instruction(21 DOWNTO 18)="0111";

    SignExtend_OUT <= (31 DOWNTO 16 => instruction(15)) & instruction(15 DOWNTO 0);

end Dec;
