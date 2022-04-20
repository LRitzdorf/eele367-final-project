library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity rw_96x8_sync is
    port (
        clock : in std_logic;
        address  : in  std_logic_vector(6 downto 0);
        write    : in  std_logic;
        data_in  : in  std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rw_96x8_sync_arch of rw_96x8_sync is

    type RW_Type is array (0 to 95) of std_logic_vector(data_in'left downto 0);
    signal RW : RW_Type;

begin

    -- TODO

end architecture;
