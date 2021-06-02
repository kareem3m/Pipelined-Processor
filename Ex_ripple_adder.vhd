Library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder is
	port (a,b,cin : in  std_logic;
		  s, cout : out std_logic );
end full_adder;

architecture arch_full_adder of full_adder is
	begin
		s <= a xor b xor cin;
		cout <= (a and b) or (cin and (a xor b));
		
end arch_full_adder;
-------------------
Library IEEE;
use IEEE.std_logic_1164.all;

entity Ex_ripple_adder is
    generic (ADDER_SIZE : integer := 32);
    port   (a, b : in std_logic_vector(ADDER_SIZE-1 downto 0) ;
            cin : in std_logic;
            sum : out std_logic_vector(ADDER_SIZE-1 downto 0);
            cout : out std_logic);
end Ex_ripple_adder;

architecture arch_ripple_adder of Ex_ripple_adder is

component full_adder is
            port( a,b,cin : in std_logic;
                s,cout : out std_logic
            );
end component;

signal outputSignal : std_logic_vector(ADDER_SIZE-1 downto 0);
begin
    f0: full_adder port MAP(a(0), b(0), cin, sum(0), outputSignal(0));
    loop1: for i in 1 to ADDER_SIZE-1 generate
            fx: full_adder port MAP(a(i), b(i), outputSignal(i-1), sum(i), outputSignal(i));
    end generate;
    Cout <= outputSignal(ADDER_SIZE-1);
end arch_ripple_adder;
