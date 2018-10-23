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
        
        --Interface with accelerometer
        xAccelFrequency : in std_logic_vector(7 downto 0) := X"01";
        yAccelFrequency : in std_logic_vector(7 downto 0) := X"03";
        
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
    
    xOffsetMode <= xOffset when slideSwitches = "01" else X"00";
    yOffsetMode <= yOffset when slideSwitches = "01" else X"00";
    
    outputEnable <= displayOn;
    
    --LED(0) 
    LEDs(0) <= displayOn;
    LEDs(5) <= leftFlag;
    LEDs(4) <= rightFlag;
    LEDs(3) <= upFlag;
    LEDs(2) <= downFlag;
    
    
    --Display mode on sseg0
    sseg0(1 downto 0) <= slideSwitches;
    sseg0(3 downto 2) <= "00";
    
    --Display xOffset or xFrequency on sseg6, 7
--    bcdConverter1 <= std_logic_vector(unsigned(xOffset) / 10) when mode = "01" 
--                else std_logic_vector(unsigned(xFrequency) / 10);
--    sseg7 <= bcdConverter1(3 downto 0);
--    bcdConverter2 <= std_logic_vector(unsigned(xOffset) mod 10) when mode = "01" 
--            else std_logic_vector(unsigned(xFrequency) mod 10);
--    sseg6 <= bcdConverter2(3 downto 0);
    
--    --Display yOffset or yFrequency on sseg4, 5
--    bcdConverter3 <= std_logic_vector(unsigned(yOffset) / 10) when mode = "01"
--            else std_logic_vector(unsigned(yOffset) / 10);
--    sseg5 <= bcdConverter3(3 downto 0);        
--    bcdConverter4 <= std_logic_vector(unsigned(yOffset) mod 10) when mode = "01" 
--            else std_logic_vector(unsigned(yFrequency) mod 10);
--    sseg4 <= bcdConverter4(3 downto 0);
            
     sseg7(2 downto 0) <= xOffsetMode(6 downto 4) when slideSwitches = "01" else xFrequencyMode(6 downto 4);
     sseg6 <= xOffsetMode(3 downto 0) when slideSwitches = "01" else xFrequencyMode(3 downto 0);
     sseg5(2 downto 0) <= yOffsetMode(6 downto 4) when slideSwitches = "01" else yFrequencyMode(6 downto 4);
     sseg4 <= yOffsetMode(3 downto 0) when slideSwitches = "01" else yFrequencyMode(3 downto 0);       
            
    --Handle LRUD button presses   
    --Left Button                     
    process(leftButton) begin
        if(rising_edge(leftButton) and slideSwitches = "01" and xOffset /= "0000000") then
            leftFlag <= not leftFlag;
        end if;
    end process;    
        
    --Right Button                     
    process(rightButton) begin
        if(rising_edge(rightButton) and slideSwitches = "01" and xOffset /= "1111111") then
            rightFlag <= not rightFlag;
        end if;
    end process; 
    
    --Up Button                     
    process(upButton) begin
        if(rising_edge(upButton) and slideSwitches = "01" and yOffset /= "1111111") then
            upFlag <= not upFlag;
        end if;
    end process; 
    
    --Down Button                     
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
    
    
    --Send, receive functionality
    process(clk) begin
        if rising_edge(clk) then  
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
                    
            --Buffer buttons
            leftButton <= buttons(3);
            rightButton <= buttons(0);
            upButton <= buttons(2);
            downButton <= buttons(1);
            onbutton <= middleButton;
        end if;
    end process;

end Behavioral;
