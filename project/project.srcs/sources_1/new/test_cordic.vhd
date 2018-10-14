----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2018 12:36:59
-- Design Name: 
-- Module Name: test_cordic - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_cordic is
end test_cordic;

architecture Behavioral of test_cordic is

    

    component cordic_0 is 
        Port ( 
            aclk : IN STD_LOGIC;
            s_axis_phase_tvalid : IN STD_LOGIC;
            s_axis_phase_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            m_axis_dout_tvalid : OUT STD_LOGIC;
            m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    end component;
    
    signal clk : std_logic := '0';
    signal inValid : std_logic := '1';
    signal inData : std_logic_vector(15 downto 0) := X"0266";
    signal outValid : std_logic;
    signal cosOut : std_logic_vector(7 downto 0);
    signal sinOut : std_logic_vector(7 downto 0);
    signal cordicCosOut : std_logic;
    signal cordicSinOut : std_logic;

begin
    clk <= not clk after 10ps;
    cosOut(7) <= not cordicCosOut;
    sinOut(7) <= not cordicSinOut;
         
    uut : cordic_0 port map (
        aclk => clk,
        s_axis_phase_tvalid => inValid,
        s_axis_phase_tdata => inData,
        m_axis_dout_tvalid => outValid,
        m_axis_dout_tdata(15) => cordicCosOut,
        m_axis_dout_tdata(14 downto 8) => cosOut(6 downto 0),
        m_axis_dout_tdata(7) => cordicSinOut,
        m_axis_dout_tdata(6 downto 0) => sinOut(6 downto 0)
    );   
    
    process(outValid) begin
        if rising_edge(outValid) then
            inValid <= '0';
            if(inData = X"058B") then 
                inData <= X"0266";
            else
                inData <= inData + '1';
            end if;
        else 
            inValid <= '1';
        end if;
    end process;
  
end Behavioral;
