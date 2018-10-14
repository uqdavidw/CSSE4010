----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.07.2018 18:44:04
-- Design Name: 
-- Module Name: test_and2orgatemixed - Behavioral
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

entity test_and2orgatemixed is
end test_and2orgatemixed;

architecture Behavioral of test_and2orgatemixed is
    COMPONENT and2or
        PORT(
            in1,in2,in3,in4 : IN std_logic;       
            outandor, outandor_flow, outandor_beh : OUT std_logic
        );
    END COMPONENT;

signal inputs : std_logic_vector(3 downto 0) := "0000";
signal outputs : std_logic_vector(2 downto 0) := "000";
    
begin

uut: and2or PORT MAP (
    in1 => inputs(0), 
    in2 => inputs(1),
    in3 => inputs(2),
    in4 => inputs(3),
    outandor => outputs(0),
    outandor_flow => outputs(1),
    outandor_beh => outputs(2)
    );

input_gen : process

    begin
        inputs <= "0000";
    
        for I in 1 to 16 loop
            wait for 10ps;
            --(in1 AND in2) OR (in3 AND in4)
            assert (outputs(0) = ((inputs(0) AND inputs(1)) OR (inputs(2) AND inputs(3)))) report "bad gate - stuck at 1" severity error;
            assert (outputs(1) = ((inputs(0) AND inputs(1)) OR (inputs(2) AND inputs(3)))) report "bad gate - stuck at 2" severity error;
            assert (outputs(2) = ((inputs(0) AND inputs(1)) OR (inputs(2) AND inputs(3)))) report "bad gate - stuck at 3" severity error;
            inputs <= inputs + '1';
        end loop;
        wait;
    end process;

end Behavioral;
