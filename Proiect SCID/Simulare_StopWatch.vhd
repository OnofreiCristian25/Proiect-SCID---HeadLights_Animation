library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Simulare_StopWatch is
--  Port ( );
end Simulare_StopWatch;

architecture Behavioral of Simulare_StopWatch is

component StopWatch is
    Port ( button : in STD_LOGIC;
           button2: in STD_LOGIC;
           clock : in STD_LOGIC;
           rst : in STD_LOGIC;
           anode : out STD_LOGIC_VECTOR (3 downto 0);
           cathode : out STD_LOGIC_VECTOR (7 downto 0));
end component StopWatch;

component DivizorFrecventa
Port ( clock : in STD_LOGIC;
       clock_segment : out STD_LOGIC;
       clock_centi : out STD_LOGIC);
end component;

component StopWatch_Display
    Port ( button : in STD_LOGIC;
           button2: in STD_LOGIC;
           rst : in STD_LOGIC;
           clock : in STD_LOGIC;
           clock_segment : in STD_LOGIC;
           clock_centi : in STD_LOGIC;
           anode : out STD_LOGIC_VECTOR (3 downto 0);
           cathode : out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal button, button2, rst, clock : std_logic := '0';
signal anode : std_logic_vector(3 downto 0);
signal cathode : STD_LOGIC_VECTOR (7 downto 0);

begin
uut: StopWatch Port map( button => button,
                         button2 => button2,
                         clock => clock,
                         rst => rst,
                         anode => anode,
                         cathode => cathode);

Stop: process
begin
    rst <= '0';
    wait for 10 sec;
    rst <= '1';
    wait for 10ns;
    button <= '1';
    button <= '0' after 20ns;
    wait for 10 sec;
    button2 <= '1';
    button2 <= '0' after 5 sec;
    
end process;


end Behavioral;
