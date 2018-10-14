----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Sam Eadie
-- 
-- Create Date: 21.09.2018 14:17:55
-- Design Name: 
-- Module Name: adder_module - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adder_module is
    port (
        Carry_in : in std_logic := '0';			
        Carry_out : out std_logic;
        A : in std_logic_vector (7 downto 0);
        B : in std_logic_vector (7 downto 0);
        S : out std_logic_vector (7 downto 0) 
    );
end adder_module;

architecture Behavioral of adder_module is
    component bcd_1_adder
    port (
        A: in STD_LOGIC_VECTOR (3 downto 0);
        B: in STD_LOGIC_VECTOR (3 downto 0);
        C_IN: in STD_LOGIC;
        SUM: out STD_LOGIC_VECTOR (3 downto 0);
        C_OUT: out STD_LOGIC
    ); 
    end component;
   
    signal carry_between : std_logic;
begin
    
    digit0Adder : bcd_1_adder port map (
        A => A(3 downto 0),
        B => B(3 downto 0),
        C_IN => Carry_in,
        SUM => S(3 downto 0),
        C_OUT => carry_between
    );
    
    digit1Adder : bcd_1_adder port map (
        A => a(7 downto 4),
        B => B(7 downto 4),
        C_IN => carry_between,
        SUM => S(7 downto 4),
        C_OUT => Carry_out
    );

end Behavioral;