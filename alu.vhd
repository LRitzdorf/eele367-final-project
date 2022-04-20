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

    ALU_PROC : process(In1, In2, Sel)
    begin
        -- TODO: Implement everything
        -- FIXME
        Result <= std_logic_vector(to_unsigned(0, Result'length));
        NZVC   <= std_logic_vector(to_unsigned(0, NZVC'length));
    end process;

end architecture;
