----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/30/2022 08:20:27 AM
-- Design Name: 
-- Module Name: a2_idk - Behavioral
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

entity a2 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           continue : in STD_LOGIC;
           pause : in STD_LOGIC;
           anode : out STD_LOGIC_VECTOR (3 downto 0);
           dp : out STD_LOGIC;
           A : out STD_LOGIC;
           B : out STD_LOGIC;
           C : out STD_LOGIC;
           D : out STD_LOGIC;
           E : out STD_LOGIC;
           F : out STD_LOGIC;
           G : out STD_LOGIC);
end ;

architecture Behavioral of a2 is

signal minute : std_logic_vector(3 downto 0):="0000";
signal second_ten : std_logic_vector(3 downto 0):="0000";
signal second_one : std_logic_vector(3 downto 0):="0000";
signal milliseconds : std_logic_vector(3 downto 0):="0000";
signal p : std_logic_vector(3 downto 0):="0000";
signal refresh_counter : std_logic_vector(19 downto 0) := (others => '0');
signal anode_activate : std_logic_vector(1 downto 0) := "00";
signal reset_watch : std_logic:='0';
signal enable_watch : std_logic:='0';
signal stop_watch_counter : std_logic_vector(23 downto 0):=(others => '0');
signal refresh_rate : integer range 0 to 41667 := 0;
begin

process(clk)
begin
if rising_edge(clk) then
    if pause = '1' then
        enable_watch <= '0';
        if continue = '1' then
            enable_watch <= '1';
            reset_watch <= '0';
        end if;
    end if;
    if enable_watch = '0' then
        if continue = '1' then
            enable_watch <= '1';
            reset_watch <= '0';
        end if;
    end if;
    if reset = '1' then
        enable_watch <= '0';
        reset_watch <= '1';
    end if;
    if start = '1' then
        enable_watch <= '1';
        reset_watch <= '0';
        if reset = '1' then 
            reset_watch <= '1';
            enable_watch <= '0';
        elsif pause = '1' then
            enable_watch <= '0';
            if continue = '1' then
                enable_watch <= '1';
            end if;
        end if;
    end if;
end if;
end process;

process(clk)
begin
if rising_edge(clk) then
    refresh_counter <= refresh_counter + '1';
    refresh_rate <= refresh_rate + 1;
    if refresh_rate = 1048576 then
        refresh_rate <= 0;
        refresh_counter <= (others => '0');
    end if;
        if stop_watch_counter = "100110001001011010000000" then
            stop_watch_counter <= "000000000000000000000000";
        else
            stop_watch_counter <= stop_watch_counter + 1;
        end if;
        if stop_watch_counter =  "100110001001011010000000" then  
            if enable_watch = '1' then
                        milliseconds <= milliseconds + 1;
                        if milliseconds = "1010" then
                                                  
                            second_one <= second_one + 1;
                            milliseconds <= "0000";
                        end if;
                        if second_one = "1010" then
                            second_ten <= second_ten + 1;
                            second_one <="0000";
                            
                        end if;
                        if second_ten = "0110" then
                            minute <= minute + 1;
                            second_ten <= "0000";
                            
                        end if;
                        if minute = "1010" then
                            minute <= "0000";
                        end if;  
             end if;                    
             if reset_watch ='1' then
                 milliseconds <= "0000";
                 second_one <= "0000";
                 second_ten <= "0000";
                 minute <= "0000";
             end if;
    end if;
    anode_activate <= refresh_counter(19 downto 18);   
end if;
end process;

process(anode_activate)
begin
    case anode_activate is
        when "00" =>
            anode <= "1110";
            dp <= '1';
            p <= milliseconds;
            if milliseconds < "1010" then
                p <= milliseconds;
            elsif milliseconds = "1010" then 
                p <= "0000";
            end if;
        when "01" =>
            anode <= "1101";
            dp <= '0';
            p <= second_one;
            if second_one < "1010" then
                p <= second_one;
            elsif second_one = "1010" then
                p<= "0000";
            end if;
        when "10" =>
            anode <= "1011";
            dp <= '1';
            p <= second_ten;
            if second_ten < "0110" then
                p <= second_ten;
            elsif second_ten = "0110" then
                p <= "0000";
            end if;
        when "11" =>
            anode <= "0111";
            dp <= '0';
            p <= minute;
            if minute < "1010" then 
                p <= minute;
            elsif minute = "1010" then
                p <= "0000";
            end if;
        when others =>
            anode <= "1111";
            dp <= '1';
    end case;
end process;

process(p)
begin
A <= ((not p(3)) and (not p(2)) and (not p(1)) and p(0)) or ((not p(3)) and p(2) and (not p(1)) and (not p(0))) or (p(3) and p(2) and (not p(1)) and p(0))
or (p(3) and (not p(2)) and p(1) and p(0));
B <= (p(2) and p(1) and (not p(0))) or (p(3) and p(1) and p(0)) or ((not p(3)) and p(2) and (not p(1)) and p(0)) or (p(3) and p(2) and (not p(1)) and (not p(0)));
C <= ((not p(3)) and (not p(2)) and p(1) and (not p(0))) or (p(3) and p(2) and p(1)) or (p(3) and p(2) and (not p(0)));
D <= ((not p(3)) and (not p(2)) and (not p(1)) and p(0)) or ((not p(3)) and p(2) and (not p(1)) and (not p(0))) or (p(3) and (not p(2)) and p(1) and (not p(0))) 
or (p(2) and p(1) and p(0));
E <= ((not p(2)) and (not p(1)) and p(0)) or ((not p(3)) and p(0)) or ((not p(3)) and p(2) and (not p(1)));
F <= ((not p(3)) and (not p(2)) and p(0)) or ((not p(3)) and (not p(2)) and p(1)) or ((not p(3)) and p(1) and p(0)) or (p(3) and p(2) and (not p(1)) and p(0));
G <= ((not p(3)) and (not p(2)) and (not p(1))) or ((not p(3)) and p(2) and p(1) and p(0)) or (p(3) and p(2) and (not p(1)) and (not p(0)));
end process;

end Behavioral;