----------------------------------------------------------------------------------
-- Company: The University of Queensland
-- Engineer: Sam Eadie
-- 
-- Create Date: 06.10.2018 14:34:03
-- Design Name: 
-- Module Name: userAdapter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: Handles user interface with sseg, slides, buttons and LEDs
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity userAdapter is
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
        xFrequencyOut : out std_logic_vector(7 downto 0) := X"01";
        yFrequencyOut : out std_logic_vector(7 downto 0) := X"01";
        xOffsetOut : out std_logic_vector(7 downto 0) := X"00";
        yOffsetOut : out std_logic_vector(7 downto 0) := X"00";
        outputEnable : out std_logic := '1'
    );
    
end userAdapter;

architecture Behavioral of userAdapter is

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
        digit8_p : in std_logic_vector(3 downto 0) := "0000";
        dots : in std_logic_vector(7 downto 0) := X"FF"
    ); 
    end component;
    
    --UI signals
    signal xOffset : std_logic_vector(7 downto 0) := "01000000";
    signal yOffset : std_logic_vector(7 downto 0) := "01000000";
    signal displayOn : std_logic := '1';
    signal leftFlag, leftFlagFSM : std_logic := '0';
    signal rightFlag, rightFlagFSM : std_logic := '0';
    signal upFlag, upFlagFSM : std_logic := '0';
    signal downFlag, downFlagFSM : std_logic := '0';
    signal leftButton, rightButton, upButton, downButton : std_logic := '0';
    signal onButton : std_logic := '0';
    
    --Output signals
    signal xOffsetMode, yOffsetMode : std_logic_vector(7 downto 0) := X"00";
    signal xFrequencyMode, yFrequencyMode : std_logic_vector(7 downto 0) := X"01";
    
    --sseg signals
    signal scaledClk : std_logic := '0';
    signal sseg0, sseg1, sseg2, sseg3, sseg4, sseg5, sseg6, sseg7 : std_logic_vector(3 downto 0) := X"0";
    
    --Hex to BCD conversion
    signal leftSsegHex, rightSsegHex : std_logic_vector(7 downto 0);
    signal sseg7dec, sseg6dec, sseg5dec, sseg4dec : std_logic_vector(7 downto 0); 
    
    --Decimal point signals
    signal ssegDecimalPoints : std_logic_vector(7 downto 0) := X"00";
    signal xOffsetDecimalPoint, yOffsetDecimalPoint : std_logic := '0';
    
    signal xOffsetModeSigned, yOffsetModeSigned : std_logic_vector(7 downto 0);
    
