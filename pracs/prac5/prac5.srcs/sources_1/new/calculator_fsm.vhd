----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Samuel Eadie
-- 
-- Create Date: 21.09.2018 15:39:39
-- Design Name: 
-- Module Name: calculator_fsm - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity calculator_fsm is
    Port (
        keypadInput : in std_logic_vector (3 downto 0);
        clk : in std_logic;
        sum : in std_logic_vector (7 downto 0);
        adderA : out std_logic_vector (7 downto 0);
        adderB : out std_logic_vector (7 downto 0);
        sseg1 : out std_logic_vector (3 downto 0);
        sseg0 : out std_logic_vector (3 downto 0);
        stateNum : out std_logic_vector (1 downto 0)
    );
end calculator_fsm;

architecture Behavioral of calculator_fsm is

    --fsm
    type states is (beginAdd, received1, received2, displaySum);
	signal state : states := beginAdd;
	
	--store values
	signal value0 : std_logic_vector(3 downto 0);
	signal value1 : std_logic_vector(3 downto 0);
	signal runningSum : std_logic_vector(7 downto 0);
	
	
begin
    adderA <= runningSum;
    adderB(7 downto 4) <= value1;
    adderB(3 downto 0) <= value0;
    
    sseg1 <= runningSum(7 downto 4) when state = displaySum else value1;
    sseg0 <= runningSum(3 downto 0) when state = displaySum else value0;
    
    process(clk)
    begin
        if falling_edge(clk) then
            --ignore C, D, E, F keys         
            if keypadInput < X"C" then
                case state is 
                    
                    when beginAdd =>
                        if keypadInput < X"A" then
                            value1 <= value0;
                            value0 <= keypadInput;
                            state <= received1;
                        elsif keypadInput = X"B" then
                            state <= displaySum;
                        end if;
                        
                    when received1 =>
                        if keypadInput < X"A" then
                            value1 <= value0;
                            value0 <= keypadInput;
                            state <= received2; 
                        end if;
                        
                    when received2 => 
                        if keypadInput < X"A" then
                            value1 <= value0;
                            value0 <= keypadInput;
                        elsif keypadInput = X"A" then
                            value0 <= X"0";
                            value1 <= X"0"; 
                            runningSum <= sum;
                            state <= beginAdd;
                        elsif keypadInput = X"B" then 
                            runningSum <= sum;
                            state <= displaySum;
                        end if;
                        
                    when displaySum =>
                        if keypadInput = X"A" then
                            value0 <= X"0";
                            value1 <= X"0";
                            runningSum <= X"00";
                            state <= beginAdd; 
                        end if;
                end case;
            end if;
        end if;
    end process;

    process(state)
    begin
        case state is
            when beginAdd => stateNum <= "00";
            when received1 => stateNum <= "01";
            when received2 => stateNum <= "10";
            when displaySum => stateNum <= "11";
        end case;
    end process;
end Behavioral;
