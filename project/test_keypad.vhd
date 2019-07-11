----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2018 12:36:59
-- Design Name: 
-- Module Name: test_keypad - Behavioral
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

entity test_keypad is
end test_keypad;

architecture Behavioral of test_keypad is
    component busController is 
        Port ( 
            requestLines : in std_logic_vector(7 downto 0);
            grantLines : out std_logic_vector(7 downto 0) := X"00";
            clk : in std_logic;
            rst : in std_logic
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
    
    
    --Bus lines
    signal clk : std_logic := '0';
    signal data : std_logic_vector(15 downto 0) := X"0000";
    signal toModule : std_logic_vector(2 downto 0) := "000";
    signal fromModule : std_logic_vector(2 downto 0) := "000";
    signal requestLines : std_logic_vector(7 downto 0) := X"00";
    signal grantLines : std_logic_vector(7 downto 0) := X"00";
    signal readyLine : std_logic := '0';
    signal ackLine : std_logic := '0';
    
    signal sendFlag : std_logic := '1';
    
    --Keypad Lines
    signal row : std_logic_vector(3 downto 0) := "1011";
    signal col : std_logic_vector(3 downto 0);
  
            
begin
    clk <= not clk after 10ps;
    sendFlag <= '0' after 100ps;
    row(3) <=  not row(3) after 97ps;
    row(1) <=  not row(1) after 97ps;
    row(0) <=  not row(0) after 97ps;
     
    busControl : busController port map (
        requestLines => requestLines,
        grantLines => grantLines,
        clk => clk,
        rst => '0'    
    );
    
    slave1 : busSlave port map (
        clk => clk,
        requestLine => requestLines(0),
        grantLine => grantLines(0),
        dataLine => data,
        toModuleAddress => toModule,
        fromModuleAddress => fromModule,
        readyLine => readyLine,
        ackLine => ackLine,
        ownAddress => "000",
        toSendRegister => X"0002",
        toModuleRegister => "010",
        sendFlag => sendFlag,
        ackFlag => '1'
    );

    keypad : keypadModule port map (
        clk => clk,
        row => row,
        col => col,
        
        requestLine => requestLines(2),
        grantLine => grantLines(2),
        dataLine => data,
        toModuleAddress => toModule,
        fromModuleAddress => fromModule,
        readyLine => readyLine,
        ackLine => ackLine
    );
    
end Behavioral;
