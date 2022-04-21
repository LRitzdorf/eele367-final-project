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

    signal intermediate : std_logic_vector(width downto 0);

begin

    with Sel select
        intermediate <=
            -- Addition
            std_logic_vector(unsigned('0' & In1) + unsigned('0' & In2))          when "000",
            -- Subtraction
            std_logic_vector(unsigned('0' & In1) - unsigned('0' & In2))          when "001",
            -- Logic AND
            '0' & (In1 and In2)                                                  when "010",
            -- Logic OR
            '0' & (In1 or In2)                                                   when "011",
            -- Increment
            std_logic_vector(unsigned('0' & In1) + to_unsigned(1, In1'length+1)) when "100",
            -- Decrement
            std_logic_vector(unsigned('0' & In1) - to_unsigned(1, In1'length+1)) when "101",
            -- Other (invalid) operation: return zero
            std_logic_vector(to_unsigned(0, intermediate'length))                when others;

    -- Result generation from intermediate value
    Result  <= intermediate(intermediate'high-1 downto 0);
    NZVC(3) <= Result(Result'high);
    NZVC(2) <= '1' when to_integer(unsigned(Result)) = 0 else '0';
    NZVC(1) <= '1' when In1(In1'high) = In2(In2'high) and In1(In1'high) /= Result(Result'high) else '0';
    NZVC(0) <= intermediate(intermediate'high);

end architecture;
