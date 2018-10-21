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
        rst : in std_logic;
        --Interface with bus module
        requestLine : out std_logic := '0';
        grantLine : in std_logic;
        dataLine : inout std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
        toModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
        fromModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
        readyLine : inout std_logic := 'Z';
        ackLine : inout std_logic := 'Z';
        
        --Interface with peripherals 
        ssegAnode : out std_logic_vector(7 downto 0);
        ssegCathode : out std_logic_vector(7 downto 0);
        
        mode : in std_logic_vector(1 downto 0) := "00"; --connect to slide switches
        buttons : in std_logic_vector(3 downto 0) := "0000";
        middleButton : in std_logic := '0';
        LEDs : out std_logic_vector(15 downto 0) := X"0000"
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
    
    component clockScaler port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        clkdiv : out STD_LOGIC
    );
    end component;
    
    component ssegDriver port (
        clk : in std_logic;
        rst : in std_logic;
        anode_p : out std_logic_vector(7 downto 0);
        cathode_p : out std_logic_vector(7 downto 0);
        digit1_p : in std_logic_vector(3 downto 0) := "0000";
        digit2_p : in std_logic_vector(3 downto 0) := "0000";
        digit3_p : in std_logic_vector(3 downto 0) := "0000";
        digit4_p : in std_logic_vector(3 downto 0) := "0000";
        digit5_p : in std_logic_vector(3 downto 0) := "0000";
        digit6_p : in std_logic_vector(3 downto 0) := "0000";
        digit7_p : in std_logic_vector(3 downto 0) := "0000";
        digit8_p : in std_logic_vector(3 downto 0) := "0000"
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
    signal yFrequency : std_logic_vector(6 downto 0) := "0000001";
    signal displayOn : std_logic := '1';
    signal frequencyFlag : std_logic := '0';
    signal leftFlag : std_logic := '0';
    signal rightFlag : std_logic := '0';
    signal upFlag : std_logic := '0';
    signal downFlag : std_logic := '0';
    signal leftButton : std_logic := '0';
    signal rightButton : std_logic := '0';
    signal upButton : std_logic := '0';
    signal downButton : std_logic := '0';
    signal onButton : std_logic := '0';
    
    --UI FSM
    type sendingStates is (waiting, sendMode, waitSend, singleSend);
    signal sendingState : sendingStates := waiting;
    signal modeFSM : std_logic_vector(1 downto 0) := "00";
    signal displayOnFSM : std_logic := '1';
    signal frequencyFlagFSM : std_logic := '0';
    signal leftFlagFSM : std_logic := '0';
    signal rightFlagFSM : std_logic := '0';
    signal upFlagFSM : std_logic := '0';
    signal downFlagFSM : std_logic := '0';

    
    --sseg signals
    signal scaledClk : std_logic := '0';
    signal sseg0 : std_logic_vector(3 downto 0) := X"0";
    signal sseg1 : std_logic_vector(3 downto 0) := X"0";
    signal sseg2 : std_logic_vector(3 downto 0) := X"0";
    signal sseg3 : std_logic_vector(3 downto 0) := X"0";
    signal sseg4 : std_logic_vector(3 downto 0) := X"0";
    signal sseg5 : std_logic_vector(3 downto 0) := X"0";
    signal sseg6 : std_logic_vector(3 downto 0) := X"0";
    signal sseg7 : std_logic_vector(3 downto 0) := X"0";    
    
    signal bcdConverter1 : std_logic_vector(6 downto 0) := "0000000";
    signal bcdConverter2 : std_logic_vector(6 downto 0) := "0000000";
    signal bcdConverter3 : std_logic_vector(6 downto 0) := "0000000";
    signal bcdConverter4 : std_logic_vector(6 downto 0) := "0000000";
    
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
        receivedRegister => receivedRegister,
        fromModuleRegister => fromModuleRegister,
        ackFlag => ackFlag
    );
    
    clock_scaler : clockScaler port map (
        clk => clk,
        rst => rst,
        clkdiv => scaledClk
    );
    
    sseg : ssegDriver port map (
        rst => rst,
        cathode_p => ssegCathode,
        anode_p => ssegAnode,
        clk => scaledClk,
        digit1_p => sseg0,
        digit2_p => sseg1,
        digit3_p => sseg2,
        digit4_p => sseg3,
        digit5_p => sseg4,
        digit6_p => sseg5,
        digit7_p => sseg6,
        digit8_p => sseg7
    );

    
    --LED(0) 
    LEDs(0) <= displayOn;
    
    LEDs(5) <= leftFlag;
    LEDs(4) <= rightFlag;
    LEDs(3) <= upFlag;
    LEDs(2) <= downFlag;
    
    
    --Display mode on sseg0
    sseg0(1 downto 0) <= mode;
    sseg0(3 downto 2) <= "00";
    
    --Display xOffset or xFrequency on sseg6, 7
