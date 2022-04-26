library ieee;
    use ieee.std_logic_1164.all;
library work;
    use work.opcodes.all;

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
        LDB_IMM_4, LDB_IMM_5, LDB_IMM_6,
        LDB_DIR_4, LDB_DIR_5, LDB_DIR_6, LDB_DIR_7, LDB_DIR_8,
        STA_DIR_4, STA_DIR_5, STA_DIR_6, STA_DIR_7,
        STB_DIR_4, STB_DIR_5, STB_DIR_6, STB_DIR_7,
        ADD_AB_4, SUB_AB_4, AND_AB_4, OR_AB_4,
        INCA_4, INCB_4, DECA_4, DECB_4,
        BRA_4, BRA_5, BRA_6,
        BMI_4, BMI_5, BMI_6, BMI_7,
        BPL_4, BPL_5, BPL_6, BPL_7,
        BEQ_4, BEQ_5, BEQ_6, BEQ_7,
        BNE_4, BNE_5, BNE_6, BNE_7,
        BVS_4, BVS_5, BVS_6, BVS_7,
        BVC_4, BVC_5, BVC_6, BVC_7,
        BCS_4, BCS_5, BCS_6, BCS_7,
        BCC_4, BCC_5, BCC_6, BCC_7,
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
    begin
        case CurrentState is

            when FETCH_0 => NextState <= FETCH_1;
            when FETCH_1 => NextState <= FETCH_2;
            when FETCH_2 => NextState <= DECODE_3;
            when DECODE_3 =>
                case IR is
                    -- Loads and stores
                    when LDA_IMM => NextState <= LDA_IMM_4;
                    when LDA_DIR => NextState <= LDA_DIR_4;
                    when LDB_IMM => NextState <= LDB_IMM_4;
                    when LDB_DIR => NextState <= LDB_DIR_4;
                    when STA_DIR => NextState <= STA_DIR_4;
                    when STB_DIR => NextState <= STB_DIR_4;
                    -- Arithmetic
                    when ADD_AB  => NextState <= ADD_AB_4;
                    when SUB_AB  => NextState <= SUB_AB_4;
                    when AND_AB  => NextState <= AND_AB_4;
                    when OR_AB   => NextState <= OR_AB_4;
                    when INCA    => NextState <= INCA_4;
                    when INCB    => NextState <= INCB_4;
                    when DECA    => NextState <= DECA_4;
                    when DECB    => NextState <= DECB_4;
                    -- Branching
                    when BRA     => NextState <= BRA_4;
                    when BMI     => if CCR(0) = '1' then NextState <= BMI_4;
                                                    else NextState <= BMI_7;
                                    end if;
                    when BPL     => if CCR(0) = '0' then NextState <= BPL_4;
                                                    else NextState <= BPL_7;
                                    end if;
                    when BEQ     => if CCR(1) = '1' then NextState <= BEQ_4;
                                                    else NextState <= BEQ_7;
                                    end if;
                    when BNE     => if CCR(1) = '0' then NextState <= BNE_4;
                                                    else NextState <= BNE_7;
                                    end if;
                    when BVS     => if CCR(2) = '1' then NextState <= BVS_4;
                                                    else NextState <= BVS_7;
                                    end if;
                    when BVC     => if CCR(2) = '0' then NextState <= BVC_4;
                                                    else NextState <= BVC_7;
                                    end if;
                    when BCS     => if CCR(3) = '1' then NextState <= BCS_4;
                                                    else NextState <= BCS_7;
                                    end if;
                    when BCC     => if CCR(3) = '0' then NextState <= BCC_4;
                                                    else NextState <= BCC_7;
                                    end if;
                    -- A no-op restarts the fetch cycle
                    when NOP    => NextState <= FETCH_0;
                    -- Handle HALT and invalid opcodes by halting
                    when HALT   => NextState <= HALT_99;
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
            -- Load B Immediate
            when LDB_IMM_4 => NextState <= LDB_IMM_5;
            when LDB_IMM_5 => NextState <= LDB_IMM_6;
            -- Load B Direct
            when LDB_DIR_4 => NextState <= LDB_DIR_5;
            when LDB_DIR_5 => NextState <= LDB_DIR_6;
            when LDB_DIR_6 => NextState <= LDB_DIR_7;
            when LDB_DIR_7 => NextState <= LDB_DIR_8;
            -- Store A Direct
            when STA_DIR_4 => NextState <= STA_DIR_5;
            when STA_DIR_5 => NextState <= STA_DIR_6;
            when STA_DIR_6 => NextState <= STA_DIR_7;
            -- Store B Direct
            when STB_DIR_4 => NextState <= STB_DIR_5;
            when STB_DIR_5 => NextState <= STB_DIR_6;
            when STB_DIR_6 => NextState <= STB_DIR_7;

            -- ALU instructions last only one state

            -- Branch Always
            when BRA_4 => NextState <= BRA_5;
            when BRA_5 => NextState <= BRA_6;
            -- Branch Minus
            when BMI_4 => NextState <= BMI_5;
            when BMI_5 => NextState <= BMI_6;
            -- Branch Positive
            when BPL_4 => NextState <= BPL_5;
            when BPL_5 => NextState <= BPL_6;
            -- Branch Equal
            when BEQ_4 => NextState <= BEQ_5;
            when BEQ_5 => NextState <= BEQ_6;
            -- Branch Not Equal
            when BNE_4 => NextState <= BNE_5;
            when BNE_5 => NextState <= BNE_6;
            -- Branch V Set
            when BVS_4 => NextState <= BVS_5;
            when BVS_5 => NextState <= BVS_6;
            -- Branch V Clear
            when BVC_4 => NextState <= BVC_5;
            when BVC_5 => NextState <= BVC_6;
            -- Branch C Set
            when BCS_4 => NextState <= BCS_5;
            when BCS_5 => NextState <= BCS_6;
            -- Branch C Clear
            when BCC_4 => NextState <= BCC_5;
            when BCC_5 => NextState <= BCC_6;

            -- HALT state remains in HALT until a reset
            when HALT_99 => NextState <= HALT_99;

            -- Other states are at the end of their respective branches, and
            -- restart the fetch cycle
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

            when LDB_IMM_4 =>
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
            when LDB_IMM_5 =>
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
            when LDB_IMM_6 =>
            -- Load B from memory
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '0';
                B_Load   <= '1';
                ALU_Sel  <= "000";
                CCR_Load <= '0';
                Bus1_Sel <= "11";
                Bus2_Sel <= "10";
                write    <= '0';

            when LDB_DIR_4 =>
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
            when LDB_DIR_5 =>
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
            when LDB_DIR_6 =>
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
            --   LDB_DIR_7 -> others  Wait for memory
            when LDB_DIR_8 =>
            -- Load B from memory
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '0';
                B_Load   <= '1';
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

            when STB_DIR_4 =>
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
            when STB_DIR_5 =>
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
            when STB_DIR_6 =>
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
            when STB_DIR_7 =>
            -- Write B to memory
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '0';
                B_Load   <= '0';
                ALU_Sel  <= "000";
                CCR_Load <= '0';
                Bus1_Sel <= "10";
                Bus2_Sel <= "11";
                write    <= '1';

            when ADD_AB_4 =>
            -- Add B to A
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '1';
                B_Load   <= '0';
                ALU_Sel  <= "000";
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "00";
                write    <= '0';
            when SUB_AB_4 =>
            -- Subtract B from A
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '1';
                B_Load   <= '0';
                ALU_Sel  <= "001";
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "00";
                write    <= '0';
            when AND_AB_4 =>
            -- Logical AND A with B
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '1';
                B_Load   <= '0';
                ALU_Sel  <= "010";
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "00";
                write    <= '0';
            when OR_AB_4 =>
            -- Logical OR A with B
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '1';
                B_Load   <= '0';
                ALU_Sel  <= "011";
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "00";
                write    <= '0';
            when INCA_4 =>
            -- Increment A by one
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '1';
                B_Load   <= '0';
                ALU_Sel  <= "100";
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "00";
                write    <= '0';
            when INCB_4 =>
            -- Increment B by one
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '0';
                B_Load   <= '1';
                ALU_Sel  <= "100";
                CCR_Load <= '1';
                Bus1_Sel <= "10";
                Bus2_Sel <= "00";
                write    <= '0';
            when DECA_4 =>
            -- Decrement A by one
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '1';
                B_Load   <= '0';
                ALU_Sel  <= "101";
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "00";
                write    <= '0';
            when DECB_4 =>
            -- Decrement B by one
                PC_Load  <= '0';
                PC_Inc   <= '0';
                IR_Load  <= '0';
                MAR_Load <= '0';
                A_Load   <= '0';
                B_Load   <= '1';
                ALU_Sel  <= "101";
                CCR_Load <= '1';
                Bus1_Sel <= "10";
                Bus2_Sel <= "00";
                write    <= '0';

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

            -- Branching instructions all have the same outputs; flow is
            -- controlled by next-state logic
            when BMI_4 | BPL_4 | BEQ_4 | BNE_4 | BVS_4 | BVC_4 | BCS_4 | BCC_4 =>
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
            --   BMI_5 | BPL_5 | BEQ_5 | BNE_5 | BVS_5 | BVC_5 | BCS_5 | BCC_5 -> others  Wait for memory
            when BMI_6 | BPL_6 | BEQ_6 | BNE_6 | BVS_6 | BVC_6 | BCS_6 | BCC_6 =>
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
            when BMI_7 | BPL_7 | BEQ_7 | BNE_7 | BVS_7 | BVC_7 | BCS_7 | BCC_7 =>
            -- Increment PC
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
