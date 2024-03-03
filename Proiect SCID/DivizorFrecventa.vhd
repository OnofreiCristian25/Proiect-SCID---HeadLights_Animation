library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity DivizorFrecventa is
    Port (clock : in STD_LOGIC;
          clock_segment : out STD_LOGIC;
          clock_centi : out STD_LOGIC);
end DivizorFrecventa;

architecture Behavioral of DivizorFrecventa is

signal clk_segment, clk_centisecunde : STD_LOGIC;
begin
process (clock)
variable c1 : unsigned (17 downto 0):="000000000000000000";
begin
if (rising_edge(clock)) then
    if c1 = "110010110111001101" then --208333
        clk_segment <= not clk_segment;
        c1 := "000000000000000000";
    end if;
    c1 := c1 + 1;
end if;
end process;
process (clock)
variable c2 : unsigned (18 downto 0):="0000000000000000000";
begin
if (rising_edge(clock)) then
    if c2 = "1111010000100100000" then --500000
        clk_centisecunde <= not clk_centisecunde;
        c2 := "0000000000000000000";
    end if;
    c2 := c2 + 1;
end if;
end process;

clock_segment <= clk_segment;
clock_centi <= clk_centisecunde;
end Behavioral;