----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.10.2018 17:27:14
-- Design Name: 
-- Module Name: test_Overall - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_Overall is
--  Port ( );
end test_Overall;

architecture Behavioral of test_Overall is
                
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
    
    --12.5MHz clock for DAC
    signal slowClockCounter : std_logic_vector(2 downto 0) := "000";
    signal slowClock : std_logic := '0';
    
    --Replicated boardtop signals 
    signal clk100mhz : std_logic := '0';
    signal slideSwitches : std_logic_vector(15 downto 0) := X"0000";
    signal pushButtons : std_logic_vector(4 downto 0) := "00000"; 
    signal LEDs : std_logic_vector(15 downto 0) := X"0000";
    signal ssegAnode : STD_LOGIC_VECTOR (7 downto 0) := X"00";
    signal ssegCathode : STD_LOGIC_VECTOR (7 downto 0) := X"00";

    signal JA : std_logic_vector(7 downto 0) := X"FF";
    signal JB : std_logic_vector(7 downto 0) := X"00";
    signal JC : std_logic_vector(7 downto 0) := X"00";
    signal JD : std_logic_vector(7 downto 0) := X"00";
    signal aclMISO : std_logic;
    signal aclMOSI : std_logic;
    signal aclSCK : std_logic;
    signal aclSS : std_logic;

begin
    
    clk100mhz <= not clk100mhz after 10ps;
    
    slowClock <= '1' when slowClockCounter > "011" else '0';
    
    process(clk100mhz) begin
        if rising_edge(clk100mhz) then 
            slowClockCounter <= slowClockCounter + "1";
        end if;
    end process;
    
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
        clk => clk100mhz,
        requestLine => requestLines(4),
        grantLine => grantLines(4),
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine,
        sinRequestToReceive => expressRequestLines(0),
        cosRequestToReceive => expressRequestLines(1),
        sinOutputReady => expressReadyLines(0),
        cosOutputReady => expressReadyLines(1),
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
