library ieee;
    use ieee.std_logic_1164.all;

entity control_unit is
    generic (width : integer);
    port (
        clock : in std_logic;
        reset : in std_logic;
        write : out std_logic;
        PC_Load    : out std_logic;
        PC_Inc     : out std_logic;
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

    -- FSM state type
    type State_Type is (
        FETCH_0, FETCH_1, FETCH_2,
        DECODE_3,
        LDA_IMM_4, LDA_IMM_5, LDA_IMM_6,
        LDA_DIR_4, LDA_DIR_5, LDA_DIR_6, LDA_DIR_7, LDA_DIR_8,
        STA_DIR_4, STA_DIR_5, STA_DIR_6, STA_DIR_7,
        BRA_4, BRA_5, BRA_6,
        -- TODO
        HALT_99
    );
    signal CurrentState, NextState : State_Type;

begin

    -- Control FSM

    STATE_MEMORY_PROC : process(clock, reset)
    begin
        if reset = '0' then
            CurrentState <= FETCH_0;
        elsif rising_edge(clock) then
            CurrentState <= NextState;
        end if;
    end process;

    NEXT_STATE_PROC : process(CurrentState)
        -- Opcode values
        constant LDA_IMM : std_logic_vector := x"86";
        constant LDA_DIR : std_logic_vector := x"87";
        constant STA_DIR : std_logic_vector := x"96";
        constant BRA     : std_logic_vector := x"20";
        -- TODO: Add opcode values above this line
        constant NOP     : std_logic_vector := x"00";
        constant HALT    : std_logic_vector := x"FF";
    begin
        case CurrentState is

            when FETCH_0 => NextState <= FETCH_1;
            when FETCH_1 => NextState <= FETCH_2;
            when FETCH_2 => NextState <= DECODE_3;
            when DECODE_3 =>
                case IR is
                    when LDA_IMM => NextState <= LDA_IMM_4;
                    when LDA_DIR => NextState <= LDA_DIR_4;
                    when STA_DIR => NextState <= STA_DIR_4;
                    when BRA     => NextState <= BRA_4;
                    -- TODO: Further instruction branching goes here
                    -- A no-op restarts the fetch cycle
                    when NOP    => NextState <= FETCH_0;
                    -- Handle HALT and invalid opcodes by halting
                    when HALT   => NextState <= HAlT_99;
                    when others => NextState <= HALT_99;
                end case;

            -- Load A Immediate
            when LDA_IMM_4 => NextState <= LDA_IMM_5;
            when LDA_IMM_5 => NextState <= LDA_IMM_6;
            -- Load A Direct
            when LDA_DIR_4 => NextState <= LDA_DIR_5;
            when LDA_DIR_5 => NextState <= LDA_DIR_6;
            when LDA_DIR_6 => NextState <= LDA_DIR_7;
            when LDA_DIR_7 => NextState <= LDA_DIR_8;
            -- Store A Direct
            when STA_DIR_4 => NextState <= STA_DIR_5;
            when STA_DIR_5 => NextState <= STA_DIR_6;
            when STA_DIR_6 => NextState <= STA_DIR_7;
            -- Branch Always
            when BRA_4 => NextState <= BRA_5;
            when BRA_5 => NextState <= BRA_6;
            -- TODO: Further FSM flow control goes here

            -- HALT state remains in HALT until a reset
            when HALT_99 => NextState <= HALT_99;
            -- Assume other states are at the end of their respective branches,
            -- and restart the fetch cycle
            when others => NextState <= FETCH_0;
        end case;
    end process;

    OUTPUT_SIGNAL_PROC : process(CurrentState)
    begin
        case CurrentState is

            when FETCH_0 =>
            -- Store PC to MAR
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '1';
                A_Load   <= '0';
                B_Load   <= '0';
                ALU_Sel  <= "000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                write    <= '0';
            when FETCH_1 =>
            -- Increment PC while waiting for memory
                PC_Load  <= '0';
                PC_Inc   <= '1';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '0';
                B_Load   <= '0';
                ALU_Sel  <= "000";
                CCR_Load <= '0';
                Bus1_Sel <= "11";
                Bus2_Sel <= "11";
                write    <= '0';
            when FETCH_2 =>
            -- Load IR from memory
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '1';
                MAR_Load <= '0';
                A_Load   <= '0';
                B_Load   <= '0';
                ALU_Sel  <= "000";
                CCR_Load <= '0';
                Bus1_Sel <= "11";
                Bus2_Sel <= "10";
                write    <= '0';
            --   DECODE_3 -> others  Wait for registers

            when LDA_IMM_4 =>
            -- Store PC to MAR
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '1';
                A_Load   <= '0';
                B_Load   <= '0';
                ALU_Sel  <= "000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                write    <= '0';
            when LDA_IMM_5 =>
            -- Increment PC while waiting for memory
                PC_Load  <= '0';
                PC_Inc   <= '1';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '0';
                B_Load   <= '0';
                ALU_Sel  <= "000";
                CCR_Load <= '0';
                Bus1_Sel <= "11";
                Bus2_Sel <= "11";
                write    <= '0';
            when LDA_IMM_6 =>
            -- Load A from memory
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '1';
                B_Load   <= '0';
                ALU_Sel  <= "000";
                CCR_Load <= '0';
                Bus1_Sel <= "11";
                Bus2_Sel <= "10";
                write    <= '0';

            when LDA_DIR_4 =>
            -- Store PC to MAR
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '1';
                A_Load   <= '0';
                B_Load   <= '0';
                ALU_Sel  <= "000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                write    <= '0';
            when LDA_DIR_5 =>
            -- Increment PC while waiting for memory
                PC_Load  <= '0';
                PC_Inc   <= '1';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '0';
                B_Load   <= '0';
                ALU_Sel  <= "000";
                CCR_Load <= '0';
                Bus1_Sel <= "11";
                Bus2_Sel <= "11";
                write    <= '0';
            when LDA_DIR_6 =>
            -- Load MAR from memory
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '1';
                A_Load   <= '0';
                B_Load   <= '0';
                ALU_Sel  <= "000";
                CCR_Load <= '0';
                Bus1_Sel <= "11";
                Bus2_Sel <= "10";
                write    <= '0';
            --   LDA_DIR_7 -> others  Wait for memory
            when LDA_DIR_8 =>
            -- Load A from memory
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '1';
                B_Load   <= '0';
                ALU_Sel  <= "000";
                CCR_Load <= '0';
                Bus1_Sel <= "11";
                Bus2_Sel <= "10";
                write    <= '0';

            when STA_DIR_4 =>
            -- Store PC to MAR
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '1';
                A_Load   <= '0';
                B_Load   <= '0';
                ALU_Sel  <= "000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                write    <= '0';
            when STA_DIR_5 =>
            -- Increment PC while waiting for memory
                PC_Load  <= '0';
                PC_Inc   <= '1';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '0';
                B_Load   <= '0';
                ALU_Sel  <= "000";
                CCR_Load <= '0';
                Bus1_Sel <= "11";
                Bus2_Sel <= "11";
                write    <= '0';
            when STA_DIR_6 =>
            -- Load MAR from memory
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '1';
                A_Load   <= '0';
                B_Load   <= '0';
                ALU_Sel  <= "000";
                CCR_Load <= '0';
                Bus1_Sel <= "11";
                Bus2_Sel <= "10";
                write    <= '0';
            when STA_DIR_7 =>
            -- Write A to memory
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '0';
                B_Load   <= '0';
                ALU_Sel  <= "000";
                CCR_Load <= '0';
                Bus1_Sel <= "01";
                Bus2_Sel <= "11";
                write    <= '1';

            when BRA_4 =>
            -- Store PC to MAR
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '1';
                A_Load   <= '0';
                B_Load   <= '0';
                ALU_Sel  <= "000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                write    <= '0';
            --   BRA_5 -> others  Wait for memory
            when BRA_6 =>
            -- Load PC from memory
                PC_Load  <= '1';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '0';
                B_Load   <= '0';
                ALU_Sel  <= "000";
                CCR_Load <= '0';
                Bus1_Sel <= "11";
                Bus2_Sel <= "10";
                write    <= '0';

            when others =>
            -- Do nothing (set all signals to defaults)
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '0';
                B_Load   <= '0';
                ALU_Sel  <= "000";
                CCR_Load <= '0';
                Bus1_Sel <= "11";
                Bus2_Sel <= "11";
                write    <= '0';

        end case;
    end process;

end architecture;
