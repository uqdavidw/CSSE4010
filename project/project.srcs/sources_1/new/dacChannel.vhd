----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.10.2018 08:10:43
-- Design Name: 
-- Module Name: dacChannel - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity dacChannel is
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
end dacChannel;

architecture Behavioral of dacChannel is
    type DMAstates is (request, read);
    signal dmaState : DMAstates := request;
    
    signal interruptFSM : std_logic := '0';
    signal interrupt : std_logic := '0';

    component TCCR is 
        Port (
            clk : in std_logic;
            rst : in std_logic; 
            compareRegister : in std_logic_vector(7 downto 0);
            interrupt : out std_logic
        );
    end component;
    
    signal scaledClk : std_logic;
    signal clkCounter : std_logic_vector := "00";
    
begin

    scaledClk <= '1' when clkCounter > X"01" else '0';

    counter : TCCR port map (
        clk => scaledClk,
        rst => rst,
        compareRegister => frequency,
        interrupt => interrupt
    );
    
    process(clk) begin
        clkCounter <= clkCounter + "1";
        if(rst = '1') then 
            dmaState <= read;
            requestToReceive <= '0';
            clkCounter <= "00";   
        else
            case dmaState is
                when request => 
                    if(interruptFSM /= interrupt) then 
                        interruptFSM <= interrupt;
                        requestToReceive <= '1';
                        dmaState <= read;    
                    end if;
                    
                when read =>
                    if(inputReady = '1') then 
                        --Change output, overflow detection
                        if(input + offset < X"FF") then
                            output <= input + offset;
                        else
                            output <= X"FF";
                        end if;
                        
                        if(enable /= '1') then
                            output <= X"00";
                        end if;
                        
                        requestToReceive <= '0';
                        dmaState <= request;
                    end if;
            end case;
        end if;
    end process;
end Behavioral;