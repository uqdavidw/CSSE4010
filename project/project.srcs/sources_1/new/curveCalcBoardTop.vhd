----------------------------------------------------------------------------------
-- Company: University of Queensland
-- Engineer: Sam Eadie
-- 
-- Create Date:    4/10/2018
-- Design Name: 
-- Module Name:    curveCalcBoardTop - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity curveCalcBoardTop is
    Port ( 
           ssegAnode : out  STD_LOGIC_VECTOR (7 downto 0);
           ssegCathode : out  STD_LOGIC_VECTOR (7 downto 0);
           slideSwitches : in  STD_LOGIC_VECTOR (15 downto 0);
           pushButtons : in  STD_LOGIC_VECTOR (4 downto 0);
           LEDs : out  STD_LOGIC_VECTOR (15 downto 0);
		   clk100mhz : in STD_LOGIC;
		   JA : inout STD_LOGIC_VECTOR(7 downto 0);
		   JB : out STD_LOGIC_VECTOR(7 downto 0);		   
		   JC : out STD_LOGIC_VECTOR(7 downto 0);
		   JD : out STD_LOGIC_VECTOR(7 downto 0);
		   
		   --Accelometer
		   aclMISO : in std_logic;
		   aclMOSI : out std_logic;
		   aclSCK : out std_logic;
		   aclSS : out std_logic
    );
    
end curveCalcBoardTop;

architecture Behavioral of curveCalcBoardTop is
            
    component busModule is
        Port (            
            --Regular bus lines
            dataLine : inout std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
            toModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
            fromModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
            readyLine : inout std_logic := 'Z';
            ackLine : inout std_logic := 'Z'
        );
    end component;
    
    component busController is
        Port (
            requestLines : in std_logic_vector(7 downto 0);
            grantLines : inout std_logic_vector(7 downto 0);
            readyLine : inout std_logic := 'Z';
            ackLine : inout std_logic := 'Z';            
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
        readyLine : inout std_logic := 'Z';
        ackLine : inout std_logic := 'Z'
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
            readyLine : inout std_logic := 'Z';
            ackLine : inout std_logic := 'Z';
            
            ownAddress : in std_logic_vector(2 downto 0);
            
            --Sending interface with module
            toSendRegister : in std_logic_vector(15 downto 0);
            toModuleRegister : in std_logic_vector(2 downto 0);
            sendFlag : in std_logic := '0';
            
            --Receiving interface with module
            receivedRegister : out std_logic_vector(15 downto 0);
            fromModuleRegister : out std_logic_vector(2 downto 0);
            receivedFlag : out std_logic := '0';
            ackFlag : in std_logic := '0'
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
    
    --General signals
    signal masterReset : std_logic := '0';
    
    --Bus signals
    signal dataLine : std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
    signal toModuleAddress : std_logic_vector(2 downto 0) := "ZZZ";
    signal fromModuleAddress : std_logic_vector(2 downto 0) := "ZZZ";
    signal readyLine : std_logic := 'Z';
    signal ackLine : std_logic := 'Z';
    signal expressRequestLines : std_logic_vector(1 downto 0) := "11";
    signal expressReadyLines : std_logic_vector(1 downto 0) := "00";
    signal expressDataLine : std_logic_vector(15 downto 0) := X"0000";
    
    --Arbiter Lines
    signal requestLines : std_logic_vector(7 downto 0);
    signal grantLines : std_logic_vector(7 downto 0);
    
    --Slow clock for RAM and DAC
    signal slowClock : std_logic := '0';

begin
    
    --Use JB for debugging
    JB <= dataLine(7 downto 0);
   
   --Generate slower clock for RAM and DAC
    slow : TCCR port map (
       clk => clk100mhz,
       rst => '0',
       compareRegister => X"64", --200
       interrupt => slowClock
   );
    
    
    buss : busModule port map (
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine
    );
    
    arbiter : busController port map (
        requestLines => requestLines,
        grantLines => grantLines,
        readyLine => readyLine,
        ackLine => ackLine,
        clk => clk100mhz,
        rst => masterReset  
    );
    
    busInterface : busSlave port map (
        clk => clk100mhz,
        requestLine => requestLines(4),
        grantLine => grantLines(4),
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        toModuleRegister => "001",
        toSendRegister => X"ABCD",
        ackLine => ackLine,
        ownAddress => "100",
        ackFlag => '1'
    );
    
    curveCalc : curveCalculatorModule port map (
        clk => clk100mhz,
        requestLine => requestLines(1),
        grantLine => grantLines(1),
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine        
    );
    
end Behavioral;