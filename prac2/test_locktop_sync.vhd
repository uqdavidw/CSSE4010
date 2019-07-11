----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.08.2018 21:45:37
-- Design Name: 
-- Module Name: test_locktop_sync - Behavioral
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
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_locktop_sync is
end test_locktop_sync;

architecture Behavioral of test_locktop_sync is
    component locktop_sync is
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
    end component;
    
    signal switchesBus : std_logic_vector(7 downto 0) := "00000000";
    signal register1Output : std_logic_vector (7 downto 0);
    signal register2Output : std_logic_vector (7 downto 0);
    signal button1 : std_logic := '0';
    signal button2 : std_logic := '0';
    signal buttonReset : std_logic := '0';
    signal lockedLED : std_logic := '1';
    signal unlockedLED : std_logic := '0';
    signal clockSignal : std_logic := '0';
    signal correctCount : std_logic_vector (7 downto 0);
    signal incorrectCount : std_logic_vector (7 downto 0);
    signal inputSequence : std_logic_vector(95 downto 0) := X"443536075524271666171425";

begin

    uut: locktop_sync port map (
        switchesBus => switchesBus,
        button1 => button1,
        button2 => button2,
        buttonReset => buttonReset, 
        lockedLED => lockedLED,
        unlockedLED => unlockedLED,
        clock => clockSignal,
        correctCount => correctCount,
        incorrectCount => incorrectCount,
        register1Output => register1Output,
        register2Output => register2Output
        
    );
    
    clock : process begin
        while true loop
            if clockSignal = '1' then 
                clockSignal <= '0';
            else
                 clockSignal <= '1';
            end if;
            wait for 10ps;
        end loop;
    end process clock; 
    
    input_gen : process
        begin
            switchesBus <= "00000000";
            button1 <= '0';
            button2 <= '0';
            buttonReset <= '0';
            
            for i in 1 to 24 loop
                switchesBus <= inputSequence(95 downto 88);
                
                --'Press' button1
                wait for 10ps;
                button1 <= '1';
                wait for 10ps;
                button1 <= '0';
                
                --Shift left by 1 digit = 4 bits
                inputSequence <= std_logic_vector(shift_left(unsigned(inputSequence), 8));
                
                if lockedLED = '1' then
                    report "The lock has been unlocked";
                end if;
                    
            end loop;
        wait;
    end process;


end Behavioral;
