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

component bcd_1_adder
    port (
        A: in STD_LOGIC_VECTOR (3 downto 0);
        B: in STD_LOGIC_VECTOR (3 downto 0);
        C_IN: in STD_LOGIC;
        SUM: out STD_LOGIC_VECTOR (3 downto 0);
        C_OUT: out STD_LOGIC
    ); 
end component;

signal carry0To1 : std_logic;
signal carry1To2 : std_logic;

BEGIN 
    
digit0Adder : bcd_1_adder port map (
    A => Adig0,
    B => Bdig0,
    C_IN => Carry_in,
    SUM => Sdig0,
    C_OUT => carry0To1
);

digit1Adder : bcd_1_adder port map (
    A => Adig1,
    B => Bdig1,
    C_IN => carry0To1,
    SUM => Sdig1,
    C_OUT => carry1To2
);

digit2Adder : bcd_1_adder port map (
    A => Adig2,
    B => Bdig2,
    C_IN => carry1To2,
    SUM => Sdig2,
    C_OUT => Carry_out
);


end bcd_3_adder_arch;
