----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.10.2018 14:34:03
-- Design Name: 
-- Module Name: userAdapter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
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
        digit8_p : in std_logic_vector(3 downto 0) := "0000"
    ); 
    end component;
    
    --UI signals
    signal xOffset : std_logic_vector(7 downto 0) := "01000000";
    signal yOffset : std_logic_vector(7 downto 0) := "01000000";
    signal displayOn : std_logic := '1';
    signal leftFlag : std_logic := '0';
    signal rightFlag : std_logic := '0';
    signal upFlag : std_logic := '0';
    signal downFlag : std_logic := '0';
    signal leftButton : std_logic := '0';
    signal rightButton : std_logic := '0';
    signal upButton : std_logic := '0';
    signal downButton : std_logic := '0';
    signal onButton : std_logic := '0';
    
    --UI FSM
    signal leftFlagFSM : std_logic := '0';
    signal rightFlagFSM : std_logic := '0';
    signal upFlagFSM : std_logic := '0';
    signal downFlagFSM : std_logic := '0';

    --Output signals
    signal xOffsetMode : std_logic_vector(7 downto 0) := X"00";
    signal yOffsetMode : std_logic_vector(7 downto 0) := X"00";
    signal xFrequencyMode : std_logic_vector(7 downto 0) := X"01";
    signal yFrequencyMode : std_logic_vector(7 downto 0) := X"01";
    
    --sseg signals
    signal scaledClk : std_logic := '0';
    signal sseg0 : std_logic_vector(3 downto 0) := X"0";
    signal sseg1 : std_logic_vector(3 downto 0) := X"0";
    signal sseg2 : std_logic_vector(3 downto 0) := X"0";
    signal sseg3 : std_logic_vector(3 downto 0) := X"0";
    signal sseg4 : std_logic_vector(3 downto 0) := X"0";
    signal sseg5 : std_logic_vector(3 downto 0) := X"0";
    signal sseg6 : std_logic_vector(3 downto 0) := X"0";
    signal sseg7 : std_logic_vector(3 downto 0) := X"0";    
    
    signal leftSsegHex : std_logic_vector(7 downto 0);
    signal rightSsegHex : std_logic_vector(7 downto 0);
    
    signal sseg7dec : std_logic_vector(7 downto 0);
    signal sseg6dec : std_logic_vector(7 downto 0);
    signal sseg5dec : std_logic_vector(7 downto 0);
    signal sseg4dec : std_logic_vector(7 downto 0); 
    
    signal bcdConverter1 : std_logic_vector(6 downto 0) := "0000000";
    signal bcdConverter2 : std_logic_vector(6 downto 0) := "0000000";
    signal bcdConverter3 : std_logic_vector(6 downto 0) := "0000000";
    signal bcdConverter4 : std_logic_vector(6 downto 0) := "0000000";
    
begin
    
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
        digit8_p => sseg7
    );

    mode <= slideSwitches;
    
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
    --sseg0(3 downto 2) <= "00";
    
    --Select sseg display based on mode      
    leftSsegHex <= xOffsetMode when slideSwitches = "01" else xFrequencyMode;
    rightSsegHex <= yOffsetMode when slideSwitches = "01" else yFrequencyMode;
     
    --Convert hex to dec
    sseg7dec <= std_logic_vector(unsigned(leftSsegHex) / 10);
    sseg6dec <= std_logic_vector(unsigned(leftSsegHex) mod 10);
    sseg5dec <= std_logic_vector(unsigned(rightSsegHex) / 10);
    sseg4dec <= std_logic_vector(unsigned(rightSsegHex) mod 10);
    sseg7 <= sseg7dec(3 downto 0);
    sseg6 <= sseg6dec(3 downto 0);
    sseg5 <= sseg5dec(3 downto 0);
    sseg4 <= sseg4dec(3 downto 0);
    
    
       
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
            if(slideSwitches = "01") then
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
