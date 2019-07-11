----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21/09/2018
-- Design Name: 
-- Module Name: test_Decoder - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_Decoder is
end test_Decoder;

architecture Behavioral of test_Decoder is
    
    component keypadAdapter is port (
        clk : in  STD_LOGIC;
        Row : in  STD_LOGIC_VECTOR (3 downto 0);
        Col : out  STD_LOGIC_VECTOR (3 downto 0);
        DecodeOut : out  STD_LOGIC_VECTOR (3 downto 0) := "0000";
        buttonDepressed  : out STD_LOGIC := '0'
        
    );
    end component;
    
    signal clock : std_logic := '0';
    signal ColOut : std_logic_vector (3 downto 0);
    signal DecodeOut : std_logic_vector (3 downto 0);
    signal inputSequence : std_logic_vector (3 downto 0);
    signal buttonDepressed : std_logic;

begin

    clock <= not clock after 5ns;
    
    uut : keypadAdapter port map (
        clk => clock,
        Col => ColOut,
        Row => inputSequence,
        DecodeOut => DecodeOut,
        buttonDepressed => buttonDepressed
    );
    
    test_sequence : process
        begin
            for i in 1 to 24 loop
                inputSequence <= "1110"; 
                wait for 50ns;
                inputSequence <= "1101"; 
                wait for 50ns;
                inputSequence <= "1011"; 
                wait for 50ns;
                inputSequence <= "0111"; 
                wait for 50ns;
            end loop;
        wait;
    end process;


end Behavioral;
