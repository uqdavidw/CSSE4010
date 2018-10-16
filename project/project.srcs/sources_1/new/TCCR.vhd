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
        interrupt : out std_logic
     );
end TCCR;

architecture Behavioral of TCCR is
    signal count : std_logic_vector(7 downto 0) := X"00";
begin

    process(clk, rst) begin
        if(rst = '1') then 
            count <= X"00";
            
        elsif rising_edge(clk) then
            if(count = compareRegister) then
                count <= X"00";
                interrupt <= '1';
            else
                count <= count + "1";
                interrupt <= '0';
            end if;
        end if;
    end process;

end Behavioral;
