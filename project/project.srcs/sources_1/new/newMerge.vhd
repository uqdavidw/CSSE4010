----------------------------------------------------------------------------------
-- Company: The University of Queensland
-- Engineer: Sam Eadie
-- 
-- Create Date: 22.10.2018 23:03:22
-- Design Name: 
-- Module Name: newMerge - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Overall structural design of refacrtored project
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;use IEEE.NUMERIC_STD.ALL;

entity newMerge is
    Port (
        ssegAnode : out  STD_LOGIC_VECTOR (7 downto 0);
        ssegCathode : out  STD_LOGIC_VECTOR (7 downto 0);
        slideSwitches : in  STD_LOGIC_VECTOR (15 downto 0);
        pushButtons : in  STD_LOGIC_VECTOR (4 downto 0);
        LEDs : out  STD_LOGIC_VECTOR (15 downto 0);
        clk100mhz : in STD_LOGIC;
        JA : in STD_LOGIC_VECTOR(7 downto 0);
        logic_analyzer : out STD_LOGIC_VECTOR(7 downto 0) := "11111111";
        JB : inout STD_LOGIC_VECTOR(7 downto 0);           
        JC : out STD_LOGIC_VECTOR(7 downto 0);
        JD : out STD_LOGIC_VECTOR(7 downto 0);
        
        --Accelometer
        aclMISO : in std_logic;
        aclMOSI : out std_logic;
        aclSCK : out std_logic;
        aclSS : out std_logic
    );
end newMerge;

architecture Behavioral of newMerge is
    component ramStorage is
        Port (
            clk : in std_logic;
            inputData : in std_logic_vector(15 downto 0) := X"0000";
            dataReady : in std_logic := '0';
            dataTaken : out std_logic := '0';
            updating : in std_logic := '1';    
            
            --Interface with Express Bus
            sinRequestToReceive : in std_logic := '1';
            cosRequestToReceive : in std_logic := '1';
            sinOutputReady : out std_logic := '0';
            cosOutputReady : out std_logic := '0';
            sinOut : out std_logic_vector(7 downto 0) := X"00";
            cosOut : out std_logic_vector(7 downto 0) := X"00";
            sinRequestAddress : in std_logic_vector(9 downto 0) := "0000000000";
            cosRequestAddress : in std_logic_vector(9 downto 0) := "0000000000"
        );
    end component;
    
    component curveGenerator is
        Port (
            clk100mhz : in std_logic := '0'; 
            data : out std_logic_vector(15 downto 0) := X"0000";
            dataReady : out std_logic := '0';
            dataTaken : in std_logic := '0';
            updating : out std_logic := '1'           
        );
        
    end component;
    
    component displayOut is
        Port (
            clk : in std_logic;
            
            --Interface with DMA bus
            xInput : in std_logic_vector(7 downto 0) := X"00";
            yInput : in std_logic_vector(7 downto 0) := X"00";
            xRequest : out std_logic := '1';
            yRequest : out std_logic := '1';
            xReady : in std_logic := '0';
            yReady : in std_logic := '0';
            xAddress : out std_logic_vector(9 downto 0) := "0000000000";
            yAddress : out std_logic_vector(9 downto 0) := "0000000000";
                        
            --Interface with UI
            xFrequency : in std_logic_vector(7 downto 0) := X"00";
            yFrequency : in std_logic_vector(7 downto 0) := X"00";
            xOffset : in std_logic_vector(7 downto 0) := X"00";
            yOffset : in std_logic_vector(7 downto 0) := X"00";
            mode : in std_logic_vector(1 downto 0) := "00";
            enable : in std_logic := '1';
            
            --Interface with PMOD headers
            xOutput : out std_logic_vector(7 downto 0) := X"00";
            yOutput : out std_logic_vector(7 downto 0) := X"00"
        );
    end component;  
    
    component userAdapter is
        Port (
            clk : in std_logic;
            rst : in std_logic;
            
            --Interface with peripherals 
            ssegAnode : out std_logic_vector(7 downto 0);
            ssegCathode : out std_logic_vector(7 downto 0);
            slideSwitches : in std_logic_vector(1 downto 0) := "00"; --connect to slide switches
            buttons : in std_logic_vector(3 downto 0) := "0000";
            middleButton : in std_logic := '0';
            LEDs : out std_logic_vector(15 downto 0) := X"0000";
            
            --Interface with keyboard
            xKeypadFrequency : in std_logic_vector(7 downto 0) := X"01";
            yKeypadFrequency : in std_logic_vector(7 downto 0) := X"01";
            keypadDisplayDigit : in std_logic_vector(3 downto 0) := X"0";
            
            --Interface with accelerometer
            xAccelFrequency : in std_logic_vector(7 downto 0) := X"01";
            yAccelFrequency : in std_logic_vector(7 downto 0) := X"03";
            accelDisplayDigit : in std_logic_vector(3 downto 0) := X"0";
            
            --Outputs
            mode : out std_logic_vector(1 downto 0);
            xFrequencyOut : out std_logic_vector(7 downto 0);
            yFrequencyOut : out std_logic_vector(7 downto 0);
            xOffsetOut : out std_logic_vector(7 downto 0);
            yOffsetOut : out std_logic_vector(7 downto 0);
            outputEnable : out std_logic
        );
        
    end component;
    
    component keyboard is
        Port (
            clk : in std_logic;
            row : in std_logic_vector(3 downto 0);
            col : out std_logic_vector(3 downto 0);
            xFrequency : out std_logic_vector(7 downto 0) := X"01";
            yFrequency : out std_logic_vector(7 downto 0) := X"01";
            displayDigit : out std_logic_vector(3 downto 0) := X"0";
            mode : in std_logic_vector(1 downto 0) := "00"                
        );
    end component; 
    
    component tiltReader is
        Port (
            clk : in std_logic;
            rst : in std_logic;
            xFrequency: out std_logic_vector(7 downto 0) := X"01";
            yFrequency: out std_logic_vector(7 downto 0) := X"03";
            displayDigit : out std_logic_vector(3 downto 0) := X"0";
            mode : in std_logic_vector(1 downto 0);            
            --SPI Interface Signals
            SCLK        : out std_logic;
            MOSI        : out std_logic;
            MISO        : in  std_logic;
            SS          : out std_logic     
        );
    end component;       
      
    --Curve calculator to RAM signals
    signal loadingData : std_logic_vector(15 downto 0) := X"0000";
    signal dataReady : std_logic := '0';
    signal dataTaken : std_logic := '0';
    signal updating : std_logic := '1';
    
    --RAM to DAC signals
    signal sinRequestToReceive : std_logic := '1';
    signal cosRequestToReceive : std_logic := '1';
    signal sinOutputReady : std_logic := '0';
    signal cosOutputReady : std_logic := '0';
    signal sinRAMOut : std_logic_vector(7 downto 0) := X"00";
    signal cosRAMOut : std_logic_vector(7 downto 0) := X"00";
    signal sinAddress : std_logic_vector(9 downto 0) := "0000000000";
    signal cosAddress : std_logic_vector(9 downto 0) := "0000000000";
    
    signal mode : std_logic_vector(1 downto 0) := "00";
    signal masterReset : std_logic := '0';
    
    --UI to DAC signals
    signal xFrequencyOut : std_logic_vector(7 downto 0);
    signal yFrequencyOut : std_logic_vector(7 downto 0);
    signal xOffsetOut : std_logic_vector(7 downto 0);
    signal yOffsetOut : std_logic_vector(7 downto 0);
    signal outputEnable : std_logic;
    
    --Keypad to UI signals
    signal xKeypadFrequency : std_logic_vector(7 downto 0);
    signal yKeypadFrequency : std_logic_vector(7 downto 0);
    signal keypadDisplayDigit : std_logic_vector(3 downto 0);
    
    --Accelerometer to UI signals
    signal xAccelFrequency : std_logic_vector(7 downto 0);
    signal yAccelFrequency : std_logic_vector(7 downto 0);
    signal accelDisplayDigit : std_logic_vector(3 downto 0);

