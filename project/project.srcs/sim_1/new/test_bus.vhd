----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2018 12:36:59
-- Design Name: 
-- Module Name: test_bus - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_bus is
end test_bus;

architecture Behavioral of test_bus is

    component busController is 
        Port ( 
            requestLines : in std_logic_vector(7 downto 0);
            grantLines : out std_logic_vector(7 downto 0) := X"00";
            clk : in std_logic;
            rst : in std_logic
        );
    end component;
    
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
                fromModuleRegister : out std_logic_vector(2 downto 0);
                receivedFlag : out std_logic := '0';
                ackFlag : in std_logic
            );
    end component;
    
    signal clk : std_logic := '0';
    signal data : std_logic_vector(15 downto 0) := X"0000";
    signal toModule : std_logic_vector(2 downto 0) := "000";
    signal fromModule : std_logic_vector(2 downto 0) := "000";
    signal requestLines : std_logic_vector(7 downto 0) := X"00";
    signal grantLines : std_logic_vector(7 downto 0) := X"00";
    signal readyLine : std_logic := '0';
    signal ackLine : std_logic := '0';
    signal sendFlag1 : std_logic := '0';
    signal sendFlag2 : std_logic := '0';
    signal sendFlag3 : std_logic := '0';
    signal receivedFlag1 : std_logic := '0';
    signal receivedFlag2 : std_logic := '0';
    signal receivedFlag3 : std_logic := '0';
    signal ackFlag1 : std_logic := '0';
    signal ackFlag2 : std_logic := '0';
    signal ackFlag3 : std_logic := '0';
    


begin
    clk <= not clk after 10ps;
    sendFlag1 <= not sendFlag1 after 83ps;
    sendFlag2 <= not sendFlag2 after 71ps;
    sendFlag3 <= not sendFlag3 after 66ps;
    ackFlag1 <= not ackFlag1 after 74ps;
    ackFlag2 <= not ackFlag2 after 88ps;
    ackFlag3 <= not ackFlag3 after 91ps;
     
    busControl : busController port map (
        requestLines => requestLines,
        grantLines => grantLines,
        clk => clk,
        rst => '0'    
    );
    
    slave1 : busSlave port map (
        clk => clk,
        requestLine => requestLines(0),
        grantLine => grantLines(0),
        dataLine => data,
        toModuleAddress => toModule,
        fromModuleAddress => fromModule,
        readyLine => readyLine,
        ackLine => ackLine,
        ownAddress => "000",
        toSendRegister => X"ABCD",
        toModuleRegister => "001",
        sendFlag => sendFlag1,
        receivedFlag => receivedFlag1,
        ackFlag => ackFlag1
    );
    
    slave2 : busSlave port map(
        clk => clk,
        requestLine => requestLines(1),
        grantLine => grantLines(1),
        dataLine => data,
        toModuleAddress => toModule,
        fromModuleAddress => fromModule,
        readyLine => readyLine,
        ackLine => ackLine,
        ownAddress => "001",
        toSendRegister => X"FEED",
        toModuleRegister => "010",
        sendFlag => sendFlag2,
        receivedFlag => receivedFlag2,
        ackFlag => ackFlag2
    );
    
    slave3 : busSlave port map(
        clk => clk,
        requestLine => requestLines(2),
        grantLine => grantLines(2),
        dataLine => data,
        toModuleAddress => toModule,
        fromModuleAddress => fromModule,
        readyLine => readyLine,
        ackLine => ackLine,
        ownAddress => "010",
        toSendRegister => X"ABBA",
        toModuleRegister => "000",
        sendFlag => sendFlag3,
        receivedFlag => receivedFlag3,
        ackFlag => ackFlag3
    );    
  
end Behavioral;
