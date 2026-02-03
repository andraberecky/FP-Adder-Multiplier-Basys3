library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Pack is
    Port(
        CLK : in STD_LOGIC; 
        RST : in STD_LOGIC;  
        sign : in STD_LOGIC;
        exponent : in STD_LOGIC_VECTOR(7 downto 0);
        mantissa : in STD_LOGIC_VECTOR(22 downto 0);
        number_out : out STD_LOGIC_VECTOR(31 downto 0);
        overflow_out : out STD_LOGIC;
        underflow_out: out STD_LOGIC
    );
end Pack;

architecture Behavioral of Pack is
    constant EXP_MIN : integer := 0;
    constant EXP_MAX : integer := 255;
    constant M_ZERO  : STD_LOGIC_VECTOR(22 downto 0) := (others => '0');
    signal number_out_reg : STD_LOGIC_VECTOR(31 downto 0);
    signal overflow_out_reg : STD_LOGIC;
    signal underflow_out_reg : STD_LOGIC;
begin
    process(CLK, RST)
        variable exp_int : integer;
        variable number_calc : STD_LOGIC_VECTOR(31 downto 0);
        variable overflow_calc : STD_LOGIC;
        variable underflow_calc: STD_LOGIC;
    begin
        if RST = '1' then
            number_out_reg <= (others => '0');
            overflow_out_reg <= '0';
            underflow_out_reg <= '0';
        elsif rising_edge(CLK) then
            number_calc := (others => '0');
            overflow_calc := '0';
            underflow_calc := '0';

            exp_int := to_integer(unsigned(exponent));

            if exp_int >= EXP_MAX then
                number_calc := sign & X"FF" & M_ZERO;
                overflow_calc := '1';
            elsif exp_int <= EXP_MIN then
                number_calc := sign & X"00" & M_ZERO;
                underflow_calc := '1';
            else
                number_calc := sign & exponent & mantissa;
            end if;

            number_out_reg <= number_calc;
            overflow_out_reg <= overflow_calc;
            underflow_out_reg <= underflow_calc;
        end if;
    end process;

    number_out <= number_out_reg;
    overflow_out <= overflow_out_reg;
    underflow_out <= underflow_out_reg;
end Behavioral;
