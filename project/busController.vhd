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
        grantLines : out std_logic_vector(7 downto 0) := X"00";
        readyLine : in std_logic;
        ackLine : in std_logic;
        clk : in std_logic;
        rst : in std_logic
    );
end busController;

architecture Behavioral of busController is
    type state_type is (setSender, waitSender);
	signal state : state_type := setSender;
	
	--signal currentSender : integer := 0;
	
	signal grantLinesRegister : std_logic_vector(7 downto 0) := X"00";
begin

    grantLines <= grantLinesRegister; 

    process(clk, rst) begin
        
        --Reset
        --if(rst = '1') then
        --    state <= setSender;
        --    grantLines <= "00000000";
        --    currentSender <= 0;
        
        --Clock
        if rising_edge(clk) then
        if(rst = '1') then
                    state <= setSender;
                    grantLinesRegister <= "00000000";
                    --currentSender <= 0;
        else 
            case state is
                when setSender =>
                    if(requestLines(0) = '1') then 
                        --currentSender <= 0;
                        grantLinesRegister(0) <= '1';
                        state <= waitSender;
                    elsif(requestLines(2) = '1') then
                        --currentSender <= 2;
                        grantLinesRegister(2) <= '1';
                        state <= waitSender;
                    elsif(requestLines(3) = '1') then
                        --currentSender <= 3;
                        grantLinesRegister(3) <= '1';
                        state <= waitSender;
                    elsif(requestLines(1) = '1') then
                        --currentSender <= 1;
                        grantLinesRegister(1) <= '1';
                        state <= waitSender;                    
                    elsif(requestLines(5) = '1') then
                        --currentSender <= 5;
                        grantLinesRegister(5) <= '1';
                        state <= waitSender;                    
                    --elsif(requestLines(7) = '1') then
                        --currentSender <= 7;
                     --   grantLinesRegister(7) <= '1';
                     --   state <= waitSender;                    
                    elsif(requestLines(4) = '1') then
                        --currentSender <= 4;
                        grantLinesRegister(4) <= '1';
                        state <= waitSender;               
                    end if;
                    
                when waitSender =>
                    if(grantLinesRegister(0) = '1' and requestLines(0) = '0') then
                        grantLinesRegister(0) <= '0';
                        state <= setSender;
                    elsif(grantLinesRegister(1) = '1' and requestLines(1) = '0') then
                        grantLinesRegister(1) <= '0';
                        state <= setSender;
                    elsif(grantLinesRegister(2) = '1' and requestLines(2) = '0') then
                        grantLinesRegister(2) <= '0';
                        state <= setSender;
                    elsif(grantLinesRegister(3) = '1' and requestLines(3) = '0') then
                        grantLinesRegister(3) <= '0';
                        state <= setSender;
                    elsif(grantLinesRegister(4) = '1' and requestLines(4) = '0') then
                        grantLinesRegister(4) <= '0';
                        state <= setSender;
                    elsif(grantLinesRegister(5) = '1' and requestLines(5) = '0') then
                        grantLinesRegister(5) <= '0';
                        state <= setSender;
                    elsif(grantLinesRegister(6) = '1' and requestLines(6) = '0') then
                        grantLinesRegister(6) <= '0';
                        state <= setSender;
                    --elsif(grantLinesRegister(7) = '1' and requestLines(7) = '0') then
                    --    grantLinesRegister(7) <= '0';
                    --    state <= setSender;
                    end if;
--                    if(requestLines(currentSender) = '0')  then -- or grantLines(currentSender) = '0') then 
--                        grantLines(currentSender) <= '0';
--                        --if(ackLine /= '1') then
--                            state <= setSender;
--                        --end if;
--                    end if;
            end case;
            end if;
        end if;        
    end process;
end Behavioral;