LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY DecodeStage IS
    PORT (

        instruction,WB_Data_IN : IN std_logic_vector(31 DOWNTO 0);
        WB_Address_IN,RDest_Ex: IN  std_logic_vector(3 DOWNTO 0);
        WB_Signal,Clk,Mem_Read_Ex,JMP,RST_SIG:IN std_logic ;  
        RD_Buffer:OUT std_logic_vector(31 DOWNTO 0);
        RS_Buffer:OUT std_logic_vector(31 DOWNTO 0);
        SGIN_Buffer:OUT std_logic_vector(31 DOWNTO 0);
        control_Buffer:OUT std_logic_vector(17 DOWNTO 0);
        Address_Buffer:OUT std_logic_vector(13 DOWNTO 0);
        N_Change:OUT std_logic
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

COMPONENT ControlUnit 
    PORT (
            OpCode:IN std_logic_vector(5 DOWNTO 0);
            Immediate,Offset,Alu_EN,Mem_Read,Mem_Write,WB,Mem_To_Reg,Push,Pop,Port_in, Port_out, JMPZ, JMPU:OUT std_logic

        );
END COMPONENT;

COMPONENT HazardDetectionUnit
PORT (
    Rsource_Decode,Rdest_Decode, RDest_Excute: IN std_logic_vector(3 DOWNTO 0);
    Mem_Read: IN std_logic;
    No_Change,Shift_Disable,Insert_Bubble:OUT std_logic
);
END COMPONENT;

COMPONENT Falling_register 
    generic (REG_SIZE: integer := 32);
        port(
            clk, rst, enable : in std_logic;
            d : in std_logic_vector (REG_SIZE-1 downto 0);
            q : out std_logic_vector (REG_SIZE-1 downto 0)
        );
END COMPONENT;

COMPONENT Reg2 IS
    GENERIC (
        N : integer
    );
    PORT (
        clock, clear, enable,JMP : IN std_logic;
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

SIGNAL Immediate_SIG :std_logic;
SIGNAL Offset_SIG :std_logic;
SIGNAL Alu_EN_SIG :std_logic;
SIGNAL Mem_Read_SIG :std_logic;
SIGNAL Mem_Write_SIG :std_logic;
SIGNAL WB_SIG :std_logic;
SIGNAL Mem_To_Reg_SIG :std_logic;
SIGNAL Push_SIG :std_logic;
SIGNAL Pop_SIG :std_logic;
SIGNAL Port_in_SIG :std_logic;
SIGNAL Port_out_SIG :std_logic;
SIGNAL JMPZ_SIG :std_logic;
SIGNAL JMPU_SIG :std_logic;

SIGNAL No_Change_SIG :std_logic;
SIGNAL Shift_Disable_SIG :std_logic;
SIGNAL Insert_Bubble_SIG :std_logic;

SIGNAL Clear_Buffer :std_logic;
SIGNAL Input_Buffer :std_logic_vector(127 DOWNTO 0);
SIGNAL RD_Buffer_SIG :std_logic_vector(31 DOWNTO 0);
SIGNAL RS_Buffer_SIG :std_logic_vector(31 DOWNTO 0);
SIGNAL Sign_Buffer_SIG :std_logic_vector(31 DOWNTO 0);
SIGNAL Control_Buffer_SIG :std_logic_vector(17 DOWNTO 0);
SIGNAL Address_Buffer_SIG :std_logic_vector(13 DOWNTO 0);

SIGNAL RS :std_logic_vector (31 DOWNTO 0);
SIGNAL RD :std_logic_vector (31 DOWNTO 0);
SIGNAL SignExtend_OUT :std_logic_vector (31 DOWNTO 0);
SIGNAL OPcode :std_logic_vector (5 DOWNTO 0);
begin
    
    R0 : REG GENERIC MAP(N => 32) PORT MAP(Clk,RST_SIG,R0_EN,WB_Data_IN,R0_OUT);
    R1 : REG GENERIC MAP(N => 32) PORT MAP(Clk,RST_SIG,R1_EN,WB_Data_IN,R1_OUT);
    R2 : REG GENERIC MAP(N => 32) PORT MAP(Clk,RST_SIG,R2_EN,WB_Data_IN,R2_OUT);
    R3 : REG GENERIC MAP(N => 32) PORT MAP(Clk,RST_SIG,R3_EN,WB_Data_IN,R3_OUT);
    R4 : REG GENERIC MAP(N => 32) PORT MAP(Clk,RST_SIG,R4_EN,WB_Data_IN,R4_OUT);
    R5 : REG GENERIC MAP(N => 32) PORT MAP(Clk,RST_SIG,R5_EN,WB_Data_IN,R5_OUT);
    R6 : REG GENERIC MAP(N => 32) PORT MAP(Clk,RST_SIG,R6_EN,WB_Data_IN,R6_OUT);
    R7 : REG GENERIC MAP(N => 32) PORT MAP(Clk,RST_SIG,R7_EN,WB_Data_IN,R7_OUT);

    CU : ControlUnit PORT MAP(instruction(31 DOWNTO 26),Immediate_SIG,Offset_SIG,Alu_EN_SIG,Mem_Read_SIG,Mem_Write_SIG,WB_SIG,Mem_To_Reg_SIG,Push_SIG,Pop_SIG,Port_in_SIG, Port_out_SIG, JMPZ_SIG, JMPU_SIG);  
    HU : HazardDetectionUnit PORT MAP(instruction(21 DOWNTO 18),instruction(25 DOWNTO 22),RDest_Ex,Mem_Read_Ex,No_Change_SIG,Shift_Disable_SIG,Insert_Bubble_SIG);
    
    BuffRD : Reg2  GENERIC MAP(32) PORT MAP(Clk,Clear_Buffer,'1',JMP,Input_Buffer(127 DOWNTO 96), RD_Buffer_SIG);--enable control???
    BuffRS : Falling_register  GENERIC MAP(REG_SIZE => 32) PORT MAP(Clk,Clear_Buffer,'1',Input_Buffer(95 DOWNTO 64), RS_Buffer_SIG);--enable control???
    BuffSIGN : Falling_register  GENERIC MAP(REG_SIZE => 32) PORT MAP(Clk,Clear_Buffer,'1',Input_Buffer(63 DOWNTO 32), Sign_Buffer_SIG);--enable control???
    BuffControl : Reg2  GENERIC MAP(18) PORT MAP(Clk,Clear_Buffer,'1',JMP,Input_Buffer(31 DOWNTO 14), Control_Buffer_SIG);--enable control???
    BuffAddress : Reg2  GENERIC MAP(14) PORT MAP(Clk,Clear_Buffer,'1',JMP,Input_Buffer(13 DOWNTO 0), Address_Buffer_SIG);--enable control???

    --Clear buffer from jmp or rst ????????????
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

    -- Decode_Buffer <=Output_Buffer; 
    RD_Buffer <= RD_Buffer_SIG;    
    RS_Buffer <= RS_Buffer_SIG;      
    SGIN_Buffer <= Sign_Buffer_SIG;
    control_Buffer <= Control_Buffer_SIG;
    Address_Buffer <= Address_Buffer_SIG;
    Clear_Buffer <= '1' WHEN  RST_SIG='1' OR Insert_Bubble_SIG='1'
    ELSE '0';

    OPcode <= "000000" WHEN  instruction(31 DOWNTO 26) = "110011" OR instruction(31 DOWNTO 26) = "100001"
    ELSE "010001" WHEN instruction(31 DOWNTO 26) = "100011" OR instruction(31 DOWNTO 26) = "100100" OR instruction(31 DOWNTO 26) = "010101"
    ELSE "010000" WHEN instruction(31 DOWNTO 26) = "100010" 
    ELSE "001001" WHEN instruction(31 DOWNTO 26) = "100000" 
    ELSE "111111" WHEN instruction(31 DOWNTO 26) = "110000"
    ELSE instruction(31 DOWNTO 26);

    Input_Buffer(127 DOWNTO 96) <= RD;
    Input_Buffer(95 DOWNTO 64) <= RS;
    Input_Buffer(63 DOWNTO 32) <= SignExtend_OUT;
    Input_Buffer(31) <=Immediate_SIG;
    Input_Buffer(30) <=Offset_SIG;
    Input_Buffer(29) <=Alu_EN_SIG;
    Input_Buffer(28) <=Mem_Read_SIG;
    Input_Buffer(27) <=Mem_Write_SIG;
    Input_Buffer(26) <=WB_SIG;
    Input_Buffer(25) <=Mem_To_Reg_SIG;
    Input_Buffer(24) <=Push_SIG;
    Input_Buffer(23) <=Pop_SIG;
    Input_Buffer(22) <=Port_in_SIG;
    Input_Buffer(21) <=Port_out_SIG;
    Input_Buffer(20) <=No_Change_SIG;
    Input_Buffer(19) <=Shift_Disable_SIG;
    Input_Buffer(18) <=Insert_Bubble_SIG;
    Input_Buffer(17) <=JMP;
    Input_Buffer(16) <=JMPZ_SIG;
    Input_Buffer(15) <=JMPU_SIG;
    Input_Buffer(14) <=RST_SIG;
    Input_Buffer(13 DOWNTO 8) <= OPcode; -- opcode
    Input_Buffer(7 DOWNTO 4) <=instruction(25 DOWNTO 22); --R DEST
    Input_Buffer(3 DOWNTO 0) <=instruction(21 DOWNTO 18); --R SRC
    N_Change <= No_Change_SIG;
    -- RDEST(127 DOWNTO 96) , RSRC(95 DOWNTO 64) ,SIGNEXTEND (63 DOWNTO 32) 
    --Immediate_SIG(17) , Offset_SIG(16) ,Alu_EN_SIG(15) ,Mem_Read_SIG(14) ,Mem_Write_SIG(13)
    --WB_SIG(12),Mem_To_Reg_SIG(11),Push_SIG(10),Pop_SIG(9),Port_in_SIG(8) , Port_out_SIG(7)
    --No_Change_SIG(6),Shift_Disable_SIG(5),Insert_Bubble_SIG(4)
    --JMP(3),  JMPZ_SIG(2), JMPU_SIG(1), RST_SIG(0)
    

end Dec;