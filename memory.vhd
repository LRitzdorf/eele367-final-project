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
        address  : out std_logic_vector(7 downto 0);
        write    : out std_logic;
        data_in  : out std_logic_vector(width-1 downto 0);
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

    signal offset_address                  : std_logic_vector(address'length-1 downto 0);
    signal rom_data, rw_data, port_in_data : std_logic_vector(7 downto 0);
    signal write_enable                    : std_logic_vector(1 downto 0);

begin

    -- TODO: Memory map control process

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

    -- TODO: Two muxers for IO ports
    --   Output port writing depends on write_enable(1)
    --   Input ports always read from given address
    --     Must assign to "port_in_data"

end architecture;
