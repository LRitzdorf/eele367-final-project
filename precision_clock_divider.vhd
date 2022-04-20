library ieee;
    use ieee.std_logic_1164.all;

entity precision_clock_divider is
    port (
        CLKIN  : in  std_logic;
        RST    : in  std_logic;
        SEL    : in  std_logic_vector(1 downto 0);
        CLKOUT : out std_logic
    );
end entity;

architecture precision_clock_divider_arch of precision_clock_divider is

    signal ClockOut : std_logic;
    signal Counter, Limit : integer;

begin

    -- Wire the ClockOut signal to the actual output clock
    CLKOUT <= ClockOut;

    -- Define limits (in base clock cycles) for each selectable frequency
    SELECT_PROC : process(SEL)
    begin
        if    SEL = "00" then Limit <= 25000000;  -- 1 Hz
        elsif SEL = "01" then Limit <= 2500000;   -- 10 Hz
        elsif SEL = "10" then Limit <= 250000;    -- 100 Hz
        elsif SEL = "11" then Limit <= 25000;     -- 1000 Hz
        end if;
    end process;

    -- Control the output clock, based on the selected counter limit
    CLOCK_PROC : process(CLKIN, RST)
    begin
        if RST = '0' then
            Counter <= 0;
            ClockOut <= '0';
        elsif rising_edge(CLKIN) then
            if Counter >= Limit then
                Counter <= 0;
                ClockOut <= not ClockOut;
            else
                Counter <= Counter + 1;
            end if;
        end if;
    end process;

end architecture;
