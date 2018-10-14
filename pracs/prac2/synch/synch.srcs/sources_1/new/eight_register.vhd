----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.08.2018 15:05:45
-- Design Name: 
-- Module Name: eight_register - Behavioral
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

entity eight_register is
    Port ( inBus : in STD_LOGIC_VECTOR (7 downto 0) := "00000000";
           outBus : out STD_LOGIC_VECTOR (7 downto 0) := "00000000";
           clk : in STD_LOGIC;
           reset : in STD_LOGIC);
end eight_register;

architecture Behavioral of eight_register is    
begin

process(reset, clk) begin 
    if reset = '1' then 
        --Perform reset
        outBus <= "10101010"; --reset to 'AA'
    elsif (clk'event and clk = '1') then
        --Perform clk rising edge
        
        outBus <= inBus;
    end if;
end process;

end Behavioral;
