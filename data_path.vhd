library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity data_path is
    generic (width : integer);
    port (
        clock : in std_logic;
        reset : in std_logic;
        address     : out std_logic_vector(width-1 downto 0);
        from_memory : in  std_logic_vector(width-1 downto 0);
        to_memory   : out std_logic_vector(width-1 downto 0);
        PC_Load    : in  std_logic;
        PC_Inc     : in  std_logic;
        PC         : out std_logic_vector(width-1 downto 0);
        IR_Load    : in  std_logic;
        IR         : out std_logic_vector(width-1 downto 0);
        MAR_Load   : in  std_logic;
        A_Load     : in  std_logic;
        B_Load     : in  std_logic;
        ALU_Sel    : in  std_logic_vector(2 downto 0);
        CCR_Load   : in  std_logic;
        CCR        : out std_logic_vector(3 downto 0);
        Bus1_Sel   : in  std_logic_vector(1 downto 0);
        Bus2_Sel   : in  std_logic_vector(1 downto 0)
    );
end entity;

architecture data_path_arch of data_path is

    component alu is
        generic (width : integer);
        port (
            In1    : in  std_logic_vector(width-1 downto 0);
            In2    : in  std_logic_vector(width-1 downto 0);
            Sel    : in  std_logic_vector(2 downto 0);
            Result : out std_logic_vector(width-1 downto 0);
            NZVC   : out std_logic_vector(3 downto 0)
        );
    end component;

    signal MAR, A, B  : std_logic_vector(width-1 downto 0);
    signal ALU_Result : std_logic_vector(width-1 downto 0);
    signal ALU_NZVC   : std_logic_vector(3 downto 0);
    signal Bus1, Bus2 : std_logic_vector(width-1 downto 0);

    constant PROGRAM_START : std_logic_vector(width-1 downto 0) := std_logic_vector(to_unsigned(0, width));

begin

    -- TODO

    -- Arithmetic/Logic Unit
    uALU : alu
        generic map (width => width)
        port map (
            In1 => B, In2 => Bus1,
            Sel => ALU_Sel,
            Result => ALU_Result, NZVC => ALU_NZVC
        );

    -- Static wiring
    address   <= MAR;
    to_memory <= Bus1;

end architecture;
