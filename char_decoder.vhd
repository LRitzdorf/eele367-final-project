library ieee;
    use ieee.std_logic_1164.all;

entity char_decoder is
    port (
        BIN_IN  : in std_logic_vector(3 downto 0);
        HEX_OUT : out std_logic_vector(6 downto 0)
    );
end entity;

architecture char_decoder_arch of char_decoder is
begin

    -- Update the seven-segment display
    SEVENSEG_PROC : process(BIN_IN)
    begin
        case BIN_IN is
            when "0000" => HEX_OUT <= "1000000";
            when "0001" => HEX_OUT <= "1111001";
            when "0010" => HEX_OUT <= "0100100";
            when "0011" => HEX_OUT <= "0110000";
            when "0100" => HEX_OUT <= "0011001";
            when "0101" => HEX_OUT <= "0010010";
            when "0110" => HEX_OUT <= "0000010";
            when "0111" => HEX_OUT <= "1111000";
            when "1000" => HEX_OUT <= "0000000";
            when "1001" => HEX_OUT <= "0010000";
            when "1010" => HEX_OUT <= "0001000";
            when "1011" => HEX_OUT <= "0000011";
            when "1100" => HEX_OUT <= "1000110";
            when "1101" => HEX_OUT <= "0100001";
            when "1110" => HEX_OUT <= "0000110";
            when "1111" => HEX_OUT <= "0001110";
        end case;
    end process;

end architecture;
