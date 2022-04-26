library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library work;
    use work.opcodes.all;

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
    --       Opcode constants are loaded from the "work.opcodes" package.
    constant ROM : ROM_Type := (
        16#00# => LDB_IMM,
        16#01# => x"03",

        16#02# => LDA_DIR,
        16#03# => x"F0",
        16#04# => ADD_AB,

        16#05# => BEQ,
        16#06# => x"02",

        16#07# => STA_DIR,
        16#08# => x"E0",
        16#09# => STA_DIR,
        16#0A# => x"E1",
        16#0B# => STA_DIR,
        16#0C# => x"E2",
        16#0D# => STA_DIR,
        16#0E# => x"E3",

        16#0F# => BRA,
        16#10# => x"02",
        others => HALT
    );

begin

    ROM_PROC : process(clock)
    begin
        if rising_edge(clock) then
            data_out <= ROM(to_integer(unsigned(address)));
        end if;
    end process;

end architecture;
