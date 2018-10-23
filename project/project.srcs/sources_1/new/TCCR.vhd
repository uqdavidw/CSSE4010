----------------------------------------------------------------------------------
-- Company: The University of Queensland
-- Engineer: Sam Eadie
-- 
-- Create Date: 16.10.2018 22:11:50
-- Design Name: 
-- Module Name: TCCR - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Timer Counter Control Register: toggles interrupt at variable rate
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

    --Buffer interrupt 
    interrupt <= interruptFlag;
    
    process(clk, rst) begin
        
        --Reset timer
        if(rst = '1') then
            interruptFlag <= '0';
            count <= (others => '0');
            
        elsif rising_edge(clk) then
            --Toggle interrupt
            if(count >= compareRegister) then
                interruptFlag <= not interruptFlag;
                count <= X"01";
            else
                count <= count + "1";
            end if;
        end if;
    end process;
end Behavioral;
