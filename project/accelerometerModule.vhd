----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.10.2018 14:32:16
-- Design Name: 
-- Module Name: accelerometerModule - Behavioral
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
--use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity accelerometerModule is
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
            
            --SPI Interface Signals
            SCLK        : out std_logic;
            MOSI        : out std_logic;
            MISO        : in  std_logic;
            SS          : out std_logic     
    );
end accelerometerModule;

architecture Behavioral of accelerometerModule is
    component ADXL362Ctrl
        Generic (
            SYSCLK_FREQUENCY_HZ : integer := 100000000;
            SCLK_FREQUENCY_HZ   : integer := 1000000;
            NUM_READS_AVG       : integer := 16;
            UPDATE_FREQUENCY_HZ : integer := 1000
        );
        Port (
            SYSCLK      : in std_logic; -- System Clock
            RESET       : in std_logic;
    
            -- Accelerometer data signals
            ACCEL_X     : out std_logic_vector(11 downto 0);
            ACCEL_Y     : out std_logic_vector(11 downto 0);
            ACCEL_Z     : out std_logic_vector(11 downto 0);
            ACCEL_TMP   : out std_logic_vector(11 downto 0);
            Data_Ready  : out std_logic;
    
            --SPI Interface Signals
            SCLK        : out std_logic;
            MOSI        : out std_logic;
            MISO        : in  std_logic;
            SS          : out std_logic
        );
    end component ADXL362Ctrl;

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

    --Accelerometer Signals
    signal dataReady : std_logic := '0';
    signal aX, aY, aZ : std_logic_vector(11 downto 0) := X"000";
    signal maxTilt : std_logic_vector(11 downto 0);
    
    --Accelerometer Frequencies
    signal xFrequency: std_logic_vector(7 downto 0) := X"01";
    signal yFrequency: std_logic_vector(7 downto 0) := X"03";
    
    --Bus signals
    signal toSendRegister : std_logic_vector(15 downto 0) := X"0000";
    signal sendFlag : std_logic := '0';
    signal receivedFlag : std_logic := '0';
    signal ackFlag : std_logic := '0';
    
    signal mode : std_logic_vector(1 downto 0) := "00";
    
    type sendingStates is (offMode, waitSend, waitTurn, write, waitACK);
    signal sendingState : sendingStates := offMode;
    
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
        ownAddress => "011",
        toSendRegister => toSendRegister,
        toModuleRegister => "101",
        sendFlag => sendFlag,
        receivedFlag => receivedFlag,
        ackFlag => ackFlag
    );

    accelerometer : ADXL362Ctrl port map (
        SYSCLK => clk,
        RESET => rst,
        ACCEL_X => aX,
        ACCEL_Y => aY,
        ACCEL_Z => aZ,
        Data_Ready => dataReady,
        SCLK => SCLK,
        MOSI => MOSI,
        MISO => MISO,
        SS => SS
    );

    maxTilt <= aX when aX > aY else aY;

    --Change Frequency 
    process(dataReady) begin
        if rising_edge(dataReady) then 
            if(signed(maxTilt) > 1750) then --Speed 5: 3.05
                xFrequency <= X"3D"; --61
                yFrequency <= X"14"; --20
            elsif(signed(maxTilt) > 1400) then --Speed 4: 3.04
                xFrequency <= X"4C"; --76
                yFrequency <= X"19"; --25
            elsif(signed(maxTilt) > 1050) then --Speed 3: 3.03
                xFrequency <= X"64"; --100
                yFrequency <= X"21"; --33
            elsif(signed(maxTilt) > 700) then --Speed 2: 3.02
                xFrequency <= X"97"; --151
                yFrequency <= X"32"; --50        
            elsif(signed(maxTilt) > 350) then --Speed 1: 3.01
                xFrequency <= X"FD"; --253;
                yFrequency <= X"54"; --84;
            elsif(signed(maxTilt) > -350) then --Speed 0: 3
                xFrequency <= X"01"; --1
                yFrequency <= X"03"; --3
            elsif(signed(maxTilt) > -700) then --Speed -1: 2.99
                xFrequency <= X"FE"; --254;
                yFrequency <= X"55"; --85;        
            elsif(signed(maxTilt) > -1050) then --Speed -2: 2.98
                xFrequency <= X"95"; --149
                yFrequency <= X"32"; --50                
            elsif(signed(maxTilt) > -1400) then --Speed -3: 2.97
                xFrequency <= X"65"; --101
                yFrequency <= X"22"; --34        
            elsif(signed(maxTilt) > -1750) then --Speed -4: 2.96
                xFrequency <= X"4A"; --74
                yFrequency <= X"19"; --25        
            else                                --Speed -5: 2.95
                xFrequency <= X"3B"; --59
                yFrequency <= X"14"; --20        
            end if;
        end if;
    end process;
    
    --Handles sending and receiving messages
    process (clk) begin
        if rising_edge(clk) then 
            --Send new frequencies 
            if(toSendRegister(15 downto 8) /= xFrequency or toSendRegister(7 downto 0) /= yFrequency) then 
                toSendRegister(15 downto 8) <= xFrequency;
                toSendRegister(7 downto 0) <= yFrequency;
               
                --Don't send if not in accelerometer mode
                if(mode = "11") then 
                    sendFlag <= '1';
                end if;
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
