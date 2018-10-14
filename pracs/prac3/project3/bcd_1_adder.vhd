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
        SUM: out STD_LOGIC_VECTOR (3 downto 0);
        C_OUT: out STD_LOGIC
    );
end bcd_1_adder;

--algorithm 
-- If A + B <= 9 then -- assume both A and B are valid BCD numbers 
-- RESULT = A + B ; 
-- CARRY = 0 ; 
-- else 
-- RESULT = A + B + 6 ; 
-- CARRY = 1; 
-- end if ; 

architecture bcd_1_adder_arch of bcd_1_adder is

begin

	--BCD adder logic
	process (A,B,C_IN)
	begin
	
	--ADD YOUR LOGIC HERE

	end process;
	
end bcd_1_adder_arch;
