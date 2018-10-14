LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY and2or IS
    PORT(
		in1,in2,in3,in4 : IN std_logic;       
		outandor, outandor_flow, outandor_beh : OUT std_logic
		);
END and2or ;

ARCHITECTURE mixed OF and2or IS 

	COMPONENT and2gate
	PORT(
		in1 : IN std_logic;
		in2 : IN std_logic;          
		outand : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT or2gate
	PORT(
		in1 : IN std_logic;
		in2 : IN std_logic;          
		outor : OUT std_logic
		);
	END COMPONENT;
	
	-- need wires to connect outputs of AND gates to OR gate 

	SIGNAL in1or :  std_logic ;
	SIGNAL in2or :  std_logic ;

BEGIN
	--THIS IS STRUCTURAL; g1,g2,g3 form a netlist
	g1: and2gate PORT MAP(
		in1 => in1,	--careful !! it means that in1 of g1 is connected to in1 of Entity and2or 
		in2 => in2,	--careful !! it means that in1 of g1 is connected to in1 of Entity and2or 
		outand => in1or -- connected to 'wire' in1or
	);

	-- another (simpler) way to instantiate (port mapping by position) 
 	g2: and2gate PORT MAP(in3, in4, in2or) ; 

 	g3: or2gate PORT MAP(in1or, in2or, outandor) ;  -- inputs wired to outputs of ANDs, otput directly to the Entity

	--THIS IS SIGNAL FLOW 
	-- now there is a behavioural description of the same functionality, it is not in a process, and is called signal flow style
   
	outandor_flow <= (in1 AND in2) OR (in3 AND in4) ; 

      --THIS IS BEHAVIOURAL/PROCESS
      -- read more in your textbook 
  	
      p1:  PROCESS(in1,in2,in3,in4)
	     BEGIN
  	 	  
              outandor_beh <= (in1 AND in2) OR (in3 AND in4); 
  
   	     END PROCESS ; 

     -- notice how much simpler it is to describe circuits in behavioural/data flow !
     -- All three: signal flow, structural, and behavioural(processes) can be freely mixed.

END;


