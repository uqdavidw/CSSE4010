----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.10.2018 08:53:37
-- Design Name: 
-- Module Name: boardOutputTop - Behavioral
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

entity boardOutputTop is
  Port ( ssegAnode : out  STD_LOGIC_VECTOR (7 downto 0);
         ssegCathode : out  STD_LOGIC_VECTOR (7 downto 0);
         slideSwitches : in  STD_LOGIC_VECTOR (15 downto 0);
         pushButtons : in  STD_LOGIC_VECTOR (4 downto 0);
         LEDs : out  STD_LOGIC_VECTOR (15 downto 0);
         clk100mhz : in STD_LOGIC;
         JA : inout STD_LOGIC_VECTOR(7 downto 0);
         JB : out STD_LOGIC_VECTOR(7 downto 0);
         JC : out STD_LOGIC_VECTOR(7 downto 0);
         JD : out STD_LOGIC_VECTOR(7 downto 0)
  );
end boardOutputTop;

architecture Behavioral of boardOutputTop is
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
            onLED : out std_logic := '1'
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
            xRequest : out std_logic;
            yRequest : out std_logic;
            xReady : in std_logic;
            yReady : in std_logic;
            
            --Interface with PMOD headers
            xOutput : out std_logic_vector(7 downto 0) := X"00";
            yOutput : out std_logic_vector(7 downto 0) := X"00"
        );
    end component;

    --Bus lines
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
    signal sinRequest : std_logic := '0';
    signal cosRequest : std_logic := '0';
    signal sinReady : std_logic := '0';
    signal cosReady : std_logic := '0';
    signal sinOut : std_logic_vector(7 downto 0) := X"00";
    signal cosOut : std_logic_vector(7 downto 0) := X"00";
            
begin
    
    slaveSendFlag <= '0' after 100ps;
    
    JB(0) <= sinClk;
    JB(1) <= cosClk;
    JB(2) <= sinReady;
    JB(3) <= cosReady;
    
     
    dacs : dacModule port map (
        clk => clk100mhz,
        requestLine => requestLines(5),
        grantLine => grantLines(5),
        dataLine => data,
        toModuleAddress => toModule,
        fromModuleAddress => fromModule,
        readyLine => readyLine,
        ackLine => ackLine,
        xInput => cosOut,
        yInput => sinOut,
        xRequest => cosRequest,
        yRequest => sinRequest,
        xReady => cosReady,
        yReady => sinReady,
        xOutput => JC,
        yOutput => JD
    ); 
    
     
    busControl : busController port map (
        requestLines => requestLines,
        grantLines => grantLines,
        clk => clk100mhz,
        rst => '0'    
    );

    userInterface : userInterfaceModule port map (
        clk => clk100mhz,
        rst => '0',
        requestLine => requestLines(0),
        grantLine => grantLines(0),
        dataLine => data,
        toModuleAddress => toModule,
        fromModuleAddress => fromModule,
        readyLine => readyLine,
        ackLine => ackLine,
        
        mode => slideSwitches(1 downto 0),
        buttons => pushButtons(3 downto 0),
        middleButton => pushButtons(4),
        onLED => LEDs(0)
    );


    bram : ramModule port map (
        clk => clk100mhz,
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
        clk => clk100mhz,
        requestLine => requestLines(1),
        grantLine => grantLines(1),
        dataLine => data,
        toModuleAddress => toModule,
        fromModuleAddress => fromModule,
        readyLine => readyLine,
        ackLine => ackLine
    );
  end Behavioral;
