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
        clk : in std_logic := '0';
        rst : in std_logic := '0'; 
        enable : in std_logic := '1';
        frequency : in std_logic_vector(7 downto 0) := X"01";
        offset : in std_logic_vector(7 downto 0) := X"00";
        input : in std_logic_vector(7 downto 0) := X"00";
        output : out std_logic_vector(7 downto 0) := X"00";
        requestToReceive : out std_logic := '1';
        inputReady : in std_logic := '0'
    );
end dacChannel;

architecture Behavioral of dacChannel is
    type DMAstates is (request, read);
    signal dmaState : DMAstates := request;
    
    signal interrupt : std_logic := '0';
    signal acknowledge : std_logic := '0';

    component TCCR is 
        Port (
            clk : in std_logic := '0';
            rst : in std_logic := '0'; 
            compareRegister : in std_logic_vector(7 downto 0) := X"00";
            interrupt : out std_logic := '0'
        );
    end component;
    
    signal scaledClk : std_logic := '0';
    signal clkCounter : std_logic_vector(1 downto 0) := "00";
    
begin

    scaledClk <= '1' when clkCounter > "01" else '0';

    counter : TCCR port map (
        clk => scaledClk,
        rst => rst,
        compareRegister => frequency,
        interrupt => interrupt
    );
    
    process(clk) begin
        if(rst = '1') then 
            dmaState <= read;
            requestToReceive <= '0';
            clkCounter <= "00";   
        elsif rising_edge(clk) then
            clkCounter <= clkCounter + "1"; 
            case dmaState is
                when request =>
                    if(interrupt /= acknowledge) then 
                        acknowledge <= not acknowledge;
                        requestToReceive <= '1';
                        dmaState <= read;    
                    end if;
                    
                when read =>
                    if(inputReady = '1') then 
                        --Change output, overflow detection
                        if(X"FF" - offset > input) then
                            output <= input + offset;
                        else
                            output <= X"FF";
                        end if;
                        
                        if(enable = '0') then
                            output <= X"00";
                        end if;
                        
                        requestToReceive <= '0';
                        dmaState <= request;
                    end if;
            end case;    
        end if;
    end process;
end Behavioral;