--    bcdConverter1 <= std_logic_vector(unsigned(xOffset) / 10) when mode = "01" 
--                else std_logic_vector(unsigned(xFrequency) / 10);
--    sseg7 <= bcdConverter1(3 downto 0);
--    bcdConverter2 <= std_logic_vector(unsigned(xOffset) mod 10) when mode = "01" 
--            else std_logic_vector(unsigned(xFrequency) mod 10);
--    sseg6 <= bcdConverter2(3 downto 0);
    
--    --Display yOffset or yFrequency on sseg4, 5
--    bcdConverter3 <= std_logic_vector(unsigned(yOffset) / 10) when mode = "01"
--            else std_logic_vector(unsigned(yOffset) / 10);
--    sseg5 <= bcdConverter3(3 downto 0);        
--    bcdConverter4 <= std_logic_vector(unsigned(yOffset) mod 10) when mode = "01" 
--            else std_logic_vector(unsigned(yFrequency) mod 10);
--    sseg4 <= bcdConverter4(3 downto 0);
            
     sseg7(2 downto 0) <= xOffset(6 downto 4) when mode = "01" else xFrequency(6 downto 4);
     sseg6 <= xOffset(3 downto 0) when mode = "01" else xFrequency(3 downto 0);
     sseg5(2 downto 0) <= yOffset(6 downto 4) when mode = "01" else yFrequency(6 downto 4);
     sseg4 <= yOffset(3 downto 0) when mode = "01" else yFrequency(3 downto 0);       
            
    --Handle LRUD button presses   
    --Left Button                     
    process(leftButton) begin
        if(rising_edge(leftButton) and mode = "01" and xOffset /= "0000000") then
            leftFlag <= not leftFlag;
        end if;
    end process;    
        
    --Right Button                     
    process(rightButton) begin
        if(rising_edge(rightButton) and mode = "01" and xOffset /= "1111111") then
            rightFlag <= not rightFlag;
        end if;
    end process; 
    
    --Up Button                     
    process(upButton) begin
        if(rising_edge(upButton) and mode = "01" and yOffset /= "1111111") then
            upFlag <= not upFlag;
        end if;
    end process; 
    
    --Down Button                     
    process(downButton) begin
        if(rising_edge(downButton) and mode = "01" and yOffset /= "0000000") then
            downFlag <= not downFlag;
        end if;
    end process;                      
    
    --Handle on/off button
    process(onButton) begin
        if rising_edge(onButton) then 
            displayOn <= not displayOn;
        end if;
    end process;
    
    process(toModuleAddress) begin
        sseg2(2 downto 0) <= toModuleRegister;
    end process;
    
    process(fromModuleAddress) begin
        sseg1(2 downto 0) <= fromModuleAddress;
    end process;
    
    process(sendingState) begin
        case sendingState is 
            when waiting =>
                sseg3 <= X"0";
            when sendMode =>
                sseg3 <= X"1";
            when waitSend =>
                sseg3 <= X"2";
            when singleSend =>
                sseg3 <= X"3";
        end case;
    end process;
    
    --Send, receive functionality
    process(clk) begin
        if rising_edge(clk) then 
            case sendingState is
                
                --Waiting for send to be triggered
                when waiting =>
                    --Check mode change
                    if(modeFSM /= mode) then
                        modeFSM <= mode;
                        toSendRegister(15 downto 2) <= "00000000000000"; --clear
                        toSendRegister(1 downto 0) <= mode;
                        toModuleRegister <= "101"; --DisplayOut 
                        sendFlag <= '1';
                        sendingState <= sendMode;
                        
                        xOffset <= "1000000";
                        yOffset <= "1000000";
                        
                        if(mode = "11") then 
                            xFrequency <= "0000001";
                            yFrequency <= "0000011";                                                    
                        else
                            xFrequency <= "0000001";
                            yFrequency <= "0000001";
                        end if;
                    
                    --Check left button press    
                    elsif(leftFlagFSM /= leftFlag) then 
                        leftFlagFSM <= leftFlag;
                        xOffset <= xOffset - "1";
                        toSendRegister(15 downto 14) <= "11"; --header
                        toSendRegister(13 downto 7) <= xOffset - "1";
                        toSendRegister(6 downto 0) <= yOffset;
                        toModuleRegister <= "101"; --displayOut
                        sendFlag <= '1';
                        sendingState <= singleSend;
    
                    --Check right button press    
                    elsif(rightFlagFSM /= rightFlag) then 
                        rightFlagFSM <= rightFlag;
                        xOffset <= xOffset + "1";
                        toSendRegister(15 downto 14) <= "11"; --header
                        toSendRegister(13 downto 7) <= xOffset + "1";
                        toSendRegister(6 downto 0) <= yOffset;
                        toModuleRegister <= "101"; --displayOut
                        sendFlag <= '1';
                        sendingState <= singleSend;
                        
                    --Check up button press    
                    elsif(upFlagFSM /= upFlag) then 
                        upFlagFSM <= upFlag;
                        yOffset <= yOffset + "1";
                        toSendRegister(15 downto 14) <= "11"; --header
                        toSendRegister(13 downto 7) <= xOffset;
                        toSendRegister(6 downto 0) <= yOffset + "1";
                        toModuleRegister <= "101"; --displayOut
                        sendFlag <= '1';
                        sendingState <= singleSend;
    
                    --Check down button press    
                    elsif(downFlagFSM /= downFlag) then 
                        downFlagFSM <= downFlag;
                        yOffset <= yOffset - "1";
                        toSendRegister(15 downto 14) <= "11"; --header
                        toSendRegister(13 downto 7) <= xOffset;
                        toSendRegister(6 downto 0) <= yOffset - "1";
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
                        toSendRegister(13 downto 1) <= "0000000000000"; --clear
                        toSendRegister(0) <= displayOn;  
                        toModuleRegister <= "101";
                        sendFlag <= '1';
                        sendingState <= singleSend;
                    
                    end if;
                
                --Sending new mode 
                when sendMode =>
                    if(grantLine = '1') then 
                        sendFlag <= '0';
                        sendingState <= waitSend;
                    end if;
                    
                --Waiting to send new mode    
                when waitSend =>
                    if(sendFlag <= '0') then --requestLine = '0') then  
                        --Finished sending mode to displayOut, accelerometer, keyboard, curve calculator
                        if(toModuleRegister = "100") then --change back to "001"
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
                --From keypad    
                if(fromModuleRegister = "010") then
                    xFrequency <= receivedRegister(14 downto 8);
                    yFrequency <= receivedRegister(6 downto 0);
                    frequencyFlag <= not frequencyFlag; 
                end if;
            end if; 
            
            if(readyLine = '0') then 
                    ackFlag <= '0';
                end if; 
           
            --Buffer buttons
            leftButton <= buttons(3);
            rightButton <= buttons(0);
            upButton <= buttons(2);
            downButton <= buttons(1);
            onbutton <= middleButton;
        end if;
    end process;

end Behavioral;
