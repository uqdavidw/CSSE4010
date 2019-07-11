-- State machine with single sequential block
-- File fsm_1.vhd
library IEEE;
use IEEE.std_logic_1164.all;

entity fsm_1 is
	port(
	clk, reset, inputX : IN  std_logic;
	outputZ      : OUT std_logic := '0';
	--display the current state ID, clock, reset, inputX, outputZ
	state1Display : OUT std_logic_vector(2 downto 0);
	state2Display : OUT std_logic_vector(1 downto 0)
    );
end entity;

architecture mixed of fsm_1 is
    --signal detectFlag : std_logic := '0';
    signal sequentialClockFlag : std_logic := '0';

    attribute state_encoding : string;

	type state_type1 is (s1, s2, s3, s4, s5, s6);
	signal state1 : state_type1 := s1;
	attribute state_encoding of state_type1: type is "100 000 001 011 010 101";
	--attribute state_encoding of state_type1: type is "gray";

	type state_type2 is (s1, s2, s3);
    signal state2 : state_type2 := s1;
    attribute state_encoding of state_type2: type is "01 00 11";
    --attribute state_encoding of state_type2: type is "gray";

begin

    --Moore machines: output function of current state only
    --detectFlag <= '1' when state1 = s6 else '0';
    --outputZ <= '0' when state2 = s1 else '1';

    process(reset, clk)
			variable detectFlag : std_logic := '0';
		begin
        --reset
        if(reset = '1') then
            state1 <= s1;
						state2 <= s1;

        --clocked state transitions
        elsif rising_edge(clk) then
        detectFlag := '0';
        case state1 is
            when s1 =>
                if inputX = '1' then
                    state1 <= s1;
                else
                    state1 <= s2;
                end if;
            when s2 =>
                if inputX = '1' then
                    state1 <= s3;
                else
                    state1 <= s2;
                end if;
            when s3 =>
                if inputX = '1' then
                    state1 <= s4;
                else
                    state1 <= s2;
                end if;
            when s4 =>
                if inputX = '1' then
                    state1 <= s5;
                else
                    state1 <= s2;
                end if;
            when s5 =>
                if inputX = '1' then
                    state1 <= s1;
                else
                    state1 <= s6;
                    detectFlag := '1';
                end if;
            when s6 =>
                if inputX = '1' then
                    state1 <= s3;
                else
                    state1 <= s2;
                end if;
            end case;

            outputZ <= '1';
			--Update fsm_2 based on fsm_1
			case state2 is
                when s1 =>
                    if detectFlag = '1' then
                        state2 <= s2;
                    else
                        state2 <= s1;
                        outputZ <= '0';
                    end if;
                when s2 =>
                    if detectFlag = '1' then
                        state2 <= s2;
                    else
                        state2 <= s3;
                    end if;
                when s3 =>
                    if detectFlag = '1' then
                        state2 <= s2;
                    else
                        state2 <= s1;
                        outputZ <= '0';
                    end if;
            end case;
		end if;
    end process;

    -- process(reset, clk)
    -- begin
    --     --reset
    --     if(reset = '1') then
    --         state2 <= s1;
		--
    --     --clocked state transitions
    --     elsif rising_edge(clk) then
    --         case state2 is
    --             when s1 =>
    --                 if detectFlag = '1' then
    --                     state2 <= s2;
    --                 else
    --                     state2 <= s1;
    --                 end if;
    --             when s2 =>
    --                 if detectFlag = '1' then
    --                     state2 <= s2;
    --                 else
    --                     state2 <= s3;
    --                 end if;
    --             when s3 =>
    --                 if detectFlag = '1' then
    --                     state2 <= s2;
    --                 else
    --                     state2 <= s1;
    --                 end if;
    --         end case;
    --     end if;
    -- end process;


    process(state1) begin
        case state1 is
            when s1 => state1Display <= "001";
            when s2 => state1Display <= "010";
            when s3 => state1Display <= "011";
            when s4 => state1Display <= "100";
            when s5 => state1Display <= "101";
            when s6 => state1Display <= "110";
        end case;
    end process;

    process(state2) begin
        case state2 is
            when s1 => state2Display <= "01";
            when s2 => state2Display <= "10";
            when s3 => state2Display <= "11";
        end case;
    end process;
--	process(reset, clk) begin
--	    --reset
--	    if(reset = '1') then
--            state1 <= s1;

--        --clocked state transitions
--	    elsif rising_edge(clk) then
--	        --sequentialClockFlag <= '1';
--	        detectFlag <= '0';
--            if inputX = '1' then
--                case state1 is
--                    when s1 => state1 <= s1;
--                    when s2 => state1 <= s3;
--                    when s3 => state1 <= s4;
--                    when s4 => state1 <= s5;
--                    when s5 => state1 <= s1;
--                    when s6 => state1 <= s3;
--                end case;
--            else
--                case state1 is
--                     when s1 => state1 <= s2;
--                     when s2 => state1 <= s2;
--                     when s3 => state1 <= s2;
--                     when s4 => state1 <= s2;
--                     when s5 => state1 <= s6;
--                        detectFlag <= '1';
--                     when s6 => state1 <= s2;
--                 end case;
--            end if;
--        end if;
--	end process;



	--state transitions
    --process(reset, sequentialClockFlag)
--    process(reset, clk)
--    begin
--        --reset
--        if(reset = '1') then
--            state2 <= s1;

--        --clocked state transitions
--        --elsif rising_edge(sequentialClockFlag) then
--        elsif rising_edge(clk) then
--            --sequentialClockFlag <= '0';
--            if detectFlag = '1' then
--                case state2 is
--                    when s1 => state2 <= s2;
--                    when s2 => state2 <= s2;
--                    when s3 => state2 <= s2;
--                end case;
--            else
--                case state2 is
--                     when s1 => state2 <= s1;
--                     when s2 => state2 <= s3;
--                     when s3 => state2 <= s1;
--                 end case;
--            end if;
--        end if;
--    end process;

--    --Moore machine: change output on state change
--    process(state1) begin
--       case state1 is
--           when s1 => detectFlag <= '0';
--           when s2 => detectFlag <= '0';
--           when s3 => detectFlag <= '0';
--           when s4 => detectFlag <= '0';
--           when s5 => detectFlag <= '0';
--           when s6 => detectFlag <= '1';
--       end case;
--    end process;

--    process(state2) begin
--       case state2 is
--           when s1 => outputZ <= '0';
--           when s2 => outputZ <= '1';
--           when s3 => outputZ <= '1';
--       end case;
--    end process;

end mixed;
