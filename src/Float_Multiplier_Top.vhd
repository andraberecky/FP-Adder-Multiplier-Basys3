library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Float_Multiplier_Top is
    Port (
        CLK       : in  STD_LOGIC;
        RST       : in  STD_LOGIC;
        A_in      : in  STD_LOGIC_VECTOR (31 downto 0);
        B_in      : in  STD_LOGIC_VECTOR (31 downto 0);
        Result    : out STD_LOGIC_VECTOR (31 downto 0);
        Overflow  : out STD_LOGIC;
        Underflow : out STD_LOGIC
    );
end Float_Multiplier_Top;

architecture Behavioral of Float_Multiplier_Top is
    signal signA, signB         : STD_LOGIC;
    signal expA, expB           : STD_LOGIC_VECTOR(7 downto 0);
    signal mantA, mantB         : STD_LOGIC_VECTOR(22 downto 0);
    signal mantA_ext, mantB_ext : STD_LOGIC_VECTOR(26 downto 0); 
    signal sign_res     : STD_LOGIC;
    signal exp_res_calc : STD_LOGIC_VECTOR(7 downto 0);
    signal mant_product : STD_LOGIC_VECTOR(53 downto 0);
    signal mant_norm    : STD_LOGIC_VECTOR(26 downto 0);
    signal exp_norm     : STD_LOGIC_VECTOR(7 downto 0);
    signal mant_round   : STD_LOGIC_VECTOR(22 downto 0);
    signal exp_round    : STD_LOGIC_VECTOR(7 downto 0);
    signal packed_result: STD_LOGIC_VECTOR(31 downto 0);
    signal overflow_int : STD_LOGIC;
    signal underflow_int: STD_LOGIC;
    signal is_Inf_A, is_Inf_B   : STD_LOGIC;
    signal is_Zero_A, is_Zero_B : STD_LOGIC;
    signal is_NaN_A, is_NaN_B   : STD_LOGIC;
    signal special_case_flag    : STD_LOGIC;
    signal special_result       : STD_LOGIC_VECTOR(31 downto 0);
    type sr6_t is array (0 to 5) of STD_LOGIC;
    type pr6_t is array (0 to 5) of STD_LOGIC_VECTOR(31 downto 0);
    type s_t   is array (0 to 5) of STD_LOGIC;
    signal special_flag_sr : sr6_t := ('0','0','0','0','0','0');
    signal special_res_sr  : pr6_t := (
        x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000"
    );
    signal sign_sr : s_t := ('0','0','0','0','0','0'); 
    signal Result_tmp : STD_LOGIC_VECTOR(31 downto 0);
    signal Result_calc : STD_LOGIC_VECTOR(31 downto 0); 
    constant EXP_MAX   : STD_LOGIC_VECTOR(7 downto 0) := X"FF";
    constant EXP_ZERO  : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
    constant M_ZERO    : STD_LOGIC_VECTOR(22 downto 0) := "00000000000000000000000";
    
begin
    sign_res <= signA xor signB;

    UnpackA: entity work.UnpackMultiplier port map (CLK => CLK, RST => RST, number => A_in,
        sign => signA, exponent => expA, mantissa => mantA, mantissa_extended => mantA_ext);
    UnpackB: entity work.UnpackMultiplier port map (CLK => CLK, RST => RST, number => B_in,
        sign => signB, exponent => expB, mantissa => mantB, mantissa_extended => mantB_ext);
    
    is_Inf_A  <= '1' when (expA = EXP_MAX and mantA = M_ZERO) else '0';
    is_Inf_B  <= '1' when (expB = EXP_MAX and mantB = M_ZERO) else '0';
    is_Zero_A <= '1' when (expA = EXP_ZERO and mantA = M_ZERO) else '0';
    is_Zero_B <= '1' when (expB = EXP_ZERO and mantB = M_ZERO) else '0';
    is_NaN_A  <= '1' when (expA = EXP_MAX and mantA /= M_ZERO) else '0';
    is_NaN_B  <= '1' when (expB = EXP_MAX and mantB /= M_ZERO) else '0';
    
    special_case_flag <= '1' when (is_Inf_A = '1' or is_Inf_B = '1' or
                                   is_Zero_A = '1' or is_Zero_B = '1' or
                                   is_NaN_A = '1'  or is_NaN_B = '1')
                       else '0';
    
    process(sign_res, is_Inf_A, is_Inf_B, is_Zero_A, is_Zero_B, is_NaN_A, is_NaN_B)
    begin
        special_result <= "00000000000000000000000000000000";
        if (is_NaN_A = '1') or (is_NaN_B = '1') then
            special_result <= X"7FC00000";
        elsif ((is_Inf_A = '1' and is_Zero_B = '1') or (is_Inf_B = '1' and is_Zero_A = '1')) then
            special_result <= X"7FC00000";
        elsif (is_Inf_A = '1') or (is_Inf_B = '1') then
            special_result <= sign_res & "11111111" & "00000000000000000000000";
        elsif (is_Zero_A = '1') or (is_Zero_B = '1') then
            special_result <= sign_res & "00000000" & "00000000000000000000000";
        end if;
    end process;

    process(CLK, RST)
    begin
        if RST = '1' then
            special_flag_sr <= ('0','0','0','0','0','0');
            special_res_sr  <= (x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000");
            sign_sr         <= ('0','0','0','0','0','0');
        elsif rising_edge(CLK) then
            special_flag_sr(0) <= special_case_flag;
            special_res_sr(0)  <= special_result;
            sign_sr(0)         <= sign_res; 
            
            for i in 1 to 5 loop
                special_flag_sr(i) <= special_flag_sr(i-1);
                special_res_sr(i)  <= special_res_sr(i-1);
                sign_sr(i)         <= sign_sr(i-1); 
            end loop;
        end if;
    end process;

    Exponent_Multiplier: entity work.Exponent_Multiplier port map (
        CLK => CLK, RST => RST, exp_A_in => expA, exp_B_in => expB, exp_res => exp_res_calc);
    Mantissa_Multiplier: entity work.Mantissa_Multiplier port map (
        CLK => CLK, RST => RST, mantissa_A => mantA_ext, mantissa_B => mantB_ext, mantissa_product => mant_product);
    Normalize_Multiplier: entity work.Normalize_Multiplier port map (
        CLK => CLK, RST => RST, mantissa_in => mant_product, exponent_in => exp_res_calc,
        mantissa_out => mant_norm, exponent_out => exp_norm);
    RoundingMultiplier: entity work.RoundingMultiplier port map (
        CLK => CLK, RST => RST, mantissa_in => mant_norm, exponent_in => exp_norm,
        mantissa_out => mant_round, exponent_out => exp_round);
    PackMultiplier: entity work.PackMultiplier port map (
        CLK => CLK, RST => RST, 
        sign => sign_sr(2),
        exponent => exp_round, mantissa => mant_round, number_out => packed_result,
        overflow_out => overflow_int, underflow_out => underflow_int);

    Result_tmp    <= special_res_sr(3) when special_flag_sr(3) = '1' else packed_result;

    Result_calc   <= (sign_sr(3) & "00000000" & "00000000000000000000000") when underflow_int = '1' else Result_tmp;

    Overflow <= '1' when (Result_tmp(30 downto 23) = EXP_MAX AND Result_tmp(22 downto 0) = M_ZERO) else 
                '1' when overflow_int = '1' else '0';

    Underflow <= '1' when (Result_calc(30 downto 23) = EXP_ZERO AND Result_calc(22 downto 0) = M_ZERO) else 
                 '1' when underflow_int = '1' else '0';
    
    Result <= Result_calc;
    
end Behavioral;