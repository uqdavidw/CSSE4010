----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.10.2018 14:34:03
-- Design Name: 
-- Module Name: ramStorage - Behavioral
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

entity ramStorage is
    Port (
        clk : in std_logic;
        inputData : in std_logic_vector(15 downto 0) := X"0000";
        dataReady : in std_logic := '0';
        dataTaken : out std_logic := '0';
        updating : in std_logic := '1';    
        
        --Interface with Express Bus
        sinRequestToReceive : in std_logic := '1';
        cosRequestToReceive : in std_logic := '1';
        sinOutputReady : out std_logic := '0';
        cosOutputReady : out std_logic := '0';
        sinOut : out std_logic_vector(7 downto 0) := X"00";
        cosOut : out std_logic_vector(7 downto 0) := X"00";
        sinRequestAddress : in std_logic_vector(9 downto 0) := "0000000000";
        cosRequestAddress : in std_logic_vector(9 downto 0) := "0000000000"
    );
end ramStorage;

architecture Behavioral of ramStorage is
    
    component blk_mem_gen_0 IS
        PORT (
            clka : IN STD_LOGIC;
            ena : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
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
    
    --BRAM sine LUT
     signal writeSinEnable : std_logic_vector(0 downto 0) := "1";
     signal sinAddress : std_logic_vector(9 downto 0) := "0000000000";
     signal sinIn : std_logic_vector(7 downto 0) := X"00";
    
    --BRAM cos LUT
     signal writeCosEnable : std_logic_vector(0 downto 0) := "1";
     signal cosAddress : std_logic_vector(9 downto 0) := "0000000000";
     signal cosIn : std_logic_vector(7 downto 0) := X"00";
     
     type updateStates is (waiting, loading, nextValue);
     signal state : updateStates := waiting;
     
     type outputStates is (waiting, update);
     signal sinState : outputStates := waiting;
     signal cosState : outputStates := waiting;
     
     signal messageCounter : std_logic_vector(9 downto 0) := "0000000000";
     signal slowClock : std_logic := '0';
         
begin
    
    slow : TCCR port map (
        clk => clk,
        rst => '0',
        compareRegister => X"08", --200
        interrupt => slowClock
    );
    
    
    sinStorage : blk_mem_gen_0 port map (
        clka => slowClock,
        ena => '1',
        wea => writeSinEnable,
        addra => sinAddress,
        dina => sinIn,
        douta => sinOut
    );
    
    cosStorage : blk_mem_gen_0 port map (
        clka => slowClock,
        ena =>  '1',
        wea => writeCosEnable,
        addra => cosAddress,
        dina => cosIn,
        douta => cosOut
    );
    
    process(slowClock) begin
        if rising_edge(slowClock) then
        
            --Populating LUTs
            if(updating = '1') then 
                case state is 
                    when waiting =>
                        if(dataReady = '1') then 
                            sinIn <= inputData(15 downto 8);
                            cosIn <= inputData(7 downto 0);
                            writeCosEnable <= "1";
                            writeSinEnable <= "1";
                            state <= loading;
                        end if;
                        
                    when loading =>
                        dataTaken <= '1';
                        state <= nextValue;
                    
                    when nextValue => 
                        if(dataReady = '0') then 
                            dataTaken <= '0';
                            writeCosEnable <= "0";
                            writeSinEnable <= "0";
                            sinAddress <= sinAddress + "1";
                            cosAddress <= cosAddress + "1";
                            messageCounter <= messageCounter + "1";
                            state <= waiting;
                        end if;
                    
                end case;
                        
            --Outputting sinusoids                        
            else 
                sinAddress <= sinRequestAddress;
                cosAddress <= cosRequestAddress;
                
                --Express Sin Bus
                case sinState is 
                    when waiting =>
                        if(sinRequestToReceive = '1') then 
                            sinOutputReady <= '1';
                            sinState <= update;
                        end if;
                        
                    when update =>
                        if(sinRequestToReceive = '0') then 
                            sinOutputReady <= '0';
                            sinState <= waiting;
                        end if;
                        
                end case;
                
                --Express Cos Bus
                case cosState is 
                    when waiting =>
                        if(cosRequestToReceive = '1') then 
                            cosOutputReady <= '1';
                            cosState <= update;
                        end if;
                        
                    when update =>
                        if(cosRequestToReceive = '0') then
                            cosOutputReady <= '0';
                            cosState <= waiting;
                        end if;
                        
                end case;
            end if;
        end if;
    end process;
end Behavioral;