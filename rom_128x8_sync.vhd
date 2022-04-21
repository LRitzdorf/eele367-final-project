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

    -- Opcode values
    -- TODO: Use a package for this?
    constant LDA_IMM : std_logic_vector := x"86";
    constant LDA_DIR : std_logic_vector := x"87";
    constant LDB_IMM : std_logic_vector := x"88";
    constant LDB_DIR : std_logic_vector := x"89";
    constant STA_DIR : std_logic_vector := x"96";
    constant STB_DIR : std_logic_vector := x"97";
    constant ADD_AB  : std_logic_vector := x"42";
    constant SUB_AB  : std_logic_vector := x"43";
    constant AND_AB  : std_logic_vector := x"44";
    constant OR_AB   : std_logic_vector := x"45";
    constant INCA    : std_logic_vector := x"46";
    constant INCB    : std_logic_vector := x"47";
    constant DECA    : std_logic_vector := x"48";
    constant DECB    : std_logic_vector := x"49";
    constant BRA     : std_logic_vector := x"20";
    -- TODO: Add opcode values above this line
    constant NOP     : std_logic_vector := x"00";
    constant HALT    : std_logic_vector := x"FF";

    type ROM_Type is array (0 to 127) of std_logic_vector(data_out'left downto 0);

    -- NOTE: Program goes in here!
    constant ROM : ROM_Type := (
        16#00# => LDB_IMM,
        16#01# => x"03",

        16#02# => LDA_DIR,
        16#03# => x"F0",
        16#04# => ADD_AB,

        16#05# => STA_DIR,
        16#06# => x"E0",
        16#07# => STA_DIR,
        16#08# => x"E1",
        16#09# => STA_DIR,
        16#0A# => x"E2",
        16#0B# => STA_DIR,
        16#0C# => x"E3",

        16#0D# => BRA,
        16#0E# => x"02",
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
