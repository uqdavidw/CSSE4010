----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.08.2018 15:39:40
-- Design Name: 
-- Module Name: locktop_async - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity locktop_async is
    Port ( switchesBus : in STD_LOGIC_VECTOR (7 downto 0);
           button1 : in STD_LOGIC;
           button2 : in STD_LOGIC;
           buttonReset : in STD_LOGIC;
           lockedLED : out STD_LOGIC;
           unlockedLED : out STD_LOGIC;
           correctCount : out STD_LOGIC_VECTOR (7 downto 0);
           incorrectCount : out STD_LOGIC_VECTOR (7 downto 0);
           clock : in STD_LOGIC;
           register1Output : out STD_LOGIC_VECTOR (7 downto 0);
           register2Output : out STD_LOGIC_VECTOR (7 downto 0)
           );
end locktop_async;

architecture Behavioral of locktop_async is

    --declare components and signals
    COMPONENT eight_register
        PORT(
            inBus : in STD_LOGIC_VECTOR (7 downto 0);
            outBus : out STD_LOGIC_VECTOR (7 downto 0);
            clk : in STD_LOGIC;
            reset : in STD_LOGIC
        );
    END COMPONENT;
    
    COMPONENT ssegDriver
        PORT(
            clk : in std_logic;
            rst : in std_logic;
            cathode_p : out std_logic_vector(7 downto 0);
            digit1_p : in std_logic_vector(3 downto 0);
            anode_p : out std_logic_vector(7 downto 0);
            digit2_p : in std_logic_vector(3 downto 0);
            digit3_p : in std_logic_vector(3 downto 0);
            digit4_p : in std_logic_vector(3 downto 0);
            digit5_p : in std_logic_vector(3 downto 0);
            digit6_p : in std_logic_vector(3 downto 0);
            digit7_p : in std_logic_vector(3 downto 0);
            digit8_p : in std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    
    COMPONENT lock_async
        PORT (
            inBus : in STD_LOGIC_VECTOR (15 downto 0);
            unlocked : out STD_LOGIC;
            locked : out STD_LOGIC;
            reset : in STD_LOGIC;
            clock1 : in STD_LOGIC;
            clock2 : in STD_LOGIC;
            correctCount : out STD_LOGIC_VECTOR (7 downto 0);
            incorrectCount : out STD_LOGIC_VECTOR (7 downto 0)
        );
    END COMPONENT;
    
    --signals 
    SIGNAL register1ShiftBus : std_logic_vector(7 downto 0);
    SIGNAL register2ShiftBus : std_logic_vector(7 downto 0);
    SIGNAL correctCountBus : std_logic_vector(7 downto 0) := "00000000";
    SIGNAL incorrectCountBus : std_logic_vector(7 downto 0) := "00000000";
    
begin

correctCount <= correctCountBus;
incorrectCount <= incorrectCountBus;
register1Output <= register1ShiftBus;
register2Output <= register2ShiftBus;


register1 : eight_register port map(
    inBus => switchesBus,
    outBus => register1ShiftBus,
    reset => buttonReset,
    clk => button1
);

register2: eight_register port map(
    inBus => switchesBus,
    outBus => register2ShiftBus,
    reset => buttonReset,
    clk => button2 
);

seven_segment_display: ssegDriver port map (
    clk => clock,
    rst => buttonReset,
    cathode_p => open,
    anode_p => open,
    digit1_p => register1ShiftBus(3 downto 0),
    digit2_p => register1ShiftBus(7 downto 4),
    digit3_p => register2ShiftBus(3 downto 0),
    digit4_p => register2ShiftBus(7 downto 4),
    digit5_p => incorrectCountBus(3 downto 0),
    digit6_p => incorrectCountBus(7 downto 4),
    digit7_p => correctCountBus(3 downto 0),
    digit8_p => correctCountBus(7 downto 4)
);

control : lock_async port map (
    inBus(7 downto 0) => register2ShiftBus,
    inBus(15 downto 8) => register1ShiftBus,
    unlocked => unlockedLED,
    locked => lockedLED,
    reset => buttonReset,
    clock1 => button1,
    clock2 => button2,
    correctCount => correctCountBus,
    incorrectCount => incorrectCountBus
);



end Behavioral;
