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
    Port ( ssegAnode : out  STD_LOGIC_VECTOR (7 downto 0);
           ssegCathode : out  STD_LOGIC_VECTOR (7 downto 0);
           slideSwitches : in  STD_LOGIC_VECTOR (15 downto 0);
           pushButtons : in  STD_LOGIC_VECTOR (4 downto 0);
           LEDs : out  STD_LOGIC_VECTOR (15 downto 0);
		   clk100mhz : in STD_LOGIC;
		   JA : inout STD_LOGIC_VECTOR(7 downto 0);
		   JC : out STD_LOGIC_VECTOR(7 downto 0);
		   JD : out STD_LOGIC_VECTOR(7 downto 0)
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
            ackLine : inout std_logic := 'Z';
            
            --Express bus lines
            expressRequestLines : inout std_logic_vector(1 downto 0);
            expressReadyLines : inout std_logic_vector(1 downto 0);
            expressDataLine : inout std_logic_vector(15 downto 0)
        );
    end component;

    component busController is
        Port (
            requestLines : in std_logic_vector(7 downto 0);
            grantLines : out std_logic_vector(7 downto 0);
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
            onButton : in std_logic := '0';
            onLED : out std_logic := '1'
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
    
    --General signals
    signal masterReset : std_logic;
    signal scaledClk : std_logic;
    
    --Bus signals
    signal dataLine : std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
    signal toModuleAddress : std_logic_vector(2 downto 0) := "ZZZ";
    signal fromModuleAddress : std_logic_vector(2 downto 0) := "ZZZ";
    signal readyLine : std_logic := 'Z';
    signal ackLine : std_logic := 'Z';
    signal expressRequestLines : std_logic_vector(1 downto 0);
    signal expressReadyLines : std_logic_vector(1 downto 0);
    signal expressDataLine : std_logic_vector(15 downto 0);
    
    --Arbiter Lines
    signal requestLines : std_logic_vector(7 downto 0);
    signal grantLines : std_logic_vector(7 downto 0);

begin

        
    buss : busModule port map (
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine,
        expressRequestLines => expressRequestLines,
        expressReadyLines => expressReadyLines,
        expressDataLine => expressDataline
    );
    
    arbiter : busController port map (
        requestLines => requestLines,
        grantLines => grantLines,
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
        onbutton => pushButtons(4),
        onLED => LEDs(0)
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
    
    fakeDisplayOutModule : busSlave port map (
        clk => clk100mhz,
        requestLine => requestLines(5),
        grantLine => grantLines(5),
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine,
        ownAddress => "101",
        toSendRegister => X"ABCD",
        toModuleRegister => "111",
        sendFlag => '0',
        ackFlag => '1'
    );

end Behavioral;