begin
    
    --Avoid ghosting on sseg
    clock_scaler : clockScaler port map (
        clk => clk,
        rst => rst,
        clkdiv => scaledClk
    );
    
    sseg : ssegDriver port map (
        rst => rst,
        cathode_p => ssegCathode,
        anode_p => ssegAnode,
        clk => scaledClk,
        digit1_p => sseg0,
        digit2_p => sseg1,
        digit3_p => sseg2,
        digit4_p => sseg3,
        digit5_p => sseg4,
        digit6_p => sseg5,
        digit7_p => sseg6,
        digit8_p => sseg7,
        dots => ssegDecimalPoints
    );

    --Mode
    mode <= slideSwitches;
    
    --Outputs to DACs
    xFrequencyOut <= xFrequencyMode;
    yFrequencyOut <= yFrequencyMode;
    xOffsetOut <= xOffsetMode;
    yOffsetOut <= yOffsetMode;
    
    --Display current modules digit
    process(slideSwitches, keypadDisplayDigit, accelDisplayDigit) begin
        case slideSwitches is
            when "00" =>
                sseg3 <= X"0";
            when "01" => 
                sseg3 <= X"0";
            when "10" =>
                sseg3 <= keypadDisplayDigit;
            when "11" =>
                sseg3 <= accelDisplayDigit;
            when others => null;
        end case;
    end process;
    
    --Select x frequency source for mode
    process(slideSwitches, xKeypadFrequency, xAccelFrequency) begin
        case slideSwitches is 
            when "00" =>
                xFrequencyMode <= X"01";
            when "01" =>
                xFrequencyMode <= X"01";
            when "10" =>
                xFrequencyMode <= xKeypadFrequency;
            when "11" =>
                xFrequencyMode <= xAccelFrequency;
            when others => null;
        end case;
    end process;
    
    --Select y frequency source for mode
    process(slideSwitches, yKeypadFrequency, yAccelFrequency) begin
        case slideSwitches is 
            when "00" =>
                yFrequencyMode <= X"01";
            when "01" =>
                yFrequencyMode <= X"01";
            when "10" =>
                yFrequencyMode <= yKeypadFrequency;
            when "11" =>
                yFrequencyMode <= yAccelFrequency;
            when others => null;
        end case;    
    end process;
    
    --Select x, y offset source for mode
    xOffsetMode <= xOffset when slideSwitches = "01" else X"00";
    yOffsetMode <= yOffset when slideSwitches = "01" else X"00";
    
    --Enable output display
    outputEnable <= displayOn;
    LEDs(0) <= displayOn;
    
    --Toggle LEDs on button presses
    LEDs(5) <= leftFlag;
    LEDs(4) <= rightFlag;
    LEDs(3) <= upFlag;
    LEDs(2) <= downFlag;
    
    --Display mode on sseg0
    sseg0(1 downto 0) <= slideSwitches;
 
    --Calculate absolute value of offset (64 is centre)   
    xOffsetModeSigned <= std_logic_vector(64 - unsigned(xOffsetMode)) when (unsigned(xOffsetMode) < 64) else std_logic_vector(unsigned(xOffsetMode) - 64);
    yOffsetModeSigned <= std_logic_vector(64 - unsigned(yOffsetMode)) when (unsigned(yOffsetMode) < 64) else std_logic_vector(unsigned(yOffsetMode) - 64);
    
    --Select sseg display based on mode      
    leftSsegHex <= xOffsetModeSigned when slideSwitches = "01" else xFrequencyMode;
    rightSsegHex <= yOffsetModeSigned when slideSwitches = "01" else yFrequencyMode;
     
    --Convert hex to dec
    sseg7dec <= std_logic_vector(unsigned(leftSsegHex) / 10);
    sseg6dec <= std_logic_vector(unsigned(leftSsegHex) mod 10);
    sseg5dec <= std_logic_vector(unsigned(rightSsegHex) / 10);
    sseg4dec <= std_logic_vector(unsigned(rightSsegHex) mod 10);
    sseg7 <= sseg7dec(3 downto 0);
    sseg6 <= sseg6dec(3 downto 0);
    sseg5 <= sseg5dec(3 downto 0);
    sseg4 <= sseg4dec(3 downto 0);
    
    --Decimal point
    ssegDecimalPoints(7) <= xOffsetDecimalPoint;
    ssegDecimalPoints(5) <= yOffsetDecimalPoint;   
       
    --Middle is 64
    xOffsetDecimalPoint <= '1' when (slideSwitches = "01" and unsigned(xOffset) < 64) else '0';
    yOffsetDecimalPoint <= '1' when (slideSwitches = "01" and unsigned(yOffset) < 64) else '0';    
       
    --Handle Left Button                     
    process(leftButton) begin
        if(rising_edge(leftButton) and slideSwitches = "01" and xOffset /= "0000000") then
            leftFlag <= not leftFlag;
        end if;
    end process;    
        
    --Handle Right Button                     
    process(rightButton) begin
        if(rising_edge(rightButton) and slideSwitches = "01" and xOffset /= "1111111") then
            rightFlag <= not rightFlag;
        end if;
    end process; 
    
    --Handle Up Button                     
    process(upButton) begin
        if(rising_edge(upButton) and slideSwitches = "01" and yOffset /= "1111111") then
            upFlag <= not upFlag;
        end if;
    end process; 
    
    --Handle Down Button                     
    process(downButton) begin
        if(rising_edge(downButton) and slideSwitches = "01" and yOffset /= "0000000") then
            downFlag <= not downFlag;
        end if;
    end process;                      
    
    --Handle on/off button
    process(onButton) begin
        if rising_edge(onButton) then 
            displayOn <= not displayOn;
        end if;
    end process;
    
    
    --Process button presses
    process(clk) begin
        if rising_edge(clk) then
          
            if(slideSwitches = "01") then --button mode
                
                --Check left button press    
                if(leftFlagFSM /= leftFlag) then 
                    leftFlagFSM <= leftFlag;
                    xOffset <= xOffset - X"5";
                end if;    
                
                --Check right button press    
                if(rightFlagFSM /= rightFlag) then
                    rightFlagFSM <= rightFlag;
                    xOffset <= xOffset + X"5";
                end if;    
                                                    
                --Check up button press    
                if(upFlagFSM /= upFlag) then
                    upFlagFSM <= upFlag;
                    yOffset <= yOffset + X"5";
                end if;    
                                                    
                --Check down button press    
                if(downFlagFSM /= downFlag) then 
                    downFlagFSM <= downFlag;
                    yOffset <= yOffset - X"5";    
                end if;    
            
            --Reset offsets on mode changes
            else
                xOffset <= "01000000";
                yOffset <= "01000000";
            end if;
                
            --Buffer buttons
            leftButton <= buttons(3);
            rightButton <= buttons(0);
            upButton <= buttons(2);
            downButton <= buttons(1);
            onbutton <= middleButton;
        end if;
    end process;

end Behavioral;
