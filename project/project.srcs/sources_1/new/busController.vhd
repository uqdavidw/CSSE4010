----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2018 17:26:05
-- Design Name: 
-- Module Name: busController - Behavioral
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

entity busController is
    Port (
        requestLines : in std_logic_vector(7 downto 0) := X"00";
        grantLines : inout std_logic_vector(7 downto 0) := X"00";
        readyLine : in std_logic;
        ackLine : in std_logic;
        clk : in std_logic;
        rst : in std_logic
    );
end busController;

architecture Behavioral of busController is
    type state_type is (setSender, waitSender);
	signal state : state_type := setSender;
	
	signal currentSender : integer := 0;
begin

    process(clk, rst) begin
        
        --Reset
        if(rst = '1') then
            state <= setSender;
            grantLines <= "00000000";
            currentSender <= 0;
        
        --Clock
        elsif rising_edge(clk) then
            case state is
                when setSender =>
                    if(requestLines(0) = '1') then 
                        currentSender <= 0;
                        grantLines(0) <= '1';
                        state <= waitSender;
                    elsif(requestLines(2) = '1') then
                        currentSender <= 2;
                        grantLines(2) <= '1';
                        state <= waitSender;
                    elsif(requestLines(3) = '1') then
                        currentSender <= 3;
                        grantLines(3) <= '1';
                        state <= waitSender;
                    elsif(requestLines(1) = '1') then
                        currentSender <= 1;
                        grantLines(1) <= '1';
                        state <= waitSender;                    
                    elsif(requestLines(5) = '1') then
                        currentSender <= 5;
                        grantLines(5) <= '1';
                        state <= waitSender;                    
                    elsif(requestLines(7) = '1') then
                        currentSender <= 7;
                        grantLines(7) <= '1';
                        state <= waitSender;                    
                    elsif(requestLines(4) = '1') then
                        currentSender <= 4;
                        grantLines(4) <= '1';
                        state <= waitSender;               
                    end if;
                    
                when waitSender =>
                    if(requestLines(currentSender) = '0') then -- or grantLines(currentSender) = '0') then 
                        grantLines(currentSender) <= '0';
                        --if(ackLine /= '1') then
                            state <= setSender;
                        --end if;
                    end if;
            end case;
        end if;        
    end process;
end Behavioral;