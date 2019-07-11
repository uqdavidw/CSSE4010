----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.10.2018 23:21:14
-- Design Name: 
-- Module Name: test_newMerge - Behavioral
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

entity test_newMerge is
--  Port ( );
end test_newMerge;

architecture Behavioral of test_newMerge is
    component newMerge is
        Port (
            ssegAnode : out  STD_LOGIC_VECTOR (7 downto 0);
            ssegCathode : out  STD_LOGIC_VECTOR (7 downto 0);
            slideSwitches : in  STD_LOGIC_VECTOR (15 downto 0) := X"0000";
            pushButtons : in  STD_LOGIC_VECTOR (4 downto 0) := "00000";
            LEDs : out  STD_LOGIC_VECTOR (15 downto 0);
            clk100mhz : in STD_LOGIC;
            JA : in STD_LOGIC_VECTOR(7 downto 0);
            logic_analyzer : out STD_LOGIC_VECTOR(7 downto 0);
            JB : inout STD_LOGIC_VECTOR(7 downto 0);           
            JC : out STD_LOGIC_VECTOR(7 downto 0);
            JD : out STD_LOGIC_VECTOR(7 downto 0);
            
            --Accelometer
            aclMISO : in std_logic;
            aclMOSI : out std_logic;
            aclSCK : out std_logic;
            aclSS : out std_logic
        );
    end component;

    signal ssegAnode : STD_LOGIC_VECTOR (7 downto 0);
    signal ssegCathode : STD_LOGIC_VECTOR (7 downto 0);
    signal slideSwitches : STD_LOGIC_VECTOR (15 downto 0) := X"0000";
    signal pushButtons : STD_LOGIC_VECTOR (4 downto 0) := "00000";
    signal LEDs : STD_LOGIC_VECTOR (15 downto 0);
    signal clk100mhz : STD_LOGIC := '0';
    signal JA : STD_LOGIC_VECTOR(7 downto 0) := "11111111";
    signal logic_analyzer : STD_LOGIC_VECTOR(7 downto 0);
    signal JB : STD_LOGIC_VECTOR(7 downto 0);         
    signal JC : STD_LOGIC_VECTOR(7 downto 0);
    signal JD : STD_LOGIC_VECTOR(7 downto 0);
            
    --Accelometer
    signal aclMISO : std_logic;
    signal aclMOSI : std_logic;
    signal aclSCK : std_logic;
    signal aclSS : std_logic;
    
begin

    clk100mhz <= not clk100mhz after 5ns;
    
    process begin
            --Test keypad
           JA(7 downto 4)<= "1111";
           slideSwitches <= X"0002";
           wait for 100ms;
           
           --4
           JA(7 downto 4)<= "1011";
           wait for 10ns;
           JA(7 downto 4)<= "1111";
           wait for 30ns;
           JA(7 downto 4)<= "1011";
           wait for 10ns;
           JA(7 downto 4)<= "1111";
           wait for 30ns;
           JA(7 downto 4)<= "1011";
           wait for 10ns;
           JA(7 downto 4)<= "1111";
           wait for 30ns;
           
           wait for 10ns;
           
           --5
           JA(7 downto 4)<= "1011";
           wait for 10ns;
           JA(7 downto 4)<= "1111";
           wait for 30ns;
           JA(7 downto 4)<= "1011";
           wait for 10ns;
           JA(7 downto 4)<= "1111";
           wait for 30ns;
           JA(7 downto 4)<= "1011";
           wait for 10ns;
           JA(7 downto 4)<= "1111";
           wait for 30ns;
           
           wait for 10ns;                
              
           --6                
           JA(7 downto 4)<= "1011";
           wait for 10ns;
           JA(7 downto 4)<= "1111";
           wait for 30ns;
           JA(7 downto 4)<= "1011";
           wait for 10ns;
           JA(7 downto 4)<= "1111";
           wait for 30ns;
           JA(7 downto 4)<= "1011";
           wait for 10ns;
           JA(7 downto 4)<= "1111";
           wait for 30ns;
           
           wait for 10ns;                
   
           --B
           JA(7 downto 4)<= "1011";
           wait for 10ns;
           JA(7 downto 4)<= "1111";
           wait for 30ns;
           JA(7 downto 4)<= "1011";
           wait for 10ns;
           JA(7 downto 4)<= "1111";
           wait for 30ns;
           JA(7 downto 4)<= "1011";
           wait for 10ns;
           JA(7 downto 4)<= "1111";
           wait for 30ns;
           
           wait;
          
    end process;

    newIdea : newMerge port map (
        ssegAnode => ssegAnode,
        ssegCathode => ssegCathode,
        slideSwitches => slideSwitches,
        pushButtons => pushButtons,
        LEDs => LEDs,
        clk100mhz => clk100mhz,
        JA => JA,
        logic_analyzer => logic_analyzer,
        JB => JB,
        JC => JC,
        JD => JD,
        aclMISO => aclMISO,
        aclMOSI => aclMOSI,
        aclSCK => aclSCK,
        aclSS => aclSS
    );

end Behavioral;
