----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.10.2018 13:01:43
-- Design Name: 
-- Module Name: busGuy1 - Behavioral
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
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity busGuy1 is
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
        
        ownAddress : in std_logic_vector(2 downto 0) := "010";
        addNumber : in std_logic_vector(15 downto 0) := X"0007";
        otherAddress : in std_logic_vector(2 downto 0) := "000";
        
        sseg1 : out std_logic_vector(3 downto 0) := X"0";
        sseg2 : out std_logic_vector(3 downto 0) := X"0";
        
        button : in std_logic := '0';
        LED : out std_logic := '0'    
    );
end busGuy1;

architecture Behavioral of busGuy1 is
    component busSlave is
    Port (
        clk : in std_logic;
        --Interface with bus module
        requestLine : out std_logic := '0';
        grantLine : in std_logic;
        dataLine : inout std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
        toModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
        fromModuleAddress : inout std_logic_vector(2 downto 0) := "ZZZ";
        readyLine : inout std_logic := 'Z';
        ackLine : inout std_logic := 'Z';
        
        ownAddress : in std_logic_vector(2 downto 0);
        
        sendState : out std_logic_vector(2 downto 0);
        receiveState : out std_logic_vector(1 downto 0);
        
        --Sending interface with module
        toSendRegister : in std_logic_vector(15 downto 0);
        toModuleRegister : in std_logic_vector(2 downto 0);
        sendFlag : in std_logic := '0';
        
        --Receiving interface with module
        receivedRegister : out std_logic_vector(15 downto 0);
        fromModuleRegister : out std_logic_vector(2 downto 0);
        receivedFlag : out std_logic := '0';
        ackFlag : in std_logic := '0'
    );
end component;

    --Bus interface signals
    signal toSendRegister : std_logic_vector(15 downto 0);
    signal toModuleRegister : std_logic_vector(2 downto 0);
    signal sendFlag : std_logic := '0';
    signal receivedRegister : std_logic_vector(15 downto 0);
    signal fromModuleRegister : std_logic_vector(2 downto 0);
    signal receivedFlag : std_logic := '0';
    signal ackFlag : std_logic := '0';
    
    signal sendState : std_logic_vector(2 downto 0);
    signal receiveState : std_logic_vector(1 downto 0);
    
    signal buttonFlag : std_logic := '0';
    signal buttonRegister : std_logic := '0';
    signal buttonDealtWith : std_logic := '0';
    
    signal myNumber : std_logic_vector(15 downto 0) := X"0000";
        

begin

    sseg1 <= myNumber(7 downto 4);
    sseg2 <= myNumber(3 downto 0);

    busInterface : busSlave port map (
        clk => clk,
        requestLine => requestLine,
        grantLine => grantLine,
        dataLine => dataLine,
        toModuleAddress => toModuleAddress,
        fromModuleAddress => fromModuleAddress,
        readyLine => readyLine,
        ackLine => ackLine,
        ownAddress => ownAddress,
        sendState => sendState,
        receiveState => receiveState,
        toSendRegister => toSendRegister,
        toModuleRegister => toModuleRegister,
        sendFlag => sendFlag,
        receivedFlag => receivedFlag,
        receivedRegister => receivedRegister,
        fromModuleRegister => fromModuleRegister,
        ackFlag => ackFlag
    );
    
    LED <= buttonFlag;
    
    process(buttonRegister) begin
        if rising_edge(buttonRegister) then 
            buttonFlag <= not buttonFlag; 
        end if;
    end process;
    
    process(clk) begin
        if rising_edge(clk) then 
            if(buttonDealtWith /= buttonRegister) then
                buttonDealtWith <= buttonRegister;
                toSendRegister <= myNumber + addNumber;
                toModuleRegister <= otherAddress; 
                sendFlag <= '1';
            end if;
        
            if(grantLine = '1') then 
                sendFlag <= '0';
            end if;
        
            if(receivedFlag = '1') then 
                ackFlag <= '1';
                myNumber <= myNumber + dataLine;
            end if;
            
            if(receiveState = "11" or receiveState = "00") then 
                ackFlag <= '0';
            end if;
        
            buttonRegister <= button;
        end if;
    end process;
    

end Behavioral;
