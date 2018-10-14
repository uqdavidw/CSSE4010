----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2018 12:36:59
-- Design Name: 
-- Module Name: test_BRAMModule - Behavioral
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

entity test_BRAMModule is
end test_BRAMModule;

architecture Behavioral of test_BRAMModule is
    component busController is 
        Port ( 
            requestLines : in std_logic_vector(7 downto 0);
            grantLines : out std_logic_vector(7 downto 0) := X"00";
            clk : in std_logic;
            rst : in std_logic
        );
    end component;
    
    component curveCalculatorModule is 
        Port (
            clk : in std_logic;
            --Interface with bus module
            requestLine : out std_logic := '0';
            grantLine : in std_logic;
            dataLine : inout std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
            toModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
            fromModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
            readyLine : inout std_logic;
            ackLine : inout std_logic
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
    
    component ramModule is
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
    end component;    
    
    --Bus lines
    signal clk : std_logic := '0';
    signal data : std_logic_vector(15 downto 0) := X"0000";
    signal toModule : std_logic_vector(2 downto 0) := "000";
    signal fromModule : std_logic_vector(2 downto 0) := "000";
    signal requestLines : std_logic_vector(7 downto 0) := X"00";
    signal grantLines : std_logic_vector(7 downto 0) := X"00";
    signal readyLine : std_logic := '0';
    signal ackLine : std_logic := '0';
    
    --Slave lines
    signal slaveSendFlag : std_logic := '1';
    
    --BRAM lines
    signal sinClk : std_logic := '0';
    signal cosClk : std_logic := '0';
    
    --Express Bus lines
    signal sinRequest : std_logic := '1';
    signal cosRequest : std_logic := '1';
    signal sinReady : std_logic := '0';
    signal cosReady : std_logic := '0';
    signal sinOut : std_logic_vector(7 downto 0) := X"00";
    signal cosOut : std_logic_vector(7 downto 0) := X"00";
            
begin
    clk <= not clk after 10ps;
    
    slaveSendFlag <= '0' after 100ps;
    
    sinRequest <= not sinRequest after 50ps;
    cosRequest <= not cosRequest after 90ps;
     
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
        toSendRegister => X"0001",
        toModuleRegister => "001",
        sendFlag => slaveSendFlag,
        ackFlag => '1'
    );

    bram : ramModule port map (
        clk => clk,
        requestLine => requestLines(4),
        grantLine => grantLines(4),
        dataLine => data,
        toModuleAddress => toModule,
        fromModuleAddress => fromModule,
        readyLine => readyLine,
        ackLine => ackLine,
        
        sinRequestToReceive => sinRequest,
        cosRequestToReceive => cosRequest,
        sinOutputReady => sinReady,
        cosOutputReady => cosReady,
        sinOut => sinOut,
        cosOut => cosOut
    );

    curveCalculator : curveCalculatorModule port map (
        clk => clk,
        requestLine => requestLines(1),
        grantLine => grantLines(1),
        dataLine => data,
        toModuleAddress => toModule,
        fromModuleAddress => fromModule,
        readyLine => readyLine,
        ackLine => ackLine
    );
  
end Behavioral;
