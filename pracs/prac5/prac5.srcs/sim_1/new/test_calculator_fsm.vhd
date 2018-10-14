----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Sam Eadie
-- 
-- Create Date: 23/09/2018
-- Design Name: 
-- Module Name: test_calculator_fsm - Mixed
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

entity test_calculator_fsm is
end test_calculator_fsm;

architecture mixed of test_calculator_fsm is
    component calculator_fsm port (
        keypadInput : in std_logic_vector (3 downto 0);
        clk : in std_logic;
        sum : in std_logic_vector (7 downto 0) := X"00";
        adderA : out std_logic_vector (7 downto 0);
        adderB : out std_logic_vector (7 downto 0);
        sseg1 : out std_logic_vector (3 downto 0);
        sseg0 : out std_logic_vector (3 downto 0);
        stateNum : out std_logic_vector (1 downto 0)
    );
    end component;

    
    signal clk : std_logic := '0';
    signal input : std_logic_vector (3 downto 0) := X"A";
    signal stateNum : std_logic_vector (1 downto 0) := "00";
    
    signal inputSequence : std_logic_vector(47 downto 0) := X"A1A23BBA45AB";

begin

    uut: calculator_fsm port map (
        clk => clk,
        keypadInput => input,
        stateNum => stateNum
    );

    --clock
    clk <= NOT clk after 100ps;
    
    --test sequence
    test_sequence : process(clk)
        begin
            if falling_edge(clk) then
                input <= inputSequence(47 downto 44);
                inputSequence <= std_logic_vector(shift_left(unsigned(inputSequence), 4));
            end if;
    end process;
end mixed;
