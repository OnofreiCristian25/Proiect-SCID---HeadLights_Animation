----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.05.2022 23:57:52
-- Design Name: 
-- Module Name: Simulare - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Simulare is
    --  Port ( );
end Simulare;

architecture Behavioral of Simulare is

    component fsm is
        Port ( clk : in STD_LOGIC;
             rst : in STD_LOGIC;
             sw : in STD_LOGIC_VECTOR (2 downto 0);
             led : out STD_LOGIC_VECTOR (15 downto 0));
    end component fsm;

    signal clk,rst : std_logic;
    signal sw : std_logic_vector(2 downto 0);
    signal led : std_logic_vector(15 downto 0);

begin

    uut : fsm port map (clk => clk,
                 rst => rst,
                 sw => sw,
                 led => led);

    process
    begin
        clk <= '1'; wait for 40ns;
        clk <= '0'; wait for 40ns;
    end process;

    rst <= '0' after 0ns, '1' after 300ns, '0' after 320ns;

    sw <= "100" after 0 ns,
 "010" after 100 ns,
 "001" after 200 ns,
 "100" after 300 ns,
 "010" after 400 ns,
 "001" after 500 ns;

end Behavioral;