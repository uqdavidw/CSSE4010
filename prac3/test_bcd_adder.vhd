----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.08.2018 09:08:08
-- Design Name: 
-- Module Name: test_bcd_adder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_bcd_adder is
end test_bcd_adder;

architecture Behavioral of test_bcd_adder is
    component bcd_3_adder is port (
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
    end component;
    
    signal Carry_in : std_logic;
    signal Carry_out : std_logic;
    signal Adig2 : std_logic_vector(3 downto 0);
    signal Adig1 : std_logic_vector(3 downto 0);
    signal Adig0 : std_logic_vector(3 downto 0);
    signal Bdig2 : std_logic_vector(3 downto 0);
    signal Bdig1 : std_logic_vector(3 downto 0);
    signal Bdig0 : std_logic_vector(3 downto 0);
    signal Sdig2 : std_logic_vector(3 downto 0);
    signal Sdig1 : std_logic_vector(3 downto 0);
    signal Sdig0 : std_logic_vector(3 downto 0);
    
    signal inputSequence : std_logic_vector(95 downto 0) := X"443536075524271666171425";

begin

    uut: bcd_3_adder port map (
        Carry_in => Carry_in, 
        Carry_out => Carry_out,
        Adig0 => Adig0,
        Adig1 => Adig1,
        Adig2 => Adig2,
        Bdig0 => Bdig0,
        Bdig1 => Bdig1,
        Bdig2 => Bdig2,
        Sdig0 => Sdig0,
        Sdig1 => Sdig1,
        Sdig2 => Sdig2
    );
    
    test_sequence : process
        begin
            Carry_in <= '0';
            
            --Using as a two digit adder
            Adig2 <= "0000";
            Bdig2 <= "0000";
            
            for i in 1 to 24 loop
                --Assign input sequence to digits
                Adig1 <= inputSequence(95 downto 92);
                Adig0 <= inputSequence(91 downto 88);
                Bdig1 <= inputSequence(87 downto 84);
                Bdig0 <= inputSequence(83 downto 80);
               
                if Sdig2 /= "0000" then
                    report "Overflow has occured";
                end if;
                
                --Shift left by 1 digit = 4 bits
                inputSequence <= std_logic_vector(shift_left(unsigned(inputSequence), 4));
                wait for 10ps;
            end loop;
        wait;
    end process;


end Behavioral;
