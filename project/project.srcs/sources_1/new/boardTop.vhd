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
		   --logic_analyzer : out STD_LOGIC_VECTOR (7 downto 0);
		   JC : out STD_LOGIC_VECTOR(7 downto 0);
		   JD : out STD_LOGIC_VECTOR(7 downto 0)
    );
end boardTop;

architecture Behavioral of boardTop is
    component clockScaler port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        clkdiv : out STD_LOGIC
    );
    end component;
    
     component eightBitCounter port (
        clk : in std_logic;
        rst : in std_logic;
        output : out std_logic_vector (7 downto 0) 
     );
     end component;
     
     component cordic_0 PORT (
         aclk : IN STD_LOGIC;
         s_axis_phase_tvalid : IN STD_LOGIC;
         s_axis_phase_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         m_axis_dout_tvalid : OUT STD_LOGIC;
         m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
       );
     END component;
    
    signal masterReset : std_logic;
    signal scaledClk : std_logic;
    signal x : std_logic_vector (7 downto 0);
    signal wireBoi : std_logic;
    
begin
    masterReset <= pushButtons(3);
    
    clock_scaler : clockScaler port map (
        clk => clk100mhz,
        rst => masterReset,
        clkdiv => scaledClk
    );
    
    counter : eightBitCounter port map (
        clk => scaledClk,
        rst => masterReset,
        output => x
    );
    
    sineMaker : cordic_0 port map (
        aclk => scaledClk,
        s_axis_phase_tdata => x,
        s_axis_phase_tvalid => wireBoi,
        m_axis_dout_tvalid => wireBoi,
        m_axis_dout_tdata(15 downto 8) => JC(7 downto 0),
        m_axis_dout_tdata(7 downto 0) => JD(7 downto 0)
    );
    
end Behavioral;