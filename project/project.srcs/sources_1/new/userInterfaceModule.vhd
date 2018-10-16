----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.10.2018 14:34:03
-- Design Name: 
-- Module Name: userInterfaceModule - Behavioral
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
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity userInterfaceModule is
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
        
        --Interface with peripherals 
        sseg0 : out std_logic_vector(3 downto 0);
        sseg1 : out std_logic_vector(3 downto 0);
        sseg2 : out std_logic_vector(3 downto 0);
        sseg3 : out std_logic_vector(3 downto 0);
        sseg4 : out std_logic_vector(3 downto 0);
        sseg5 : out std_logic_vector(3 downto 0);
        sseg6 : out std_logic_vector(3 downto 0);
        sseg7 : out std_logic_vector(3 downto 0);
        
        mode : in std_logic_vector(1 downto 0) := "00"; --connect to slide switches
        buttons : in std_logic_vector(3 downto 0) := "0000";
        onButton : in std_logic := '0';
        onLED : out std_logic := '1'
    );
    
end userInterfaceModule;

architecture Behavioral of userInterfaceModule is
    component busSlave is
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
    end component;
    
    --Bus interface signals
    signal toSendRegister : std_logic_vector(15 downto 0);
    signal toModuleRegister : std_logic_vector(2 downto 0);
    signal sendFlag : std_logic := '0';
    signal receivedRegister : std_logic_vector(15 downto 0);
    signal fromModuleRegister : std_logic_vector(2 downto 0);
    signal receivedFlag : std_logic := '0';
    signal ackFlag : std_logic := '0';
    
    --UI signals
    signal xOffset : std_logic_vector(6 downto 0) := "1000000";
    signal yOffset : std_logic_vector(6 downto 0) := "1000000";
    signal xFrequency : std_logic_vector(6 downto 0) := "0000001";
    signal yFrequency : std_logic_vector(6 downto 0) := "00000001";
    signal displayOn : std_logic := '1';
    signal frequencyFlag : std_logic := '0';
    signal offsetFlag : std_logic := '0';
    
    --UI FSM
    type sendingStates is (waiting, sendMode, waitSend, singleSend);
    signal sendingState : sendingStates := waiting;
    signal modeFSM : std_logic_vector(1 downto 0) := "00";
    signal displayOnFSM : std_logic := '1';
    signal frequencyFlagFSM : std_logic := '0';
    signal offsetFlagFSM : std_logic := '0';
    
    
    
