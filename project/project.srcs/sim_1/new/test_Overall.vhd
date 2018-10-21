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
                
component boardTop is
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
    
end component;  
    
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
    
    --Simulation additions
    clk100mhz <= not clk100mhz after 10ps;
    
    inputs : process begin
        wait for 2us;
        slideSwitches <= X"0001";
        wait for 2us;
        slideSwitches <= X"0002";
        wait for 2us;
        slideSwitches <= X"0003";
        wait for 2us;
        slideSwitches <= X"0002";
        wait for 2us;
        slideSwitches <= X"0003";                                
        wait;
    end process;
    
    board : boardTop port map (
        ssegAnode => ssegAnode,
        ssegCathode => ssegCathode,
        slideSwitches => slideSwitches,
        pushButtons => pushButtons,
        LEDs => LEDs,
        clk100mhz => clk100mhz,
        JA => JA, 
        JB => JB,
        JC => JC,
        JD => JD,
        aclMISO => aclMISO,
        aclMOSI => aclMOSI,
        aclSCK => aclSCK,
        aclSS => aclSS
    );    

end Behavioral;
