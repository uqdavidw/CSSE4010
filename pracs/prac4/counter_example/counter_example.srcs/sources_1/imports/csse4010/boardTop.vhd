----------------------------------------------------------------------------------
-- Company: University of Queensland
-- Engineer: NPG 
-- 
-- Create Date: 01-Sep-18 3:40:31 PM
-- Design Name: Binary Counter and boardtop example
-- Module Name: boardTop - Behavioral 
-- Project Name: counter_vio_debug
-- Target Devices: xc7a100tcsg324-1 on Digilent Nexys4
-- Tool versions: Vivado 2018.1
-- Description: 
--
-- Dependencies: counter.vhd,
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
	       logic_analyzer : out STD_LOGIC_VECTOR (7 downto 0)
       );
end boardTop;

architecture Behavioral of boardTop is

	component counter port (
				       clk : in std_logic;
				       rst : in std_logic;		
				       led : out std_logic_vector( 7 downto 0 )
			       );
	end component;

	component clockScaler port (
					   clk : in std_logic;
					   rst : in std_logic;
					   clkdiv : out std_logic
				   );
	end component;


	signal masterReset : std_logic;
	signal clockScaled : std_logic;

begin

	u1 : counter port map (
				      clk => clockScaled,
				      rst => masterReset,
				      led => LEDs( 7 downto 0)
			      );

	u2 : clockScaler port map (
					  clk => clk100mhz,
					  rst => masterReset,
					  clkdiv => clockScaled
				  );

	masterReset <= pushButtons(3);


end Behavioral;

