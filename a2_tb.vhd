----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/30/2022 11:11:55 PM
-- Design Name: 
-- Module Name: a2_tb - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity a2_tb is
--  Port ( );
end a2_tb;

architecture Behavioral of a2_tb is
     component a2
         Port ( clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            start : in STD_LOGIC;
            continue : in STD_LOGIC;
            pause : in STD_LOGIC;
            anode : out std_logic_vector(3 downto 0);
            dp : out std_logic;
            A : out std_logic;
            B : out std_logic;
            C : out std_logic;
            D : out std_logic;
            E : out std_logic;
            F : out std_logic;
            G : out std_logic);
     end component;
     signal clk,reset,start,continue,pause : std_logic:='0';
     signal anode : std_logic_vector(3 downto 0) := "0000";
     signal dp,A,B,C,D,E,F,G : std_logic := '0';
     constant period : time :=10 ns ;
begin
     UUT : a2 port map 
(clk=>clk,reset=>reset,start=>start,continue=>continue,pause=>pause,anode=>anode,dp=>dp,A=>A,B=>B,C=>C,D=>D,E=>E,F=>F,G=>G);
    clk<= not clk after period/2;
    start <='1';
    pause<= '0','1' after 300 ns, '0' after 400 ns;
    continue<= '0', '1' after 400 ns,'0' after 500 ns;
    reset <= '0';

end Behavioral;
