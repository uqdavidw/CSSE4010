----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.10.2018 17:27:14
-- Design Name: 
-- Module Name: test_user_interface - Behavioral
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

entity test_user_interface is
--  Port ( );
end test_user_interface;

architecture Behavioral of test_user_interface is
    
    component busModule is
        Port (            
            --Regular bus lines
            dataLine : inout std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
            toModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
            fromModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
            readyLine : inout std_logic := 'Z';
            ackLine : inout std_logic := 'Z';
            
            --Express bus lines
            expressRequestLines : inout std_logic_vector(1 downto 0);
            expressReadyLines : inout std_logic_vector(1 downto 0);
            expressDataLine : inout std_logic_vector(15 downto 0)
        );
    end component;
    
    component busController is
        Port (
            requestLines : in std_logic_vector(7 downto 0);
            grantLines : out std_logic_vector(7 downto 0);
            clk : in std_logic;
            rst : in std_logic
        );
    end component;    
    
    component userInterfaceModule is
        Port (
            clk : in std_logic;
            rst : in std_logic;
            --Interface with bus module
            requestLine : out std_logic := '0';
            grantLine : in std_logic;
            dataLine : inout std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
            toModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
            fromModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
            readyLine : inout std_logic := 'Z';
            ackLine : inout std_logic := 'Z';
            
            --Interface with peripherals 
            ssegAnode : out std_logic_vector(7 downto 0);
            ssegCathode : out std_logic_vector(7 downto 0);
            
            mode : in std_logic_vector(1 downto 0) := "00"; --connect to slide switches
            buttons : in std_logic_vector(3 downto 0) := "0000";
            onButton : in std_logic := '0';
            onLED : out std_logic := '1'
        );
    end component;
    
    component keypadModule is
        Port (
            clk : in std_logic;
            row : in std_logic_vector(3 downto 0);
            col : out std_logic_vector(3 downto 0);
            --Interface with bus module
            requestLine : out std_logic := '0';
            grantLine : in std_logic;
            dataLine : inout std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
            toModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
            fromModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
            readyLine : inout std_logic := 'Z';
            ackLine : inout std_logic := 'Z'        
        );
    end component;

    component busSlave is 
        Port (
                clk : in std_logic;
                --Interface with bus module
                requestLine : out std_logic := '0';
                grantLine : in std_logic;
                dataLine : inout std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
                toModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
                fromModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
                readyLine : inout std_logic;
                ackLine : inout std_logic;
                
                ownAddress : in std_logic_vector(2 downto 0);
                
                --Sending interface with module
                toSendRegister : in std_logic_vector(15 downto 0);
                toModuleRegister : in std_logic_vector(2 downto 0);
                sendFlag : in std_logic;
                
                --Receiving interface with module
                receivedRegister : out std_logic_vector(15 downto 0);
                fromModuleRegister : out std_logic_vector(2 downto 0);
                receivedFlag : out std_logic := '0';
                ackFlag : in std_logic
            );
    end component;

    --General signals
    signal masterReset : std_logic;
    signal scaledClk : std_logic;

    --Bus signals
    signal dataLine : std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
    signal toModuleAddress : std_logic_vector(2 downto 0) := "ZZZ";
    signal fromModuleAddress : std_logic_vector(2 downto 0) := "ZZZ";
    signal readyLine : std_logic := 'Z';
    signal ackLine : std_logic := 'Z';
    signal expressRequestLines : std_logic_vector(1 downto 0);
    signal expressReadyLines : std_logic_vector(1 downto 0);
    signal expressDataLine : std_logic_vector(15 downto 0);
    
    --Arbiter Lines
    signal requestLines : std_logic_vector(7 downto 0);
    signal grantLines : std_logic_vector(7 downto 0);
    
    --Replicated signals 
    signal clk100mhz : std_logic := '0';
    signal slideSwitches : std_logic_vector(15 downto 0) := X"0000";
    signal pushButtons : std_logic_vector(4 downto 0) := "00000"; 
    signal LEDs : std_logic_vector(15 downto 0) := X"0000";
    signal JA : std_logic_vector(7 downto 0) := X"FF";
    
