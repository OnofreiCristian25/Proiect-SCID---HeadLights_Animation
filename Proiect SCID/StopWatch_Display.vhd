library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity StopWatch_Display is
    Port ( button : in STD_LOGIC;
           button2: in STD_LOGIC;
           rst : in STD_LOGIC;
           clock : in STD_LOGIC;
           clock_segment : in STD_LOGIC;
           clock_centi : in STD_LOGIC;
           anode : out STD_LOGIC_VECTOR (3 downto 0);
           cathode : out STD_LOGIC_VECTOR (7 downto 0));
end StopWatch_Display;

architecture Behavioral of StopWatch_Display is

--Setare temporizaor
signal tempy: integer:=9; --xx.x9 secunde
signal tempx: integer:=9; --xx.9x secunde
signal tempb: integer:=9; --x9.xx secunde
signal tempa: integer:=9; --9x.xx secunde

signal a, b, x, y : integer:=0;
signal current_state, next_state : STD_LOGIC_VECTOR (1 downto 0):="00";
signal ss1, ss2, en : STD_LOGIC:='0';

begin

process(clock)
begin
    if (rising_edge(clock)) then
        current_state <= next_state;
    end if;
end process;

process (button, button2, rst, clock_centi, current_state, next_state, ss1, ss2)
begin
if rst = '1' then --resetare. 7seg arata 0
    a <= 0;
    b <= 0;
    x <= 0;
    y <= 0;
else
    if button2 = '0' then  --cronometru
        if (rising_edge(clock_centi)) then
            if button = '1' then
                ss1 <= '1';
            elsif button = '0' then
                ss1 <= '0';
            end if;
            ss2 <= ss1;
            if ss2 = '0' and ss1 = '1' then
                en <= not en;
            end if;
            case (current_state) is
            when "11" =>
            if en = '1' then
                next_state <= "11";
                y <= y + 1;
                if y = 9 then --0.09 sec
                    x <= x + 1;
                    y <= 0;
                    if x = 9 then --0.9 sec
                        b <= b + 1;
                        x <= 0;
                        if b = 9 then --9 sec
                            a <= a + 1;
                            b <= 0;
                            if a = 9 then --se reseteaza cand ajunge la 99.99
                                a <= 0;
                                b <= 0;
                                x <= 0;
                                y <= 0;
                            end if;
                        end if;
                    end if;
                end if;
            elsif en = '0' then
                next_state <= "00";
            end if;
            when "00" =>
                if en = '0' then
                    next_state <= "00";
                    a <= a;
                    b <= b;
                    x <= x;
                    y <= y;
                elsif en = '1' then
                    next_state <= "11";
                end if;
            when others =>
                next_state <= "00";
                a <= 0;
                b <= 0;
                x <= 0;
                y <= 0;
            end case;
        end if;
    else --temporizator
        a <= tempa;
        b <= tempb;
        x <= tempx;
        y <= tempy;
        if button = '1' then
                ss1 <= '1';
            elsif button = '0' then
                ss1 <= '0';
        end if;
        ss2 <= ss1;
        if ss2 = '0' and ss1 = '1' then
            en <= not en;
        end if;
        case (current_state) is
        when "11" =>
        if en = '1' then
            next_state <= "11";
            y <= y - 1;
            if y = 0 then --(de la .09 -> la 0.00 secunde)
                x <= x - 1;
                y <= 9;
                if x = 0 then --(.9 -> .0 secunde)
                    b <= b - 1;
                    x <= 9;
                    if b = 0 then --(9 -> 0 secunde)
                        a <= a - 1;
                        b <= 9;
                        if a = 0 then --se reseteaza la valorile stabilite cand ajunge la 00.00
                            a <= tempa;
                            b <= tempb;
                            x <= tempx;
                            y <= tempy;
                        end if;
                    end if;
                end if;
            end if;
            elsif en = '0' then
                next_state <= "00";
            end if;
            when "00" =>
                if en = '0' then
                    next_state <= "00";
                    a <= a;
                    b <= b;
                    x <= x;
                    y <= y;
                elsif en = '1' then
                    next_state <= "11";
                end if;
            when others =>
                next_state <= "00";
                a <= tempa;
                b <= tempb;
                x <= tempx;
                y <= tempy;
            end case;
        end if;
    end if;
--end if;
end process;

process (clock_segment)
variable seg1, seg2 : unsigned (1 downto 0):="00";
begin
    if (rising_edge(clock_segment)) then
        case (seg1) is
            when "00" => anode <= "0111";
            when "01" => anode <= "1011";
            when "10" => anode <= "1101";
            when "11" => anode <= "1110";
            when others => anode <= "1111";
        end case;
        case (seg2) is
            when "00" => case (a) is
                when 0 => cathode <= "00000011";
                when 1 => cathode <= "10011111";
                when 2 => cathode <= "00100101";
                when 3 => cathode <= "00001101";
                when 4 => cathode <= "10011001";
                when 5 => cathode <= "01001001";
                when 6 => cathode <= "01000001";
                when 7 => cathode <= "00011111";
                when 8 => cathode <= "00000001";
                when 9 => cathode <= "00011001";
                when others => cathode <= "11111111";
            end case;
            when "01" => case (b) is
                when 0 => cathode <= "00000010";
                when 1 => cathode <= "10011110";
                when 2 => cathode <= "00100100";
                when 3 => cathode <= "00001100";
                when 4 => cathode <= "10011000";
                when 5 => cathode <= "01001000";
                when 6 => cathode <= "01000000";
                when 7 => cathode <= "00011110";
                when 8 => cathode <= "00000000";
                when 9 => cathode <= "00011000";
                when others => cathode <= "11111110";
            end case;
            when "10" =>case (x) is
                when 0 => cathode <= "00000011";
                when 1 => cathode <= "10011111";
                when 2 => cathode <= "00100101";
                when 3 => cathode <= "00001101";
                when 4 => cathode <= "10011001";
                when 5 => cathode <= "01001001";
                when 6 => cathode <= "01000001";
                when 7 => cathode <= "00011111";
                when 8 => cathode <= "00000001";
                when 9 => cathode <= "00011001";
                when others => cathode <= "11111111";
            end case;
            when "11" =>case (y) is
                when 0 => cathode <= "00000011";
                when 1 => cathode <= "10011111";
                when 2 => cathode <= "00100101";
                when 3 => cathode <= "00001101";
                when 4 => cathode <= "10011001";
                when 5 => cathode <= "01001001";
                when 6 => cathode <= "01000001";
                when 7 => cathode <= "00011111";
                when 8 => cathode <= "00000001";
                when 9 => cathode <= "00011001";
                when others => cathode <= "11111111";
            end case;
            when others => 
                    anode <= "0000";
                    cathode <= "11111111";
        end case;
        seg1 := seg1 + 1;
        seg2 := seg2 + 1;
    end if;
end process;
end Behavioral;