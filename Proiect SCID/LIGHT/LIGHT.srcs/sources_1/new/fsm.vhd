----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.05.2022 23:56:33
-- Design Name: 
-- Module Name: fsm - Behavioral
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

entity fsm is
    Port ( clk : in STD_LOGIC;
         rst : in STD_LOGIC;
         sw : in STD_LOGIC_VECTOR (2 downto 0);
         led : out STD_LOGIC_VECTOR (15 downto 0));
end fsm;

architecture Behavioral of fsm is

    --starile automatului
    type states is(idle, LAon, LALBon, LALBLCon, RAon, RARBon, RARBRCon, HAZARD1, HAZARD2, HAZARD3);

    --starea curenta si starea viitoare
    signal current_state, next_state : states;

    --declaram parametrilor
    signal LEFT, RIGHT, HAZ, inc1sec : std_logic;

begin

    HAZ <= sw(0);
    LEFT <= sw(1);
    RIGHT <= sw(2);

    --declararea ledurilor in vectori de valori binare in functie de fiecare stdiu
    led <= "0000000000000000" when current_state = idle

           else   "0000110000110000" when current_state = HAZARD1
           else   "0011110000111100" when current_state = HAZARD2
           else   "1111110000111111" when current_state = HAZARD3


           else   "0000110000000000" when current_state = LAon
           else   "0011110000000000" when current_state = LALBon
           else   "1111110000000000" when current_state = LALBLCon

           else   "0000000000110000" when current_state = RAon
           else   "0000000000111100" when current_state = RARBon
           else   "0000000000111111" when current_state = RARBRCon;

    process(clk,rst)
        variable q : integer := 0;
    begin
        if rst = '1' then
            q := 0;
            inc1sec <= '0';
        elsif rising_edge(clk) then
            if q = 99999999 then --DIV 1Hz
                q := 0;
                inc1sec <= '1';
            else
                q := q + 1;
                inc1sec <= '0';
            end if;
        end if;
    end process;


    process (clk, rst)
    begin
        if rst = '1' then
            current_state <= idle;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if ;
    end process;



    process(current_state, LEFT, RIGHT, HAZ, inc1sec)
    begin
        case current_state is

            --Idle
            when idle => if LEFT = '1'  then
                    next_state <= LAon;
                elsif RIGHT = '1'  then
                    next_state <= RAon;
                elsif HAZ = '1'  then
                    next_state <= HAZARD1;
                else
                    next_state <= idle;
                end if;

            --Left Signal             
            when LAon => if LEFT = '1' and inc1sec = '1' then
                    next_state <= LALBon;
                elsif RIGHT = '1'  then
                    next_state <= RAon;
                elsif HAZ = '1'  then
                    next_state <= HAZARD1;
                elsif LEFT = '0' and RIGHT = '0' and HAZ = '0' then
                    next_state <= idle;
                else
                    next_state <= LAon;
                end if;
            when LALBon => if LEFT = '1' and inc1sec = '1' then
                    next_state <= LALBLCon;
                elsif RIGHT = '1'  then
                    next_state <= RAon;
                elsif HAZ = '1'  then
                    next_state <= HAZARD1;
                elsif LEFT = '0' and RIGHT = '0' and HAZ = '0' and inc1sec = '1' then
                    next_state <= idle;
                else
                    next_state <= LALBon;
                end if;
            when LALBLCon => if LEFT = '1' and inc1sec = '1' then
                    next_state <= idle;
                elsif RIGHT = '1'  then
                    next_state <= RAon;
                elsif HAZ = '1'  then
                    next_state <= HAZARD1;
                elsif LEFT = '0' and RIGHT = '0' and HAZ = '0'  then
                    next_state <= idle;
                else
                    next_state <= LALBLCon;
                end if;

            --Right Signal                 
            when RAon => if RIGHT = '1' and inc1sec = '1' then
                    next_state <= RARBon;
                elsif LEFT = '1'  then
                    next_state <= LAon;
                elsif HAZ = '1'  then
                    next_state <= HAZARD1;
                elsif LEFT = '0' and RIGHT = '0' and HAZ = '0' then
                    next_state <= idle;
                else
                    next_state <= RAon;
                end if;
            when RARBon => if RIGHT = '1' and inc1sec = '1' then
                    next_state <= RARBRCon;

                elsif LEFT = '1'  then
                    next_state <= LAon;

                elsif HAZ = '1' then
                    next_state <= HAZARD1;

                elsif LEFT = '0' and RIGHT = '0' and HAZ = '0' then
                    next_state <= idle;
                else
                    next_state <= RARBon;
                end if;
            when RARBRCon => if RIGHT = '1' and inc1sec = '1' then
                    next_state <= idle;

                elsif LEFT = '1' then
                    next_state <= LAon;

                elsif HAZ = '1' then
                    next_state <= HAZARD1;
                elsif LEFT = '0' and RIGHT = '0' and HAZ = '0' then
                    next_state <= idle;
                else
                    next_state <= RARBRCon;
                end if;

            --Hazard Lights                   
            when HAZARD1 => if HAZ = '1' and inc1sec = '1' then
                    next_state <= HAZARD2;
                elsif LEFT = '1' then
                    next_state <= LAon;
                elsif RIGHT = '1' then
                    next_state <= RAon;
                elsif LEFT = '0' and RIGHT = '0' and HAZ = '0'  then
                    next_state <= idle;
                else
                    next_state <= HAZARD1;
                end if;
            when HAZARD2 => if HAZ = '1' and inc1sec = '1' then
                    next_state <= HAZARD3;
                elsif LEFT = '1' then
                    next_state <= LAon;
                elsif RIGHT = '1' then
                    next_state <= RAon;
                elsif LEFT = '0' and RIGHT = '0' and HAZ = '0'  then
                    next_state <= idle;
                else
                    next_state <= HAZARD2;
                end if;
            when HAZARD3 => if HAZ = '1' and inc1sec = '1' then
                    next_state <= idle;
                elsif LEFT = '1'  then
                    next_state <= LAon;
                elsif RIGHT = '1'  then
                    next_state <= RAon;
                elsif LEFT = '0' and RIGHT = '0' and HAZ = '0' then
                    next_state <= idle;
                else
                    next_state <= HAZARD3;
                end if;
            when others => next_state <= idle;
        end case;
    end process;
end Behavioral;