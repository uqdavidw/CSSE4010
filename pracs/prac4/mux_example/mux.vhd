----------------------------------------------------------------------------------
-- Company: The University of Queensland
-- Engineer: NPG
-- 
-- Create Date: 09/01/2018 04:47:31 PM
-- Design Name: 4 to 1 Multiplexer - IO example
-- Module Name: mux - Behavioral
-- Project Name: mux_io_example
-- Target Devices: xc7a100tcsg324-1 on Nexys4 board
-- Tool Versions: Vivado 2018.1
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

entity mux is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           C : in STD_LOGIC;
           D : in STD_LOGIC;
           SEL : in STD_LOGIC_VECTOR( 1 downto 0 );
           Z : out STD_LOGIC);
end mux;

architecture Behavioral of mux is

begin
	process (A, B, C, D, SEL) is
	begin
		case SEL is
			when "00" => Z <= A;
			when "01" => Z <= B;
			when "10" => Z <= C;
			when "11" => Z <= D;
			when others => NULL;
		end case;
	end process;



end Behavioral;
