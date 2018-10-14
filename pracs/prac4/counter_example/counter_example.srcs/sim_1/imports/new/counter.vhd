----------------------------------------------------------------------------------
-- Company: University of Queensland
-- Engineer: NPG 
-- 
-- Create Date: 01-Sep-18 3:40:31 PM
-- Design Name: Binary Counter and boardtop example
-- Module Name: counter.vhd
-- Project Name: counter_vio_debug
-- Target Devices: xc7a100tcsg324-1 on Digilent Nexys4
-- Tool versions: Vivado 2018.1
-- Description: 
--
-- Dependencies: None
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

entity counter is
    Port ( clk : in STD_LOGIC;
    	   rst : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR(7 downto 0));
end counter;

architecture Behavioral of counter is

	signal count_out : std_logic_vector(7 downto 0);

begin

	process(clk, rst)
	begin
		if( rst = '1' ) then
			count_out <= (others => '0');
		elsif(rising_edge(clk)) then
			count_out <= count_out + '1';
		else
		end if;
	end process;

	led(7 downto 0) <= count_out;



end Behavioral;
