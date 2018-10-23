----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.10.2018 14:34:03
-- Design Name: 
-- Module Name: keyboard - Behavioral
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

entity keyboard is
    Port (
        clk : in std_logic;
        row : in std_logic_vector(3 downto 0);
        col : out std_logic_vector(3 downto 0);
        xFrequency : out std_logic_vector(7 downto 0) := X"01";
        yFrequency : out std_logic_vector(7 downto 0) := X"01";
        mode : in std_logic_vector(1 downto 0) := "00"
                
    );
end keyboard;

architecture Behavioral of keyboard is

    component keypadAdapter port (
		clk : in  STD_LOGIC;
        Row : in  STD_LOGIC_VECTOR (3 downto 0);
		Col : out  STD_LOGIC_VECTOR (3 downto 0);
        DecodeOut : out  STD_LOGIC_VECTOR (3 downto 0);
        buttonDepressed  : out STD_LOGIC := '0'
    );
    end component;
    
    --Keypad signals
    signal keypadValue : std_logic_vector(3 downto 0) := "0000";
    signal buttonDepressed : std_logic := '0';
    signal enteredValues : std_logic_vector(11 downto 0) := X"000";
   
    signal valueUpdated : std_logic := '0'; 
    signal updateHandled : std_logic := '0';
        
begin

    --Interfaces with keypad hardware
    adapter : keypadAdapter port map (
        clk => clk,
        DecodeOut => keypadValue,
        Row => row, 
        Col => col,
        buttonDepressed => buttonDepressed
    );
    
    --Handles keypad presses stores in shift register
    keypadPresses : process (buttonDepressed) begin
        if falling_edge(buttonDepressed) then
            if(mode = "10") then 
                if(keypadValue = X"F" or keypadValue < X"C") then 
                    enteredValues(11 downto 8) <= enteredValues(7 downto 4);
                    enteredValues(7 downto 4) <= enteredValues(3 downto 0);
                    enteredValues(3 downto 0) <= keypadValue;
                    
                    if(keypadValue > X"9") then 
                        valueUpdated <= not valueUpdated;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    --Handles sending and receiving messages
    process (clk) begin
        if rising_edge(clk) then 
            --Process shift register
            if(updateHandled /= valueUpdated) then
                updateHandled <= valueUpdated;
                
                --Check inputs are valid
                if(enteredValues(11 downto 8) < X"9" or enteredValues(7 downto 4) < X"9") then
                    
                    --Reset value
                    if(enteredValues(3 downto 0) = X"F") then
                        xFrequency <= X"01";
                        yFrequency <= X"01";
                            
                    --Set A value
                    elsif(enteredValues(3 downto 0) = X"A") then
                        xFrequency <= std_logic_vector(unsigned(enteredValues(11 downto 8)) * 10 + unsigned(enteredValues(7 downto 4)));
                            
                    --Set B value
                    elsif(enteredValues(3 downto 0) = X"B") then
                        yFrequency <= std_logic_vector(unsigned(enteredValues(11 downto 8)) * 10 + unsigned(enteredValues(7 downto 4)));
                    end if;
                    
                end if;
            end if;
        end if;    
    end process;
end Behavioral;
