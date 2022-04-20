library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity alu is
    generic (width : integer);
    port (
        In1    : in  std_logic_vector(width-1 downto 0);
        In2    : in  std_logic_vector(width-1 downto 0);
        Sel    : in  std_logic_vector(2 downto 0);
        Result : out std_logic_vector(width-1 downto 0);
        NZVC   : out std_logic_vector(3 downto 0)
    );
end entity;

architecture alu_arch of alu is

    signal full_result : std_logic_vector(width downto 0);

begin

    -- TODO

end architecture;
