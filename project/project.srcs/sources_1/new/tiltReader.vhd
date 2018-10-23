----------------------------------------------------------------------------------
-- Company: The University of Queensland 
-- Engineer: Sam Eadie
-- 
-- Create Date: 06.10.2018 14:32:16
-- Design Name: 
-- Module Name: tiltReader - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Provides frequency updates from on-board ADXL accelerometer 
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
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tiltReader is
    Port (
            clk : in std_logic;
            rst : in std_logic;
            xFrequency: out std_logic_vector(7 downto 0) := X"01";
            yFrequency: out std_logic_vector(7 downto 0) := X"03";
            displayDigit: out std_logic_vector(3 downto 0) := X"0";
            mode : in std_logic_vector(1 downto 0);            
            
            --SPI Interface Signals
            SCLK        : out std_logic;
            MOSI        : out std_logic;
            MISO        : in  std_logic;
            SS          : out std_logic     
    );
end tiltReader;

architecture Behavioral of tiltReader is
    --ADXL controller: Digilent Source Code
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

    --Accelerometer Signals
    signal dataReady : std_logic := '0';
    signal aX, aY, aZ : std_logic_vector(11 downto 0) := X"000";
    
    signal adjustedTilt : std_logic_vector(11 downto 0);
    
begin 

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

    adjustedTilt <= aZ + X"800"; --Shift up 2048 to make fully positive

    --Threshold acceleration on updates 
    process(dataReady) begin
        if rising_edge(dataReady) then
            if(mode = "11") then --Accelerometer mode  
                
                --Speed 3.03
                if(unsigned(adjustedTilt) > 1600) then 
                    xFrequency <= X"5B";
                    yFrequency <= X"1E";
                    displayDigit <= X"5";
                    
                --Speed 3.025    
                elsif(unsigned(adjustedTilt) > 1500) then
                    xFrequency <= X"79";
                    yFrequency <= X"28";
                    displayDigit <= X"4";        
                
                --Speed 3.02
                elsif(unsigned(adjustedTilt) > 1400) then
                    xFrequency <= X"97";
                    yFrequency <= X"32";
                    displayDigit <= X"3";                
                
                --Speed 3.015
                elsif(unsigned(adjustedTilt) > 1300) then
                    xFrequency <= X"C7";
                    yFrequency <= X"42";
                    displayDigit <= X"2";        
                    
                --Speed 3.01
                elsif(unsigned(adjustedTilt) > 1250) then
                    xFrequency <= X"FD";
                    yFrequency <= X"54";
                    displayDigit <= X"1";           
                
                --Speed 3.00
                else                                
                    xFrequency <= X"FF";
                    yFrequency <= X"55";     
                    displayDigit <= X"0";   
                end if;
                
            end if;
        end if;
    end process;
end Behavioral;
