----------------------------------------------------------------------------------
-- Company: University of Queensland
-- Engineer: Sam Eadie
-- 
-- Create Date:    4/10/2018
-- Design Name: 
-- Module Name:    boardTop - Behavioral 
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

entity boardTop is
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
    
end boardTop;

architecture Behavioral of boardTop is
            
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
            
    component userInterfaceModule is
        Port (
            clk : in std_logic;
            rst : in std_logic;
            --Interface with bus module
            requestLine : out std_logic := '0';
            grantLine : in std_logic;
            dataLine : inout std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
            toModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
            fromModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
            readyLine : inout std_logic := 'Z';
            ackLine : inout std_logic := 'Z';
            
            --Interface with peripherals 
            ssegAnode : out std_logic_vector(7 downto 0);
            ssegCathode : out std_logic_vector(7 downto 0);
            
            mode : in std_logic_vector(1 downto 0) := "00"; --connect to slide switches
            buttons : in std_logic_vector(3 downto 0) := "0000";
            middleButton : in std_logic := '0';
            LEDs : out std_logic_vector(15 downto 0) := X"0000"
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
    
    component keypadModule is
    Port (
        clk : in std_logic;
        row : in std_logic_vector(3 downto 0);
        col : out std_logic_vector(3 downto 0);
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
    
    component accelerometerModule is
    Port (
            clk : in std_logic;
            rst : in std_logic;
    
            --Interface with bus module
            requestLine : out std_logic := '0';
            grantLine : in std_logic;
            dataLine : inout std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
            toModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
            fromModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
            readyLine : inout std_logic := 'Z';
            ackLine : inout std_logic := 'Z';
            
            --SPI Interface Signals
            SCLK        : out std_logic;
            MOSI        : out std_logic;
            MISO        : in  std_logic;
            SS          : out std_logic     
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
        sinRequestToReceive : in std_logic := '1';
        cosRequestToReceive : in std_logic := '1';
        sinOutputReady : out std_logic := '0';
        cosOutputReady : out std_logic := '0';
        sinOut : out std_logic_vector(7 downto 0) := X"00";
        cosOut : out std_logic_vector(7 downto 0) := X"00"
    );
    end component;
    
    component dacModule is
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
        
        --Interface with DMA bus
        xInput : in std_logic_vector(7 downto 0) := X"00";
        yInput : in std_logic_vector(7 downto 0) := X"00";
        xRequest : out std_logic := '1';
        yRequest : out std_logic := '1';
        xReady : in std_logic := '0';
        yReady : in std_logic := '0';
        
        --Interface with PMOD headers
        xOutput : out std_logic_vector(7 downto 0) := X"00";
        yOutput : out std_logic_vector(7 downto 0) := X"00"
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
    JB(7) <= clk100mhz;
    JB(6) <= slowClock;
    JB(5) <= readyLine;
    JB(4) <= ackLine;
    JB(3 downto 2) <= expressRequestLines;
    JB(1 downto 0) <= expressReadyLines;
   
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
    
    userInterface : userInterfaceModule port map (
        clk => clk100mhz,
        rst => masterReset,
        requestLine => requestLines(0),
        grantLine => grantLines(0),
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine,
        
        mode => slideSwitches(1 downto 0),
        buttons => pushButtons(3 downto 0),
        middleButton => pushButtons(4),
        LEDs => LEDs,
        
        ssegAnode => ssegAnode,
        ssegCathode => ssegCathode
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
    
    keypad : keypadModule port map (
        clk => clk100mhz,
        row => JA(7 downto 4), 
        col => JA(3 downto 0),
        requestLine => requestLines(2),
        grantLine => grantLines(2),
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine
    );
    
    accelerometer : accelerometerModule port map (
        clk => clk100mhz,
        rst => masterReset,
        requestLine => requestLines(3),
        grantLine => grantLines(3),
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine, 
        
        SCLK => aclSCK,
        MISO => aclMISO,
        MOSI => aclMOSI,
        SS => aclSS        
    );
    
    ram : ramModule port map (
        clk => slowClock,
        requestLine => requestLines(4),
        grantLine => grantLines(4),
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine,
        sinRequestToReceive => expressRequestLines(1),
        cosRequestToReceive => expressRequestLines(0),
        sinOutputReady => expressReadyLines(1),
        cosOutputReady => expressReadyLines(0),
        sinOut => expressDataLine(15 downto 8),
        cosOut => expressDataLine(7 downto 0)
    );
    
    dac : dacModule port map (
        clk => slowClock,
        requestLine => requestLines(5),
        grantLine => grantLines(5),
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine,
        xInput => expressDataLine(15 downto 8),
        yInput => expressDataLine(7 downto 0),
        xRequest => expressRequestLines(1),
        yRequest => expressRequestLines(0),
        xReady => expressReadyLines(1),
        yReady => expressReadyLines(0),
        xOutput => JC,
        yOutput => JD
    );
    
end Behavioral;