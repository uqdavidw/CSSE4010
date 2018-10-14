----------------------------------------------------------------------------------
-- Company: University of Queensland
-- Engineer: Sam Eadie
-- 
-- Create Date:    25/07/2014 
-- Design Name: 
-- Module Name:    boardTop 
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

architecture structural of boardTop is

    component fsm_1 port (
         clk : IN std_logic;
         reset : IN std_logic;
         inputX : IN std_logic;
         outputZ : OUT std_logic;
         state1Display : OUT std_logic_vector(2 downto 0);
         state2Display : OUT std_logic_vector(1 downto 0)
    );
    end component;
    
    component clockScaler port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        clkdiv : out STD_LOGIC
    );
    end component;
    
    signal masterReset : std_logic;
    signal scaledClk : std_logic;
    
begin

    clock_scaler : clockScaler port map (
        clk => clk100mhz,
        rst => masterReset,
        clkdiv => scaledClk
    );
    
    fsm : fsm_1 port map (
        clk => scaledClk,
        reset => masterReset,
        inputX => JA(4), --JA7 == JA[4] 
        outputZ => logic_analyzer(0),
        state1Display => logic_analyzer(3 downto 1),
        state2Display => logic_analyzer(5 downto 4)
    );
    
    --display the current state ID, clock, reset, inputX, outputZ

    logic_analyzer(6) <= scaledClk;
    masterReset <= pushButtons(3);

end structural;

