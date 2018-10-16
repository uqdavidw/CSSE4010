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
        clk : in std_logic;
        row : in std_logic_vector(3 downto 0);
        col : out std_logic_vector(3 downto 0);
        --Interface with bus module
        requestLine : out std_logic := '0';
        grantLine : in std_logic;
        dataLine : inout std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
        toModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
        fromModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
        readyLine : inout std_logic := 'Z';
        ackLine : inout std_logic := 'Z'        
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
    
    component busSlave is 
        Port (
            clk : in std_logic;
            --Interface with bus module
            requestLine : out std_logic := '0';
            grantLine : in std_logic;
            dataLine : inout std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
            toModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
            fromModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
            readyLine : inout std_logic;
            ackLine : inout std_logic;
                
            ownAddress : in std_logic_vector(2 downto 0);
                
            --Sending interface with module
            toSendRegister : in std_logic_vector(15 downto 0);
            toModuleRegister : in std_logic_vector(2 downto 0);
            sendFlag : in std_logic;
                
            --Receiving interface with module
            receivedRegister : out std_logic_vector(15 downto 0);
            fromModuleRegister : out std_logic_vector(2 downto 0) := "000";
            receivedFlag : out std_logic := '0';
            ackFlag : in std_logic
        );
    end component;
    
    --Bus signals
    signal toSendRegister : std_logic_vector(15 downto 0) := X"0000";
    signal sendFlag : std_logic := '0';
    signal receivedFlag : std_logic := '0';
    signal ackFlag : std_logic := '0';
    
    --Keypad signals
    signal keypadValue : std_logic_vector(3 downto 0) := "0000";
    signal buttonDepressed : std_logic := '0';
    signal enteredValues : std_logic_vector(11 downto 0) := X"000";
    signal mode : std_logic_vector(1 downto 0) := "00";

    signal valueUpdated : std_logic := '0'; 
    signal updateHandled : std_logic := '0';

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
    
    busInterface : busSlave port map (
        clk => clk,
        requestLine => requestLine,
        grantLine => grantLine,
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine,
        ownAddress => "010",
        toSendRegister => toSendRegister,
        toModuleRegister => "000",
        sendFlag => sendFlag,
        receivedFlag => receivedFlag,
        ackFlag => ackFlag
    );
    
    --Handles keypad presses stores in shift register
    keypadPresses : process (buttonDepressed) begin
        if falling_edge(buttonDepressed) then
            if(keypadValue = X"F" or keypadValue < X"C") then 
                enteredValues(11 downto 8) <= enteredValues(7 downto 4);
                enteredValues(7 downto 4) <= enteredValues(3 downto 0);
                enteredValues(3 downto 0) <= keypadValue;
                
                if(keypadValue > X"9") then 
                    valueUpdated <= not valueUpdated;
                end if;
            end if;
        end if;
    end process;
    
    --Handles sending and receiving messages
    process (clk) begin
        if rising_edge(clk) then 
            --Process shift register
            if(updateHandled /= valueUpdated) then
                --Reset value
                if(enteredValues(3 downto 0) = X"F") then
                    toSendRegister(15 downto 8) <= X"01";
                    toSendRegister(7 downto 0)  <= X"01";
                    sendFlag <= '1';
                        
                --Set A value
                elsif(enteredValues(3 downto 0) = X"A") then 
                    toSendRegister(15 downto 8) <= std_logic_vector(unsigned(enteredValues(11 downto 8)) * 10 + unsigned(enteredValues(7 downto 4)));
                    sendFlag <= '1';
                        
                --Set B value
                elsif(enteredValues(3 downto 0) = X"B") then
                    toSendRegister(7 downto 0) <= std_logic_vector(unsigned(enteredValues(11 downto 8)) * 10 + unsigned(enteredValues(7 downto 4)));
                    sendFlag <= '1';
                end if;
                
                updateHandled <= '1';
                
                --Don't send if not in keypad mode
                if(mode /= "10") then 
                    sendFlag <= '0';
                end if;
                
                updateHandled <= not updateHandled;
            end if;
            
            --Message sent    
            if(grantLine = '1') then
                sendFlag <= '0';
            end if;
            
            --Handle receiving messages
            if(receivedFlag = '1') then 
                ackFlag <= '1'; 
                if(fromModuleAddress = "000") then --Messages from user interface 
                    mode <= dataLine(1 downto 0);
                end if;
            end if;
            
            if(readyLine = '0') then 
                ackFlag <= '0';
            end if; 
        end if;
    end process;
end Behavioral;
