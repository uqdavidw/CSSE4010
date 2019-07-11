----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.10.2018 13:36:30
-- Design Name: 
-- Module Name: eightBitCounter - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity eightBitCounter is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        output : out std_logic_vector (7 downto 0) 
    );
end eightBitCounter;

architecture Behavioral of eightBitCounter is
    signal count : std_logic_vector(7 downto 0) := X"00";    
begin

    output <= count;
   
    process(rst, clk) begin 
        if rst = '1' then
            count <= X"00";
        elsif rising_edge(clk) then
            count <= count + '1';
        end if;
    end process;


end Behavioral;
