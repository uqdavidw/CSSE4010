----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.10.2018 14:34:03
-- Design Name: 
-- Module Name: ramModule - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ramModule is
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
        
        --Interface with Express Bus
        sinRequestToReceive : in std_logic := '0';
        cosRequestToReceive : in std_logic := '0';
        sinOutputReady : out std_logic := '0';
        cosOutputReady : out std_logic := '0';
        sinOut : out std_logic_vector(7 downto 0) := X"00";
        cosOut : out std_logic_vector(7 downto 0) := X"00"
    );
end ramModule;

architecture Behavioral of ramModule is
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
           
    --Receiving interface with module
    signal receivedRegister : std_logic_vector(15 downto 0);
    signal fromModuleRegister : std_logic_vector(2 downto 0) := "000";
    signal receivedFlag : std_logic := '0';
    signal ackFlag : std_logic := '0';
    
    signal updatingFlag : std_logic := '1';
    
    --BRAM sine LUT
     signal writeSinEnable : std_logic_vector(0 downto 0) := "0";
     signal sinAddress : std_logic_vector(9 downto 0) := "0000000000";
     signal sinIn : std_logic_vector(7 downto 0) := X"00";
    
    --BRAM cos LUT
     signal writeCosEnable : std_logic_vector(0 downto 0) := "0";
     signal cosAddress : std_logic_vector(9 downto 0) := "0000000000";
     signal cosIn : std_logic_vector(7 downto 0) := X"00";
     
     type updateStates is (waiting, loading, loaded);
     signal state : updateStates := waiting;
     
     type outputStates is (waiting, update);
     signal sinState : outputStates := waiting;
     signal cosState : outputStates := waiting;
     
     signal messageCounter : std_logic_vector(9 downto 0) := "0000000000";
         
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
        ownAddress => "100",
        toSendRegister => X"0000",
        toModuleRegister => "000",
        sendFlag => '0',
        receivedFlag => receivedFlag,
        ackFlag => ackFlag
    );

    sinStorage : blk_mem_gen_0 port map (
        clka => clk,
        ena => '1',
        wea => writeSinEnable,
        addra => sinAddress,
        dina => sinIn,
        douta => sinOut
    );
    
    cosStorage : blk_mem_gen_0 port map (
        clka => clk,
        ena =>  '1',
        wea => writeCosEnable,
        addra => cosAddress,
        dina => cosIn,
        douta => cosOut
    );
    
    process(clk) begin
        if rising_edge(clk) then
            
            --Update LUT values
            case state is
                
                --Waiting for value
                when waiting =>
                    if(receivedFlag = '1') then 
                        sinIn <= dataLine(15 downto 8);
                        cosIn <= dataLine(7 downto 0);
                        writeSinEnable <= "1";
                        writeCosEnable <= "1";
                        updatingFlag <= '1';
                        state <= loading;
                        messageCounter <= messageCounter + "1";
                    end if;
                    
                --Loading value into BRAM    
                when loading =>
                    ackFlag <= '1';
                    state <= loaded;
                
                --Value loaded into BRAM
                when loaded =>
                    if(receivedFlag = '0') then 
                        ackFlag <= '0';
                        
                        --LUT is "1100100101" long
                        if(cosAddress = "1100100101") then 
                            cosAddress <= "0000000000";
                            updatingFlag <= '0';
                            writeCosEnable <= "0";
                            cosOutputReady <= '1';
                        else
                            cosAddress <= cosAddress + "1";
                        end if;
                                        
                        if(sinAddress = "1100100101") then 
                            sinAddress <= "0000000000";
                            updatingFlag <= '0';
                            writeSinEnable <= "0";
                            sinOutputReady <= '1';
                        else
                            sinAddress <= sinAddress + "1";
                        end if;
                        
                        state <= waiting;
                    end if;
            end case;
        
            if(updatingFlag = '0') then 
                --Express Sin Bus
                case sinState is 
                    when waiting =>
                        if(sinRequestToReceive = '1') then 
                            sinOutputReady <= '1';
                            sinState <= update;
                        end if;
                        
                    when update =>
                        if(sinRequestToReceive = '0') then
                            if(sinAddress = "1100100101") then 
                                sinAddress <= "0000000000";
                            else
                                sinAddress <= sinAddress + "1";
                            end if;
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
                            if(cosAddress = "1100100101") then 
                                cosAddress <= "0000000000";
                            else
                                cosAddress <= cosAddress + "1";
                            end if;
                            cosOutputReady <= '0';
                            cosState <= waiting;
                        end if;
                        
                end case;
            end if;
        end if;
    end process;
end Behavioral;