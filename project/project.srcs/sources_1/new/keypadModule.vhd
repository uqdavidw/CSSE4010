----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.10.2018 14:34:03
-- Design Name: 
-- Module Name: keypadModule - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity keypadModule is
    Port (
        row : in std_logic_vector(3 downto 0);
        col : out std_logic_vector(3 downto 0);
        clk : in std_logic;
        senderHandshake : inout std_logic;
        receiverHandshake : inout std_logic;
        toModuleAddress : inout std_logic_vector(2 downto 0);
        fromModuleAddress : inout std_logic_vector(2 downto 0);
        data : inout std_logic_vector(15 downto 0)
        
    );
end keypadModule;

architecture Behavioral of keypadModule is

    component keypadAdapter port (
		clk : in  STD_LOGIC;
        Row : in  STD_LOGIC_VECTOR (3 downto 0);
		Col : out  STD_LOGIC_VECTOR (3 downto 0);
        DecodeOut : out  STD_LOGIC_VECTOR (3 downto 0);
        buttonDepressed  : out STD_LOGIC := '0'
    );
    end component;
    
    signal keypadValue : std_logic_vector(3 downto 0) := "0000";
    signal buttonDepressed : std_logic := '0';
    signal enteredValue : std_logic_vector(8 downto 0) := X"00";
    signal aValue : std_logic_vector(7 downto 0) := X"00";
    signal bValue : std_logic_vector(7 downto 0) := X"00";
    signal sendFlag : std_logic := '0';
    signal onMode : std_logic := '0';

    type sendingStates is (offMode, waitSend, waitTurn, write, waitACK);
    signal sendingState : sendingStates := offMode;
        
begin

    --Interfaces with keypad hardware
    adapter : keypadAdapter port map (
        clk => clk,
        DecodeOut => keypadValue,
        Row => row, 
        Col => col,
        buttonDepressed => buttonDepressed
    );
    
    --Handles keypad presses
    keypadPresses : process (buttonDepressed) begin
        if falling_edge(buttonDepressed) then
            
            --Reset value
            if(keypadValue = X"F") then 
                enteredValue <= X"00";
                aValue <= X"01";
                bValue <= X"01";
                sendFlag <= '1';
                
            --Set A value
            elsif(keypadValue = X"A") then 
                aValue <= std_logic_vector(unsigned(enteredValue(7 downto 4)) * 10 + unsigned(enteredValue(3 downto 0)));
                enteredValue <= X"00";
                sendFlag <= '1';
                
            --Set B value
            elsif(keypadValue = X"B") then
                bValue <= std_logic_vector(unsigned(enteredValue(7 downto 4)) * 10 + unsigned(enteredValue(3 downto 0)));
                enteredValue <= X"00";
                sendFlag <= '1';
                
            --Shift entered value in    
            elsif(keypadValue < X"A") then 
                enteredValue(7 downto 4) <= enteredValue(3 downto 0);
                enteredValue(3 downto 0) <= keypadValue;
            end if;
        end if;
    end process;

    --Handles sending messages
    sendValues : process(clk)
    begin
        if rising_edge(clk) then
             if(onMode = '0') then 
                sendingState <= offMode;
             else
                case sendingState is
                
                    --Not in a mode requiring keyboard
                    when offMode =>
                        sendingState <= waitSend;
                        
                    --Waiting for a message to send
                    when waitSend =>
                        if(sendFlag = '1') then
                            senderHandshake <= '1';
                            sendingState <= waitTurn; 
                        end if;
                        
                    --Waiting for module's turn to send    
                    when waitTurn => 
                        if(senderHandshake <= '0') then
                            sendingState <= write; 
                        end if;
                        
                    --Writing value to send
                    when write => 
                        data(15 downto 8) <= aValue;
                        data(7 downto 0) <= bValue;
                        fromModuleAddress <= X"3";
                        toModuleAddress <= X"1";
                        senderHandshake <= '1';                         
                        sendingState <= waitACK;
                        
                    --Waiting for acknowledgement of message received 
                    when waitACK =>
                        if(senderHandshake = '0') then
                            sendingState <= waitSend; 
                        end if; 
                end case;
             end if; 
        end if;
    end process;
    
    --Handles receiving 
    receiveMode : process(receiverHandshake) begin 
        if rising_edge(receiverHandshake) then 
            if(fromModuleAddress = X"1") then
              if(toModuleAddress = X"3") then
                onMode <= data(0);
              end if; 
            end if;
            receiverHandshake <= '0';
        end if;
    end process;

end Behavioral;
