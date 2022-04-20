library ieee;
    use ieee.std_logic_1164.all;

entity top is
    port (
        CLK  : in  std_logic_vector(1 downto 0);
        KEY  : in  std_logic_vector(1 downto 0);
        SW   : in  std_logic_vector(9 downto 0);
        LEDR : out std_logic_vector(9 downto 0);
        HEX0 : out std_logic_vector(6 downto 0);
        HEX1 : out std_logic_vector(6 downto 0);
        HEX2 : out std_logic_vector(6 downto 0);
        HEX3 : out std_logic_vector(6 downto 0);
        HEX4 : out std_logic_vector(6 downto 0);
        HEX5 : out std_logic_vector(6 downto 0);
        GPIO : out std_logic_vector(15 downto 0)
    );
end entity;

architecture top_arch of top is

    component precision_clock_divider is
        port (
            CLKIN  : in  std_logic;
            RST    : in  std_logic;
            SEL    : in  std_logic_vector(1 downto 0);
            CLKOUT : out std_logic
        );
    end component;

    component computer is
        port (
            clock : in std_logic;
            reset : in std_logic;
            port_in_00  : in  std_logic_vector(7 downto 0);
            port_in_01  : in  std_logic_vector(7 downto 0);
            port_in_02  : in  std_logic_vector(7 downto 0);
            port_in_03  : in  std_logic_vector(7 downto 0);
            port_in_04  : in  std_logic_vector(7 downto 0);
            port_in_05  : in  std_logic_vector(7 downto 0);
            port_in_06  : in  std_logic_vector(7 downto 0);
            port_in_07  : in  std_logic_vector(7 downto 0);
            port_in_08  : in  std_logic_vector(7 downto 0);
            port_in_09  : in  std_logic_vector(7 downto 0);
            port_in_10  : in  std_logic_vector(7 downto 0);
            port_in_11  : in  std_logic_vector(7 downto 0);
            port_in_12  : in  std_logic_vector(7 downto 0);
            port_in_13  : in  std_logic_vector(7 downto 0);
            port_in_14  : in  std_logic_vector(7 downto 0);
            port_in_15  : in  std_logic_vector(7 downto 0);
            port_out_00 : out std_logic_vector(7 downto 0);
            port_out_01 : out std_logic_vector(7 downto 0);
            port_out_02 : out std_logic_vector(7 downto 0);
            port_out_03 : out std_logic_vector(7 downto 0);
            port_out_04 : out std_logic_vector(7 downto 0);
            port_out_05 : out std_logic_vector(7 downto 0);
            port_out_06 : out std_logic_vector(7 downto 0);
            port_out_07 : out std_logic_vector(7 downto 0);
            port_out_08 : out std_logic_vector(7 downto 0);
            port_out_09 : out std_logic_vector(7 downto 0);
            port_out_10 : out std_logic_vector(7 downto 0);
            port_out_11 : out std_logic_vector(7 downto 0);
            port_out_12 : out std_logic_vector(7 downto 0);
            port_out_13 : out std_logic_vector(7 downto 0);
            port_out_14 : out std_logic_vector(7 downto 0);
            port_out_15 : out std_logic_vector(7 downto 0)
        );
    end component;

    component char_decoder is
        port (
            BIN_IN  : in std_logic_vector(3 downto 0);
            HEX_OUT : out std_logic_vector(6 downto 0)
        );
    end component;

    signal clock_div   : std_logic;
    signal reset       : std_logic;
    signal port_out_01,
           port_out_02,
           port_out_03 : std_logic_vector(7 downto 0);

begin

    uClockDivider : precision_clock_divider port map (
        CLKIN  => CLK(0),
        RST    => reset,
        SEL    => SW(9 downto 8),
        CLKOUT => clock_div
    );

    uComputer : computer port map (
        clock => clock_div,
        reset => reset,
        port_in_00  => SW(7 downto 0),
        port_in_01  => "000000" & KEY(1 downto 0),
        port_in_02  => "00000000",
        port_in_03  => "00000000",
        port_in_04  => "00000000",
        port_in_05  => "00000000",
        port_in_06  => "00000000",
        port_in_07  => "00000000",
        port_in_08  => "00000000",
        port_in_09  => "00000000",
        port_in_10  => "00000000",
        port_in_11  => "00000000",
        port_in_12  => "00000000",
        port_in_13  => "00000000",
        port_in_14  => "00000000",
        port_in_15  => "00000000",
        port_out_00 => LEDR(7 downto 0),
        port_out_01 => port_out_01,
        port_out_02 => port_out_02,
        port_out_03 => port_out_03,
        port_out_04 => GPIO( 7 downto 0),
        port_out_05 => GPIO(15 downto 8),
        port_out_06 => open,
        port_out_07 => open,
        port_out_08 => open,
        port_out_09 => open,
        port_out_10 => open,
        port_out_11 => open,
        port_out_12 => open,
        port_out_13 => open,
        port_out_14 => open,
        port_out_15 => open
    );

    -- Seven-segment decoders
    uHex0 : char_decoder port map (BIN_IN => port_out_01(3 downto 0), HEX_OUT => HEX0);
    uHex1 : char_decoder port map (BIN_IN => port_out_01(7 downto 4), HEX_OUT => HEX1);
    uHex2 : char_decoder port map (BIN_IN => port_out_02(3 downto 0), HEX_OUT => HEX2);
    uHex3 : char_decoder port map (BIN_IN => port_out_02(7 downto 4), HEX_OUT => HEX3);
    uHex4 : char_decoder port map (BIN_IN => port_out_03(3 downto 0), HEX_OUT => HEX4);
    uHex5 : char_decoder port map (BIN_IN => port_out_03(7 downto 4), HEX_OUT => HEX5);

    -- Active-low reset
    reset <= KEY(0) or KEY(1);  -- Triggers when both keys are pressed
    --reset <= '1';               -- Never triggers

    -- Clock display, for reference
    LEDR(8) <= clock_div;

end architecture;