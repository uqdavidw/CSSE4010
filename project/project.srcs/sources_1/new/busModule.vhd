----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.10.2018 14:34:03
-- Design Name: 
-- Module Name: busModule - Behavioral
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

entity busModule is
    Port ( 
        data : inout std_logic_vector(15 downto 0) := X"0000";
        toModuleAddress : inout std_logic_vector(2 downto 0) := "000";
        fromModuleAddress : inout std_logic_vector(2 downto 0) := "000";
        senderHandshakes : inout std_logic_vector(7 downto 0) := X"00";
        receiverHandshakes :  inout std_logic_vector(7 downto 0) := X"00";
        clk : in std_logic;
        rst : in std_logic
    );
end busModule;

architecture Behavioral of busModule is
    type state_type is (setSender, waitSender, setReceiver, waitReceiver);
	signal state : state_type := setSender;
	
	signal currentSender : integer := 0;
	signal currentReceiver : integer := 0;
begin

    process(clk, rst) begin
        
        --Reset
        if(rst = '1') then
            state <= setSender;
            senderHandshakes <= "00000000";
            receiverHandshakes <= "00000000";
            currentSender <= 0;
            currentReceiver <= 0;
        
        --Clock
        elsif rising_edge(clk) then
            case state is
                when setSender =>
                    if(senderHandshakes(0) = '1') then 
                        currentSender <= 0;
                        senderHandshakes(0) <= '0';
                    elsif(senderHandshakes(2) = '1') then
                        currentSender <= 2;
                        senderHandshakes(2) <= '0';
                    elsif(senderHandshakes(3) = '1') then
                        currentSender <= 3;
                        senderHandshakes(3) <= '0';
                    elsif(senderHandshakes(1) = '1') then
                        currentSender <= 1;
                        senderHandshakes(1) <= '0';                    
                    elsif(senderHandshakes(5) = '1') then
                        currentSender <= 5;
                        senderHandshakes(5) <= '0';                    
                    elsif(senderHandshakes(7) = '1') then
                        currentSender <= 7;
                        senderHandshakes(7) <= '0';                    
                    elsif(senderHandshakes(4) = '1') then
                        currentSender <= 4;
                        senderHandshakes(4) <= '0';               
                    end if;
                    state <= waitSender;
                       
                when waitSender =>
                    if(senderHandshakes(currentSender) = '1') then 
                        state <= setReceiver;
                    end if;
                    
                when setReceiver =>
                    case toModuleAddress is
                        when "000" =>
                            currentReceiver <= 0;
                            receiverHandshakes(0) <= '1';
                        when "001" =>
                            currentReceiver <= 1;
                            receiverHandshakes(1) <= '1';
                        when "010" =>
                            currentReceiver <= 2;
                            receiverHandshakes(2) <= '1';
                        when "011" =>
                            currentReceiver <= 3;
                            receiverHandshakes(3) <= '1';
                        when "100" =>
                            currentReceiver <= 4;
                            receiverHandshakes(4) <= '1';
                        when "101" =>
                            currentReceiver <= 5;
                            receiverHandshakes(5) <= '1';
                        when "110" =>
                            currentReceiver <= 6;
                            receiverHandshakes(6) <= '1';
                        when "111" =>
                            currentReceiver <= 7;
                            receiverHandshakes(7) <= '1';
                        when others => null;
                    end case;
                    state <= waitReceiver;
                    
                when waitReceiver => 
                    if(receiverHandshakes(currentReceiver) = '0') then
                        state <= setSender;
                        currentReceiver <= 0;
                        currentSender <= 0;
                        receiverHandshakes(currentSender) <= '0';
                    end if;
            end case;
        end if;
    end process;
end Behavioral;
