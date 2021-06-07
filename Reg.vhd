LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Reg IS
    GENERIC (
        N : integer
    );
    PORT (
        clock, clear, enable : IN std_logic;
        d : IN std_logic_vector(N - 1 DOWNTO 0);
        q : OUT std_logic_vector(N - 1 DOWNTO 0)
    );
END Reg;

ARCHITECTURE rtl OF Reg IS
BEGIN
    PROCESS (clock, clear)
    BEGIN
        IF clear = '1' THEN
            q <= (OTHERS => '0');
        ELSIF rising_edge(clock) AND enable = '1' THEN
            q <= d;
        END IF;
    END PROCESS;
END rtl;



---------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Reg2 IS
    GENERIC (
        N : integer
    );
    PORT (
        clock, clear, enable : IN std_logic;
        d : IN std_logic_vector(N - 1 DOWNTO 0);
        q : OUT std_logic_vector(N - 1 DOWNTO 0)
    );
END Reg2;

ARCHITECTURE rtl2 OF Reg2 IS
BEGIN
    PROCESS (clock)
    BEGIN
    IF rising_edge(clock) AND enable = '1' and clear='1' THEN
        q <= (OTHERS => '0');
    END IF;    
    IF    falling_edge(clock) AND enable = '1' then
            q <= d;
        END IF;
    END PROCESS;
END rtl2;