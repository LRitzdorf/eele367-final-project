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
        0  => x"00",
        others => x"00"
    );

begin

    -- TODO

end architecture;
