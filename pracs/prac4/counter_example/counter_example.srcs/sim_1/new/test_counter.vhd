----------------------------------------------------------------------------------
-- Company: University of Queensland
-- Engineer: NPG 
-- 
-- Create Date: 01-Sep-18 3:40:31 PM
-- Design Name: Binary Counter and boardtop example
-- Module Name: test_counter.vhd
-- Project Name: counter_vio_debug
-- Target Devices: xc7a100tcsg324-1 on Digilent Nexys4
-- Tool versions: Vivado 2018.1
-- Description: Testbench for counter.vhd
--
-- Dependencies: counter.vhd
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_counter is
	end test_counter;

architecture Behavioral of test_counter is

	component counter port ( 
				       clk : in STD_LOGIC;
				       rst : in STD_LOGIC;
				       led : out STD_LOGIC_VECTOR(7 downto 0)
			       );
	end component;

	signal gen_clk : std_logic := '0';
	signal gen_rst : std_logic := '0';
	signal gen_led : std_logic_vector ( 7 downto 0 ) := (others => '0');


begin
	uut : counter port map (
		clk => gen_clk,
		rst => gen_rst,
		led => gen_led
	);

	gen_rst <= '1', '0' after 20ns;
	gen_clk <= not gen_clk after 100ns;

end Behavioral;
