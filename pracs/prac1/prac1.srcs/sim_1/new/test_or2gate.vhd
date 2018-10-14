----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.07.2018 17:11:02
-- Design Name: 
-- Module Name: test_and2gate - Behavioral
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;	

entity test_or2gate is
--  Port ( );
end test_or2gate;


ARCHITECTURE behavioral OF test_or2gate IS

COMPONENT or2gate
PORT(
in1 : IN std_logic;
in2 : IN std_logic;
outOr : OUT std_logic);
END COMPONENT;

signal inputs : std_logic_vector(1 downto 0) := "00";
signal outOr : std_logic;

BEGIN

--Instantiate the Unit Under Test (UUT)
uut: or2gate PORT MAP (
in1 => inputs(0),
in2 => inputs(1),
outOr => outOr);

    input_gen : process

        begin
    
            inputs <= "00"; --this loop will  output the truth table for  an AND gate
            for I in 1 to 4 loop
                wait for 10ps;
                
                if (inputs = "00") then
                    assert (outOr = '0') report "bad gate - stuck at 1" severity error;
                elsif (inputs = "10") then
                    assert (outOr = '1') report "bad  gate - stuck at 1 " severity error;
                elsif (inputs = "01") then
                    assert (outOr = '1') report "bad gate - stuck at 1" severity error;
                elsif (inputs = "11") then
                    assert (outOr = '1') report "bad gate - stuck at 0" severity error;
                end if;

                inputs <= inputs + '1';
            end loop;
            wait;
    end process;

END Behavioral;