library ieee;
    use ieee.std_logic_1164.all;

entity cpu is
    generic (width : integer);
    port (
        clock : in std_logic;
        reset : in std_logic;
        address     : out std_logic_vector(width-1 downto 0);
        write       : out std_logic;
        to_memory   : out std_logic_vector(width-1 downto 0);
        from_memory : out std_logic_vector(width-1 downto 0)
    );
end entity;

architecture cpu_arch of cpu is

    component control_unit is
        generic (width : integer);
        port (
            clock : in std_logic;
            reset : in std_logic;
            write : out std_logic;
            PC_Load    : out std_logic;
            PC_Inc     : in  std_logic;
            PC         : in  std_logic_vector(width-1 downto 0);
            IR_Load    : out std_logic;
            IR         : in  std_logic_vector(width-1 downto 0);
            MAR_Load   : out std_logic;
            A_Load     : out std_logic;
            B_Load     : out std_logic;
            ALU_Sel    : out std_logic_vector(2 downto 0);
            CCR_Load   : out std_logic;
            CCR        : in  std_logic_vector(3 downto 0);
            Bus1_Sel   : out std_logic_vector(1 downto 0);
            Bus2_Sel   : out std_logic_vector(1 downto 0)
        );
    end component;

    component data_path is
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
    end component;

    signal PC_Load, PC_Inc,
           IR_Load, MAR_Load,
           A_Load, B_Load,
           CCR_Load           : std_logic;
    signal PC, IR             : std_logic_vector(width-1 downto 0);
    signal ALU_Sel            : std_logic_vector(2 downto 0);
    signal CCR                : std_logic_vector(3 downto 0);
    signal Bus1_Sel, Bus2_Sel : std_logic_vector(1 downto 0);

begin

    uControlUnit : control_unit
        generic map (width => width)
        port map (
            clock => clock, reset => reset,
            write => write,
            PC_Load => PC_Load, PC_Inc => PC_Inc, PC => PC,
            IR_Load => IR_Load, IR => IR,
            MAR_Load => MAR_Load,
            A_Load => A_Load, B_Load => B_Load,
            ALU_Sel => ALU_Sel,
            CCR_Load => CCR_Load, CCR => CCR,
            Bus1_Sel => Bus1_Sel, Bus2_Sel => Bus2_Sel
        );

    uDataPath : data_path
        generic map (width => width)
        port map (
            clock => clock, reset => reset,
            address => address,
            from_memory => from_memory,
            to_memory => to_memory,
            PC_Load => PC_Load, PC_Inc => PC_Inc, PC => PC,
            IR_Load => IR_Load, IR => IR,
            MAR_Load => MAR_Load,
            A_Load => A_Load, B_Load => B_Load,
            ALU_Sel => ALU_Sel,
            CCR_Load => CCR_Load, CCR => CCR,
            Bus1_Sel => Bus1_Sel, Bus2_Sel => Bus2_Sel
        );

    -- TODO

end architecture;