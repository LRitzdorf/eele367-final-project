library ieee;
    use ieee.std_logic_1164.all;

package opcodes is
    -- Opcodes
    constant LDA_IMM : std_logic_vector;
    constant LDA_DIR : std_logic_vector;
    constant LDB_IMM : std_logic_vector;
    constant LDB_DIR : std_logic_vector;
    constant STA_DIR : std_logic_vector;
    constant STB_DIR : std_logic_vector;
    constant ADD_AB  : std_logic_vector;
    constant SUB_AB  : std_logic_vector;
    constant AND_AB  : std_logic_vector;
    constant OR_AB   : std_logic_vector;
    constant INCA    : std_logic_vector;
    constant INCB    : std_logic_vector;
    constant DECA    : std_logic_vector;
    constant DECB    : std_logic_vector;
    constant BRA     : std_logic_vector;
    constant BMI     : std_logic_vector;
    constant BPL     : std_logic_vector;
    constant BEQ     : std_logic_vector;
    constant BNE     : std_logic_vector;
    constant BVS     : std_logic_vector;
    constant BVC     : std_logic_vector;
    constant BCS     : std_logic_vector;
    constant BCC     : std_logic_vector;
    constant NOP     : std_logic_vector;
    constant HALT    : std_logic_vector;
end package;

package body opcodes is
    -- Opcode values
    constant LDA_IMM : std_logic_vector := x"86";
    constant LDA_DIR : std_logic_vector := x"87";
    constant LDB_IMM : std_logic_vector := x"88";
    constant LDB_DIR : std_logic_vector := x"89";
    constant STA_DIR : std_logic_vector := x"96";
    constant STB_DIR : std_logic_vector := x"97";
    constant ADD_AB  : std_logic_vector := x"42";
    constant SUB_AB  : std_logic_vector := x"43";
    constant AND_AB  : std_logic_vector := x"44";
    constant OR_AB   : std_logic_vector := x"45";
    constant INCA    : std_logic_vector := x"46";
    constant INCB    : std_logic_vector := x"47";
    constant DECA    : std_logic_vector := x"48";
    constant DECB    : std_logic_vector := x"49";
    constant BRA     : std_logic_vector := x"20";
    constant BMI     : std_logic_vector := x"21";
    constant BPL     : std_logic_vector := x"22";
    constant BEQ     : std_logic_vector := x"23";
    constant BNE     : std_logic_vector := x"24";
    constant BVS     : std_logic_vector := x"25";
    constant BVC     : std_logic_vector := x"26";
    constant BCS     : std_logic_vector := x"27";
    constant BCC     : std_logic_vector := x"28";
    constant NOP     : std_logic_vector := x"00";
    constant HALT    : std_logic_vector := x"FF";
end package body;
