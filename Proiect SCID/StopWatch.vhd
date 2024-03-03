library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity StopWatch is
    Port ( button : in STD_LOGIC;
           button2: in STD_LOGIC; --switch intre timer si cronometruS
           clock : in STD_LOGIC;
           rst : in STD_LOGIC;
           anode : out STD_LOGIC_VECTOR (3 downto 0);
           cathode : out STD_LOGIC_VECTOR (7 downto 0)); --ultimul vector e pentru decimal point
end StopWatch;

architecture Behavioral of StopWatch is
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

signal clock1, clock2 : STD_LOGIC;
begin
Ceas: DivizorFrecventa port map (clock => clock, 
                                   clock_segment => clock1,
                                   clock_centi => clock2);

Afisare: StopWatch_Display port map (clock => clock,
                                    clock_segment => clock1, 
                                    clock_centi => clock2, 
                                    button =>button,
                                    button2 => button2,
                                    rst => rst, 
                                    anode => anode, 
                                    cathode => cathode);
end Behavioral;