begin
    clk100mhz <= not clk100mhz after 10ps;
    
    process begin
    
        --Test mode changes
        slideSwitches <= X"0001";
        wait for 1000ps;
        slideSwitches <= X"0002";
        wait for 1000ps;
        slideSwitches <= X"0003";
        wait for 1000ps;
        slideSwitches <= X"0000";
        wait for 1000ps;
        slideSwitches <= X"0001";
        wait for 1000ps;
        
        --Test button presses
        pushButtons <= "00001";
        wait for 300ps;
        pushButtons <= "00000";
        wait for 300ps;
        pushButtons <= "00001";
        wait for 300ps;
        pushButtons <= "00000";
        wait for 300ps;
        pushButtons <= "00010";
        wait for 300ps;
        pushButtons <= "00000";
        wait for 300ps;
        pushButtons <= "00100";
        wait for 300ps;
        pushButtons <= "00000";
        wait for 300ps;
        pushButtons <= "01000";
        wait for 300ps;
        pushButtons <= "00000";
        wait for 300ps;
        
        JA(7 downto 4) <= "1011";
        wait for 20ps;
        JA(7 downto 4) <= "1111";
        wait for 60ps;
        JA(7 downto 4) <= "1011";
        wait for 20ps;
        JA(7 downto 4) <= "1111";
        wait for 60ps;
        JA(7 downto 4) <= "1011";
        wait for 20ps;
        JA(7 downto 4) <= "1111";
        wait for 60ps;
        
        wait for 20ps;
        
        JA(7 downto 4) <= "1011";
        wait for 20ps;
        JA(7 downto 4) <= "1111";
        wait for 60ps;
        JA(7 downto 4) <= "1011";
        wait for 20ps;
        JA(7 downto 4) <= "1111";
        wait for 60ps;
        JA(7 downto 4) <= "1011";
        wait for 20ps;
        JA(7 downto 4) <= "1111";
        wait for 60ps;
        
        wait for 20ps;                
                        
        JA(7 downto 4) <= "1011";
        wait for 20ps;
        JA(7 downto 4) <= "1111";
        wait for 60ps;
        JA(7 downto 4) <= "1011";
        wait for 20ps;
        JA(7 downto 4) <= "1111";
        wait for 60ps;
        JA(7 downto 4) <= "1011";
        wait for 20ps;
        JA(7 downto 4) <= "1111";
        wait for 60ps;
        
        wait for 20ps;                

        JA(7 downto 4) <= "1011";
        wait for 20ps;
        JA(7 downto 4) <= "1111";
        wait for 60ps;
        JA(7 downto 4) <= "1011";
        wait for 20ps;
        JA(7 downto 4) <= "1111";
        wait for 60ps;
        JA(7 downto 4) <= "1011";
        wait for 20ps;
        JA(7 downto 4) <= "1111";
        wait for 60ps;
        
        wait for 20ps;                

        
    end process;
    
        
    buss : busModule port map (
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine,
        expressRequestLines => expressRequestLines,
        expressReadyLines => expressReadyLines,
        expressDataLine => expressDataline
    );
    
    arbiter : busController port map (
        requestLines => requestLines,
        grantLines => grantLines,
        clk => clk100mhz,
        rst => masterReset  
    );
    
    userInterface : userInterfaceModule port map (
        clk => clk100mhz,
        rst => masterReset,
        requestLine => requestLines(0),
        grantLine => grantLines(0),
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine,
        
        mode => slideSwitches(1 downto 0),
        buttons => pushButtons(3 downto 0),
        onbutton => pushButtons(4),
        onLED => LEDs(0)
    );
    
    keypad : keypadModule port map (
        clk => clk100mhz,
        row => JA(7 downto 4), 
        col => JA(3 downto 0),
        requestLine => requestLines(2),
        grantLine => grantLines(2),
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine
        
    );
    
    fakeDisplayOutModule : busSlave port map (
        clk => clk100mhz,
        requestLine => requestLines(5),
        grantLine => grantLines(5),
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine,
        ownAddress => "101",
        toSendRegister => X"ABCD",
        toModuleRegister => "111",
        sendFlag => '0',
        ackFlag => '1'
    );
    

end Behavioral;
