----------------------------------------------------------------------------------
-- Company: The University of Queensland
-- Engineer: Sam Eadie
-- 
-- Create Date: 17.10.2018 08:10:43
-- Design Name: 
-- Module Name: dacChannel - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Outputs a signal from BRAM with variable frequency and offset
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
        clk : in std_logic := '0';
        rst : in std_logic := '0'; 
        enable : in std_logic := '1';
        frequency : in std_logic_vector(7 downto 0) := X"01";
        offset : in std_logic_vector(7 downto 0) := X"00";
        input : in std_logic_vector(7 downto 0) := X"00";
        output : out std_logic_vector(7 downto 0) := X"00";
        ramAddress : out std_logic_vector(9 downto 0) := "0000000000";
        requestToReceive : out std_logic := '1';
        inputReady : in std_logic := '0'
    );
end dacChannel;

architecture Behavioral of dacChannel is
    
    --Timer Counter Control Register
    component TCCR is 
        Port (
            clk : in std_logic := '0';
            rst : in std_logic := '0'; 
            compareRegister : in std_logic_vector(7 downto 0) := X"00";
            interrupt : out std_logic := '0'
        );
    end component;
    
    --DMA bus handshake FSM
    type DMAstates is (request, read);
    signal dmaState : DMAstates := request;
        
    --TCCR update signals    
    signal interrupt : std_logic := '0';
    signal acknowledge : std_logic := '0';
    
    --The address in BRAM to read from
    signal address : std_logic_vector(9 downto 0) := "0000000000";    
    
    --Clock scalings
    signal scaledClk : std_logic := '0';
    signal clkCounter : std_logic_vector(1 downto 0) := "00";
    
begin

    counter : TCCR port map (
        clk => scaledClk,
        rst => rst,
        compareRegister => frequency,
        interrupt => interrupt
    );
    
    scaledClk <= '1' when clkCounter > "01" else '0';
    ramAddress <= address;
    
    process(clk) begin
    
        --Reset dacChannel, synchronise phase between multiple signals
        if(rst = '1') then 
            clkCounter <= "00";
            address <= "0000000000";
               
        elsif rising_edge(clk) then
            clkCounter <= clkCounter + "1"; 
            
            --Express bus handshake
            case dmaState is
                
                --Request new value on TCCR interrupt
                when request =>
                    if(interrupt /= acknowledge) then 
                        acknowledge <= not acknowledge;
                        requestToReceive <= '1';
                        dmaState <= read;    
                    end if;
                    
                --Output value when ready
                when read =>
                    if(inputReady = '1') then 
                        --Change output, overflow detection
                        if(X"FF" - offset > input) then
                            output <= input + offset;
                        else
                            output <= X"FF";
                        end if;
                        
                        --Output enable
                        if(enable = '0') then
                            output <= X"00";
                        end if;
                        
                        address <= address + "1";
                        requestToReceive <= '0';
                        dmaState <= request;
                    end if;
            end case;    
        end if;
    end process;
end Behavioral;
