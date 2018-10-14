----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.10.2018 14:34:03
-- Design Name: 
-- Module Name: curveCalculatorModule - Behavioral
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

entity curveCalculatorModule is
    Port ( 
        clk : in std_logic;
        --Interface with bus module
        requestLine : out std_logic := '0';
        grantLine : in std_logic;
        dataLine : inout std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
        toModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
        fromModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
        readyLine : inout std_logic := 'Z';
        ackLine : inout std_logic := 'Z'
    );
end curveCalculatorModule;

architecture Behavioral of curveCalculatorModule is

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

    component cordic_0 is 
        Port ( 
            aclk : IN STD_LOGIC;
            s_axis_phase_tvalid : IN STD_LOGIC;
            s_axis_phase_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            m_axis_dout_tvalid : OUT STD_LOGIC;
            m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    end component;

    --Sending interface with module
    signal toSendRegister : std_logic_vector(15 downto 0);
    signal toModuleRegister : std_logic_vector(2 downto 0);
    signal sendFlag : std_logic := '0';
           
    --Receiving interface with module
    signal receivedRegister : std_logic_vector(15 downto 0);
    signal fromModuleRegister : std_logic_vector(2 downto 0) := "000";
    signal receivedFlag : std_logic := '0';
    signal ackFlag : std_logic := '0';
    
    type states is (idle, calculate, hold, send, repeat);
    signal state : states := idle;
    
    signal updateFlag : std_logic := '0';
    signal inValid : std_logic := '0';
    signal inData : std_logic_vector(15 downto 0) := X"0266";
    signal outValid : std_logic;
    signal outData : std_logic_vector(15 downto 0);
    signal currentMode : std_logic_vector(1 downto 0) := "00";
    
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
        ownAddress => "001",
        toSendRegister => toSendRegister,
        toModuleRegister => toModuleRegister,
        sendFlag => sendFlag,
        receivedFlag => receivedFlag,
        ackFlag => ackFlag
    );
    
    sineMaker : cordic_0 port map (
        aclk => clk,
        s_axis_phase_tvalid => inValid,
        s_axis_phase_tdata => inData,
        m_axis_dout_tvalid => outValid,
        m_axis_dout_tdata => outData
    );

    --Handles sending messages
    sendValues : process(clk)
    begin
        if rising_edge(clk) then
                case state is
                
                    --Waiting for update
                    when idle =>
                        if(updateFlag = '1') then
                            inData <= X"0266";
                            inValid <= '1';
                            state <= calculate; 
                        end if;
                        
                    --Waiting for cordic to calculate value    
                    when calculate => 
                        if(outValid = '1') then
                            toSendRegister(15) <= not outData(15);
                            toSendRegister(14 downto 8) <= outData(14 downto 8);
                            toSendRegister(7) <= not outData(7);
                            toSendRegister(6 downto 0) <= outData(6 downto 0);
                            toModuleRegister <= "100"; --BRAM module
                            sendFlag <= '1';
                            state <= hold; 
                        end if;
                      
                    --Hold values for FSM
                    when hold => 
                        if(grantLine = '1') then 
                            sendFlag <= '0';
                            state <= send;
                        end if;  
                        
                    --Send value
                    when send =>
                        if(ackLine <= '1') then 
                            inValid <= '0';
                            if(inData = X"058B") then
                                inData <= X"0266";
                                inValid <= '0';
                                updateFlag <= '0';
                                state <= idle;
                            else
                                inData <= inData + '1';
                                state <= repeat;
                            end if;
                        end if; 
                        
                    --Repeat sending values
                    when repeat =>
                        if(outValid = '0') then 
                            inValid <= '1';
                            state <= calculate;
                        end if;
                    
                end case;
             
             --Handle received mode updates from user interface
             if(receivedFlag = '1') then 
                 ackFlag <= '1';
                 --Mode changes come from User Interface Module
                 if(fromModuleAddress = "000") then
                     
                     --Currently drawing small circle
                     if(currentMode = "01") then 
                                         
                         --Moving to a large circle mode
                         if(dataLine(1 downto 0) /= "01") then 
                             updateFlag <= '1';
                         end if;
                                         
                     --Currently drawing large circle
                     else                
                         --Moving to small circle mode
                         if(dataLine(1 downto 0) = "01") then
                             updateFlag <= '1';
                         end if;
                                             
                     end if;
                                         
                     --Update mode
                     currentMode <= dataLine(1 downto 0);             
                 end if;                 
             else 
                ackFlag <= '0';
             end if;   
             
         end if;
    end process;
end Behavioral;
