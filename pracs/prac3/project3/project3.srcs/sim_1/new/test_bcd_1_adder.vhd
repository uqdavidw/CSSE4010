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

entity test_bcd_1_adder is
end test_bcd_1_adder;

architecture Behavioral of test_bcd_1_adder is
    component bcd_1_adder is port (
        C_IN : in std_logic;            
        C_OUT : out std_logic;
        A: in STD_LOGIC_VECTOR (3 downto 0);
        B: in STD_LOGIC_VECTOR (3 downto 0);
        SUM: out STD_LOGIC_VECTOR (3 downto 0)
    );
    end component;
    
    signal C_IN : std_logic;
    signal C_OUT : std_logic;
    signal A : std_logic_vector(3 downto 0);
    signal B : std_logic_vector(3 downto 0);
    signal SUM : std_logic_vector(3 downto 0);
    
    signal inputSequence : std_logic_vector(95 downto 0) := X"443536075524271666171425";

begin

    uut: bcd_1_adder port map (
        C_IN => C_IN, 
        C_OUT => C_OUT,
        A => A,
        B => B,
        SUM => SUM
    );
    
    input_gen : process
        begin            
            --C_OUT <= '0';
            for i in 1 to 24 loop
                --Assign input sequence to digits
                A <= inputSequence(95 downto 92);
                B <= inputSequence(91 downto 88);
                C_IN <= '0';
               
                wait for 10ps;
                C_IN <= '1';
                
                --Shift left by 1 digit = 4 bits
                inputSequence <= std_logic_vector(shift_left(unsigned(inputSequence), 4));
                wait for 10ps;
            end loop;
        wait;
    end process;


end Behavioral;
