----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.09.2018 09:24:17
-- Design Name: 
-- Module Name: keypadAdapter - Behavioral
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

entity keypadAdapter is
    Port (
        clk : in  STD_LOGIC;
        Row : in  STD_LOGIC_VECTOR (3 downto 0);
	    Col : out  STD_LOGIC_VECTOR (3 downto 0) := "0000";
        DecodeOut : out  STD_LOGIC_VECTOR (3 downto 0) := "0000";
        buttonDepressed  : out STD_LOGIC := '0'
        );
end keypadAdapter;

architecture Behavioral of keypadAdapter is
    signal ColOn : std_logic_vector (1 downto 0) := "00";
    signal depressedState : std_logic_vector (1 downto 0) := "00";    
begin
    process(clk)
    begin
        if rising_edge(clk) then 
            case ColOn is
                --Check 1st column
                when "00" =>
                    case Row is 
                        when "0111" => 
                            DecodeOut <= X"1";
                            depressedState <= "00";
                            buttonDepressed <= '1';
                        when "1011" => 
                            DecodeOut <= X"4";
                            depressedState <= "00";
                            buttonDepressed <= '1';
                        when "1101" => 
                            DecodeOut <= X"7";
                            depressedState <= "00";
                            buttonDepressed <= '1';
                        when "1110" => 
                            DecodeOut <= X"0";
                            depressedState <= "00";
                            buttonDepressed <= '1';
                        when others =>
                            if depressedState = "00" then
                                buttonDepressed <= '0';
                            end if;
                    end case;
                    Col <= "1011";
                    ColOn <= "01";
                
                --Check 2nd column
                when "01" =>
                    case Row is 
                        when "0111" => 
                            DecodeOut <= X"2";
                            depressedState <= "01";
                            buttonDepressed <= '1';
                        when "1011" => 
                            DecodeOut <= X"5";
                            depressedState <= "01";
                            buttonDepressed <= '1';
                        when "1101" => 
                            DecodeOut <= X"8";
                            depressedState <= "01";
                            buttonDepressed <= '1';
                        when "1110" => 
                            DecodeOut <= X"F";
                            depressedState <= "01";
                            buttonDepressed <= '1';
                        when others => 
                            if depressedState = "01" then
                                buttonDepressed <= '0';
                            end if;
                    end case;
                    Col <= "1101";
                    ColOn <= "10";
                
                --Check 3rd column
                when "10" =>
                    case Row is 
                        when "0111" => 
                            DecodeOut <= X"3";
                            depressedState <= "10";
                            buttonDepressed <= '1';
                        when "1011" => 
                            DecodeOut <= X"6";
                            depressedState <= "10";
                            buttonDepressed <= '1';
                        when "1101" => 
                            DecodeOut <= X"9";
                            depressedState <= "10";
                            buttonDepressed <= '1';
                        when "1110" => 
                            DecodeOut <= X"E";
                            depressedState <= "10";
                            buttonDepressed <= '1';
                        when others => 
                            if depressedState = "10" then
                                buttonDepressed <= '0';
                            end if;
                    end case;
                    Col <= "1110";
                    ColOn <= "11";
                
                --Check 4th column
                when "11" =>
                    case Row is 
                        when "0111" => 
                            DecodeOut <= X"A";
                            depressedState <= "11";
                            buttonDepressed <= '1';
                        when "1011" => 
                            DecodeOut <= X"B";
                            depressedState <= "11";
                            buttonDepressed <= '1';
                        when "1101" => 
                            DecodeOut <= X"C";
                            depressedState <= "11";
                            buttonDepressed <= '1';
                        when "1110" => 
                            DecodeOut <= X"D";
                            depressedState <= "11";
                            buttonDepressed <= '1';
                        when others => 
                            if depressedState = "11" then
                                 buttonDepressed <= '0';
                            end if;
                    end case;
                    Col <= "0111";
                    ColOn <= "00";
                when others => null;
            end case;
        end if;
    end process;


end Behavioral;
