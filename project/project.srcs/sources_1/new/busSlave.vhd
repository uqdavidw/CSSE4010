----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2018 13:00:21
-- Design Name: 
-- Module Name: busSlave - Behavioral
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

entity busSlave is
    Port (
        clk : in std_logic;
        --Interface with bus module
        requestLine : out std_logic := '0';
        grantLine : in std_logic;
        dataLine : inout std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
        toModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
        fromModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
        readyLine : inout std_logic := 'Z';
        ackLine : inout std_logic := 'Z';
        
        ownAddress : in std_logic_vector(2 downto 0);
        
        --Sending interface with module
        toSendRegister : in std_logic_vector(15 downto 0);
        toModuleRegister : in std_logic_vector(2 downto 0);
        sendFlag : in std_logic := '0';
        
        --Receiving interface with module
        receivedRegister : out std_logic_vector(15 downto 0);
        fromModuleRegister : out std_logic_vector(2 downto 0);
        receivedFlag : out std_logic := '0';
        ackFlag : in std_logic := '0'
    );
end busSlave;

architecture Behavioral of busSlave is
    type sendingStates is (waitSend, waitTurn, write, waitACK, finished);
    signal sendingState : sendingStates := waitSend;
    
    type receivingStates is (waiting, receiving, ACK, finished);
    signal receivingState : receivingStates := waiting;
    
begin

    --Handles sending messages
    sendValues : process(clk)
    begin
        if rising_edge(clk) then
                case sendingState is
                
                    --Waiting for a message to send
                    when waitSend =>
                        if(sendFlag = '1') then
                            requestLine <= '1';
                            sendingState <= waitTurn; 
                        end if;
                        
                    --Waiting for module's turn to send    
                    when waitTurn => 
                        if(grantLine = '1') then
                            sendingState <= write; 
                        end if;
                        
                    --Writing value to send
                    when write => 
                        readyLine <= '1';
                        dataLine <= toSendRegister;
                        toModuleAddress <= toModuleRegister;
                        fromModuleAddress <= ownAddress;        
                        sendingState <= waitACK;
                        
                    --Waiting for acknowledgement of message received 
                    when waitACK =>
                        if(ackLine = '1') then
                            readyLine <= '0';
                            if(sendFlag = '1') then
                                sendingState <= write;
                            else
                                sendingState <= finished;
                            end if;
                        end if;
                            
                    --Finished sending relinquish control
                    when finished =>
                        if(ackLine = '0') then 
                            dataLine <= "ZZZZZZZZZZZZZZZZ";
                            toModuleAddress <= "ZZZ";
                            fromModuleAddress <= "ZZZ";
                            readyLine <= 'Z';
                            requestLine <= '0';
                            sendingState <= waitSend;
                        end if;    
                        
                   
                end case;
             end if;
    end process;
    
    --Handles receiving messages
    receiveValue : process(clk) begin
        if rising_edge(clk) then 
            case receivingState is
            
                --Waiting to receive message
                when waiting => 
                    if(readyLine = '1') then 
                        if(toModuleAddress = ownAddress) then
                            fromModuleRegister <= fromModuleAddress;
                            receivedRegister <= dataLine;
                            receivedFlag <= '1';
                            receivingState <= receiving;
                        end if; 
                    end if;
                    
                --Received message, let module use value    
                when receiving =>
                    if(ackFlag = '1') then
                        ackLine <= '1';
                        receivingState <= ACK;
                    end if;
                
                --Message acknowledged
                when ACK =>
                    if(readyLine = '0') then
                        ackLine <= '0';
                        receivedFlag <= '0';
                        receivingState <= finished;
                    end if;
                
                --Finished receving, relinquish control
                when finished =>
                    ackLine <= 'Z';
                    receivingState <= waiting;

            end case;
        end if;
    end process;
end Behavioral;