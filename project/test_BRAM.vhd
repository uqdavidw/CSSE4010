----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2018 12:36:59
-- Design Name: 
-- Module Name: test_BRAM - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_BRAM is
end test_BRAM;

architecture Behavioral of test_BRAM is
    component blk_mem_gen_0 IS
        PORT (
            clka : IN STD_LOGIC;
            ena : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    end component;

    
    signal clk : std_logic := '1';
    signal ena : std_logic := '0';
    signal wea : std_logic_vector(0 downto 0) := "0";
    signal address : std_logic_vector(9 downto 0) := "0000000000";
    signal dataIn : std_logic_vector(7 downto 0);
    signal dataOut : std_logic_vector(7 downto 0);
   
    signal counter : std_logic_vector(7 downto 0) := X"00";
    signal readOutput : std_logic_vector(7 downto 0) := X"00";

    type BRAM_type is (loadWrite, write, loadRead, read);
	signal state : BRAM_type := loadWrite;
begin
    clk <= not clk after 10ps;
    
    BRAM : blk_mem_gen_0 port map (
        clka => clk,
        ena => ena,
        wea => wea,
        addra => address,
        dina => dataIn,
        douta => dataOut
    );
    
    process(clk) begin
        if rising_edge(clk) then 
            case state is
            
                when loadWrite =>
                    ena <= '1';
                    wea <= "1";
                    address(7 downto 0) <= counter;
                    dataIn <= counter;
                    state <= write;
                    
                when write =>
                    ena <= '0';
                    wea <= "0";
                    counter <= counter + "1";
                    
                    if(counter = X"FF") then 
                        state <= loadRead;
                    else
                        state <= loadWrite;
                    end if;
                    
                when loadRead =>
                    wea <= "0";
                    ena <= '1';
                    address(7 downto 0) <= counter;
                    state <= read;
                    
                when read =>
                    readOutput <= dataOut;
                    ena <= '0';
                    counter <= counter + "1";
                    if(counter = X"FF") then 
                        state <= loadWrite;
                    else
                        state <= loadRead;
                    end if;
                
                when others => null;            
            end case;
        end if;
    end process;
    
  
end Behavioral;