begin

    curve : curveGenerator port map (
        clk100mhz => clk100mhz,
        data => loadingData,
        dataReady => dataReady,
        dataTaken => dataTaken,
        updating => updating
    );
    
    ram : ramStorage port map (
        clk => clk100mhz,
        inputData => loadingData,
        dataReady => dataReady,
        dataTaken => dataTaken,
        updating => updating,
        
        sinRequestToReceive => sinRequestToReceive,
        cosRequestToReceive => cosRequestToReceive,  
        sinOutputReady => sinOutputReady,
        cosOutputReady => cosOutputReady,
        sinRequestAddress => sinAddress,
        cosRequestAddress => cosAddress,
        sinOut => sinRAMOut,
        cosOut => cosRAMOut
    );
    
    dac : displayOut port map (
        clk => clk100mhz,
        xInput => sinRAMOut,
        yInput => cosRamOut,
        xRequest => sinRequestToReceive,
        yRequest => cosRequestToReceive,
        xReady => sinOutputReady,
        yReady => cosOutputReady,
        xAddress => sinAddress,
        yAddress => cosAddress,
        xFrequency => xFrequencyOut,
        yFrequency => yFrequencyOut,
        xOffset => xOffsetOut,
        yOffset => yOffsetOut,
        mode => mode,
        enable => outputEnable,
        xOutput => JC,
        yOutput => JD
    );
    
    user : userAdapter port map (
        clk => clk100mhz,
        rst => masterReset,
        ssegAnode => ssegAnode,
        ssegCathode => ssegCathode,
        slideSwitches => slideSwitches(1 downto 0),
        buttons => pushButtons(3 downto 0),
        middleButton => pushButtons(4),
        LEDs => LEDs,
        xKeypadFrequency => xKeypadFrequency,
        yKeypadFrequency => yKeypadFrequency,
        xAccelFrequency => xAccelFrequency,
        yAccelFrequency => yAccelFrequency,
        keypadDisplayDigit => keypadDisplayDigit,
        accelDisplayDigit => accelDisplayDigit,
        mode => mode,
        xFrequencyOut => xFrequencyOut,
        yFrequencyOut => yFrequencyOut,
        xOffsetOut => xOffsetOut,
        yOffsetOut => yOffsetOut,
        outputEnable => outputEnable
    );  
    
    keypad : keyboard port map (
        clk => clk100mhz,
        row => JA(7 downto 4),
        col => logic_analyzer(3 downto 0),
        xFrequency => xKeypadFrequency,
        yFrequency => yKeypadFrequency,
        displayDigit => keypadDisplayDigit,
        mode => mode
    );
    
    tilt : tiltReader port map (
        clk => clk100mhz,
        rst => masterReset,
        xFrequency => xAccelFrequency,
        yFrequency => yAccelFrequency,
        displayDigit => accelDisplayDigit,
        mode => mode,
        SCLK => aclSCK,
        MOSI => aclMOSI,
        MISO => aclMISO,
        SS => aclSS
    );
     
end Behavioral;
