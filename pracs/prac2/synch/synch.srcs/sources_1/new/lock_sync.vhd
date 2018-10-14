----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.08.2018 15:25:54
-- Design Name: 
-- Module Name: lock_sync - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lock_sync is
    Port ( inBus : in STD_LOGIC_VECTOR (15 downto 0);
           unlocked : out STD_LOGIC := '0';
           locked : out STD_LOGIC := '1';
           reset : in STD_LOGIC;
           clock1 : in STD_LOGIC := '0';
           correctCount : out STD_LOGIC_VECTOR (7 downto 0);
           incorrectCount : out STD_LOGIC_VECTOR (7 downto 0)
           );
    
end lock_sync;

architecture Behavioral of lock_sync is

signal correctCounter : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
signal incorrectCounter : STD_LOGIC_VECTOR (7 downto 0) := "00000000";

begin

process(clock1, reset, inBus) begin
    if reset'event and reset = '1' then
        --Reset 
        correctCounter <= "00000000";
        incorrectCounter <= "00000000";
        locked <= '1';
        unlocked <= '0';   
    
    elsif clock1'event and clock1 = '0' then 
        if inBus = "0011011000000111" then --s4435'3607'
            --Received Correct Combination
            locked <= '0';
            unlocked <= '1';
            correctCounter <= correctCounter + '1';
        else
            --Received Incorrect Combination
            locked <= '1';
            unlocked <= '0';
            incorrectCounter <= incorrectCounter + "1";
        end if;
    end if;
    
        
    correctCount <= correctCounter;
    incorrectCount <= incorrectCounter;
    
end Process;

end Behavioral;
