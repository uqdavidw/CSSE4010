----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Sam Eadie
-- 
-- Create Date: 23/09/2018
-- Design Name: 
-- Module Name: test_keypad_adapter - Mixed
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
    component keypadAdapter port (
        clk : in  STD_LOGIC;
        Row : in  STD_LOGIC_VECTOR (3 downto 0);
        Col : out  STD_LOGIC_VECTOR (3 downto 0);
        DecodeOut : out  STD_LOGIC_VECTOR (3 downto 0);
        buttonDepressed  : out STD_LOGIC := '0'
    );
    end component;

    
    signal clk : std_logic := '0';
    signal rowIn : std_logic_vector (3 downto 0) := X"A";
    signal colOut : std_logic_vector (3 downto 0);
    signal decodeOut : std_logic_vector (3 downto 0) := X"F";
    signal buttonDepressed: std_logic;
    
    signal comparisonOut : std_logic_vector (3 downto 0);
    
    signal inputSequence : std_logic_vector(47 downto 0) := X"";

begin

    uut: keypadAdapter port map (
        clk => clk,
        Row => rowIn,
        Col => colOut,
        DecodeOut => decodeOut,
        buttonDepressed => buttonDepressed
    );

    --clock
    clk <= NOT clk after 100ps;
    
    --generate comparison outputs
    comparison_generator : process(rowIn, colOut)
    begin
        case colOut is
                    when "0111" =>
                        case rowIn is 
                            when "0111" => comparisonOut <= X"1";
                            when "1011" => comparisonOut <= X"4";
                            when "1101" => comparisonOut <= X"7";
                            when "1110" => comparisonOut <= X"0";
                            when others => null;
                        end case;
                    when "1011" =>
                        case rowIn is 
                            when "0111" => comparisonOut <= X"2";
                            when "1011" => comparisonOut <= X"5";
                            when "1101" => comparisonOut <= X"8";
                            when "1110" => comparisonOut <= X"F";
                            when others => null;
                        end case;
                    when "1101" =>
                        case rowIn is 
                            when "0111" => comparisonOut <= X"3";
                            when "1011" => comparisonOut <= X"6";
                            when "1101" => comparisonOut <= X"9";
                            when "1110" => comparisonOut <= X"E";
                            when others => null;
                        end case;                   
                    when "1110" =>
                        case rowIn is 
                            when "0111" => comparisonOut <= X"A";
                            when "1011" => comparisonOut <= X"B";
                            when "1101" => comparisonOut <= X"C";
                            when "1110" => comparisonOut <= X"D";
                            when others => null;
                        end case;
                    when others => null;
                end case;
    end process;
    
    
    --test sequence
    test_sequence : process
    begin
        for i in 1 to 20 loop
            rowIn <= inputSequence(47 downto 44);
            wait for 1ns;
            rowIn <= "1111";
            inputSequence <= std_logic_vector(shift_left(unsigned(inputSequence), 4));
            wait for 1ns;
        end loop;
    end process;
end mixed;
