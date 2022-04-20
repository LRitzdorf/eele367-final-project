library ieee;
    use ieee.std_logic_1164.all;

entity control_unit is
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
end entity;

architecture control_unit_arch of control_unit is

    type StateType is (
        IDLE  -- TODO
    );
    signal State : StateType;

begin

    -- TODO

end architecture;