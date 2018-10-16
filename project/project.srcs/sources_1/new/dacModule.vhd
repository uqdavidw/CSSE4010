----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.10.2018 14:34:03
-- Design Name: 
-- Module Name: dacModule - Behavioral
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

entity dacModule is
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
        
        --Interface with DMA bus
        xInput : in std_logic_vector(7 downto 0) := X"00";
        yInput : in std_logic_vector(7 downto 0) := X"00";
        xRequest : out std_logic;
        yRequest : out std_logic;
        xReady : in std_logic;
        yReady : in std_logic;
        
        --Interface with PMOD headers
        xOutput : out std_logic_vector(7 downto 0) := X"00";
        yOutput : out std_logic_vector(7 downto 0) := X"00"
    );
end dacModule;

architecture Behavioral of dacModule is

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
            toSendRegister : in std_logic_vector(15 downto 0) := X"0000";
            toModuleRegister : in std_logic_vector(2 downto 0) := "000";
            sendFlag : in std_logic := '0';
                
            --Receiving interface with module
            receivedRegister : out std_logic_vector(15 downto 0);
            fromModuleRegister : out std_logic_vector(2 downto 0) := "000";
            receivedFlag : out std_logic := '0';
            ackFlag : in std_logic
        );
    end component;
    
    component dacChannel is
        Port (
            clk : in std_logic;
            rst : in std_logic; 
            enable : in std_logic;
            frequency : in std_logic_vector(7 downto 0);
            offset : in std_logic_vector(7 downto 0);
            input : in std_logic_vector(7 downto 0);
            output : out std_logic_vector(7 downto 0);
            requestToReceive : out std_logic;
            inputReady : in std_logic
        );
    end component;
    
    
    --Bus signals
    signal receivedRegister : std_logic_vector(15 downto 0);
    signal receivedFlag : std_logic := '0';
    signal ackFlag : std_logic := '0';
    
    signal mode : std_logic_vector(1 downto 0) := "00";
    
    --DAC signals
    signal rst : std_logic := '0';
    signal enable : std_logic := '0';
    signal xFrequency : std_logic_vector(7 downto 0) := X"00";
    signal yFrequency : std_logic_vector(7 downto 0) := X"00";
    signal xOffset : std_logic_vector(7 downto 0) := X"00";
    signal yOffset : std_logic_vector(7 downto 0) := X"00";
    signal xScaledInput : std_logic_vector(7 downto 0) := X"00";
    signal yScaledInput : std_logic_vector(7 downto 0) := X"00";
    
begin

    --Half inputs in "01" mode, smaller circle to shift around
    xScaledInput(7) <= '0' when mode = "01" else xInput(7);
    xScaledInput(6 downto 0) <= xInput(7 downto 1) when mode = "01" else xInput(6 downto 0); 
    yScaledInput(7) <= '0' when mode = "01" else yInput(7);
    yScaledInput(6 downto 0) <= yInput(7 downto 1) when mode = "01" else yinput(6 downto 0);

    busInterface : busSlave port map (
        clk => clk,
        requestLine => requestLine,
        grantLine => grantLine,
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine,
        ownAddress => "101",
        receivedFlag => receivedFlag,
        receivedRegister => receivedRegister,
        ackFlag => ackFlag
    );
    
    channelX : dacChannel port map (
        clk => clk,
        rst => rst,
        enable => enable,
        frequency => xFrequency,
        offset => xOffset,
        input => xScaledInput,
        output => xOutput,
        requestToReceive => xRequest,
        inputReady => xReady
    );
    
    channelY : dacChannel port map (
        clk => clk,
        rst => rst,
        enable => enable,
        frequency => yFrequency,
        offset => yOffset,
        input => yScaledInput,
        output => yOutput,
        requestToReceive => yRequest,
        inputReady => yReady
    );
    
    --Receives messages, updates DACs
    process(clk) begin
        --Handle receiving messages
        if(receivedFlag = '1') then 
            ackFlag <= '1';
            if(fromModuleAddress = "000") then --Messages from user interface
                
                --Switch on packet header
                case receivedRegister(15 downto 14) is 
                    
                    --Mode change
                    when "00" =>
                        mode <= receivedRegister(1 downto 0);
                    
                    --Display on/off
                    when "01" =>
                        enable <= receivedRegister(0);
                    
                    --Frequency change
                    when "10" =>
                        xFrequency(6 downto 0) <= receivedRegister(13 downto 7);
                        yFrequency(6 downto 0) <= receivedRegister(6 downto 0);
                    
                    --Offset change
                    when "11" =>
                        xOffset(6 downto 0) <= receivedRegister(13 downto 7);
                        yOffset(6 downto 0) <= receivedRegister(6 downto 0);
                    
                end case; 
            end if;
        end if;
              
        if(readyLine = '0') then 
            ackFlag <= '0';
        end if;        
    end process;

end Behavioral;
