library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity rom_128x8_sync is
    port (
        clock : in std_logic;
        address  : in  std_logic_vector(6 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rom_128x8_sync_arch of rom_128x8_sync is

    type ROM_Type is array (0 to 127) of std_logic_vector(data_out'left downto 0);

    -- NOTE: Program goes in here!
    constant ROM : ROM_Type := (
        16#00# => x"87",
        16#01# => x"F0",

        16#02# => x"96",
        16#03# => x"E0",
        16#04# => x"96",
        16#05# => x"E1",
        16#06# => x"96",
        16#07# => x"E2",
        16#08# => x"96",
        16#09# => x"E3",

        16#0A# => x"20",
        16#0B# => x"00",
        others => x"FF"
    );

begin

    ROM_PROC : process(clock)
    begin
        if rising_edge(clock) then
            data_out <= ROM(to_integer(unsigned(address)));
        end if;
    end process;

end architecture;
