
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

ENTITY ForwardingUnit IS
    PORT (
        RdestAddress : IN std_logic_vector (3 DOWNTO 0);
        RsrcAddress : IN std_logic_vector (3 DOWNTO 0);
        RdestExecuteMemAddress : IN std_logic_vector (3 DOWNTO 0);
        RdestMemWriteBackAddress : IN std_logic_vector (3 DOWNTO 0);
        inPortSignal : IN std_logic;
        immediateSignal : IN std_logic;
        WBExecuteMemSignal : IN std_logic;
        WBMemWriteBackSignal : IN std_logic;
        DestSel : OUT std_logic_vector (1 DOWNTO 0);
        SrcSel : OUT std_logic_vector (1 DOWNTO 0)

    );
END ForwardingUnit;

ARCHITECTURE rtl OF ForwardingUnit IS
    
BEGIN
        DestSel <= "11" WHEN inPortSignal = '1'
        ELSE "01" WHEN WBExecuteMemSignal = '1' AND RdestAddress = RdestExecuteMemAddress
        ELSE "10" WHEN WBMemWriteBackSignal = '1' AND RdestAddress = RdestMemWriteBackAddress
        ELSE "00"; 

        SrcSel <= "11" WHEN immediateSignal = '1'
        ELSE "01" WHEN WBExecuteMemSignal = '1' AND RsrcAddress = RdestExecuteMemAddress
        ELSE "10" WHEN WBMemWriteBackSignal = '1' AND RsrcAddress = RdestMemWriteBackAddress
        ELSE "00"; 
END rtl;
