---------------------------------------------------------------------
--	ONLY MODIFY THE INDICATED SECTION OF THIS FILE
---------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity bcd_1_adder is
    port (
        A: in STD_LOGIC_VECTOR (3 downto 0);
        B: in STD_LOGIC_VECTOR (3 downto 0);
        C_IN: in STD_LOGIC;
        SUM: out STD_LOGIC_VECTOR (3 downto 0) := "0000";
        C_OUT: out STD_LOGIC := '0'
    );
end bcd_1_adder;

architecture bcd_1_adder_arch of bcd_1_adder is

begin

	process (A,B,C_IN)
	begin
	   if A + B + C_IN <= 9 then
	       SUM  <= A + B + C_IN;
	       C_OUT <= '0';
	   else
	       SUM <= A + B + C_IN + 6;
	       C_OUT <= '1';
	   end if;
	end process;
	
end bcd_1_adder_arch;
