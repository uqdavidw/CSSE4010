----------------------------------------------------------------------------------
-- Company: The University of Queensland
-- Engineer: Sam Eadie
-- 
-- Create Date: 06.10.2018 14:34:03
-- Design Name: 
-- Module Name: keyboard - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Provides x, y frequencies based on keypad input
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

entity keyboard is
    Port (
        clk : in std_logic;
        row : in std_logic_vector(3 downto 0);
        col : out std_logic_vector(3 downto 0);
        xFrequency : out std_logic_vector(7 downto 0) := X"01";
        yFrequency : out std_logic_vector(7 downto 0) := X"01";
        displayDigit : out std_logic_vector(3 downto 0) := X"0";
        mode : in std_logic_vector(1 downto 0) := "00"  
    );
end keyboard;

architecture Behavioral of keyboard is
    
    --Timer Counter Control Register
    component TCCR is
        Port (
            clk : in std_logic;
            rst : in std_logic; 
            compareRegister : in std_logic_vector(7 downto 0);
            interrupt : out std_logic := '0'
         );
    end component;    

    component keypadAdapter port (
		clk : in  STD_LOGIC;
        Row : in  STD_LOGIC_VECTOR (3 downto 0);
		Col : out  STD_LOGIC_VECTOR (3 downto 0);
        DecodeOut : out  STD_LOGIC_VECTOR (3 downto 0);
        buttonDepressed  : out STD_LOGIC := '0'
    );
    end component;
    
    --Keypad clock 
    signal slowClock : std_logic := '0';
    
    --Keypad signals
    signal keypadValue : std_logic_vector(3 downto 0) := "0000";
    signal buttonDepressed : std_logic := '0';
    signal enteredValues : std_logic_vector(11 downto 0) := X"000";
   
    --New frequency handshake
    signal valueUpdated : std_logic := '0'; 
    signal updateHandled : std_logic := '0';
    
    --Reset handshake
    signal clearRegistersFlag : std_logic := '0';
    signal registersCleared : std_logic := '0';
        
begin

    --Display last digit pressed 
    displayDigit <= keypadValue;

    slowDown : TCCR port map (
        clk => clk,
        rst => '0',
        compareRegister => X"FF", 
        interrupt => slowClock
    );

    --Interfaces with keypad hardware
    adapter : keypadAdapter port map (
        clk => slowClock,
        DecodeOut => keypadValue,
        Row => row, 
        Col => col,
        buttonDepressed => buttonDepressed
    );
    
    --Handles keypad presses stores in shift register
    keypadPresses : process (buttonDepressed) begin
        if falling_edge(buttonDepressed) then
            if(mode = "10") then --keypad mode
            
                --Check for valid button press
                if(keypadValue = X"F" or keypadValue < X"C") then 
                    enteredValues(11 downto 8) <= enteredValues(7 downto 4);
                    enteredValues(7 downto 4) <= enteredValues(3 downto 0);
                    enteredValues(3 downto 0) <= keypadValue;
                    
                    --A, B, F terminate sequence
                    if(keypadValue > X"9") then 
                        valueUpdated <= not valueUpdated;
                    end if;
                 end if;
                 
             --Reset values on mode changes    
             else
                enteredValues <= X"000";
             end if;
         end if;
         
         --Check reset handshake
         if rising_edge(clk) then
            if(registersCleared /= clearRegistersFlag) then
                registersCleared <= clearRegistersFlag; 
                enteredValues <= X"000";
            end if;
         end if;
    end process;
    
    --Handles frequency updates
    process (slowClock) begin
        if rising_edge(slowClock) then 
            
            --Process shift register
            if(updateHandled /= valueUpdated) then
                updateHandled <= valueUpdated;
                clearRegistersFlag <= not clearRegistersFlag;
                
                --Reset value
                if(enteredValues(3 downto 0) = X"F") then
                    xFrequency <= X"01";
                    yFrequency <= X"01";
                end if;
                
                --Check inputs are valid
                if(enteredValues(11 downto 8) < X"A" and enteredValues(7 downto 4) < X"A") then
                         
                    --Set A value: BCD -> hex conversion
                    if(enteredValues(3 downto 0) = X"A") then
                        xFrequency <= std_logic_vector(unsigned(enteredValues(11 downto 8)) * 10 + unsigned(enteredValues(7 downto 4)));
                            
                    --Set B value: BCD -> hex conversion
                    elsif(enteredValues(3 downto 0) = X"B") then
                        yFrequency <= std_logic_vector(unsigned(enteredValues(11 downto 8)) * 10 + unsigned(enteredValues(7 downto 4)));
                    end if;
                    
                end if;
            end if;
            
            --Reset frequencies on mode changes
            if(mode /= "10") then 
                xFrequency <= X"01";
                yFrequency <= X"01";
                clearRegistersFlag <= not registersCleared;
            end if;
        end if;    
    end process;
end Behavioral;
