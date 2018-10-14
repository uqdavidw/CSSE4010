----------------------------------------------------------------------------------
-- Company: The University of Queensland
-- Engineer: NPG
-- 
-- Create Date: 09/01/2018 04:47:31 PM
-- Design Name: 4 to 1 Multiplexer - IO example
-- Module Name: boardTop
-- Project Name: mux_io_example
-- Target Devices: xc7a100tcsg324-1 on Nexys4 board
-- Tool Versions: Vivado 2018.1
-- Description: 
-- 
-- Dependencies: mux.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity boardTop is
    Port ( ssegAnode : out  STD_LOGIC_VECTOR (7 downto 0);
           ssegCathode : out  STD_LOGIC_VECTOR (7 downto 0);
           slideSwitches : in  STD_LOGIC_VECTOR (15 downto 0);
           pushButtons : in  STD_LOGIC_VECTOR (4 downto 0);
           LEDs : out  STD_LOGIC_VECTOR (15 downto 0);
			  clk100mhz : in STD_LOGIC;
			  logic_analyzer : out STD_LOGIC_VECTOR (7 downto 0));
end boardTop;

architecture Behavioral of boardTop is
	component mux port (
		A, B, C, D : in std_logic;
		SEL : in std_logic_vector( 1 downto 0 );
		Z : out std_logic
	);
	end component;

begin
	u1: mux port map (
		A => slideSwitches(15),
		B => slideSwitches(14),
		C => slideSwitches(13),
		D => slideSwitches(12),
		SEL(1) => slideSwitches(11),
		SEL(0) => slideSwitches(10),
		Z => LEDs(0)
	);

end Behavioral;

