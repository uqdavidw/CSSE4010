----------------------------------------------------------------------------------
-- Company: University of Queensland
-- Engineer: Sam Eadie
-- 
-- Create Date:    4/10/2018
-- Design Name: 
-- Module Name:    curveGenerator - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity curveGenerator is
    Port (
        clk100mhz : in std_logic := '0'; 
        data : out std_logic_vector(15 downto 0) := X"0000";
        dataReady : out std_logic := '0';
        dataTaken : in std_logic := '0';
        updating : out std_logic := '1'		   
    );
    
end curveGenerator;

architecture Behavioral of curveGenerator is

COMPONENT cordic_0 IS
      PORT (
        aclk : IN STD_LOGIC;
        s_axis_phase_tvalid : IN STD_LOGIC;
        s_axis_phase_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        m_axis_dout_tvalid : OUT STD_LOGIC;
        m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
      );
END COMPONENT;

component TCCR is
    Port (
        clk : in std_logic;
        rst : in std_logic; 
        compareRegister : in std_logic_vector(7 downto 0);
        interrupt : out std_logic := '0'
     );
end component;
    
    type states is (starting, calculating, ready, nextValue, done);
    signal state : states := starting;
    
    signal inValid : std_logic := '0';
    signal inData : std_logic_vector(15 downto 0) := X"0000";
    signal outData : std_logic_vector(31 downto 0) := X"00000000";
    
    signal clk : std_logic := '0';
    signal updatingFlag : std_logic := '1';
    signal outValid : std_logic := '0';
    
    signal rawSin : signed (15 downto 0);
    signal rawCos : signed (15 downto 0);
    
    signal sinOut : std_logic_vector(7 downto 0);
    signal cosOut : std_logic_vector(7 downto 0);
    
    
begin
    
    slow : TCCR port map (
        clk => clk100mhz,
        rst => '0',
        compareRegister => X"64", --200
        interrupt => clk
    );
    
    sineMaker : cordic_0 port map (
        aclk => clk,
        s_axis_phase_tvalid => inValid,
        s_axis_phase_tdata => inData,
        m_axis_dout_tvalid => outValid,
        m_axis_dout_tdata => outData
    );
    
    data(15 downto 8) <= sinOut;
    data(7 downto 0) <= cosOut;
    dataReady <= outValid;
    updating <= updatingFlag;
    
    rawSin <= signed(outData (31 downto 16)) + 16384;
    rawCos <= signed(outData (15 downto 0)) + 16384;
    
    -- Ensure the case for -1 is taken care of by mapping it to 0.
    sinOut <= std_logic_vector(rawSin (14 downto 7)) when rawSin(15) = '0' else not std_logic_vector(rawSin (14 downto 7));
    cosOut <= std_logic_vector(rawCos (14 downto 7)) when rawCos(15) = '0' else not std_logic_vector(rawCos (14 downto 7));    
    
    process(clk100mhz) begin
        if rising_edge(clk100mhz) then 
            case state is 
            
                when starting =>
                    if(outValid = '0') then 
                        inData <= "1110000000000000"; 
                        inValid <= '1';
                        state <= calculating;
                    end if;
                
                when calculating =>
                    if(outValid = '1') then
                        state <= ready;    
                    end if;
                    
                when ready =>
                    if(dataTaken = '1') then
                        inValid <= '0'; 
                        state <= nextValue;
                    end if;
                
                when nextValue =>
                    if(outValid = '0' and dataTaken = '0') then 
                        if(inData = "0010000000000000") then 
                            inData <= "1110000000000000";
                            updatingFlag <= '0';
                            state <= done;
                        else 
                            inValid <= '1';
                            inData <= inData + X"0010";
                            state <= calculating;
                        end if;
                    end if;
                    
                when done => 
                    if(updatingFlag = '1') then 
                        state <= calculating;
                    end if;
            end case;
        end if;
    end process;
    
end Behavioral;