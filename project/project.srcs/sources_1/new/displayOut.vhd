----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.10.2018 14:34:03
-- Design Name: 
-- Module Name: displayOut - Behavioral
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

entity displayOut is
    Port (
        clk : in std_logic;
        
        --Interface with DMA bus
        xInput : in std_logic_vector(7 downto 0) := X"00";
        yInput : in std_logic_vector(7 downto 0) := X"00";
        xRequest : out std_logic := '1';
        yRequest : out std_logic := '1';
        xAddress : out std_logic_vector(9 downto 0) := "0000000000";
        yAddress : out std_logic_vector(9 downto 0) := "0000000000";
        xReady : in std_logic := '0';
        yReady : in std_logic := '0';
        
        --Interface with UI
        xFrequency : in std_logic_vector(7 downto 0) := X"00";
        yFrequency : in std_logic_vector(7 downto 0) := X"00";
        xOffset : in std_logic_vector(7 downto 0) := X"00";
        yOffset : in std_logic_vector(7 downto 0) := X"00";
        mode : in std_logic_vector(1 downto 0) := "00";
        enable : in std_logic := '1';
        
        --Interface with PMOD headers
        xOutput : out std_logic_vector(7 downto 0) := X"00";
        yOutput : out std_logic_vector(7 downto 0) := X"00"
    );
end displayOut;

architecture Behavioral of displayOut is

    component dacChannel is
        Port (
            clk : in std_logic := '0';
            rst : in std_logic := '0'; 
            enable : in std_logic := '1';
            frequency : in std_logic_vector(7 downto 0) := X"01";
            offset : in std_logic_vector(7 downto 0) := X"00";
            input : in std_logic_vector(7 downto 0) := X"00";
            output : out std_logic_vector(7 downto 0) := X"00";
            requestToReceive : out std_logic := '1';
            inputReady : in std_logic := '0';
            ramAddress : out std_logic_vector(9 downto 0) := "0000000000"
        );
    end component;
    
    component TCCR is
        Port (
            clk : in std_logic;
            rst : in std_logic; 
            compareRegister : in std_logic_vector(7 downto 0);
            interrupt : out std_logic := '0'
         );
    end component;     
    
    --DAC signals
    signal rst : std_logic := '0';
    signal xScaledInput : std_logic_vector(7 downto 0) := X"00";
    signal yScaledInput : std_logic_vector(7 downto 0) := X"00";
    
    signal slowClock : std_logic := '0';
    
    signal xFrequencyBuffer : std_logic_vector(7 downto 0) := "00000000";
    signal yFrequencyBuffer : std_logic_vector(7 downto 0) := "00000000";
    
begin
    --Half inputs in "01" mode, smaller circle to shift around
    xScaledInput(7) <= '0' when mode = "01" else xInput(7);
    xScaledInput(6 downto 0) <= xInput(7 downto 1) when mode = "01" else xInput(6 downto 0); 
    yScaledInput(7) <= '0' when mode = "01" else yInput(7);
    yScaledInput(6 downto 0) <= yInput(7 downto 1) when mode = "01" else yinput(6 downto 0);
        
    process(slowClock) begin
        if rising_edge(slowClock) then 
            if((xFrequency /= xFrequencyBuffer) or (yFrequency /= yFrequencyBuffer)) then
                xFrequencyBuffer <= xFrequency;
                yFrequencyBuffer <= yFrequency;
                rst <= '1';
            else
                rst <= '0';
            end if;
        end if;
    end process;
        
    slow : TCCR port map (
        clk => clk,
        rst => '0',
        compareRegister => X"64", --200
        interrupt => slowClock
    );
    
    channelX : dacChannel port map (
        clk => slowClock,
        rst => rst,
        enable => enable,
        frequency => xFrequencyBuffer,
        offset => xOffset,
        input => xScaledInput,
        output => xOutput,
        requestToReceive => xRequest,
        inputReady => xReady,
        ramAddress => xAddress
    );
    
    channelY : dacChannel port map (
        clk => slowClock,
        rst => rst,
        enable => enable,
        frequency => yFrequencyBuffer,
        offset => yOffset,
        input => yScaledInput,
        output => yOutput,
        requestToReceive => yRequest,
        inputReady => yReady,
        ramAddress => yAddress
    );
end Behavioral;