begin
    
    busInterface : busSlave port map (
        clk => clk,
        requestLine => requestLine,
        grantLine => grantLine,
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine,
        ownAddress => "000",
        toSendRegister => toSendRegister,
        toModuleRegister => toModuleRegister,
        sendFlag => sendFlag,
        receivedFlag => receivedFlag,
        ackFlag => ackFlag
    );
    
    --LED(0) 
    onLED <= displayOn;
    
    --Display mode on sseg0
    sseg0(1 downto 0) <= mode;
    sseg0(7 downto 2) <= "00000";
    
    --Display xOffset or xFrequency on sseg6, 7
    sseg7 <= std_logic_vector(unsigned(xOffset) / 10) when mode = "01" 
            else std_logic_vector(unsigned(xFrequency) / 10);
    sseg6 <= std_logic_vector(unsigned(xOffset) mod 10) when mode = "01" 
            else std_logic_vector(unsigned(xFrequency) mod 10);
    
    --Display yOffset or yFrequency on sseg4, 5
    sseg5 <= std_logic_vector(unsigned(yOffset) / 10) when mode = "01"
            else std_logic_vector(unsigned(yOffset) / 10);        
    sseg4 <= std_logic_vector(unsigned(yOffset) mod 10) when mode = "01" 
            else std_logic_vector(unsigned(yFrequency) mod 10);
            
    --Handle LRUD button presses                        
    process(buttons) begin
        if(mode = "01") then 
            
            --Left Button
            if rising_edge(buttons(0)) then
                if(xOffset /= "0000000") then 
                    xOffset <= xOffset - "1";
                    offsetFlag <= not offsetFlag;
                end if;
            
            --Right Button    
            elsif rising_edge(buttons(1)) then
                if(xOffset /= "1111111") then 
                    xOffset <= xOffset + "1";
                    offsetFlag <= not offsetFlag;                    
                end if;
            
            --Up Button
            elsif rising_edge(buttons(2)) then 
                if(yOffset /= "1111111") then 
                    yOffset <= yOffset + "1";
                    offsetFlag <= not offsetFlag;                    
                end if;
                
            --Down Button
            elsif rising_edge(buttons(3)) then
                if(yOffset /= "0000000") then 
                    yOffset <= yOffset - "1";
                    offsetFlag <= not offsetFlag;                    
                end if;
            end if;
            
        end if;
    end process;
    
    --Handle on/off button
    process(onButton) begin
        if rising_edge(onButton) then 
            displayOn <= not displayOn;
        end if;
    end process;
    
    --Send, receive functionality
    process(clk) begin
        case sendingState is
            
            --Waiting for send to be triggered
            when waiting =>
                --Check mode change
                if(modeFSM /= mode) then
                    modeFSM <= mode;
                    toSendRegister(15 downto 2) <= "0000000000000"; --clear
                    toSendRegister(1 downto 0) <= mode;
                    toModuleAddress <= "011"; --Accelerometer 
                    sendFlag <= '1';
                    sendingState <= sendMode;
                
                --Check offset change    
                elsif(offsetFlagFSM /= offsetFlag) then 
                    offsetFlagFSM <= offsetFlag;
                    toSendRegister(15 downto 14) <= "11"; --header
                    toSendRegister(13 downto 7) <= xOffset;
                    toSendRegister(6 downto 0) <= yOffset;
                    toModuleRegister <= "101"; --displayOut
                    sendFlag <= '1';
                    sendingState <= singleSend;
                    
                --Check frequency change
                elsif(frequencyFlagFSM /= frequencyFlag) then 
                    frequencyFlagFSM <= frequencyFlag;
                    toSendRegister(15 downto 14) <= "10"; --header
                    toSendRegister(13 downto 7) <= xFrequency;
                    toSendRegister(6 downto 0) <= yFrequency;
                    toModuleRegister <= "101"; --displayOut
                    sendFlag <= '1';
                    sendingState <= singleSend;
                    
                    
                --Check display on/off change    
                elsif(displayOnFSM /= displayOn) then 
                    displayOnFSM <= displayOn;
                    toSendRegister(15 downto 14) <= "01"; --header
                    toSendRegister(13 downto 1) <= "00000000000"; --clear
                    toSendRegister(0) <= displayOn;  
                    toModuleRegister <= "101";
                    sendFlag <= '1';
                    sendingState <= singleSend;
                
                end if;
            
            --Sending new mode 
            when sendMode =>
                if(grantLine <= '1') then 
                    sendFlag <= '0';
                    sendingState <= waitSend;
                end if;
                
            --Waiting to send new mode    
            when waitSend =>
                if(readyLine = '0') then 
                    --Finished sending mode to accelerometer, keyboard, curve calculator
                    if(toModuleRegister = "001") then 
                        sendingState <= waiting;
                        
                    --Send mode to next module    
                    else
                        toModuleRegister <= toModuleRegister - "1";
                        sendFlag <= '1';
                        sendingState <= sendMode;
                    end if;
                end if;
            
            --Handles sending to single module
            when singleSend => 
                if(grantLine = '1') then 
                    sendFlag <= '0';
                    sendingState <= waiting;
                end if;
             
        end case;
        
        --Handle received messages 
        if(receivedFlag = '1') then
            ackFlag <= '1';
            
            --From accelerometer
            if(fromModuleRegister = "011") then 
                --Handle messages from accelerometer
            --From keypad    
            elsif(fromModuleRegister = "010") then
                xFrequency <= receivedRegister(14 downto 8);
                yFrequency <= receivedRegister(6 downto 0);
                frequencyFlag <= not frequencyFlag; 
            end if;
        else
            ackFlag <= '0';
        end if;
    end process;

end Behavioral;
