----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2018 22:11:50
-- Design Name: 
-- Module Name: TCCR - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TCCR is
    Port (
        clk : in std_logic;
        rst : in std_logic; 
        compareRegister : in std_logic_vector(7 downto 0);
        interrupt : out std_logic := '0'
     );
end TCCR;

architecture Behavioral of TCCR is
    signal count : std_logic_vector(7 downto 0) := X"00";
    signal interruptFlag : std_logic := '0';
begin

    interrupt <= interruptFlag;
    
    process(clk, rst) begin
        if(rst = '1') then
            interruptFlag <= '0';
            count <= (others => '0');
            
        elsif rising_edge(clk) then
            if(count >= compareRegister) then
                interruptFlag <= not interruptFlag;
                count <= X"01";
            else
                count <= count + "1";
            end if;
        end if;
    end process;
end Behavioral;
