library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity memory is
    generic (width : integer);
    -- WARNING: Designed for use with 8-bit systems. Data input bus width will
    -- be based on the "width" parameter, but extra bits on the left side will
    -- be dropped (that is, the input will be truncated, preserving less
    -- significant bits) for storage into memory. The same truncation will occur
    -- for external input ports when their data is routed to the memory output.
    port (
        clock : in std_logic;
        reset : in std_logic;
        address  : in  std_logic_vector(7 downto 0);
        write    : in  std_logic;
        data_in  : in  std_logic_vector(width-1 downto 0);
        data_out : out std_logic_vector(7 downto 0);
        port_in_00  : in  std_logic_vector(width-1 downto 0);
        port_in_01  : in  std_logic_vector(width-1 downto 0);
        port_in_02  : in  std_logic_vector(width-1 downto 0);
        port_in_03  : in  std_logic_vector(width-1 downto 0);
        port_in_04  : in  std_logic_vector(width-1 downto 0);
        port_in_05  : in  std_logic_vector(width-1 downto 0);
        port_in_06  : in  std_logic_vector(width-1 downto 0);
        port_in_07  : in  std_logic_vector(width-1 downto 0);
        port_in_08  : in  std_logic_vector(width-1 downto 0);
        port_in_09  : in  std_logic_vector(width-1 downto 0);
        port_in_10  : in  std_logic_vector(width-1 downto 0);
        port_in_11  : in  std_logic_vector(width-1 downto 0);
        port_in_12  : in  std_logic_vector(width-1 downto 0);
        port_in_13  : in  std_logic_vector(width-1 downto 0);
        port_in_14  : in  std_logic_vector(width-1 downto 0);
        port_in_15  : in  std_logic_vector(width-1 downto 0);
        port_out_00 : out std_logic_vector(width-1 downto 0);
        port_out_01 : out std_logic_vector(width-1 downto 0);
        port_out_02 : out std_logic_vector(width-1 downto 0);
        port_out_03 : out std_logic_vector(width-1 downto 0);
        port_out_04 : out std_logic_vector(width-1 downto 0);
        port_out_05 : out std_logic_vector(width-1 downto 0);
        port_out_06 : out std_logic_vector(width-1 downto 0);
        port_out_07 : out std_logic_vector(width-1 downto 0);
        port_out_08 : out std_logic_vector(width-1 downto 0);
        port_out_09 : out std_logic_vector(width-1 downto 0);
        port_out_10 : out std_logic_vector(width-1 downto 0);
        port_out_11 : out std_logic_vector(width-1 downto 0);
        port_out_12 : out std_logic_vector(width-1 downto 0);
        port_out_13 : out std_logic_vector(width-1 downto 0);
        port_out_14 : out std_logic_vector(width-1 downto 0);
        port_out_15 : out std_logic_vector(width-1 downto 0)
    );
end entity;

architecture memory_arch of memory is

    component rom_128x8_sync is
        port (
            clock : in std_logic;
            address  : in  std_logic_vector(6 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;

    component rw_96x8_sync is
        port (
            clock : in std_logic;
            address  : in  std_logic_vector(6 downto 0);
            write    : in  std_logic;
            data_in  : in  std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;

    -- NOTE: Memory map ordering is: ROM, RW, output ports, input ports
    constant RW_START       : unsigned := x"80";
    constant PORT_OUT_START : unsigned := x"E0";
    constant PORT_IN_START  : unsigned := x"F0";

    signal offset_address                  : std_logic_vector(address'length-1 downto 0);
    signal rom_data, rw_data, port_in_data : std_logic_vector(7 downto 0);
    signal write_enable                    : std_logic_vector(1 downto 0);

begin

    -- Address translation and memory map control
    offset_address <= address                                              when unsigned(address) < RW_START else
                      std_logic_vector(unsigned(address) - RW_START)       when unsigned(address) < PORT_OUT_START else
                      std_logic_vector(unsigned(address) - PORT_OUT_START) when unsigned(address) < PORT_IN_START else
                      std_logic_vector(unsigned(address) - PORT_IN_START);
    data_out       <= rom_data                                          when unsigned(address) < RW_START else
                      rw_data                                           when unsigned(address) < PORT_OUT_START else
                      std_logic_vector(to_unsigned(0, data_out'length)) when unsigned(address) < PORT_IN_START else
                      port_in_data;
    write_enable   <= "00" when unsigned(address) < RW_START else
                      "01" when unsigned(address) < PORT_OUT_START else
                      "10" when unsigned(address) < PORT_IN_START else
                      "00";

    -- ROM and RW instantiation
    uROM : rom_128x8_sync
        port map (
            clock => clock,
            address => offset_address(6 downto 0),
            data_out => rom_data
        );
    uRW : rw_96x8_sync
        port map (
            clock => clock,
            address => offset_address(6 downto 0),
            write => write_enable(0) and write,
            data_in => data_in,
            data_out => rw_data
        );

    -- Output ports
    OUTPUT_PORT_PROC : process(clock)
    begin
        if rising_edge(clock) then
            if write_enable(1) = '1' and write = '1' then
                case offset_address is
                    when x"00" => port_out_00 <= data_in;
                    when x"01" => port_out_01 <= data_in;
                    when x"02" => port_out_02 <= data_in;
                    when x"03" => port_out_03 <= data_in;
                    when x"04" => port_out_04 <= data_in;
                    when x"05" => port_out_05 <= data_in;
                    when x"06" => port_out_06 <= data_in;
                    when x"07" => port_out_07 <= data_in;
                    when x"08" => port_out_08 <= data_in;
                    when x"09" => port_out_09 <= data_in;
                    when x"0A" => port_out_10 <= data_in;
                    when x"0B" => port_out_11 <= data_in;
                    when x"0C" => port_out_12 <= data_in;
                    when x"0D" => port_out_13 <= data_in;
                    when x"0E" => port_out_14 <= data_in;
                    when x"0F" => port_out_15 <= data_in;
                    when others => null;
                end case;
            end if;
        end if;
    end process;

    -- Input ports
    INPUT_PORT_PROC : process(clock)
    begin
        if rising_edge(clock) then
            case offset_address is
                when x"00" => port_in_data <= port_in_00;
                when x"01" => port_in_data <= port_in_01;
                when x"02" => port_in_data <= port_in_02;
                when x"03" => port_in_data <= port_in_03;
                when x"04" => port_in_data <= port_in_04;
                when x"05" => port_in_data <= port_in_05;
                when x"06" => port_in_data <= port_in_06;
                when x"07" => port_in_data <= port_in_07;
                when x"08" => port_in_data <= port_in_08;
                when x"09" => port_in_data <= port_in_09;
                when x"0A" => port_in_data <= port_in_10;
                when x"0B" => port_in_data <= port_in_11;
                when x"0C" => port_in_data <= port_in_12;
                when x"0D" => port_in_data <= port_in_13;
                when x"0E" => port_in_data <= port_in_14;
                when x"0F" => port_in_data <= port_in_15;
                when others => null;
            end case;
        end if;
    end process;

end architecture;
