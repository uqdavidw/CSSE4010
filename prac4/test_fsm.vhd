----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Sam Eadie
-- 
-- Create Date: 07/09/2018
-- Design Name: 
-- Module Name: test_fsm - Mixed
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_fsm is
end test_fsm;

architecture mixed of test_fsm is
    component fsm_1 is port (
        clk : in std_logic;
        reset : in std_logic;
        inputX : in std_logic;
        outputZ : out std_logic
    );
    end component;
    
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal inputX : std_logic := '0';
    signal outputZ : std_logic;
    
    signal inputSequence : std_logic_vector(23 downto 0) := "001001110101101111011100";

begin

    uut: fsm_1 port map (
        clk => clk,
        reset => reset,
        inputX => inputX,
        outputZ => outputZ
    );

    --clock
    clk <= NOT clk after 100ps;
    
    --test sequence
    test_sequence : process(clk)
        begin
            if falling_edge(clk) then
                inputX <= inputSequence(23);
                inputSequence <= std_logic_vector(shift_left(unsigned(inputSequence), 1));
            end if;
    end process;
end mixed;
