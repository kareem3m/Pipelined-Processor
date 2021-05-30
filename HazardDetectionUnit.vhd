LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY HazardDetectionUnit IS
    PORT (
        Rsource_Decode,Rdest_Decode, RDest_Excute: IN std_logic_vector(3 DOWNTO 0);
        Mem_Read: IN std_logic;
        No_Change,Shift_Disable,Insert_Bubble:OUT std_logic

    );
END HazardDetectionUnit;
ARCHITECTURE HazardDetection OF HazardDetectionUnit IS
begin 
Shift_Disable<='1' WHEN (Mem_Read = '1') AND ((RDest_Excute = Rdest_Decode) OR (RDest_Excute= Rsource_Decode))
ELSE '0';
Insert_Bubble<='1' WHEN (Mem_Read = '1') AND ((RDest_Excute = Rdest_Decode) OR (RDest_Excute = Rsource_Decode))
ELSE '0';
No_Change <= '1' WHEN (Mem_Read = '1') AND ((RDest_Excute = Rdest_Decode) OR (RDest_Excute = Rsource_Decode))
ELSE '0';
end HazardDetection;




