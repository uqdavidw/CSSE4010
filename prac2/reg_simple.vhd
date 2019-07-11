library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--  library UNISIM;
--  use UNISIM.VComponents.all;

--This entity is generic for all design samples below this is why so complicated 

entity register_simple is
    Port ( rst: in std_logic; --reset pin
    		 dir: in std_logic;  --direction pin (read or write)
			 en: in std_logic ; --enable pin
           clk : in std_logic; --clk pin
           reg_in : in std_logic_vector(3 downto 0); --input data into register
           reg_out : out std_logic_vector(3 downto 0); --output data from register
           reg_out_p : out std_logic_vector(3 downto 0); --output stored here
		 regSL : inout std_logic_vector(3 downto 0);		--inout allow writing and reading this signal from within the architecture
		 regSR : inout std_logic_vector(3 downto 0);   --inout allow writing and reading this signal from within the architecture
		 regSLa : inout std_logic_vector(3 downto 0);		--inout allow writing and reading this signal from within the architecture
		 regSRa : inout std_logic_vector(3 downto 0);   --inout allow writing and reading this signal from within the architecture
		 regSdir : inout std_logic_vector(3 downto 0);   --inout allow writing and reading this signal from within the architecture
		 reg_out1 : out std_logic_vector(3 downto 0); 
		 reg_out2 : out std_logic_vector(3 downto 0)
		 ); 
end register_simple;

architecture Behavioral of register_simple is
 

begin

-- a simple clocked register with reset 
-- notice that only one clk'event clause is allowed by XILINX synthesis tools 
-- (but the simulator allows as nmany you wish) 

reg_out <= "0000" when rst = '1' else reg_in when (clk'event and clk = '1');

-- reg with enable  (synchronous or asynchronous en ??)   --check what circuit ISE produces in the schematic diagram
reg_out1 <= "0000" when rst = '1' else reg_in when (clk'event and clk = '1') and (en = '1') ;
-- also with  enable  (synchronous or asynchronous en ??)   --check what circuit ISE produces in the schematic diagram
reg_out2 <= "0000" when rst = '1' else (reg_in and en&en&en&en) when (clk'event and clk = '1');
-- comment  on differences of the above registers, read K.L.Short "VHDL for Engineers", Chapter 8



-- the same register described in a process (behavioural VHDL) 
-- again, pay attention to only one clk'event condition required by XILINX synthesis tools to derive 
-- correct synchronous circuitry 

process(rst,clk)is
begin
  if rst = '1' then 	-- asynchronous reset 
    reg_out_p <= "0000" ; 
  elsif (clk'event and clk = '1') then	--the rising edge chose as the active clock edge 
   reg_out_p <= reg_in; 
  end if ;
end process ; 

-- a simple shift left register filling with '0's
regSL <= reg_in when rst = '1' else regSL(2 downto 0)&'0' when (clk'event and clk = '1');

-- a simple shift right register filling with '0's
regSR <= reg_in when rst = '1' else '0'& regSR(3 downto 1) when (clk'event and clk = '1');

-- arithmetic shift left register 
regSLa <= reg_in when rst = '1' else regSLa(2 downto 0)&'0' when (clk'event and clk = '1');

-- arithmetic shift right register filling with signbit 
regSRa <= reg_in when rst = '1' else regSRa(3)& regSRa(3 downto 1) when (clk'event and clk = '1');

-- logical sr sl register with dir signal
-- dir = '1' --> sr
process(rst,clk,dir)is
begin
 if rst = '1' then 
    regSdir <= reg_in ; 
 elsif (clk'event and clk = '1') then
    if dir = '1' then --sr
       regSdir <= '0'& regSdir(3 downto 1);
    else  --  
       regSdir <=  regSdir(2 downto 0)& '0';
    end if ;
 end if ;
end process ; 

end Behavioral;
