----------------------------------------------------------------------------------
-- Company: University of Queensland
-- Engineer: Sam Eadie
-- 
-- Create Date:    4/10/2018
-- Design Name: 
-- Module Name:    busBoardTop - Behavioral 
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

entity busBoardTop is
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
    
end busBoardTop;


architecture Behavioral of busBoardTop is
            
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
            
    component busGuy1 is
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
            
            ownAddress : in std_logic_vector(2 downto 0) := "010";
            otherAddress : in std_logic_vector(2 downto 0) := "000";
            addNumber : in std_logic_vector(15 downto 0) := X"0007";
            
            sseg1 : out std_logic_vector(3 downto 0) := X"0";
            sseg2 : out std_logic_vector(3 downto 0) := X"0";
            
            button : in std_logic := '0';
            LED : out std_logic := '0'    
        );
    end component;

    component clockScaler port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        clkdiv : out STD_LOGIC
    );
    end component;
    
    component ssegDriver port (
        clk : in std_logic;
        rst : in std_logic;
        anode_p : out std_logic_vector(7 downto 0);
        cathode_p : out std_logic_vector(7 downto 0);
        digit1_p : in std_logic_vector(3 downto 0) := "0000";
        digit2_p : in std_logic_vector(3 downto 0) := "0000";
        digit3_p : in std_logic_vector(3 downto 0) := "0000";
        digit4_p : in std_logic_vector(3 downto 0) := "0000";
        digit5_p : in std_logic_vector(3 downto 0) := "0000";
        digit6_p : in std_logic_vector(3 downto 0) := "0000";
        digit7_p : in std_logic_vector(3 downto 0) := "0000";
        digit8_p : in std_logic_vector(3 downto 0) := "0000"
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
    
    signal scaledClk : std_logic := '0';    
    
    signal sseg0 : std_logic_vector(3 downto 0) := "0000";
    signal sseg1 : std_logic_vector(3 downto 0) := "0000";
    signal sseg2 : std_logic_vector(3 downto 0) := "0000";
    signal sseg3 : std_logic_vector(3 downto 0) := "0000";
    
begin 

    --JB <= dataLine(7 downto 0);
    JB <= requestLines;
    JC <= grantLines;
    JD(7 downto 5) <= toModuleAddress;
    JD(4 downto 2) <= fromModuleAddress;

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

    clock_scaler : clockScaler port map (
        clk => clk100mhz,
        rst => masterReset,
        clkdiv => scaledClk
    );
    
    sseg : ssegDriver port map (
        rst => masterReset,
        cathode_p => ssegCathode,
        anode_p => ssegAnode,
        clk => scaledClk,
        digit1_p => sseg0,
        digit2_p => sseg1,
        digit4_p => sseg2,
        digit5_p => sseg3
    );
    
    personA : busGuy1 port map (
        clk => clk100mhz,
        rst => masterReset,
        requestLine => requestLines(1),
        grantLine => grantLines(1),
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine,
        ownAddress => "001",
        otherAddress => "100",
        addNumber => X"0003",
        sseg1 => sseg1,
        sseg2 => sseg0,
        button => pushButtons(0), 
        LED => LEDs(10)   
    );

    personB : busGuy1 port map (
        clk => clk100mhz,
        rst => masterReset,
        requestLine => requestLines(4),
        grantLine => grantLines(4),
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine,
        ownAddress => "100",
        otherAddress => "001",
        addNumber => X"0008",
        sseg1 => sseg3,
        sseg2 => sseg2,
        button => pushButtons(1),
        LED => LEDs(4)    
    );
    
end Behavioral;