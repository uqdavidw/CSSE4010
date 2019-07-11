----------------------------------------------------------------------------------
-- Company: University of Queensland
-- Engineer: Sam Eadie
-- 
-- Create Date:    25/07/2014 
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity boardTop is
    Port ( ssegAnode : out  STD_LOGIC_VECTOR (7 downto 0);
           ssegCathode : out  STD_LOGIC_VECTOR (7 downto 0);
           slideSwitches : in  STD_LOGIC_VECTOR (15 downto 0);
           pushButtons : in  STD_LOGIC_VECTOR (4 downto 0);
           LEDs : out  STD_LOGIC_VECTOR (15 downto 0);
           clk100mhz : in STD_LOGIC;
		   logic_analyzer : out STD_LOGIC_VECTOR (7 downto 0);
		   JA : in STD_LOGIC_VECTOR(7 downto 0)
		   );
end boardTop;

architecture Behavioral of boardTop is
    
    component keypadAdapter port (
		clk : in  STD_LOGIC;
        Row : in  STD_LOGIC_VECTOR (3 downto 0);
		Col : out  STD_LOGIC_VECTOR (3 downto 0);
        DecodeOut : out  STD_LOGIC_VECTOR (3 downto 0);
        buttonDepressed  : out STD_LOGIC := '0'
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
    
    component calculator_fsm port (
        keypadInput : in std_logic_vector (3 downto 0);
        clk : in std_logic;
        sum : in std_logic_vector (7 downto 0);
        adderA : out std_logic_vector (7 downto 0);
        adderB : out std_logic_vector (7 downto 0);
        sseg1 : out std_logic_vector (3 downto 0);
        sseg0 : out std_logic_vector (3 downto 0);
        stateNum : out std_logic_vector (1 downto 0)
    );
    end component;
    
    component adder_module port (
        Carry_in : in std_logic := '0';			
        Carry_out : out std_logic;
        A : in std_logic_vector (7 downto 0);
        B : in std_logic_vector (7 downto 0);
        S : out std_logic_vector (7 downto 0) 
    );
    end component;
    
    signal masterReset : std_logic;
    signal scaledClk : std_logic;
    signal keypadOutput : std_logic_vector(3 downto 0);
    signal keypadDepressed : std_logic;
    signal sseg1 : std_logic_vector (3 downto 0);
    signal sseg0 : std_logic_vector (3 downto 0);
    signal adderA : std_logic_vector (7 downto 0);
    signal adderB : std_logic_vector (7 downto 0);
    signal adderSum : std_logic_vector (7 downto 0);
    signal fsmState : std_logic_vector (1 downto 0);
    
    
begin

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
        digit2_p => sseg1
        
    );
    
    keypad : keypadAdapter port map (
        clk => scaledClk,
        DecodeOut => keypadOutput,
        Row => JA(7 downto 4), 
        Col => logic_analyzer(3 downto 0),
        buttonDepressed => keypadDepressed
    );
    
    calculator : calculator_fsm port map (
        clk => keypadDepressed,
        keypadInput => keypadOutput,
        sum => adderSum,
        adderA => adderA,
        adderB => adderB,
        sseg1 => sseg1,
        sseg0 => sseg0,
        stateNum => fsmState
    );
    
    adder : adder_module port map (
        --Carry_out TO THIRD SEVEN SEG DIG MAYBE?
        A => adderA,
        B => adderB,
        S => adderSum
    );  
    
    logic_analyzer(7 downto 6) <= fsmState;
    logic_analyzer(5) <= keypadDepressed;
    masterReset <= pushButtons(3);
end Behavioral;

