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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_and2gate is
--  Port ( );
end test_and2gate;

--architecture Behavioral of test_and2gate is

--component and2gate port (
--in1 : in STD_LOGIC; 
--in2 : in STD_LOGIC; 
--outAnd : out STD_LOGIC); 
--end component; 

--signal in1 : STD_LOGIC; 
--signal in2 : STD_LOGIC; 
--signal outAnd : STD_LOGIC; 
	

--begin

--	u1 : and2gate port map (
--	   in1 => in1,
--	   in2 => in2,
--	   outAnd => outAnd);	
	   
--	   tgen1: PROCESS               -- tgen1 is a label that can be changed 
--	   BEGIN
--	        in1 <= '0';              -- Must start from explicitly set values
--	             FOR I IN 0 TO 5 LOOP     -- loop as many times you see fit
--	                      in1 <= '1' ;
--	                      WAIT FOR 10ps ;      -- the process stops for 10ps,
--	                      in1 <= '0' ;               
--                          WAIT FOR 15ps ;      -- '0' is kept on in1w for 15ps     
--                  END LOOP ;     
--             WAIT ;                   -- will wait forever, stops simulation  END PROCESS ; 
--	   END PROCESS;

--       in2 <= '0', '1' AFTER 20 ps, '0' AFTER 20 ps, '1' AFTER 25 ps, '0' AFTER 32 ps, '1' AFTER 41 ps, '0' AFTER 50 ps ; 

--end Behavioral;

ARCHITECTURE behavioral OF test_and2gate IS

COMPONENT and2gate
PORT(
in1 : IN std_logic;
in2 : IN std_logic;
outAnd : OUT std_logic);
END COMPONENT;

signal inputs : std_logic_vector(1 downto 0) := "00";
signal outAnd : std_logic;

BEGIN

--Instantiate the Unit Under Test (UUT)
uut: and2gate PORT MAP (
in1 => inputs(0),
in2 => inputs(1),
outAnd => outAnd);

    input_gen : process

        begin
    
            inputs <= "00"; --this loop will  output the truth table for  an AND gate
            for I in 1 to 4 loop
                wait for 10ps;
                
                if (inputs = "00") then
                    assert (outAnd = '0') report "bad gate - stuck at 1" severity error;
                elsif (inputs = "10") then
                    assert (outAnd = '0') report "bad  gate - stuck at 1 " severity error;
                elsif (inputs = "01") then
                    assert (outAnd = '0') report "bad gate - stuck at 1" severity error;
                elsif (inputs = "11") then
                    assert (outAnd = '1') report "bad gate - stuck at 0" severity error;
                end if;

                
                inputs <= inputs + '1';
            end loop;
            wait;
    end process;

END Behavioral;
