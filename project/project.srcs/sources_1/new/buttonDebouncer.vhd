----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.10.2018 16:34:56
-- Design Name: 
-- Module Name: buttonDebouncer - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity buttonDebouncer is
    Port (
        clk : in std_logic;
        buttonIn : in std_logic;
        buttonOut : out std_logic
    );
end buttonDebouncer;

architecture Behavioral of buttonDebouncer is

    signal counter : std_logic_vector(15 downto 0) := X"0000";
    
begin
    process(clk) begin
        if(buttonIn = '1') then
        else
        end if;
    end process;

end Behavioral;
