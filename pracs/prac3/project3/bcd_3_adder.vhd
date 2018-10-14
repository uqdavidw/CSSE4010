---------------------------------------------------------------------
--	ONLY MODIFY THE INDICATED SECTION OF THIS FILE
---------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity bcd_3_adder is
    port (
	Carry_in : in std_logic;			
	Carry_out : out std_logic;
        Adig0: in STD_LOGIC_VECTOR (3 downto 0);
        Adig1: in STD_LOGIC_VECTOR (3 downto 0);
        Adig2: in STD_LOGIC_VECTOR (3 downto 0);
        Bdig0: in STD_LOGIC_VECTOR (3 downto 0);
        Bdig1: in STD_LOGIC_VECTOR (3 downto 0);
        Bdig2: in STD_LOGIC_VECTOR (3 downto 0);
        Sdig0: out STD_LOGIC_VECTOR (3 downto 0);
        Sdig1: out STD_LOGIC_VECTOR (3 downto 0);
        Sdig2: out STD_LOGIC_VECTOR (3 downto 0)
    );
end bcd_3_adder;

architecture bcd_3_adder_arch of bcd_3_adder is


--declare everything you want to use
--including one bit adder component and signals for connecting carry pins of 3 adders. 


BEGIN 




--ADD YOUR LOGIC HERE 
-- remember you connect components which are one digit adders





end bcd_3_adder_arch;
