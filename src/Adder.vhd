library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Float_Adder_Top is
    Port(
        CLK        : in  STD_LOGIC;
        RST        : in  STD_LOGIC;
        A_in       : in  STD_LOGIC_VECTOR(31 downto 0);
        B_in       : in  STD_LOGIC_VECTOR(31 downto 0);
        sub_op     : in  STD_LOGIC;
        Result_out : out STD_LOGIC_VECTOR(31 downto 0);
        Overflow   : out STD_LOGIC;
        Underflow  : out STD_LOGIC
    );
end Float_Adder_Top;

architecture Behavioral of Float_Adder_Top is
    signal signA, signB, signB_op, sign_res : STD_LOGIC;
    signal expA, expB, exp_aligned, exp_norm, exp_round : STD_LOGIC_VECTOR(7 downto 0);
    signal mantA_ext, mantB_ext, mantA_aligned, mantB_aligned : STD_LOGIC_VECTOR(26 downto 0);
    signal mant_result, mant_norm : STD_LOGIC_VECTOR(26 downto 0);
    signal mant_round : STD_LOGIC_VECTOR(22 downto 0);
    signal swap_flag, carry_out : STD_LOGIC;
    signal NaN_A, NaN_B, Inf_A, Inf_B : STD_LOGIC;
    signal packed_result : STD_LOGIC_VECTOR(31 downto 0);
    constant EXP_MAX : STD_LOGIC_VECTOR(7 downto 0) := X"FF";
    constant M_ZERO  : STD_LOGIC_VECTOR(22 downto 0) := (others => '0');
    constant ZERO_32 : STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
begin
    signB_op <= signB xor sub_op;

    UnpackA: entity work.Unpack
        port map(CLK => CLK, RST => RST, number => A_in, sign => signA, exponent => expA, mantissa => open, mantissa_extended => mantA_ext);

    UnpackB: entity work.Unpack
        port map(CLK => CLK, RST => RST, number => B_in, sign => signB, exponent => expB, mantissa => open, mantissa_extended => mantB_ext);

    Exponent_Alignment: entity work.Exponent_Alignment
        port map(CLK => CLK, RST => RST, exp_A_in => expA, exp_b_in => expB, mantissa_A_in => mantA_ext, mantissa_B_in => mantB_ext,
                 exp_out => exp_aligned, mantissa_A_out => mantA_aligned, mantissa_B_out => mantB_aligned, swap_flag => swap_flag);

    Mantissa_add_sub: entity work.mantissa_add_sub
        port map(CLK => CLK, RST => RST, mantissa_A => mantA_aligned, mantissa_B => mantB_aligned, sign_A => signA, sign_B => signB_op,
                 result => mant_result, sign_res => sign_res, carry_out => carry_out);

    Normalize: entity work.Normalize
        port map(CLK => CLK, RST => RST, mantissa_in => mant_result, exponent_in => exp_aligned, carry_in => carry_out,
                 mantissa_out => mant_norm, exponent_out => exp_norm);

    Rounding: entity work.Rounding
        port map(CLK => CLK, RST => RST, mantissa_in => mant_norm, exponent_in => exp_norm,
                 mantissa_out => mant_round, exponent_out => exp_round);

    Pack: entity work.Pack
        port map(CLK => CLK, RST => RST, sign => sign_res, exponent => exp_round, mantissa => mant_round,
                 number_out => packed_result, overflow_out => Overflow, underflow_out => Underflow);

   process(A_in, B_in, expA, expB, mantA_ext, mantB_ext)
begin
    if (expA = EXP_MAX) and (mantA_ext(25 downto 3) = M_ZERO) then
        Inf_A <= '1';
    else
        Inf_A <= '0';
    end if;

    if (expB = EXP_MAX) and (mantB_ext(25 downto 3) = M_ZERO) then
        Inf_B <= '1';
    else
        Inf_B <= '0';
    end if;

    if (expA = EXP_MAX) and (mantA_ext(25 downto 3) /= M_ZERO) then
        NaN_A <= '1';
    else
        NaN_A <= '0';
    end if;

    if (expB = EXP_MAX) and (mantB_ext(25 downto 3) /= M_ZERO) then
        NaN_B <= '1';
    else
        NaN_B <= '0';
    end if;
end process;


    process(CLK, RST)
    begin
        if RST='1' then
            Result_out <= ZERO_32;
        elsif rising_edge(CLK) then
            if NaN_A='1' or NaN_B='1' then
                Result_out <= X"7FC00000";
            elsif (Inf_A='1' or Inf_B='1') then
                if Inf_A='1' and Inf_B='1' and sub_op='1' then
                    Result_out <= X"7FC00000";
                elsif Inf_A='1' then
                    Result_out <= signA & EXP_MAX & M_ZERO;
                else
                    Result_out <= (signB xor sub_op) & EXP_MAX & M_ZERO;
                end if;
            else
                Result_out <= packed_result;
            end if;
        end if;
    end process;

end Behavioral;